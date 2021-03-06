// Filename: PETScVecUtilities.h
// Created on 23 Aug 2010 by Boyce Griffith
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

#ifndef included_PETScVecUtilities
#define included_PETScVecUtilities

/////////////////////////////// INCLUDES /////////////////////////////////////

#include <vector>

#include "petscvec.h"
#include "tbox/Pointer.h"

namespace SAMRAI {
namespace hier {
template <int DIM> class PatchLevel;
}  // namespace hier
namespace xfer {
template <int DIM> class RefineSchedule;
}  // namespace xfer
}  // namespace SAMRAI

/////////////////////////////// CLASS DEFINITION /////////////////////////////

namespace IBTK
{
/*!
 * \brief Class PETScVecUtilities provides utility functions for <A
 * HREF="http://www.mcs.anl.gov/petsc">PETSc</A> Vec objects.
 */
class PETScVecUtilities
{
public:
    /*!
     * \name Methods acting on SAMRAI::hier::PatchLevel and
     * SAMRAI::hier::Variable objects.
     */
    //\{

    /*!
     * \brief Copy data to a parallel PETSc Vec on the provided
     * SAMRAI::hier::PatchLevel.
     */
    static void
    copyToPatchLevelVec(
        Vec& vec,
        int data_idx,
        int dof_index_idx,
        SAMRAI::tbox::Pointer<SAMRAI::hier::PatchLevel<NDIM> > patch_level);

    /*!
     * \brief Copy data from a parallel PETSc Vec on the provided
     * SAMRAI::hier::PatchLevel.
     */
    static void
    copyFromPatchLevelVec(
        Vec& vec,
        int data_idx,
        int dof_index_idx,
        SAMRAI::tbox::Pointer<SAMRAI::hier::PatchLevel<NDIM> > patch_level,
        SAMRAI::tbox::Pointer<SAMRAI::xfer::RefineSchedule<NDIM> > data_synch_sched,
        SAMRAI::tbox::Pointer<SAMRAI::xfer::RefineSchedule<NDIM> > ghost_fill_sched);

    /*!
     * \brief Construct a RefineSchedule to synchronize shared values that can
     * be used in conjunction with copyFromPatchLevelVec().
     *
     * \note Synchronization is not required for all data centerings.  For cases
     * in which it is not needed, this method will return a NULL pointer.
     */
    static SAMRAI::tbox::Pointer<SAMRAI::xfer::RefineSchedule<NDIM> >
    constructDataSynchSchedule(
        int data_idx,
        SAMRAI::tbox::Pointer<SAMRAI::hier::PatchLevel<NDIM> > patch_level);

    /*!
     * \brief Construct a RefineSchedule to fill ghost cell values that can be
     * used in conjunction with copyFromPatchLevelVec().
     */
    static SAMRAI::tbox::Pointer<SAMRAI::xfer::RefineSchedule<NDIM> >
    constructGhostFillSchedule(
        int data_idx,
        SAMRAI::tbox::Pointer<SAMRAI::hier::PatchLevel<NDIM> > patch_level);

    /*!
     * \brief Assign a DOF index to each unique degree of freedom on a
     * SAMRAI::hier::PatchLevel.
     *
     * The DOF indices generated by this method are compatible with the parallel
     * PETSc Vec objects generated by constructPatchLevelVec().
     *
     * \note DOF indices are \em not assigned to ghost cell values by this
     * method.
     */
    static void
    constructPatchLevelDOFIndices(
        std::vector<int>& num_dofs_per_proc,
        int dof_index_idx,
        SAMRAI::tbox::Pointer<SAMRAI::hier::PatchLevel<NDIM> > patch_level);

    //\}

protected:

private:
    /*!
     * \brief Default constructor.
     *
     * \note This constructor is not implemented and should not be used.
     */
    PETScVecUtilities();

    /*!
     * \brief Copy constructor.
     *
     * \note This constructor is not implemented and should not be used.
     *
     * \param from The value to copy to this object.
     */
    PETScVecUtilities(
        const PETScVecUtilities& from);

    /*!
     * \brief Assignment operator.
     *
     * \note This operator is not implemented and should not be used.
     *
     * \param that The value to assign to this object.
     *
     * \return A reference to this object.
     */
    PETScVecUtilities&
    operator=(
        const PETScVecUtilities& that);

    /*!
     * \brief Implementation of copyToPatchLevelVec() for cell-centered data.
     */
    static void
    copyToPatchLevelVec_cell(
        Vec& vec,
        int data_idx,
        int dof_index_idx,
        SAMRAI::tbox::Pointer<SAMRAI::hier::PatchLevel<NDIM> > patch_level);

    /*!
     * \brief Implementation of copyToPatchLevelVec() for side-centered data.
     */
    static void
    copyToPatchLevelVec_side(
        Vec& vec,
        int data_idx,
        int dof_index_idx,
        SAMRAI::tbox::Pointer<SAMRAI::hier::PatchLevel<NDIM> > patch_level);

    /*!
     * \brief Implementation of copyFromPatchLevelVec() for cell-centered data.
     */
    static void
    copyFromPatchLevelVec_cell(
        Vec& vec,
        int data_idx,
        int dof_index_idx,
        SAMRAI::tbox::Pointer<SAMRAI::hier::PatchLevel<NDIM> > patch_level);

    /*!
     * \brief Implementation of copyFromPatchLevelVec() for side-centered data.
     */
    static void
    copyFromPatchLevelVec_side(
        Vec& vec,
        int data_idx,
        int dof_index_idx,
        SAMRAI::tbox::Pointer<SAMRAI::hier::PatchLevel<NDIM> > patch_level);

    /*!
     * \brief Implementation of constructPatchLevelDOFIndices() for
     * cell-centered data.
     */
    static void
    constructPatchLevelDOFIndices_cell(
        std::vector<int>& num_dofs_proc,
        int dof_index_idx,
        SAMRAI::tbox::Pointer<SAMRAI::hier::PatchLevel<NDIM> > patch_level);

    /*!
     * \brief Implementation of constructPatchLevelDOFIndices() for
     * side-centered data.
     */
    static void
    constructPatchLevelDOFIndices_side(
        std::vector<int>& num_dofs_proc,
        int dof_index_idx,
        SAMRAI::tbox::Pointer<SAMRAI::hier::PatchLevel<NDIM> > patch_level);
};
}// namespace IBTK

//////////////////////////////////////////////////////////////////////////////

#endif //#ifndef included_PETScVecUtilities
