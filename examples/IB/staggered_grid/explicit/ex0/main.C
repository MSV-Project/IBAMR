// Copyright (c) 2002-2010, Boyce Griffith
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
//    * Redistributions of source code must retain the above copyright notice,
//      this list of conditions and the following disclaimer.
//
//    * Redistributions in binary form must reproduce the above copyright
//      notice, this list of conditions and the following disclaimer in the
//      documentation and/or other materials provided with the distribution.
//
//    * Neither the name of New York University nor the names of its
//      contributors may be used to endorse or promote products derived from
//      this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.

// Config files
#include <IBAMR_config.h>
#include <SAMRAI_config.h>

// Headers for basic SAMRAI objects
#include <PatchLevel.h>
#include <VariableDatabase.h>
#include <tbox/Database.h>
#include <tbox/InputDatabase.h>
#include <tbox/InputManager.h>
#include <tbox/MathUtilities.h>
#include <tbox/PIO.h>
#include <tbox/Pointer.h>
#include <tbox/RestartManager.h>
#include <tbox/SAMRAIManager.h>
#include <tbox/SAMRAI_MPI.h>
#include <tbox/TimerManager.h>
#include <tbox/Utilities.h>

// Headers for major algorithm/data structure objects
#include <BergerRigoutsos.h>
#include <CartesianGridGeometry.h>
#include <GriddingAlgorithm.h>
#include <LoadBalancer.h>
#include <PatchHierarchy.h>
#include <StandardTagAndInitialize.h>
#include <VisItDataWriter.h>

// Headers for application-specific algorithm/data structure objects
#include <ibamr/IBStaggeredHierarchyIntegrator.h>
#include <ibamr/IBStandardForceGen.h>
#include <ibamr/IBStandardInitializer.h>
#include <ibtk/LagSiloDataWriter.h>
#include <ibtk/muParserCartGridFunction.h>
#include <ibtk/muParserRobinBcCoefs.h>

using namespace IBAMR;
using namespace IBTK;
using namespace SAMRAI;
using namespace std;

/*
 * A simple post-processor to compute the total energy in the system.
 */
class myPostProcessor
    : public IBDataPostProcessor
{
public:
    tbox::Pointer<IBLagrangianForceStrategy> d_force_generator;

    myPostProcessor()
    {
        // intentionally blank
        return;
    }// myPostProcessor()

    ~myPostProcessor()
    {
        // intentionally blank
        return;
    }// ~myPostProcessor()

    virtual void
    postProcessData(
        const int u_idx,
        const int p_idx,
        const int f_idx,
        std::vector<tbox::Pointer<LNodeLevelData> > F_data,
        std::vector<tbox::Pointer<LNodeLevelData> > X_data,
        std::vector<tbox::Pointer<LNodeLevelData> > U_data,
        const tbox::Pointer<hier::PatchHierarchy<NDIM> > hierarchy,
        const int coarsest_level_number,
        const int finest_level_number,
        const double data_time,
        LDataManager* const lag_manager)
    {
        // Compute the total energy in the system as 0.5*|u|^2 - X*F.
        HierarchyMathOps hier_math_ops("HierarchyMathOps", hierarchy);
        hier_math_ops.setPatchHierarchy(hierarchy);
        hier_math_ops.resetLevels(coarsest_level_number, finest_level_number);
        const int wgt_sc_idx = hier_math_ops.getSideWeightPatchDescriptorIndex();

        math::HierarchySideDataOpsReal<NDIM,double> hier_sc_data_ops(hierarchy, coarsest_level_number, finest_level_number);
        const double kinetic_energy = 0.5*hier_sc_data_ops.dot(u_idx, u_idx, wgt_sc_idx);

        double potential_energy = 0.0;
        for (int ln = coarsest_level_number; ln <= finest_level_number; ++ln)
        {
            potential_energy += d_force_generator->computeLagrangianEnergy(X_data[ln], U_data[ln], hierarchy, ln, data_time, lag_manager);
        }

        tbox::pout << "\ntime = " << data_time << "\n"
                           << "kinetic energy = " << kinetic_energy << "\n"
                           << "potential energy = " << potential_energy << "\n"
                           << "total energy = " << kinetic_energy + potential_energy << "\n\n";
        return;
    }// postProcessData
};

/************************************************************************
 * For each run, the input filename and restart information (if         *
 * needed) must be given on the command line.  For non-restarted case,  *
 * command line is:                                                     *
 *                                                                      *
 *    executable <input file name>                                      *
 *                                                                      *
 * For restarted run, command line is:                                  *
 *                                                                      *
 *    executable <input file name> <restart directory> <restart number> *
 *                                                                      *
 ************************************************************************
 */

int
main(
    int argc,
    char* argv[])
{
    /*
     * Initialize PETSc, MPI, and SAMRAI.
     */
    PetscInitialize(&argc,&argv,PETSC_NULL,PETSC_NULL);
    tbox::SAMRAI_MPI::setCommunicator(PETSC_COMM_WORLD);
    tbox::SAMRAI_MPI::setCallAbortInSerialInsteadOfExit();
    tbox::SAMRAIManager::setMaxNumberPatchDataEntries(1024);
    tbox::SAMRAIManager::startup();

    {// cleanup all smart Pointers prior to shutdown

        /*
         * Process command line and enable logging.
         */
        string input_filename;
        string restart_read_dirname;
        int restore_num = 0;

        bool is_from_restart = false;

        if (argc == 1)
        {
            tbox::pout << "USAGE:  " << argv[0] << " <input filename> "
                       << "<restart dir> <restore number> [options]\n"
                       << "  options:\n"
                       << "  PETSc command line options; use -help for more information"
                       << endl;
            tbox::SAMRAI_MPI::abort();
            return -1;
        }
        else
        {
            input_filename = argv[1];
            if (argc >= 4)
            {
                FILE* fstream = NULL;
                if (tbox::SAMRAI_MPI::getRank() == 0)
                {
                    fstream = fopen(argv[2], "r");
                }
                int worked = (fstream ? 1 : 0);
#ifdef HAVE_MPI
                worked = tbox::SAMRAI_MPI::bcast(worked, 0);
#endif
                if (worked)
                {
                    restart_read_dirname = argv[2];
                    restore_num = atoi(argv[3]);
                    is_from_restart = true;
                }
                if (fstream) fclose(fstream);
            }
        }

        tbox::plog << "input_filename = " << input_filename << endl;
        tbox::plog << "restart_read_dirname = " << restart_read_dirname << endl;
        tbox::plog << "restore_num = " << restore_num << endl;

        /*
         * Create input database and parse all data in input file.
         */
        tbox::Pointer<tbox::Database> input_db = new tbox::InputDatabase("input_db");
        tbox::InputManager::getManager()->parseInputFile(input_filename, input_db);

        /*
         * Retrieve "Main" section of the input database.  First, read dump
         * information, which is used for writing plot files.  Second, if proper
         * restart information was given on command line, and the restart
         * interval is non-zero, create a restart database.
         */
        tbox::Pointer<tbox::Database> main_db = input_db->getDatabase("Main");

        string log_file_name = "IB.log";
        if (main_db->keyExists("log_file_name"))
        {
            log_file_name = main_db->getString("log_file_name");
        }
        bool log_all_nodes = false;
        if (main_db->keyExists("log_all_nodes"))
        {
            log_all_nodes = main_db->getBool("log_all_nodes");
        }
        if (log_all_nodes)
        {
            tbox::PIO::logAllNodes(log_file_name);
        }
        else
        {
            tbox::PIO::logOnlyNodeZero(log_file_name);
        }

        int viz_dump_interval = 0;
        if (main_db->keyExists("viz_dump_interval"))
        {
            viz_dump_interval = main_db->getInteger("viz_dump_interval");
        }

        tbox::Array<string> viz_writer(1);
        viz_writer[0] = "VisIt";
        string viz_dump_filename;
        string visit_dump_dirname;
        bool uses_visit = false;
        int visit_number_procs_per_file = 1;
        if (viz_dump_interval > 0)
        {
            if (main_db->keyExists("viz_writer"))
            {
                viz_writer = main_db->getStringArray("viz_writer");
            }
            if (main_db->keyExists("viz_dump_filename"))
            {
                viz_dump_filename = main_db->getString("viz_dump_filename");
            }
            string viz_dump_dirname;
            if (main_db->keyExists("viz_dump_dirname"))
            {
                viz_dump_dirname = main_db->getString("viz_dump_dirname");
            }
            for (int i = 0; i < viz_writer.getSize(); i++)
            {
                if (viz_writer[i] == "VisIt") uses_visit = true;
            }
            if (uses_visit)
            {
                visit_dump_dirname = viz_dump_dirname;
            }
            else
            {
                TBOX_ERROR("main(): "
                           << "\nUnrecognized 'viz_writer' entry..."
                           << "\nOptions are 'Vizamrai' and/or 'VisIt'"
                           << endl);
            }
            if (uses_visit)
            {
                if (viz_dump_dirname.empty())
                {
                    TBOX_ERROR("main(): "
                               << "\nviz_dump_dirname is null ... "
                               << "\nThis must be specified for use with VisIt"
                               << endl);
                }
                if (main_db->keyExists("visit_number_procs_per_file"))
                {
                    visit_number_procs_per_file = main_db->getInteger("visit_number_procs_per_file");
                }
            }
        }

        const bool viz_dump_data = (viz_dump_interval > 0);

        int restart_interval = 0;
        if (main_db->keyExists("restart_interval"))
        {
            restart_interval = main_db->getInteger("restart_interval");
        }

        string restart_write_dirname;
        if (restart_interval > 0)
        {
            if (main_db->keyExists("restart_write_dirname"))
            {
                restart_write_dirname = main_db->getString("restart_write_dirname");
            }
            else
            {
                TBOX_ERROR("restart_interval > 0, but key `restart_write_dirname'"
                           << " not specified in input file");
            }
        }

        const bool write_restart = restart_interval > 0
            && !restart_write_dirname.empty();

        bool stop_after_writing_restart = false;
        if (write_restart)
        {
            if (main_db->keyExists("stop_after_writing_restart"))
            {
                stop_after_writing_restart = main_db->getBool("stop_after_writing_restart");
            }
        }

        int hier_dump_interval = 0;
        if (main_db->keyExists("hier_dump_interval"))
        {
            hier_dump_interval = main_db->getInteger("hier_dump_interval");
        }

        string hier_dump_dirname;
        if (hier_dump_interval > 0)
        {
            if (main_db->keyExists("hier_dump_dirname"))
            {
                hier_dump_dirname = main_db->getString("hier_dump_dirname");
            }
            else
            {
                TBOX_ERROR("hier_dump_interval > 0, but key `hier_dump_dirname'"
                           << " not specified in input file");
            }
        }

        const bool write_hier_data = (hier_dump_interval > 0)
            && !(hier_dump_dirname.empty());
        if (write_hier_data)
        {
            tbox::Utilities::recursiveMkdir(hier_dump_dirname);
        }

        int timer_dump_interval = 0;
        if (main_db->keyExists("timer_dump_interval"))
        {
            timer_dump_interval = main_db->getInteger("timer_dump_interval");
        }

        const bool write_timer_data = (timer_dump_interval > 0);
        if (write_timer_data)
        {
            tbox::TimerManager::createManager(input_db->getDatabase("TimerManager"));
        }

        int postprocess_interval = 0;
        if (main_db->keyExists("postprocess_interval"))
        {
            postprocess_interval = main_db->getInteger("postprocess_interval");
        }

        const bool postprocess_data = (postprocess_interval > 0);

        /*
         * Get the restart manager and root restart database.  If run is from
         * restart, open the restart file.
         */
        tbox::RestartManager* restart_manager = tbox::RestartManager::getManager();
        if (is_from_restart)
        {
            restart_manager->openRestartFile(
                restart_read_dirname, restore_num, tbox::SAMRAI_MPI::getNodes());
        }

        /*
         * Create major algorithm and data objects which comprise the
         * application.  Each object will be initialized either from input data
         * or restart files, or a combination of both.  Refer to each class
         * constructor for details.  For more information on the composition of
         * objects for this application, see comments at top of file.
         */
        tbox::Pointer<geom::CartesianGridGeometry<NDIM> > grid_geometry =
            new geom::CartesianGridGeometry<NDIM>(
                "CartesianGeometry",
                input_db->getDatabase("CartesianGeometry"));

        tbox::Pointer<hier::PatchHierarchy<NDIM> > patch_hierarchy =
            new hier::PatchHierarchy<NDIM>(
                "PatchHierarchy",
                grid_geometry);

       tbox::Pointer<INSStaggeredHierarchyIntegrator> navier_stokes_integrator =
            new INSStaggeredHierarchyIntegrator(
                "INSStaggeredHierarchyIntegrator",
                input_db->getDatabase("INSStaggeredHierarchyIntegrator"),
                patch_hierarchy);

        tbox::Pointer<IBSpringForceGen> spring_force_generator = new IBSpringForceGen();
        tbox::Pointer<IBBeamForceGen> beam_force_generator = new IBBeamForceGen();
        tbox::Pointer<IBTargetPointForceGen> target_point_force_generator = new IBTargetPointForceGen();
        tbox::Pointer<IBStandardForceGen> force_generator = new IBStandardForceGen(
            spring_force_generator, beam_force_generator, target_point_force_generator);

        tbox::Pointer<IBLagrangianSourceStrategy> source_generator = NULL;

        myPostProcessor* t_post_processor = new myPostProcessor();
        t_post_processor->d_force_generator = force_generator;
        tbox::Pointer<IBDataPostProcessor> post_processor = t_post_processor;

        tbox::Pointer<IBStaggeredHierarchyIntegrator> time_integrator =
            new IBStaggeredHierarchyIntegrator(
                "IBStaggeredHierarchyIntegrator",
                input_db->getDatabase("IBStaggeredHierarchyIntegrator"),
                patch_hierarchy, navier_stokes_integrator,
                force_generator, source_generator, post_processor);

        tbox::Pointer<IBStandardInitializer> initializer =
            new IBStandardInitializer(
                "IBStandardInitializer",
                input_db->getDatabase("IBStandardInitializer"));
        time_integrator->registerLNodeInitStrategy(initializer);

        tbox::Pointer<mesh::StandardTagAndInitialize<NDIM> > error_detector =
            new mesh::StandardTagAndInitialize<NDIM>(
                "StandardTagAndInitialize",
                time_integrator,
                input_db->getDatabase("StandardTagAndInitialize"));

        tbox::Pointer<mesh::BergerRigoutsos<NDIM> > box_generator =
            new mesh::BergerRigoutsos<NDIM>();

        tbox::Pointer<mesh::LoadBalancer<NDIM> > load_balancer =
            new mesh::LoadBalancer<NDIM>(
                "LoadBalancer",
                input_db->getDatabase("LoadBalancer"));

        tbox::Pointer<mesh::GriddingAlgorithm<NDIM> > gridding_algorithm =
            new mesh::GriddingAlgorithm<NDIM>(
                "GriddingAlgorithm",
                input_db->getDatabase("GriddingAlgorithm"),
                error_detector, box_generator, load_balancer);

        /*
         * Create initial condition specification objects.
         */
        tbox::Pointer<CartGridFunction> u_init = new muParserCartGridFunction(
            "u_init", input_db->getDatabase("VelocityInitialConditions"), grid_geometry);
        time_integrator->registerVelocityInitialConditions(u_init);

        /*
         * Create boundary condition specification objects (when necessary).
         */
        const hier::IntVector<NDIM>& periodic_shift = grid_geometry->getPeriodicShift();
        const bool periodic_domain = periodic_shift.min() != 0;

        vector<solv::RobinBcCoefStrategy<NDIM>*> u_bc_coefs;
        if (!periodic_domain)
        {
            for (int d = 0; d < NDIM; ++d)
            {
                ostringstream bc_coefs_name_stream;
                bc_coefs_name_stream << "u_bc_coefs_" << d;
                const string bc_coefs_name = bc_coefs_name_stream.str();

                ostringstream bc_coefs_db_name_stream;
                bc_coefs_db_name_stream << "VelocityBcCoefs_" << d;
                const string bc_coefs_db_name = bc_coefs_db_name_stream.str();

                u_bc_coefs.push_back(
                    new muParserRobinBcCoefs(
                        bc_coefs_name, input_db->getDatabase(bc_coefs_db_name), grid_geometry));
            }
            time_integrator->registerVelocityPhysicalBcCoefs(u_bc_coefs);
        }

        /*
         * Create body force function specification objects (when necessary).
         */
        if (input_db->keyExists("ForcingFunction"))
        {
            tbox::Pointer<CartGridFunction> f_fcn = new muParserCartGridFunction(
                "f_fcn", input_db->getDatabase("ForcingFunction"), grid_geometry);
            time_integrator->registerBodyForceSpecification(f_fcn);
        }

        /*
         * Set up visualization plot file writer.
         */
        tbox::Pointer<appu::VisItDataWriter<NDIM> > visit_data_writer =
            new appu::VisItDataWriter<NDIM>(
                "VisIt Writer",
                visit_dump_dirname, visit_number_procs_per_file);
        tbox::Pointer<LagSiloDataWriter> silo_data_writer =
            new LagSiloDataWriter(
                "LagSiloDataWriter",
                visit_dump_dirname);

        if (uses_visit)
        {
            initializer->registerLagSiloDataWriter(silo_data_writer);
            time_integrator->registerVisItDataWriter(visit_data_writer);
            time_integrator->registerLagSiloDataWriter(silo_data_writer);
        }

        /*
         * Initialize hierarchy configuration and data on all patches.  Then,
         * close restart file and write initial state for visualization.
         */
        time_integrator->initializeHierarchyIntegrator(gridding_algorithm);
        double dt_now = time_integrator->initializeHierarchy();
        tbox::RestartManager::getManager()->closeRestartFile();

        /*
         * Deallocate the Lagrangian initializer, as it is no longer needed.
         */
        time_integrator->freeLNodeInitStrategy();
        initializer.setNull();

        /*
         * After creating all objects and initializing their state, we print the
         * input database contents to the log file.
         */
        tbox::plog << "\nCheck input data before simulation:" << endl;
        tbox::plog << "Input database..." << endl;
        input_db->printClassData(tbox::plog);

        /*
         * Write initial visualization files.
         */
        if (viz_dump_data)
        {
            if (uses_visit)
            {
                tbox::pout << "\nWriting visualization files...\n\n";
                visit_data_writer->writePlotData(
                    patch_hierarchy,
                    time_integrator->getIntegratorStep(),
                    time_integrator->getIntegratorTime());
                silo_data_writer->writePlotData(
                    time_integrator->getIntegratorStep(),
                    time_integrator->getIntegratorTime());
            }
        }

        /*
         * Perform initial post processing.
         */
        if (postprocess_data)
        {
            time_integrator->postProcessData();
        }

        /*
         * Time step loop.  Note that the step count and integration time are
         * maintained by the time integrator object.
         */
        double loop_time = time_integrator->getIntegratorTime();
        double loop_time_end = time_integrator->getEndTime();
        double dt_old = 0.0;

        int iteration_num = time_integrator->getIntegratorStep();
#if 0
        /*
         * At specified intervals, write state data for post-processing.
         */
        if (write_hier_data && iteration_num%hier_dump_interval == 0)
        {
            /*
             * Write Cartesian data.
             */
            hier::VariableDatabase<NDIM>* var_db = hier::VariableDatabase<NDIM>::getDatabase();

            tbox::plog << "writing hierarchy data at iteration " << iteration_num << " to disk" << endl;
            tbox::plog << "simulation time is " << loop_time << endl;

            string file_name = hier_dump_dirname + "/" + "hier_data.";
            char temp_buf[128];
            sprintf(temp_buf, "%05d.samrai.%05d", iteration_num, tbox::SAMRAI_MPI::getRank());
            file_name += temp_buf;

            tbox::Pointer<tbox::HDFDatabase> hier_db = new tbox::HDFDatabase("hier_db");
            hier_db->create(file_name);

            hier::ComponentSelector hier_data;
            hier_data.setFlag(var_db->mapVariableAndContextToIndex(navier_stokes_integrator->getVelocityVar(),
                                                                   navier_stokes_integrator->getCurrentContext()));
            hier_data.setFlag(var_db->mapVariableAndContextToIndex(navier_stokes_integrator->getPressureVar(),
                                                                   navier_stokes_integrator->getCurrentContext()));
            hier_data.setFlag(var_db->mapVariableAndContextToIndex(navier_stokes_integrator->getExtrapolatedPressureVar(),
                                                                   navier_stokes_integrator->getCurrentContext()));

            patch_hierarchy->putToDatabase(hier_db->putDatabase("PatchHierarchy"), hier_data);
            hier_db->putDouble("loop_time", loop_time);
            hier_db->putDouble("end_time", loop_time_end);
            hier_db->putDouble("dt", dt_now);
            hier_db->putInteger("iteration_num", iteration_num);
            hier_db->putInteger("hier_dump_interval", hier_dump_interval);

            hier_db->close();

            /*
             * Write Lagrangian data.
             */
            const int finest_hier_level = patch_hierarchy->getFinestLevelNumber();
            LDataManager* lag_manager = time_integrator->getLDataManager();
            tbox::Pointer<LNodeLevelData> X_data = lag_manager->getLNodeLevelData("X", finest_hier_level);
            Vec X_petsc_vec = X_data->getGlobalVec();
            Vec X_lag_vec;
            VecDuplicate(X_petsc_vec, &X_lag_vec);
            lag_manager->scatterPETScToLagrangian(X_petsc_vec, X_lag_vec, finest_hier_level);
            file_name = hier_dump_dirname + "/" + "X.";
            sprintf(temp_buf, "%05d", iteration_num);
            file_name += temp_buf;
            PetscViewer viewer;
            PetscViewerASCIIOpen(PETSC_COMM_WORLD, file_name.c_str(), &viewer);
            VecView(X_lag_vec, viewer);
            PetscViewerDestroy(viewer);
            VecDestroy(X_lag_vec);
        }
#endif
        while (!tbox::MathUtilities<double>::equalEps(loop_time,loop_time_end) &&
               time_integrator->stepsRemaining())
        {
            iteration_num = time_integrator->getIntegratorStep() + 1;

            tbox::pout <<                                                        endl;
            tbox::pout << "++++++++++++++++++++++++++++++++++++++++++++++++"  << endl;
            tbox::pout << "At beginning of timestep # " <<  iteration_num - 1 << endl;
            tbox::pout << "Simulation time is " << loop_time                  << endl;

            dt_old = dt_now;
            double dt_new = time_integrator->advanceHierarchy(dt_now);

            loop_time += dt_now;
            dt_now = dt_new;

            tbox::pout <<                                                        endl;
            tbox::pout << "At end       of timestep # " <<  iteration_num - 1 << endl;
            tbox::pout << "Simulation time is " << loop_time                  << endl;
            tbox::pout << "++++++++++++++++++++++++++++++++++++++++++++++++"  << endl;
            tbox::pout <<                                                        endl;

            /*
             * At specified intervals, write visualization and restart files,
             * and print out timer data.
             */
            if (write_timer_data && iteration_num%timer_dump_interval == 0)
            {
                tbox::pout << "\nWriting timer data...\n\n";
                tbox::TimerManager::getManager()->print(tbox::plog);
            }

            if (viz_dump_data && iteration_num%viz_dump_interval == 0)
            {
                if (uses_visit)
                {
                    tbox::pout << "\nWriting visualization files...\n\n";
                    visit_data_writer->writePlotData(
                        patch_hierarchy, iteration_num, loop_time);
                    silo_data_writer->writePlotData(
                        iteration_num, loop_time);
                }
            }

            if (write_restart && iteration_num%restart_interval == 0)
            {
                tbox::pout << "\nWriting restart files...\n\n";
                tbox::RestartManager::getManager()->writeRestartFile(
                    restart_write_dirname, iteration_num);

                if (stop_after_writing_restart) break;
            }
#if 0
            /*
             * At specified intervals, write state data for post-processing.
             */
            if (write_hier_data && iteration_num%hier_dump_interval == 0)
            {
                /*
                 * Write Cartesian data.
                 */
                hier::VariableDatabase<NDIM>* var_db = hier::VariableDatabase<NDIM>::getDatabase();

                tbox::plog << "writing hierarchy data at iteration " << iteration_num << " to disk" << endl;
                tbox::plog << "simulation time is " << loop_time << endl;

                string file_name = hier_dump_dirname + "/" + "hier_data.";
                char temp_buf[128];
                sprintf(temp_buf, "%05d.samrai.%05d", iteration_num, tbox::SAMRAI_MPI::getRank());
                file_name += temp_buf;

                tbox::Pointer<tbox::HDFDatabase> hier_db = new tbox::HDFDatabase("hier_db");
                hier_db->create(file_name);

                hier::ComponentSelector hier_data;
                hier_data.setFlag(var_db->mapVariableAndContextToIndex(navier_stokes_integrator->getVelocityVar(),
                                                                       navier_stokes_integrator->getCurrentContext()));
                hier_data.setFlag(var_db->mapVariableAndContextToIndex(navier_stokes_integrator->getPressureVar(),
                                                                       navier_stokes_integrator->getCurrentContext()));
                hier_data.setFlag(var_db->mapVariableAndContextToIndex(navier_stokes_integrator->getExtrapolatedPressureVar(),
                                                                       navier_stokes_integrator->getCurrentContext()));

                patch_hierarchy->putToDatabase(hier_db->putDatabase("PatchHierarchy"), hier_data);
                hier_db->putDouble("loop_time", loop_time);
                hier_db->putDouble("end_time", loop_time_end);
                hier_db->putDouble("dt", dt_now);
                hier_db->putInteger("iteration_num", iteration_num);
                hier_db->putInteger("hier_dump_interval", hier_dump_interval);

                hier_db->close();

                /*
                 * Write Lagrangian data.
                 */
                const int finest_hier_level = patch_hierarchy->getFinestLevelNumber();
                LDataManager* lag_manager = time_integrator->getLDataManager();
                tbox::Pointer<LNodeLevelData> X_data = lag_manager->getLNodeLevelData("X", finest_hier_level);
                Vec X_petsc_vec = X_data->getGlobalVec();
                Vec X_lag_vec;
                VecDuplicate(X_petsc_vec, &X_lag_vec);
                lag_manager->scatterPETScToLagrangian(X_petsc_vec, X_lag_vec, finest_hier_level);
                file_name = hier_dump_dirname + "/" + "X.";
                sprintf(temp_buf, "%05d", iteration_num);
                file_name += temp_buf;
                PetscViewer viewer;
                PetscViewerASCIIOpen(PETSC_COMM_WORLD, file_name.c_str(), &viewer);
                VecView(X_lag_vec, viewer);
                PetscViewerDestroy(viewer);
                VecDestroy(X_lag_vec);
            }
#endif
            /*
             * At specified intervals, post-process data.
             */
            if (postprocess_data && iteration_num%postprocess_interval == 0)
            {
                time_integrator->postProcessData();
            }
        }

        /*
         * Ensure the final timer data is written out.
         */
        if (write_timer_data && iteration_num%timer_dump_interval != 0)
        {
            tbox::pout << "\nWriting timer data...\n\n";
            tbox::TimerManager::getManager()->print(tbox::plog);
        }

        /*
         * Ensure the last state is written out.
         */
        if (viz_dump_data && iteration_num%viz_dump_interval != 0)
        {
            if (uses_visit)
            {
                tbox::pout << "\nWriting visualization files...\n\n";
                visit_data_writer->writePlotData(
                    patch_hierarchy, iteration_num, loop_time);
                silo_data_writer->writePlotData(
                    iteration_num, loop_time);
            }
        }

        /*
         * Cleanup boundary condition specification objects (when necessary).
         */
        if (!periodic_domain)
        {
            for (vector<solv::RobinBcCoefStrategy<NDIM>*>::const_iterator cit = u_bc_coefs.begin();
                 cit != u_bc_coefs.end(); ++cit)
            {
                delete (*cit);
            }
        }
    }// cleanup all smart Pointers prior to shutdown

    tbox::SAMRAIManager::shutdown();
    PetscFinalize();

    return 0;
}// main
