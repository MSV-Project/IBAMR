// Filename: CartSideRobinPhysBdryOp.h
// Created on 21 May 2008 by Boyce Griffith
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

#ifndef included_CartSideRobinPhysBdryOp
#define included_CartSideRobinPhysBdryOp

/////////////////////////////// INCLUDES /////////////////////////////////////

// IBTK INCLUDES
#include <ibtk/RobinPhysBdryPatchStrategy.h>

/////////////////////////////// CLASS DEFINITION /////////////////////////////

namespace IBTK
{
/*!
 * \brief Class CartSideRobinPhysBdryOp is a concrete
 * SAMRAI::xfer::RefinePatchStrategy for setting Robin boundary conditions at
 * physical boundaries for side-centered vector-valued quantities.
 *
 * \note This class is intended to be used to specify boundary conditions for
 * MAC vector fields and may not work correctly for other types of data.
 *
 * \warning Presently, this class only supports pure Dirichlet or pure Neumann
 * boundary conditions for the normal component of the vector field.  Mixed
 * (Robin) boundary conditions are \em not supported in the normal direction.
 */
class CartSideRobinPhysBdryOp
    : public RobinPhysBdryPatchStrategy
{
public:
    /*!
     * \brief Default constructor.
     *
     * \note This constructor leaves the class in an undefined state.  In
     * particular, the patch data indices requiring cell filling and the
     * boundary condition specifications must be set prior to use of method
     * setPhysicalBoundaryConditions().
     *
     * \see setPatchDataIndex
     * \see setPatchDataIndices
     * \see setPhysicalBcCoef
     * \see setPhysicalBcCoefs
     * \see setHomogeneousBc
     */
    CartSideRobinPhysBdryOp();

    /*!
     * \brief Constructor to fill boundary conditions for vector-valued
     * quantities.  Distinct boundary condition objects are provided for each
     * vector component.
     *
     * \param patch_data_index  Patch data index requiring ghost cell filling.
     * \param bc_coefs          Robin boundary conditions to use with this class.
     * \param homogeneous_bc    Whether to employ the homogeneous form of the boundary conditions.
     */
    CartSideRobinPhysBdryOp(
        int patch_data_index,
        const std::vector<SAMRAI::solv::RobinBcCoefStrategy<NDIM>*>& bc_coefs,
        bool homogeneous_bc=false);

    /*!
     * \brief Constructor to fill boundary conditions for vector-valued
     * quantities.  Distinct boundary condition objects are provided for each
     * vector component.
     *
     * \param patch_data_indices  Collection of patch data indices which require ghost cell filling.
     * \param bc_coefs            Robin boundary conditions to use with this class.
     * \param homogeneous_bc      Whether to employ the homogeneous form of the boundary conditions.
     */
    CartSideRobinPhysBdryOp(
        const std::set<int>& patch_data_indices,
        const std::vector<SAMRAI::solv::RobinBcCoefStrategy<NDIM>*>& bc_coefs,
        bool homogeneous_bc=false);

    /*!
     * \brief Constructor to fill boundary conditions for vector-valued
     * quantities.  Distinct boundary condition objects are provided for each
     * vector component.
     *
     * \param patch_data_indices  Collection of patch data indices which require ghost cell filling.
     * \param bc_coefs            Robin boundary conditions to use with this class.
     * \param homogeneous_bc      Whether to employ the homogeneous form of the boundary conditions.
     */
    CartSideRobinPhysBdryOp(
        const SAMRAI::hier::ComponentSelector& patch_data_indices,
        const std::vector<SAMRAI::solv::RobinBcCoefStrategy<NDIM>*>& bc_coefs,
        bool homogeneous_bc=false);

    /*!
     * \brief Destructor.
     */
    ~CartSideRobinPhysBdryOp();

    /*!
     * \name Implementation of SAMRAI::xfer::RefinePatchStrategy interface.
     */
    //\{

    /*!
     * Function to set data associated with the given list of patch data indices
     * at patch boundaries that intersect the physical domain boundary.  The
     * patch data components set in this routine correspond to the "scratch"
     * components specified in calls to the registerRefine() function in the
     * SAMRAI::xfer::RefineAlgorithm class.
     *
     * \param patch                Patch on which to fill boundary data.
     * \param fill_time            Double simulation time for boundary filling.
     * \param ghost_width_to_fill  Integer vector describing maximum ghost width to fill over all registered scratch components.
     */
    void
    setPhysicalBoundaryConditions(
        SAMRAI::hier::Patch<NDIM>& patch,
        double fill_time,
        const SAMRAI::hier::IntVector<NDIM>& ghost_width_to_fill);

    /*!
     * Function to return maximum stencil width needed over user-defined data
     * interpolation operations.  This is needed to determine the correct
     * interpolation data dependencies.
     */
    SAMRAI::hier::IntVector<NDIM>
    getRefineOpStencilWidth() const;

    //\}

protected:

private:
    /*!
     * \brief Copy constructor.
     *
     * \note This constructor is not implemented and should not be used.
     *
     * \param from The value to copy to this object.
     */
    CartSideRobinPhysBdryOp(
        const CartSideRobinPhysBdryOp& from);

    /*!
     * \brief Assignment operator.
     *
     * \note This operator is not implemented and should not be used.
     *
     * \param that The value to assign to this object.
     *
     * \return A reference to this object.
     */
    CartSideRobinPhysBdryOp&
    operator=(
        const CartSideRobinPhysBdryOp& that);

    /*!
     * \brief Set the boundary conditions along the co-dimension one boundary.
     */
    void
    setCodimension1BdryValues(
        int patch_data_idx,
        const SAMRAI::tbox::Array<SAMRAI::hier::BoundaryBox<NDIM> >& physical_codim1_boxes,
        double fill_time,
        const SAMRAI::hier::IntVector<NDIM>& ghost_width_to_fill,
        SAMRAI::hier::Patch<NDIM>& patch);

#if (NDIM > 1)
    /*!
     * \brief Set the boundary conditions along the co-dimension two boundary.
     */
    void
    setCodimension2BdryValues(
        int patch_data_idx,
        const SAMRAI::tbox::Array<SAMRAI::hier::BoundaryBox<NDIM> >& physical_codim2_boxes,
        const SAMRAI::hier::IntVector<NDIM>& ghost_width_to_fill,
        const SAMRAI::hier::Patch<NDIM>& patch);
#if (NDIM > 2)
    /*!
     * \brief Set the boundary conditions along the co-dimension three boundary.
     */
    void
    setCodimension3BdryValues(
        int patch_data_idx,
        const SAMRAI::tbox::Array<SAMRAI::hier::BoundaryBox<NDIM> >& physical_codim3_boxes,
        const SAMRAI::hier::IntVector<NDIM>& ghost_width_to_fill,
        const SAMRAI::hier::Patch<NDIM>& patch);
#endif
#endif
};
}// namespace IBTK

/////////////////////////////// INLINE ///////////////////////////////////////

//#include <ibtk/CartSideRobinPhysBdryOp.I>

//////////////////////////////////////////////////////////////////////////////

#endif //#ifndef included_CartSideRobinPhysBdryOp
