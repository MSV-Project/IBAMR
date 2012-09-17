//
// File:	$URL: file:///usr/casc/samrai/repository/SAMRAI/tags/v-2-4-4/source/hierarchy/boxes/BoxList.C $
// Package:	SAMRAI hierarchy
// Copyright:	(c) 1997-2008 Lawrence Livermore National Security, LLC
// Revision:	$LastChangedRevision: 2141 $
// Modified:	$LastChangedDate: 2008-04-23 08:36:33 -0700 (Wed, 23 Apr 2008) $
// Description:	A list of boxes with basic domain calculus operations
//

#ifndef included_hier_BoxList_C
#define included_hier_BoxList_C

#include "BoxList.h"

#include "BoxArray.h"
#include "Index.h"
#ifdef DEBUG_CHECK_ASSERTIONS
#include "tbox/Utilities.h"
#endif

#ifdef DEBUG_NO_INLINE
#include "BoxList.I"
#endif

namespace SAMRAI {
   namespace hier {


/*
*************************************************************************
*									*
* Implement the various constructors and the assignment operator for	*
* the list of boxes.  Note that none of these routines modify their	*
* arguments.								*
*									*
*************************************************************************
*/

template<int DIM>  BoxList<DIM>::BoxList(const Box<DIM>& box)
:  tbox::List< Box<DIM> >()
{
  this->addItem(box);
}

template<int DIM>  BoxList<DIM>::BoxList(const BoxList<DIM>& list)
:  tbox::List< Box<DIM> >()
{
  this->copyItems(list);
}
      
template<int DIM>  BoxList<DIM>::BoxList(const BoxArray<DIM>& array)
:  tbox::List< Box<DIM> >()
{
   const int n = array.getNumberOfBoxes();
   for (int i = 0; i < n; i++) {
     this->appendItem(array[i]);
   }
}

template<int DIM> BoxList<DIM>& BoxList<DIM>::operator=(const BoxList<DIM>& list)
{
   if (this != &list) {
      this->clearItems();
      this->copyItems(list);
   }
   return(*this);
}

/*
*************************************************************************
*									*
* Function simplifyBoxes() takes the complicated list of boxes and	*
* coalesces regions together where possible.				*
*									*
* The canonical ordering for boxes is defined such that boxes which	*
* lie next to each other in higher dimensions are coalesced together	*
* before boxes which lie next to each other in lower dimensions.	*
* Thus, we try to coalesce two boxes together on the higher		*
* dimensions first.							*
*									*
* Assuming that two boxes a and b of dimension DIM are in canonical	*
* order for dimensions d+1, ..., D, we can coalesce them together on	*
* dimension d if:							*
*									*
*	(1) the lower and upper bounds for a and b agree for all	*
*	    dimensions greater than d					*
*	(2) boxes a and b overlap or are next to each other in		*
*	    dimension d							*
*	(3) boxes a and b overlap for all dimensions less than d	*
*									*
* If these conditions hold, then we break up the two boxes and put	*
* them onto the list of non-canonical boxes.				*
*									*
*************************************************************************
*/

template<int DIM> void BoxList<DIM>::simplifyBoxes()
{
   // Start coalescing on the highest dimension of the lists and work down
   // While there are non-canonical boxes, pick somebody off of the list

   BoxList<DIM> notCanonical;
   for (int d = DIM-1; d >= 0; d--) {
      notCanonical.catenateItems(*this);
      while (!notCanonical.isEmpty()) {
         Box<DIM> tryMe = notCanonical.getFirstItem();
         notCanonical.removeFirstItem();

         // Pick somebody off of the canonical list and compare against tryMe

         if (!tryMe.empty()) {
            bool combineDaPuppies = false;
            typename BoxList<DIM>::Iterator l;
            for (l = this ->listStart(); l; l++) {
               const Box<DIM> andMe = l();

               const Index<DIM>& al = andMe.lower();
               const Index<DIM>& ah = andMe.upper();
               const Index<DIM>& bl = tryMe.lower();
               const Index<DIM>& bh = tryMe.upper();

               combineDaPuppies = true;
               for (int du = d+1; du < DIM; du++) {
                  if ((al(du) != bl(du)) || (ah(du) != bh(du))) {
                     combineDaPuppies = false;
                     break;
                  }
               }
               if (combineDaPuppies) {
                  if ((bl(d) > ah(d)+1) || (bh(d) < al(d)-1)) {
                     combineDaPuppies = false;
                  } else {
                     for (int dl = 0; dl < d; dl++) {
                        if ((bl(dl) > ah(dl)) || (bh(dl) < al(dl))) {
                           combineDaPuppies = false;
                           break;
                        }
                     }
                  }
               }
               if (combineDaPuppies) break;
            }

         // If we are at the end of the canonical list, then just add
         // Otherwise, burst tryMe and andMe and put on noncanonical

            if (!combineDaPuppies) {
              this->appendItem(tryMe);
            } else {
               Box<DIM> andMe = l();
               this->removeItem(l);
               const Index<DIM>& bl = tryMe.lower();
               const Index<DIM>& bh = tryMe.upper();
               Index<DIM> il = andMe.lower();
               Index<DIM> ih = andMe.upper();
               for (int dl = 0; dl < d; dl++) {
                  if (il(dl) < bl(dl)) il(dl) = bl(dl);
                  if (ih(dl) > bh(dl)) ih(dl) = bh(dl);
               }
               if (bl(d) < il(d)) il(d) = bl(d);
               if (bh(d) > ih(d)) ih(d) = bh(d);
               Box<DIM> intersection(il, ih);
               notCanonical.addItem(intersection);
               if (d > 0) {
                  notCanonical.burstBoxes(tryMe, intersection, d);
                  notCanonical.burstBoxes(andMe, intersection, d);
               }
            }
         }
      }
   }
}

/*
*************************************************************************
*									*
* Break up box bursty against box solid and adds the pieces to list.	*
* The bursting is done on dimensions 0 through dimension-1, starting	*
* with lowest dimensions first to try to maintain the canonical		*
* representation for the bursted domains.				*
*									*
*************************************************************************
*/

template<int DIM> void BoxList<DIM>::burstBoxes(const Box<DIM>& bursty,
                               const Box<DIM>& solid,
                               const int dimension)
{
   // Set up the lower and upper bounds of the regions for ease of access

   Index<DIM> burstl = bursty.lower();
   Index<DIM> bursth = bursty.upper();
   const Index<DIM>& solidl = solid.lower();
   const Index<DIM>& solidh = solid.upper();

   // Break bursty region against solid region along low dimensions first

   for (int d = 0; d < dimension; d++) {
      if (bursth(d) > solidh(d)) {
         Index<DIM> newl = burstl;
         newl(d) = solidh(d) + 1;
         this->appendItem(Box<DIM>(newl, bursth));
         bursth(d) = solidh(d);
      }
      if (burstl(d) < solidl(d)) {
         Index<DIM> newh = bursth;
         newh(d) = solidl(d) - 1;
         this->appendItem(Box<DIM>(burstl, newh));
         burstl(d) = solidl(d);
      }
   }
}

/*
*************************************************************************
*									*
* Return the current list without the portions that intersect takeaway.	*
*									*
*************************************************************************
*/

template<int DIM> void BoxList<DIM>::removeIntersections(const Box<DIM>& takeaway)
{
   BoxList<DIM> fragments;
   while (!this ->isEmpty()) {
      Box<DIM> tryme = this ->getFirstItem();
      this ->removeFirstItem();
      if ((tryme * takeaway).empty()) {
         fragments.appendItem(tryme);
      } else {
         fragments.burstBoxes(tryme, takeaway, DIM);
      }
   }
   this->catenateItems(fragments);
}

template<int DIM> void BoxList<DIM>::removeIntersections(const Box<DIM>& box,
                                        const Box<DIM>& takeaway)
{
   /*
    * The boxlist MUST be empty to use this function (see comments
    * in header file for discussion of why). If the two boxes intersect,
    * form a boxlist that contains the boxes resulting from removing
    * the intersection of box with takeaway.  If the two boxes do not
    * intersect, simply add box to the box list (no intersection removed).
    */
#ifdef DEBUG_CHECK_ASSERTIONS
   TBOX_ASSERT(this ->isEmpty());
#endif

   if (!(box * takeaway).empty()) {
      BoxList<DIM>::burstBoxes(box, takeaway, DIM);
   } else {
     this->appendItem(box);
   }

}

template<int DIM> void BoxList<DIM>::removeIntersections(const BoxList<DIM>& takeaway)
{
   for (typename BoxList<DIM>::Iterator remove(takeaway); remove; remove++) {
      const Box<DIM>& byebye = remove();
      BoxList<DIM>::removeIntersections(byebye);
   }
}

/*
*************************************************************************
*									*
* Return the boxes in the current list that intersect the index space	*
* of the argument.							*
*									*
*************************************************************************
*/

template<int DIM> void BoxList<DIM>::intersectBoxes(const Box<DIM>& box)
{
   BoxList<DIM> intersection;
   while (!this ->isEmpty()) {
      Box<DIM> tryme = this ->getFirstItem();
      this ->removeFirstItem();
      Box<DIM> overlap = tryme * box;
      if (!overlap.empty()) {
         intersection.appendItem(overlap);
      }
   }
   this->catenateItems(intersection);
}

template<int DIM> void BoxList<DIM>::intersectBoxes(const BoxList<DIM>& boxes)
{
   BoxList<DIM> intersection;
   while (!this ->isEmpty()) {
      Box<DIM> tryme = this ->getFirstItem();
      this ->removeFirstItem();
      for (typename BoxList<DIM>::Iterator i(boxes); i; i++) {
         Box<DIM> overlap = tryme * i();
         if (!overlap.empty()) {
            intersection.appendItem(overlap);
         }
      }
   }
   this->catenateItems(intersection);
}

/*
*************************************************************************
*                                                                       *
* Coalesce boxes on the list where possible.  The resulting box list    *
* will contain a non-overlapping set of boxes covering the identical    *
* region of index space covered by the original list.  Two boxes may be *
* coalesced if their union is a box (recall that union is not closed    *
* over boxes), and they have a non-empty intersection or they are       *
* adjacent to each other in index space.  Empty boxes on the list are   *
* removed during this process.  Also, the boxes are coalesced in the    *
* order in which they appear on the list.  No attempt is made to        *
* coalesce boxes in any particular way (e.g., to achieve the smallest   *
* number of boxes).                                                     *
*                                                                       *
*************************************************************************
*/

template<int DIM> void BoxList<DIM>::coalesceBoxes()
{
   typename BoxList<DIM>::Iterator tb = this ->listStart();
   while (tb) {

      bool found_match = false;

      typename BoxList<DIM>::Iterator tb2 = tb;
      tb2++;

      while (!found_match && tb2) {

         if ( tb2().coalesceWith(tb()) ) {
            found_match = true;
            this->removeItem(tb);
         }

         tb2++;
      }

      if (found_match) {
         tb = this ->listStart();
      } else {
         tb++;
      }
   }
}

/*
*************************************************************************
*                                                                       *
* Sort boxes in list from largest to smallest in size with a heap sort. *
*                                                                       *
*************************************************************************
*/

template<int DIM> void BoxList<DIM>::heapify(Box<DIM>** heap, const int i, const int j)
{
   const int l = 2*i+1;
   const int r = l+1;
   int s = i;
   if ((l < j) && (heap[s]->size() > heap[l]->size())) s = l;
   if ((r < j) && (heap[s]->size() > heap[r]->size())) s = r;
   if (s != i) {
      Box<DIM>* tmp = heap[s];
      heap[s] = heap[i];
      heap[i] = tmp;
      heapify(heap, s, j);
   }
}

template<int DIM> void BoxList<DIM>::sortDescendingBoxSizes()
{
   if (!this ->isEmpty()) {
      const int nboxes = this ->getNumberOfItems();
      Box<DIM>** heap = new Box<DIM>*[nboxes];
      int ib = 0;
      for (typename BoxList<DIM>::Iterator lb(*this); lb; lb++) {
         heap[ib] = &(lb());
         ib++;
      }

      for (int j = nboxes/2 - 1; j >= 0; j--) heapify(heap, j, nboxes);

      for (int k = nboxes - 1; k >= 1; k--) {
         Box<DIM>* tmp = heap[0];
         heap[0] = heap[k];
         heap[k] = tmp;
         heapify(heap, 0, k);
      }

      BoxList<DIM> out_boxes;
      for (int l = 0; l < nboxes; l++) {
         out_boxes.appendItem(*(heap[l]));
      }
      delete [] heap;

      *this = out_boxes;

#ifdef DEBUG_CHECK_ASSERTIONS
      bool boxes_in_order = true;
      typename BoxList<DIM>::Iterator tlb(*this);
      int size = tlb().size();
      tlb++;
      while (boxes_in_order && tlb) {
         int next_size = tlb().size();
         boxes_in_order = (size >= next_size); 
         tlb++;
         size = next_size;
      }
#endif
   }
}

/*
*************************************************************************
*									*
* Count the total size of all of the boxes in the boxlist.		*
*									*
*************************************************************************
*/

template<int DIM> int BoxList<DIM>::getTotalSizeOfBoxes() const
{
   int size = 0;
   for (typename BoxList<DIM>::Iterator i(*this); i; i++) {
      size += i().size();
   }
   return(size);
}

/*
*************************************************************************
*									*
* Perform simple operations (contains, grow, shift, refine, coarsen)	*
* on all elements in the box list.  These functions simply iterate over	*
* all list boxes and apply the operation to each box.			*
*									*
*************************************************************************
*/

template<int DIM> bool BoxList<DIM>::contains(const Index<DIM>& p) const
{
   for (typename BoxList<DIM>::Iterator i(*this); i; i++) {
      if (i().contains(p)) return(true);
   }
   return(false);
}

template<int DIM> void BoxList<DIM>::grow(const IntVector<DIM>& ghosts)
{
   for (typename BoxList<DIM>::Iterator i(*this); i; i++) {
      i().grow(ghosts);
   }
}

template<int DIM> void BoxList<DIM>::shift(const IntVector<DIM>& offset)
{
   for (typename BoxList<DIM>::Iterator i(*this); i; i++) {
      i().shift(offset);
   }
}

template<int DIM> void BoxList<DIM>::refine(const IntVector<DIM>& ratio)
{
   for (typename BoxList<DIM>::Iterator i(*this); i; i++) {
      i().refine(ratio);
   }
}

template<int DIM> void BoxList<DIM>::coarsen(const IntVector<DIM>& ratio)
{
   for (typename BoxList<DIM>::Iterator i(*this); i; i++) {
      i().coarsen(ratio);
   }
}

/*
*************************************************************************
*                                                                       *
* Test the box list for intersections among its boxes.			*
*                                                                       *
*************************************************************************
*/

template<int DIM> bool BoxList<DIM>::boxesIntersect() const
{
   bool intersections = false;

   BoxList<DIM> my_boxes(*this);
   while (!intersections && !my_boxes.isEmpty()) {
      Box<DIM> tryMe = my_boxes.getFirstItem();
      my_boxes.removeFirstItem();
 
      BoxList<DIM> test_boxes = my_boxes;

      while (!intersections && !test_boxes.isEmpty()) {
         Box<DIM> whatAboutMe = test_boxes.getFirstItem();
         test_boxes.removeFirstItem();
  
         if ( !((tryMe * whatAboutMe).size() == 0) ) {
            intersections = true;
         }
      }
   }

   return(intersections);
}

/*
*************************************************************************
*									*
* Return the bounding box for all boxes in the box list.		*
*									*
*************************************************************************
*/

template<int DIM> Box<DIM> BoxList<DIM>::getBoundingBox() const
{
   Box<DIM> bbox;
   for (typename BoxList<DIM>::Iterator i(*this); i; i++) {
      bbox += i();
   }
   return(bbox);
}

/*
*************************************************************************
*                                                                       *
* Print boxes in list.                                                  *
*                                                                       *
*************************************************************************
*/

template<int DIM> void BoxList<DIM>::print(std::ostream& os) const
{
   int i = 0;
   for (typename BoxList<DIM>::Iterator b(*this); b; b++) {
      os << "Box # " << i << ":  " << b() << std::endl;
      i++;
   }
}


}
}


#endif
