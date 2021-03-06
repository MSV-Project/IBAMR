// Filename: IBImplicitStaggeredPETScLevelSolver.h
// Created on 16 Apr 2012 by Boyce Griffith
//
// Copyright (c) 2002-2013, Boyce Griffith
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

#ifndef included_IBImplicitStaggeredPETScLevelSolver
#define included_IBImplicitStaggeredPETScLevelSolver

/////////////////////////////// INCLUDES /////////////////////////////////////

#include <string>
#include <vector>

#include "CellVariable.h"
#include "RefineSchedule.h"
#include "SideVariable.h"
#include "VariableContext.h"
#include "ibamr/StokesSpecifications.h"
#include "ibtk/PETScLevelSolver.h"
#include "petscmat.h"
#include "petscvec.h"
#include "tbox/Pointer.h"

namespace SAMRAI {
namespace hier {
template <int DIM> class PatchLevel;
}  // namespace hier
namespace solv {
template <int DIM, class TYPE> class SAMRAIVectorReal;
template <int DIM> class LocationIndexRobinBcCoefs;
template <int DIM> class RobinBcCoefStrategy;
}  // namespace solv
namespace tbox {
class Database;
}  // namespace tbox
}  // namespace SAMRAI

/////////////////////////////// CLASS DEFINITION /////////////////////////////

namespace IBAMR
{
/*!
 * \brief Class IBImplicitStaggeredPETScLevelSolver is a concrete LinearSolver
 * for a staggered-grid (MAC) discretization of a linearly implicit version of
 * the IB method.
 *
 * \see IBImplicitStaggeredHierarchyIntegrator
 */
class IBImplicitStaggeredPETScLevelSolver
    : public IBTK::PETScLevelSolver
{
public:
    /*!
     * \brief Constructor.
     */
    IBImplicitStaggeredPETScLevelSolver(
        const std::string& object_name,
        SAMRAI::tbox::Pointer<SAMRAI::tbox::Database> input_db,
        const std::string& default_options_prefix);

    /*!
     * \brief Destructor.
     */
    ~IBImplicitStaggeredPETScLevelSolver();

    /*!
     * \brief Initialize the operator.
     */
    void
    initializeOperator();

    /*!
     * \brief Update the operator.
     */
    void
    updateOperator();

protected:
    /*!
     * \brief Compute hierarchy dependent data required for solving \f$Ax=b\f$.
     */
    void
    initializeSolverStateSpecialized(
        const SAMRAI::solv::SAMRAIVectorReal<NDIM,double>& x,
        const SAMRAI::solv::SAMRAIVectorReal<NDIM,double>& b);

    /*!
     * \brief Remove all hierarchy dependent data allocated by
     * initializeSolverStateSpecialized().
     */
    void
    deallocateSolverStateSpecialized();

    /*!
     * \brief Copy a generic vector to the PETSc representation.
     */
    void
    copyToPETScVec(
        Vec& petsc_x,
        SAMRAI::solv::SAMRAIVectorReal<NDIM,double>& x,
        SAMRAI::tbox::Pointer<SAMRAI::hier::PatchLevel<NDIM> > patch_level);

    /*!
     * \brief Copy a generic vector from the PETSc representation.
     */
    void
    copyFromPETScVec(
        Vec& petsc_x,
        SAMRAI::solv::SAMRAIVectorReal<NDIM,double>& x,
        SAMRAI::tbox::Pointer<SAMRAI::hier::PatchLevel<NDIM> > patch_level);

    /*!
     * \brief Copy solution and right-hand-side data to the PETSc
     * representation, including any modifications to account for boundary
     * conditions.
     */
    void
    setupKSPVecs(
        Vec& petsc_x,
        Vec& petsc_b,
        SAMRAI::solv::SAMRAIVectorReal<NDIM,double>& x,
        SAMRAI::solv::SAMRAIVectorReal<NDIM,double>& b,
        SAMRAI::tbox::Pointer<SAMRAI::hier::PatchLevel<NDIM> > patch_level);

private:
    /*!
     * \brief Default constructor.
     *
     * \note This constructor is not implemented and should not be used.
     */
    IBImplicitStaggeredPETScLevelSolver();

    /*!
     * \brief Copy constructor.
     *
     * \note This constructor is not implemented and should not be used.
     *
     * \param from The value to copy to this object.
     */
    IBImplicitStaggeredPETScLevelSolver(
        const IBImplicitStaggeredPETScLevelSolver& from);

    /*!
     * \brief Assignment operator.
     *
     * \note This operator is not implemented and should not be used.
     *
     * \param that The value to assign to this object.
     *
     * \return A reference to this object.
     */
    IBImplicitStaggeredPETScLevelSolver&
    operator=(
        const IBImplicitStaggeredPETScLevelSolver& that);

    /*!
     * \name Problem specification and boundary condition handling.
     */
    //\{

    /*
     * Problem coefficient specifications.
     */
    StokesSpecifications d_problem_coefs;
    double d_dt;

    /*!
     * Fluid operator.
     */
    Mat d_stokes_mat;

    /*!
     * Structure operator and coupling position vector.
     */
    Mat* d_J_mat;
    void (*d_interp_fcn)(double r_lower,double* w);
    int d_interp_stencil;
    Vec* d_X_vec;
    Mat d_R_mat, d_RtJR_mat;

    /*!
     * \brief Boundary coefficient object for physical boundaries and related
     * data.
     */
    SAMRAI::solv::LocationIndexRobinBcCoefs<NDIM>* const d_default_u_bc_coef;
    std::vector<SAMRAI::solv::RobinBcCoefStrategy<NDIM>*> d_u_bc_coefs;

    //\}

    /*!
     * \name PETSc objects.
     */
    //\{

    SAMRAI::tbox::Pointer<SAMRAI::hier::VariableContext> d_context;
    std::vector<int> d_num_dofs_per_proc;
    int d_u_dof_index_idx, d_p_dof_index_idx;
    SAMRAI::tbox::Pointer<SAMRAI::pdat::SideVariable<NDIM,int> > d_u_dof_index_var;
    SAMRAI::tbox::Pointer<SAMRAI::pdat::CellVariable<NDIM,int> > d_p_dof_index_var;
    SAMRAI::tbox::Pointer<SAMRAI::xfer::RefineSchedule<NDIM> > d_data_synch_sched, d_ghost_fill_sched;

    //\}
};
}// namespace IBAMR

//////////////////////////////////////////////////////////////////////////////

#endif //#ifndef included_IBImplicitStaggeredPETScLevelSolver
