// Filename: PETScLevelSolver.h
// Created on 16 Apr 2012 by Boyce Griffith
//
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

#ifndef included_PETScLevelSolver
#define included_PETScLevelSolver

/////////////////////////////// INCLUDES /////////////////////////////////////

// PETSc INCLUDES
#include <petscksp.h>

// IBTK INCLUDES
#include <ibtk/LinearSolver.h>

/////////////////////////////// CLASS DEFINITION /////////////////////////////

namespace IBTK
{
/*!
 * \brief Class PETScLevelSolver is an abstract LinearSolver for solving systems
 * of linear equations on a \em single SAMRAI::hier::PatchLevel using <A
 * HREF="http://www.mcs.anl.gov/petsc/petsc-as">PETSc</A>.
 *
 * Sample parameters for initialization from database (and their default
 * values): \verbatim

 options_prefix = ""           // see setOptionsPrefix()
 ksp_type = "gmres"            // see setKSPType()
 initial_guess_nonzero = TRUE  // see setInitialGuessNonzero()
 rel_residual_tol = 1.0e-5     // see setRelativeTolerance()
 abs_residual_tol = 1.0e-50    // see setAbsoluteTolerance()
 max_iterations = 10000        // see setMaxIterations()
 enable_logging = FALSE        // see setLoggingEnabled()
 \endverbatim
 *
 * PETSc is developed at the Argonne National Laboratory Mathematics and
 * Computer Science Division.  For more information about \em PETSc, see <A
 * HREF="http://www.mcs.anl.gov/petsc">http://www.mcs.anl.gov/petsc</A>.
 */
class PETScLevelSolver
    : public virtual LinearSolver
{
public:
    /*!
     * \brief Constructor.
     */
    PETScLevelSolver(
        const std::string& object_name,
        SAMRAI::tbox::Pointer<SAMRAI::tbox::Database> input_db,
        const std::string& default_options_prefix);

    /*!
     * \brief Destructor.
     */
    ~PETScLevelSolver();

    /*!
     * \brief Set the KSP type.
     */
    void
    setKSPType(
        const std::string& ksp_type);

    /*!
     * \brief Set the options prefix used by this PETSc solver object.
     */
    void
    setOptionsPrefix(
        const std::string& options_prefix);

    /*!
     * \name Linear solver functionality.
     */
    //\{

    /*!
     * \brief Set the nullspace of the linear system.
     */
    void
    setNullspace(
        bool contains_constant_vec,
        const std::vector<SAMRAI::tbox::Pointer<SAMRAI::solv::SAMRAIVectorReal<NDIM,double> > >& nullspace_basis_vecs=std::vector<SAMRAI::tbox::Pointer<SAMRAI::solv::SAMRAIVectorReal<NDIM,double> > >());

    /*!
     * \brief Solve the linear system of equations \f$Ax=b\f$ for \f$x\f$.
     *
     * Before calling solveSystem(), the form of the solution \a x and
     * right-hand-side \a b vectors must be set properly by the user on all
     * patch interiors on the specified range of levels in the patch hierarchy.
     * The user is responsible for all data management for the quantities
     * associated with the solution and right-hand-side vectors.  In particular,
     * patch data in these vectors must be allocated prior to calling this
     * method.
     *
     * \param x solution vector
     * \param b right-hand-side vector
     *
     * <b>Conditions on Parameters:</b>
     * - vectors \a x and \a b must have same patch hierarchy
     * - vectors \a x and \a b must have same structure, depth, etc.
     *
     * \note The vector arguments for solveSystem() need not match those for
     * initializeSolverState().  However, there must be a certain degree of
     * similarity, including:\par
     * - hierarchy configuration (hierarchy pointer and range of levels)
     * - number, type and alignment of vector component data
     * - ghost cell widths of data in the solution \a x and right-hand-side \a b
     *   vectors
     *
     * \note The solver need not be initialized prior to calling solveSystem();
     * however, see initializeSolverState() and deallocateSolverState() for
     * opportunities to save overhead when performing multiple consecutive
     * solves.
     *
     * \see initializeSolverState
     * \see deallocateSolverState
     *
     * \return \p true if the solver converged to the specified tolerances, \p
     * false otherwise
     */
    bool
    solveSystem(
        SAMRAI::solv::SAMRAIVectorReal<NDIM,double>& x,
        SAMRAI::solv::SAMRAIVectorReal<NDIM,double>& b);

    /*!
     * \brief Compute hierarchy dependent data required for solving \f$Ax=b\f$.
     *
     * By default, the solveSystem() method computes some required hierarchy
     * dependent data before solving and removes that data after the solve.  For
     * multiple solves that use the same hierarchy configuration, it is more
     * efficient to:
     *
     * -# initialize the hierarchy-dependent data required by the solver via
     *    initializeSolverState(),
     * -# solve the system one or more times via solveSystem(), and
     * -# remove the hierarchy-dependent data via deallocateSolverState().
     *
     * Note that it is generally necessary to reinitialize the solver state when
     * the hierarchy configuration changes.
     *
     * \param x solution vector
     * \param b right-hand-side vector
     *
     * <b>Conditions on Parameters:</b>
     * - vectors \a x and \a b must have same patch hierarchy
     * - vectors \a x and \a b must have same structure, depth, etc.
     *
     * \note The vector arguments for solveSystem() need not match those for
     * initializeSolverState().  However, there must be a certain degree of
     * similarity, including:\par
     * - hierarchy configuration (hierarchy pointer and range of levels)
     * - number, type and alignment of vector component data
     * - ghost cell widths of data in the solution \a x and right-hand-side \a b
     *   vectors
     *
     * \note It is safe to call initializeSolverState() when the state is
     * already initialized.  In this case, the solver state is first deallocated
     * and then reinitialized.
     *
     * \note Subclasses of class PETScLevelSolver should \em not override this
     * method.  Instead, they should override the protected method
     * initializeSolverStateSpecialized().
     *
     * \see deallocateSolverState
     */
    void
    initializeSolverState(
        const SAMRAI::solv::SAMRAIVectorReal<NDIM,double>& x,
        const SAMRAI::solv::SAMRAIVectorReal<NDIM,double>& b);

    /*!
     * \brief Remove all hierarchy dependent data allocated by
     * initializeSolverState().
     *
     * \note It is safe to call deallocateSolverState() when the solver state is
     * already deallocated.
     *
     * \note Subclasses of class PETScLevelSolver should \em not override this
     * method.  Instead, they should override the protected method
     * deallocatedSolverStateSpecialized().
     *
     * \see initializeSolverState
     */
    void
    deallocateSolverState();

    //\}

protected:
    /*!
     * \brief Compute hierarchy dependent data required for solving \f$Ax=b\f$.
     */
    virtual void
    initializeSolverStateSpecialized(
        const SAMRAI::solv::SAMRAIVectorReal<NDIM,double>& x,
        const SAMRAI::solv::SAMRAIVectorReal<NDIM,double>& b) = 0;

    /*!
     * \brief Remove all hierarchy dependent data allocated by
     * initializeSolverStateSpecialized().
     */
    virtual void
    deallocateSolverStateSpecialized() = 0;

    /*!
     * \brief Copy a generic vector to the PETSc representation.
     */
    virtual void
    copyToPETScVec(
        Vec& petsc_x,
        SAMRAI::solv::SAMRAIVectorReal<NDIM,double>& x,
        SAMRAI::tbox::Pointer<SAMRAI::hier::PatchLevel<NDIM> > patch_level) = 0;

    /*!
     * \brief Copy a generic vector from the PETSc representation.
     */
    virtual void
    copyFromPETScVec(
        Vec& petsc_x,
        SAMRAI::solv::SAMRAIVectorReal<NDIM,double>& x,
        SAMRAI::tbox::Pointer<SAMRAI::hier::PatchLevel<NDIM> > patch_level) = 0;

    /*!
     * \brief Copy solution and right-hand-side data to the PETSc
     * representation, including any modifications to account for boundary
     * conditions.
     */
    virtual void
    setupKSPVecs(
        Vec& petsc_x,
        Vec& petsc_b,
        SAMRAI::solv::SAMRAIVectorReal<NDIM,double>& x,
        SAMRAI::solv::SAMRAIVectorReal<NDIM,double>& b,
        SAMRAI::tbox::Pointer<SAMRAI::hier::PatchLevel<NDIM> > patch_level) = 0;

    /*!
     * \brief Setup the solver nullspace (if any).
     */
    virtual void
    setupNullspace();

    /*!
     * \brief Associated hierarchy.
     */
    SAMRAI::tbox::Pointer<SAMRAI::hier::PatchHierarchy<NDIM> > d_hierarchy;

    /*!
     * \brief Associated level number.
     */
    int d_level_num;

    /*!
     * \name PETSc objects.
     */
    //\{
    std::string d_ksp_type;
    std::string d_options_prefix;
    KSP d_petsc_ksp;
    Mat d_petsc_mat, d_petsc_pc;
    MatStructure d_petsc_ksp_ops_flag;
    MatNullSpace d_petsc_nullsp;
    Vec d_petsc_x, d_petsc_b;
    //\}

private:
    /*!
     * \brief Default constructor.
     *
     * \note This constructor is not implemented and should not be used.
     */
    PETScLevelSolver();

    /*!
     * \brief Copy constructor.
     *
     * \note This constructor is not implemented and should not be used.
     *
     * \param from The value to copy to this object.
     */
    PETScLevelSolver(
        const PETScLevelSolver& from);

    /*!
     * \brief Assignment operator.
     *
     * \note This operator is not implemented and should not be used.
     *
     * \param that The value to assign to this object.
     *
     * \return A reference to this object.
     */
    PETScLevelSolver&
    operator=(
        const PETScLevelSolver& that);
};
}// namespace IBTK

/////////////////////////////// INLINE ///////////////////////////////////////

//#include <ibtk/PETScLevelSolver.I>

//////////////////////////////////////////////////////////////////////////////

#endif //#ifndef included_PETScLevelSolver
