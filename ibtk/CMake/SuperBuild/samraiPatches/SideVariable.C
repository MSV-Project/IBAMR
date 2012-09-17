//
// File:	$URL: file:///usr/casc/samrai/repository/SAMRAI/tags/v-2-4-4/source/patchdata/side/SideVariable.C $
// Package:	SAMRAI patch data
// Copyright:	(c) 1997-2008 Lawrence Livermore National Security, LLC
// Revision:	$LastChangedRevision: 2856 $
// Modified:	$LastChangedDate: 2009-01-30 13:58:39 -0800 (Fri, 30 Jan 2009) $
// Description:	hier::Variable class for defining side centered variables
//

#ifndef included_pdat_SideVariable_C
#define included_pdat_SideVariable_C

#include "SideVariable.h"
#include "SideDataFactory.h"
#include "tbox/Utilities.h"


#define ALL_DIRECTIONS (-1)

#ifndef NULL
#define NULL (0)
#endif

namespace SAMRAI {
    namespace pdat {

/*
*************************************************************************
*									*
* Constructor and destructor for side variable objects			*
*									*
*************************************************************************
*/

template<int DIM, class TYPE>
SideVariable<DIM,TYPE>::SideVariable(
   const std::string &name, 
   int depth, 
   bool fine_boundary_represents_var,
   int direction)
:  hier::Variable<DIM>(name, 
                  new SideDataFactory<DIM,TYPE>(depth, 
                                                  // default zero ghost cells
                                                  hier::IntVector<DIM>(0), 
                                                  fine_boundary_represents_var)),
   d_fine_boundary_represents_var(fine_boundary_represents_var)
 
{
#ifdef DEBUG_CHECK_ASSERTIONS
   TBOX_ASSERT((direction >= ALL_DIRECTIONS) && (direction < DIM));
#endif
   d_directions = hier::IntVector<DIM>(1);
   if ( (direction != ALL_DIRECTIONS) ) {
      for (int id = 0; id < DIM; id++) {
         d_directions(id) = ( (direction == id) ? 1 : 0 );  
      }  
      this->setPatchDataFactory(new SideDataFactory<DIM,TYPE>(
                             depth,
                             hier::IntVector<DIM>(0),
                             fine_boundary_represents_var,
                             d_directions));
   }
}

template<int DIM, class TYPE>
SideVariable<DIM,TYPE>::~SideVariable()
{
}

template<int DIM, class TYPE>
const hier::IntVector<DIM>& SideVariable<DIM,TYPE>::getDirectionVector() const
{
   return(d_directions);
}

/*
*************************************************************************
*									*
* These are private and should not be used.  They are defined here	*
* because some template instantiation methods fail if some member	*
* functions are left undefined.						*
*									*
*************************************************************************
*/

template<int DIM, class TYPE>
SideVariable<DIM,TYPE>::SideVariable(
   const SideVariable<DIM,TYPE>& foo)
:  hier::Variable<DIM>(NULL, NULL)
{
   NULL_USE(foo);
}

template<int DIM, class TYPE>
void SideVariable<DIM,TYPE>::operator=(const SideVariable<DIM,TYPE>& foo)
{
   NULL_USE(foo);
}

}
}
#endif
