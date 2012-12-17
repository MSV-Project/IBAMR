//
// File:        $URL: file:///usr/casc/samrai/repository/SAMRAI/tags/v-2-4-4/source/hierarchy/patches/BoundaryLookupTable.C $
// Package:     SAMRAI hierarchy 
// Copyright:   (c) 1997-2008 Lawrence Livermore National Security, LLC
// Revision:    $LastChangedRevision: 2040 $
// Modified:    $LastChangedDate: 2008-03-11 15:05:44 -0700 (Tue, 11 Mar 2008) $
// Description:  Lookup table to aid in BoundaryBox construction
//

#ifndef included_hier_BoundaryLookupTable_C
#define included_hier_BoundaryLookupTable_C

#include "BoundaryLookupTable.h"

#include "tbox/ShutdownRegistry.h"


#ifdef DEBUG_NO_INLINE
#include "BoundaryLookupTable.I"
#endif


namespace SAMRAI {
   namespace hier {


template<int DIM> BoundaryLookupTable<DIM>*
BoundaryLookupTable<DIM>::s_lookup_table_instance =
   (BoundaryLookupTable<DIM>*) NULL;
template<int DIM> bool BoundaryLookupTable<DIM>::s_registered_callback = false;
template<int DIM> bool BoundaryLookupTable<DIM>::s_using_original_locations = false;


/*
*************************************************************************
*                                                                       *
* Lookup table constructor and destructor.                              *
*                                                                       *
*************************************************************************
*/

template<int DIM>  BoundaryLookupTable<DIM>::BoundaryLookupTable()
{

   /*
    * These "fake" uses of statics avoid the Intel compiler
    * optimizing them away.  They are only used in 
    * inline methods.
    */
   if(s_lookup_table_instance == NULL) {
      s_lookup_table_instance = NULL;
   }
   if(s_registered_callback == false) {
      s_lookup_table_instance = NULL;
   }

   if (d_table[0].isNull()) {
      int factrl[DIM+1];
      factrl[0] = 1;
      for (int i = 1; i <= DIM; i++) factrl[i] = i * factrl[i-1];
      d_ncomb.resizeArray(DIM);
      d_max_li.resizeArray(DIM);
      for (int codim = 1; codim <= DIM; codim++) {
	 int cdm1 = codim-1;
         d_ncomb[cdm1] = factrl[DIM]/(factrl[codim]*factrl[DIM-codim]);

	 tbox::Array<int> work;
	 work.resizeArray(codim*d_ncomb[cdm1]);

	 int recursive_work[DIM];
	 int recursive_work_lvl = 0;
	 int *recursive_work_ptr;
	 buildTable(work.getPointer(), codim, 1, recursive_work, recursive_work_lvl, recursive_work_ptr);

	 d_table[cdm1].resizeArray(d_ncomb[cdm1]);
	 for (int j=0; j<d_ncomb[cdm1]; j++) {
	    d_table[cdm1][j].resizeArray(codim);
	    for (int k=0; k<codim; k++) {
	       d_table[cdm1][j][k] = work[j*codim+k]-1;
	    }
	 }

         d_max_li[cdm1] = d_ncomb[cdm1]*(1<<codim);
      }
   }

   buildBoundaryDirectionVectors();
}

template<int DIM>  BoundaryLookupTable<DIM>::~BoundaryLookupTable()
{
}

/*
*************************************************************************
*                                                                       *
* Recursive function that computes the combinations in the lookup       *
* table.                                                                *
*                                                                       *
*************************************************************************
*/

template<int DIM>
void BoundaryLookupTable<DIM>::buildTable(int *table,
                                          int codim,
                                          int ibeg,
                                          int (&work)[DIM],
                                          int &lvl,
                                          int *&ptr)
{
   lvl++;                                  
   if (lvl == 1) ptr = table;              
   int iend = DIM - codim + lvl;          
   for (int i = ibeg; i <= iend; i++) {    
      work[lvl-1] = i;
      if (lvl != codim) {
	 buildTable(ptr, codim, i+1,work, lvl, ptr);
      } else {
         for (int j = 0; j < codim; j++) {
	    *(ptr+j) = work[j];
	 }
	 ptr += codim;
      }
   }
   lvl--;
}

template<int DIM> void BoundaryLookupTable<DIM>::setUsingOriginalLocations(
   const bool use_original)
{
   s_using_original_locations = use_original;
}

/*
*************************************************************************
*                                                                       *
* Build table of IntVectors indication locations of boundaries relative *
* to a patch.                                                           *
*                                                                       *
*************************************************************************
*/

template<int DIM>
void BoundaryLookupTable<DIM>::buildBoundaryDirectionVectors()
{

   d_bdry_dirs.resizeArray(DIM);

   for (int i = 0; i < DIM; i++) {
      d_bdry_dirs[i].resizeArray(d_max_li[i]);
      int codim = i+1;

      for (int loc = 0; loc < d_max_li[i]; loc++) { 
         d_bdry_dirs[i][loc] = IntVector<DIM>(0);
 
         const tbox::Array<int>& dirs = getDirections(loc, codim);

         for (int d = 0; d < dirs.size(); d++) {

            if (isUpper(loc, codim, d)) {

               d_bdry_dirs[i][loc](dirs[d]) = 1;

            } else {

               d_bdry_dirs[i][loc](dirs[d]) = -1;
 
            }
         }
      }
   }
}



}
}

#endif
