// Filename: CellNoCornersFillPattern.h
// Created on 09 Mar 2010 by Boyce Griffith
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

#ifndef included_CellNoCornersFillPattern
#define included_CellNoCornersFillPattern

/////////////////////////////// INCLUDES /////////////////////////////////////

// SAMRAI INCLUDES
#include <VariableFillPattern.h>

/////////////////////////////// CLASS DEFINITION /////////////////////////////

namespace IBTK
{
/*!
 * \brief Class CellCellNoCornersFillPattern is a concrete implementation of the
 * abstract base class SAMRAI::xfer::VariableFillPattern.  It is used to
 * calculate overlaps according to a pattern which limits overlaps to the
 * cell-centered ghost region surrounding a patch, excluding all corners.  In
 * 3D, it is also possible to configure this fill pattern object also to exclude
 * all edges.
 */
class CellNoCornersFillPattern
    : public virtual SAMRAI::xfer::VariableFillPattern<NDIM>
{
public:
    /*!
     * \brief Constructor.
     *
     * \note Parameters include_edges_on_dst_level and
     * include_edges_on_src_level have no effect for 2D problems.
     */
    CellNoCornersFillPattern(
        const int stencil_width,
        const bool include_edges_on_dst_level,
        const bool include_edges_on_src_level);

    /*!
     * \brief Destructor.
     */
    virtual
    ~CellNoCornersFillPattern();

    /*!
     * Calculate overlaps between the destination and source geometries according
     * to the desired pattern.  This will return the portion of the intersection
     * of the geometries that lies in the ghost region of the specified width
     * surrounding the patch, excluding all edges and corners.  The patch is
     * identified by the argument dst_patch_box.
     *
     * \param dst_geometry        geometry object for destination box
     * \param src_geometry        geometry object for source box
     * \param dst_patch_box       box for the destination patch
     * \param src_mask            the source mask, the box resulting from shifting the source box
     * \param overwrite_interior  controls whether or not to include the destination box interior in the overlap
     * \param src_offset          the offset between source and destination index space (src + src_offset = dst)
     *
     * \return                    pointer to the calculated overlap object
     */
    virtual SAMRAI::tbox::Pointer<SAMRAI::hier::BoxOverlap<NDIM> >
    calculateOverlap(
        const SAMRAI::hier::BoxGeometry<NDIM>& dst_geometry,
        const SAMRAI::hier::BoxGeometry<NDIM>& src_geometry,
        const SAMRAI::hier::Box<NDIM>& dst_patch_box,
        const SAMRAI::hier::Box<NDIM>& src_mask,
        const bool overwrite_interior,
        const SAMRAI::hier::IntVector<NDIM>& src_offset) const;

    /*!
     * Calculate overlaps between the destination and source geometries according
     * to the desired pattern.  This will return the portion of the intersection
     * of the geometries that lies in the ghost region of the specified width
     * surrounding the patch, excluding all edges and corners.  The patch is
     * identified by the argument dst_patch_box.
     *
     * \param dst_geometry        geometry object for destination box
     * \param src_geometry        geometry object for source box
     * \param dst_patch_box       box for the destination patch
     * \param src_mask            the source mask, the box resulting from shifting the source box
     * \param overwrite_interior  controls whether or not to include the destination box interior in the overlap
     * \param src_offset          the offset between source and destination index space (src + src_offset = dst)
     * \param dst_level_num       the level of the patch hierarchy on which the dst boxes are located
     * \param src_level_num       the level of the patch hierarchy on which the src boxes are located
     *
     * \return                    pointer to the calculated overlap object
     */
    virtual SAMRAI::tbox::Pointer<SAMRAI::hier::BoxOverlap<NDIM> >
    calculateOverlap(
        const SAMRAI::hier::BoxGeometry<NDIM>& dst_geometry,
        const SAMRAI::hier::BoxGeometry<NDIM>& src_geometry,
        const SAMRAI::hier::Box<NDIM>& dst_patch_box,
        const SAMRAI::hier::Box<NDIM>& src_mask,
        const bool overwrite_interior,
        const SAMRAI::hier::IntVector<NDIM>& src_offset,
        const int dst_level_num,
        const int src_level_num) const;

    /*!
     * Set the target patch level number for the variable fill pattern.
     */
    virtual void
    setTargetPatchLevelNumber(
        const int level_num);

    /*!
     * Returns the stencil width.
     */
    virtual SAMRAI::hier::IntVector<NDIM>&
    getStencilWidth();

    /*!
     * Returns a string name identifier "CELL_NO_CORNERS_FILL_PATTERN".
     */
    virtual const std::string&
    getPatternName() const;

private:
    /*!
     * \brief Default constructor.
     *
     * \note This constructor is not implemented and should not be used.
     */
    CellNoCornersFillPattern();

    /*!
     * \brief Copy constructor.
     *
     * \note This constructor is not implemented and should not be used.
     *
     * \param from The value to copy to this object.
     */
    CellNoCornersFillPattern(
        const CellNoCornersFillPattern& from);

    /*!
     * \brief Assignment operator.
     *
     * \note This operator is not implemented and should not be used.
     *
     * \param that The value to assign to this object.
     *
     * \return A reference to this object.
     */
    CellNoCornersFillPattern&
    operator=(
        const CellNoCornersFillPattern& that);

    SAMRAI::hier::IntVector<NDIM> d_stencil_width;
    const bool d_include_edges_on_dst_level;
    const bool d_include_edges_on_src_level;
    int d_target_level_num;
};
}// namespace IBTK

/////////////////////////////// INLINE ///////////////////////////////////////

//#include "CellNoCornersFillPattern.I"

//////////////////////////////////////////////////////////////////////////////

#endif //#ifndef included_CellNoCornersFillPattern
