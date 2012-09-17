//
// File:	$URL: file:///usr/casc/samrai/repository/SAMRAI/tags/v-2-4-4/source/hierarchy/boxes/BoxList.I $
// Package:	SAMRAI hierarchy
// Copyright:	(c) 1997-2008 Lawrence Livermore National Security, LLC
// Revision:	$LastChangedRevision: 2043 $
// Modified:	$LastChangedDate: 2008-03-12 09:14:32 -0700 (Wed, 12 Mar 2008) $
// Description:	A list of boxes with basic domain calculus operations
//

#ifdef DEBUG_NO_INLINE
#define inline
#endif

namespace SAMRAI {
   namespace hier {


template<int DIM> inline
BoxList<DIM>::BoxList() : tbox::List< Box<DIM> >()
{
}

template<int DIM> inline
int BoxList<DIM>::getNumberOfBoxes() const
{
   return(this->getNumberOfItems());
}

template<int DIM> inline
void BoxList<DIM>::unionBoxes(const Box<DIM>& box)
{
   if (!box.empty()) {
      this->appendItem(box);
   }
}

template<int DIM> inline
void BoxList<DIM>::unionBoxes(const BoxList<DIM>& boxes)
{
   this->copyItems(boxes);
}

template<int DIM> inline
BoxList<DIM>::~BoxList()
{
}

#ifdef DEBUG_NO_INLINE
#undef inline
#endif

}
}

