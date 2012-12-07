//
// File:	$URL: file:///usr/casc/samrai/repository/SAMRAI/tags/v-2-4-4/source/patchdata/boxgeometry/CellGeometry.C $
// Package:	SAMRAI patch data geometry
// Copyright:	(c) 1997-2008 Lawrence Livermore National Security, LLC
// Revision:	$LastChangedRevision: 3061 $
// Modified:	$LastChangedDate: 2009-03-19 16:03:30 -0700 (Thu, 19 Mar 2009) $
// Description:	hier::Box geometry information for cell centered objects
//

#ifndef included_pdat_CellGeometry_C
#define included_pdat_CellGeometry_C

#include "CellGeometry.h"
#include "BoxList.h"
#include "CellOverlap.h"

#ifdef DEBUG_CHECK_ASSERTIONS
#include "tbox/Utilities.h"
#endif

#ifdef DEBUG_NO_INLINE
#include "CellGeometry.I"
#endif
namespace SAMRAI {
    namespace pdat {

/*
*************************************************************************
*									*
* Create a cell geometry object given the box and ghost cell width.	*
*									*
*************************************************************************
*/

template<int DIM>  CellGeometry<DIM>::CellGeometry(const hier::Box<DIM>& box,
                                       const hier::IntVector<DIM>& ghosts)
{
#ifdef DEBUG_CHECK_ASSERTIONS
   TBOX_ASSERT(ghosts.min() >= 0);
#endif
   d_box    = box;
   d_ghosts = ghosts;
}

template<int DIM>  CellGeometry<DIM>::~CellGeometry()
{
}

/*
*************************************************************************
*									*
* Attempt to calculate the intersection between two cell centered box	*
* geometries.  The calculateOverlap() checks whether both arguments are	*
* cell geometries; if so, it computes the intersection.  If not, then	*
* it calls calculateOverlap() on the source object (if retry is true)	*
* to allow the source a chance to calculate the intersection.  See the	*
* hier::BoxGeometry<DIM> base class for more information about the protocol.	*
* A pointer to null is returned if the intersection cannot be computed.	*
* 									*
*************************************************************************
*/

template<int DIM> tbox::Pointer< hier::BoxOverlap<DIM> > CellGeometry<DIM>::calculateOverlap(
   const hier::BoxGeometry<DIM>& dst_geometry,
   const hier::BoxGeometry<DIM>& src_geometry,
   const hier::Box<DIM>& src_mask,
   const bool overwrite_interior,
   const hier::IntVector<DIM>& src_offset,
   const bool retry) const
{
   const CellGeometry<DIM> *t_dst = 
      dynamic_cast<const CellGeometry<DIM> *>(&dst_geometry);
   const CellGeometry<DIM> *t_src = 
      dynamic_cast<const CellGeometry<DIM> *>(&src_geometry);

   tbox::Pointer< hier::BoxOverlap<DIM> > over = NULL;
   if ((t_src != NULL) && (t_dst != NULL)) {
      over = this->doOverlap(*t_dst, *t_src, src_mask, overwrite_interior, 
		       src_offset);
   } else if (retry) {
      over = src_geometry.calculateOverlap(dst_geometry, src_geometry,
                                           src_mask, overwrite_interior,
                                           src_offset, false);
   }
   return(over);
}

/*
*************************************************************************
*									*
* Compute the overlap between two cell centered boxes.  The two boxes	*
* are intersected and, if necessary, the interior section is removed	*
* from the destination box.						*
*									*
*************************************************************************
*/

template<int DIM> tbox::Pointer< hier::BoxOverlap<DIM> > CellGeometry<DIM>::doOverlap(
   const CellGeometry<DIM>& dst_geometry,
   const CellGeometry<DIM>& src_geometry,
   const hier::Box<DIM>& src_mask,
   const bool overwrite_interior,
   const hier::IntVector<DIM>& src_offset)
{
   hier::BoxList<DIM> dst_boxes;

   // Translate the source box and grow the destination box by the ghost cells

   const hier::Box<DIM> src_box =
      hier::Box<DIM>::grow(src_geometry.d_box, src_geometry.d_ghosts) * src_mask;
   const hier::Box<DIM> src_shift =
      hier::Box<DIM>::shift(src_box, src_offset);
   const hier::Box<DIM> dst_ghost =
      hier::Box<DIM>::grow(dst_geometry.d_box, dst_geometry.d_ghosts);

   // Convert the boxes into cell space and compute the intersection

   const hier::Box<DIM> dst_cell = CellGeometry<DIM>::toCellBox(dst_ghost);
   const hier::Box<DIM> src_cell = CellGeometry<DIM>::toCellBox(src_shift);
   const hier::Box<DIM> together = dst_cell * src_cell;

   if (!together.empty()) {
      if (!overwrite_interior) {
         const hier::Box<DIM> int_cell = toCellBox(dst_geometry.d_box);
         dst_boxes.removeIntersections(together,int_cell);
      } else {
         dst_boxes.appendItem(together);
      }
   }

   // Create the cell overlap data object using the boxes and source shift

   hier::BoxOverlap<DIM> *overlap = new CellOverlap<DIM>(dst_boxes, src_offset);
   return(tbox::Pointer< hier::BoxOverlap<DIM> >(overlap));
}

template<int DIM>
void CellGeometry<DIM>::computeDestinationBoxes(
   hier::BoxList<DIM>& dst_boxes,
   const CellGeometry<DIM>& src_geometry,
   const hier::Box<DIM>& src_mask,
   const bool overwrite_interior,
   const hier::IntVector<DIM>& src_offset) const
{

   // Translate the source box and grow the destination box by the ghost cells

   const hier::Box<DIM> src_box =
      hier::Box<DIM>::grow(src_geometry.d_box, src_geometry.d_ghosts) * src_mask;
   const hier::Box<DIM> src_shift =
      hier::Box<DIM>::shift(src_box, src_offset);
   const hier::Box<DIM> dst_ghost =
      hier::Box<DIM>::grow(d_box, d_ghosts);

   // Convert the boxes into cell space and compute the intersection

   const hier::Box<DIM> dst_cell = CellGeometry<DIM>::toCellBox(dst_ghost);
   const hier::Box<DIM> src_cell = CellGeometry<DIM>::toCellBox(src_shift);
   const hier::Box<DIM> together = dst_cell * src_cell;

   if (!together.empty()) {
      if (!overwrite_interior) {
         const hier::Box<DIM> int_cell = toCellBox(d_box);
         dst_boxes.removeIntersections(together,int_cell);
      } else {
         dst_boxes.appendItem(together);
      }
   }
}


}
}
#endif
