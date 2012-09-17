//
// File:	$URL: file:///usr/casc/samrai/repository/SAMRAI/tags/v-2-4-4/source/geometry/cartesian/grid_geom/CartesianGridGeometry.C $
// Package:	SAMRAI geometry package
// Copyright:	(c) 1997-2008 Lawrence Livermore National Security, LLC
// Revision:	$LastChangedRevision: 2141 $
// Modified:	$LastChangedDate: 2008-04-23 08:36:33 -0700 (Wed, 23 Apr 2008) $
// Description: Simple Cartesian grid geometry for an AMR hierarchy.
//

#ifndef included_geom_CartesianGridGeometry_C
#define included_geom_CartesianGridGeometry_C

#include "CartesianGridGeometry.h"
#include <stdlib.h>
#include <fstream>

#include "CartesianPatchGeometry.h"

// Cell data coarsen operators
#include "CartesianCellComplexWeightedAverage.h"
#include "CartesianCellDoubleWeightedAverage.h"
#include "CartesianCellFloatWeightedAverage.h"

// Cell data refine operators
#include "CartesianCellComplexConservativeLinearRefine.h"
#include "CartesianCellComplexLinearRefine.h"
#include "CartesianCellDoubleConservativeLinearRefine.h"
#include "CartesianCellDoubleLinearRefine.h"
#include "CartesianCellFloatConservativeLinearRefine.h"
#include "CartesianCellFloatLinearRefine.h"
#include "CellComplexConstantRefine.h"
#include "CellDoubleConstantRefine.h"
#include "CellFloatConstantRefine.h"
#include "CellIntegerConstantRefine.h"

// Edge data coarsen operators
#include "CartesianEdgeComplexWeightedAverage.h"
#include "CartesianEdgeDoubleWeightedAverage.h"
#include "CartesianEdgeFloatWeightedAverage.h"

// Edge data refine operators
#include "CartesianEdgeDoubleConservativeLinearRefine.h"
#include "CartesianEdgeFloatConservativeLinearRefine.h"
#include "EdgeComplexConstantRefine.h"
#include "EdgeDoubleConstantRefine.h"
#include "EdgeFloatConstantRefine.h"
#include "EdgeIntegerConstantRefine.h"

// Face data coarsen operators
#include "CartesianFaceComplexWeightedAverage.h"
#include "CartesianFaceDoubleWeightedAverage.h"
#include "CartesianFaceFloatWeightedAverage.h"

// Face data refine operators
#include "CartesianFaceDoubleConservativeLinearRefine.h"
#include "CartesianFaceFloatConservativeLinearRefine.h"
#include "FaceComplexConstantRefine.h"
#include "FaceDoubleConstantRefine.h"
#include "FaceFloatConstantRefine.h"
#include "FaceIntegerConstantRefine.h"

// Node data coarsen operators
#include "NodeComplexInjection.h"
#include "NodeDoubleInjection.h"
#include "NodeFloatInjection.h"
#include "NodeIntegerInjection.h"

// Node data refine operators
#include "CartesianNodeComplexLinearRefine.h"
#include "CartesianNodeDoubleLinearRefine.h"
#include "CartesianNodeFloatLinearRefine.h"

// Outerface data coarsen operators
#include "CartesianOuterfaceComplexWeightedAverage.h"
#include "CartesianOuterfaceDoubleWeightedAverage.h"
#include "CartesianOuterfaceFloatWeightedAverage.h"

// Outerface data refine operators
#include "OuterfaceComplexConstantRefine.h"
#include "OuterfaceDoubleConstantRefine.h"
#include "OuterfaceFloatConstantRefine.h"
#include "OuterfaceIntegerConstantRefine.h"

// Outernode data coarsen operators
#include "OuternodeDoubleConstantCoarsen.h"

// Outerside data coarsen operators
#include "CartesianOutersideDoubleWeightedAverage.h"

// Side data coarsen operators
#include "CartesianSideComplexWeightedAverage.h"
#include "CartesianSideDoubleWeightedAverage.h"
#include "CartesianSideFloatWeightedAverage.h"

// Side data refine operators
#include "CartesianSideDoubleConservativeLinearRefine.h"
#include "CartesianSideFloatConservativeLinearRefine.h"
#include "SideComplexConstantRefine.h"
#include "SideDoubleConstantRefine.h"
#include "SideFloatConstantRefine.h"
#include "SideIntegerConstantRefine.h"

// Time interpolation operators
#include "CellComplexLinearTimeInterpolateOp.h"
#include "CellDoubleLinearTimeInterpolateOp.h"
#include "CellFloatLinearTimeInterpolateOp.h"
#include "EdgeComplexLinearTimeInterpolateOp.h"
#include "EdgeDoubleLinearTimeInterpolateOp.h"
#include "EdgeFloatLinearTimeInterpolateOp.h"
#include "FaceComplexLinearTimeInterpolateOp.h"
#include "FaceDoubleLinearTimeInterpolateOp.h"
#include "FaceFloatLinearTimeInterpolateOp.h"
#include "NodeComplexLinearTimeInterpolateOp.h"
#include "NodeDoubleLinearTimeInterpolateOp.h"
#include "NodeFloatLinearTimeInterpolateOp.h"
#include "OuterfaceComplexLinearTimeInterpolateOp.h"
#include "OuterfaceDoubleLinearTimeInterpolateOp.h"
#include "OuterfaceFloatLinearTimeInterpolateOp.h"
#include "OutersideComplexLinearTimeInterpolateOp.h"
#include "OutersideDoubleLinearTimeInterpolateOp.h"
#include "OutersideFloatLinearTimeInterpolateOp.h"
#include "SideComplexLinearTimeInterpolateOp.h"
#include "SideDoubleLinearTimeInterpolateOp.h"
#include "SideFloatLinearTimeInterpolateOp.h"

#include "BoundaryLookupTable.h"
#include "Box.h"
#include "BoxArray.h"
#include "Index.h"
#include "IntVector.h"
#include "Patch.h"
#include "PatchLevel.h"
#include "tbox/Array.h"
#include "tbox/PIO.h"
#include "tbox/RestartManager.h"
#include "tbox/Utilities.h"

#define GEOM_CARTESIAN_GRID_GEOMETRY_VERSION (2)

#ifdef DEBUG_NO_INLINE
#include "CartesianGridGeometry.I"
#endif
namespace SAMRAI {
    namespace geom {

/*
*************************************************************************
*                                                                       *
* Constructors for CartesianGridGeometry.  Both set up operator    *
* handlers and register the geometry object with the RestartManager.    *
* However, one initializes data members based on arguments.             *
* The other initializes the object based on input file information.     *
*                                                                       *
*************************************************************************
*/
template<int DIM>  CartesianGridGeometry<DIM>::CartesianGridGeometry(
   const std::string& object_name,
   tbox::Pointer<tbox::Database> input_db,
   bool register_for_restart)
:  xfer::Geometry<DIM>(object_name)
{
#ifdef DEBUG_CHECK_ASSERTIONS
   TBOX_ASSERT(!object_name.empty());
   TBOX_ASSERT(!input_db.isNull());
#endif

   d_object_name = object_name;
   d_registered_for_restart = register_for_restart;

   if (d_registered_for_restart) {
      tbox::RestartManager::getManager()->
         registerRestartItem(d_object_name, this);
   }

   makeStandardOperators();

   bool is_from_restart = tbox::RestartManager::getManager()->isFromRestart();
   if ( is_from_restart ) {
      getFromRestart();
   }

   getFromInput(input_db, is_from_restart);

   hier::BoundaryLookupTable<DIM>::
      setUsingOriginalLocations(d_using_original_locations);
}

template<int DIM>  CartesianGridGeometry<DIM>::CartesianGridGeometry(
   const std::string& object_name,
   const double* x_lo,
   const double* x_up,
   const hier::BoxArray<DIM>& domain,
   bool register_for_restart)
:  xfer::Geometry<DIM>(object_name)
{
#ifdef DEBUG_CHECK_ASSERTIONS
   TBOX_ASSERT(!object_name.empty());
   TBOX_ASSERT(!(x_lo == (double*)NULL));
   TBOX_ASSERT(!(x_up == (double*)NULL));
#endif

   d_object_name = object_name;
   d_registered_for_restart = register_for_restart;

   if (d_registered_for_restart) {
      tbox::RestartManager::getManager()->
         registerRestartItem(d_object_name, this);
   }

   setGeometryData(x_lo, x_up, domain);

   makeStandardOperators();

   d_using_original_locations = true;
   hier::BoundaryLookupTable<DIM>::
      setUsingOriginalLocations(d_using_original_locations);
}



/*
*************************************************************************
*                                                                       *
* Create and return pointer to refined version of this Cartesian        *
* grid geometry object refined by the given ratio.                      *
*                                                                       *
*************************************************************************
*/

template<int DIM> tbox::Pointer<hier::GridGeometry<DIM> >
CartesianGridGeometry<DIM>::makeRefinedGridGeometry(
   const std::string& fine_geom_name,
   const hier::IntVector<DIM>& refine_ratio,
   bool register_for_restart) const
{
#ifdef DEBUG_CHECK_ASSERTIONS
   TBOX_ASSERT(!fine_geom_name.empty());
   TBOX_ASSERT(fine_geom_name != d_object_name);
   TBOX_ASSERT(refine_ratio > hier::IntVector<DIM>(0));
#endif

   hier::BoxArray<DIM> fine_domain(this -> getPhysicalDomain());
   fine_domain.refine(refine_ratio);

   CartesianGridGeometry<DIM>* fine_geometry =
      new CartesianGridGeometry<DIM>(fine_geom_name,
                                     d_x_lo,
                                     d_x_up,
                                     fine_domain,
                                     register_for_restart);

   fine_geometry->initializePeriodicShift(this -> getPeriodicShift());

   return(tbox::Pointer<hier::GridGeometry<DIM> >(fine_geometry));
}

/*
*************************************************************************
*                                                                       *
* Create and return pointer to coarsened version of this Cartesian      *
* grid geometry object coarsened by the given ratio.                    *
*                                                                       *
*************************************************************************
*/

template<int DIM> tbox::Pointer<hier::GridGeometry<DIM> > CartesianGridGeometry<DIM>::makeCoarsenedGridGeometry(
   const std::string& coarse_geom_name,
   const hier::IntVector<DIM>& coarsen_ratio,
   bool register_for_restart) const
{
#ifdef DEBUG_CHECK_ASSERTIONS
   TBOX_ASSERT(!coarse_geom_name.empty());
   TBOX_ASSERT(coarse_geom_name != d_object_name);
   TBOX_ASSERT(coarsen_ratio > hier::IntVector<DIM>(0));
#endif

   hier::BoxArray<DIM> coarse_domain(this -> getPhysicalDomain());
   coarse_domain.coarsen(coarsen_ratio);

   /*
    * Need to check that domain can be coarsened by given ratio.
    */
   const hier::BoxArray<DIM>& fine_domain = this -> getPhysicalDomain();
   const int nboxes = fine_domain.getNumberOfBoxes();
   for (int ib = 0; ib < nboxes; ib++) {
      hier::Box<DIM> testbox = hier::Box<DIM>::refine(coarse_domain[ib], coarsen_ratio);
      if (testbox != fine_domain[ib]) {
#ifdef DEBUG_CHECK_ASSERTIONS
         tbox::plog << "CartesianGridGeometry::makeCoarsenedGridGeometry : Box # " << ib << std::endl;
         tbox::plog << "      fine box = " << fine_domain[ib] << std::endl;
         tbox::plog << "      coarse box = " << coarse_domain[ib] << std::endl;
         tbox::plog << "      refined coarse box = " << testbox << std::endl;
#endif
         TBOX_ERROR("geom::CartesianGridGeometry<DIM>::makeCoarsenedGridGeometry() error...\n"
                    << "    geometry object with name = " << d_object_name
                    << "\n    Cannot be coarsened by ratio " << coarsen_ratio << std::endl);
      }
   }

   hier::GridGeometry<DIM>* coarse_geometry =
      new geom::CartesianGridGeometry<DIM>(coarse_geom_name,
                                      d_x_lo,
                                      d_x_up,
                                      coarse_domain,
                                      register_for_restart);

   coarse_geometry->initializePeriodicShift(this -> getPeriodicShift());

   return(tbox::Pointer<hier::GridGeometry<DIM> >(coarse_geometry));
}

/*
*************************************************************************
*                                                                       *
* Destructor for CartesianGridGeometry deallocates grid storage.   *
* Note that operator handlers that are created in constructor are       *
* deallocated in xfer::Geometry<DIM> destructor.                             *
*                                                                       *
*************************************************************************
*/

template<int DIM>  CartesianGridGeometry<DIM>::~CartesianGridGeometry()
{
   if (d_registered_for_restart) {
      tbox::RestartManager::getManager()->unregisterRestartItem(d_object_name);
   }
}

/*
*************************************************************************
*                                                                       *
* Set data members for this geometry object based on arguments.         *
*                                                                       *
*************************************************************************
*/

template<int DIM> void CartesianGridGeometry<DIM>::setGeometryData(
   const double* x_lo,
   const double* x_up,
   const hier::BoxArray<DIM>& domain)
{
#ifdef DEBUG_CHECK_ASSERTIONS
   TBOX_ASSERT(!(x_lo == (double*)NULL));
   TBOX_ASSERT(!(x_up == (double*)NULL));
#endif

   for (int id = 0; id < DIM; id++ ) {
      d_x_lo[id] = x_lo[id];
      d_x_up[id] = x_up[id];
   }

   this->setPhysicalDomain(domain);

   hier::Box<DIM> bigbox;
   for (int k =0 ; k < this -> getPhysicalDomain().getNumberOfBoxes(); k++)
      bigbox += this -> getPhysicalDomain()[k];

   d_domain_box = bigbox;

   hier::IntVector<DIM> ncells = d_domain_box.numberCells();
   for (int id2 = 0; id2 < DIM; id2++ ) {
      double length = d_x_up[id2] - d_x_lo[id2];
      d_dx[id2]= length / ((double) ncells(id2));
   }
}

/*
*************************************************************************
*                                                                       *
* Create default interlevel transfer operator handlers and time         *
* interpolation operator handlers.  Add them to appropriate chains.     *
*                                                                       *
*************************************************************************
*/

template<int DIM> void CartesianGridGeometry<DIM>::makeStandardOperators()
{
#ifdef HAVE_DCOMPLEX
   /*
    * Standard spatial coarsening operators.
    */

   this->addSpatialCoarsenOperator(new CartesianCellComplexWeightedAverage<DIM>());
   this->addSpatialCoarsenOperator(new CartesianEdgeComplexWeightedAverage<DIM>());
   this->addSpatialCoarsenOperator(new CartesianFaceComplexWeightedAverage<DIM>());
   this->addSpatialCoarsenOperator(new pdat::NodeComplexInjection<DIM>());
   this->addSpatialCoarsenOperator(new CartesianOuterfaceComplexWeightedAverage<DIM>());
   this->addSpatialCoarsenOperator(new CartesianSideComplexWeightedAverage<DIM>());

   this->addSpatialRefineOperator(new pdat::CellComplexConstantRefine<DIM>());
   this->addSpatialRefineOperator(new CartesianCellComplexLinearRefine<DIM>());
   this->addSpatialRefineOperator(new pdat::EdgeComplexConstantRefine<DIM>());
   this->addSpatialRefineOperator(new pdat::FaceComplexConstantRefine<DIM>());
   this->addSpatialRefineOperator(new CartesianNodeComplexLinearRefine<DIM>());
   this->addSpatialRefineOperator(new pdat::OuterfaceComplexConstantRefine<DIM>());
   this->addSpatialRefineOperator(new pdat::SideComplexConstantRefine<DIM>());

   /*
    * Standard linear time interpolation operators.
    */

   this->addTimeInterpolateOperator(new pdat::CellComplexLinearTimeInterpolateOp<DIM>());
   this->addTimeInterpolateOperator(new pdat::EdgeComplexLinearTimeInterpolateOp<DIM>());
   this->addTimeInterpolateOperator(new pdat::FaceComplexLinearTimeInterpolateOp<DIM>());
   this->addTimeInterpolateOperator(new pdat::NodeComplexLinearTimeInterpolateOp<DIM>());
   this->addTimeInterpolateOperator(new pdat::OuterfaceComplexLinearTimeInterpolateOp<DIM>());
   this->addTimeInterpolateOperator(new pdat::OutersideComplexLinearTimeInterpolateOp<DIM>());
   this->addTimeInterpolateOperator(new pdat::SideComplexLinearTimeInterpolateOp<DIM>());
#endif

#ifdef HAVE_FLOAT
   /*
    * Standard spatial coarsening operators.
    */

   this->addSpatialCoarsenOperator(new CartesianCellFloatWeightedAverage<DIM>());
   this->addSpatialCoarsenOperator(new CartesianEdgeFloatWeightedAverage<DIM>());
   this->addSpatialCoarsenOperator(new CartesianFaceFloatWeightedAverage<DIM>());
   this->addSpatialCoarsenOperator(new pdat::NodeFloatInjection<DIM>());
   this->addSpatialCoarsenOperator(new CartesianOuterfaceFloatWeightedAverage<DIM>());
   this->addSpatialCoarsenOperator(new CartesianSideFloatWeightedAverage<DIM>());

   /*
    * Standard spatial refining operators.
    */

   this->addSpatialRefineOperator(new CartesianCellFloatConservativeLinearRefine<DIM>());
   this->addSpatialRefineOperator(new CartesianEdgeFloatConservativeLinearRefine<DIM>());
   this->addSpatialRefineOperator(new pdat::EdgeFloatConstantRefine<DIM>());
   this->addSpatialRefineOperator(new pdat::CellFloatConstantRefine<DIM>());
   this->addSpatialRefineOperator(new CartesianCellFloatLinearRefine<DIM>());
   this->addSpatialRefineOperator(new CartesianFaceFloatConservativeLinearRefine<DIM>());
   this->addSpatialRefineOperator(new CartesianNodeFloatLinearRefine<DIM>());
   this->addSpatialRefineOperator(new pdat::FaceFloatConstantRefine<DIM>());
   this->addSpatialRefineOperator(new pdat::OuterfaceFloatConstantRefine<DIM>());
   this->addSpatialRefineOperator(new pdat::OuterfaceIntegerConstantRefine<DIM>());
   this->addSpatialRefineOperator(new CartesianSideFloatConservativeLinearRefine<DIM>());
   this->addSpatialRefineOperator(new pdat::SideFloatConstantRefine<DIM>());

   /*
    * Standard linear time interpolation operators.
    */

   this->addTimeInterpolateOperator(new pdat::CellFloatLinearTimeInterpolateOp<DIM>());
   this->addTimeInterpolateOperator(new pdat::EdgeFloatLinearTimeInterpolateOp<DIM>());
   this->addTimeInterpolateOperator(new pdat::FaceFloatLinearTimeInterpolateOp<DIM>());
   this->addTimeInterpolateOperator(new pdat::NodeFloatLinearTimeInterpolateOp<DIM>());
   this->addTimeInterpolateOperator(new pdat::OuterfaceFloatLinearTimeInterpolateOp<DIM>());
   this->addTimeInterpolateOperator(new pdat::OutersideFloatLinearTimeInterpolateOp<DIM>());
   this->addTimeInterpolateOperator(new pdat::SideFloatLinearTimeInterpolateOp<DIM>());
#endif

   /*
    * Standard spatial coarsening operators.
    */
   this->addSpatialCoarsenOperator(new CartesianCellDoubleWeightedAverage<DIM>());
   this->addSpatialCoarsenOperator(new CartesianEdgeDoubleWeightedAverage<DIM>());
   this->addSpatialCoarsenOperator(new CartesianFaceDoubleWeightedAverage<DIM>());
   this->addSpatialCoarsenOperator(new pdat::NodeDoubleInjection<DIM>());
   this->addSpatialCoarsenOperator(new pdat::NodeIntegerInjection<DIM>());
   this->addSpatialCoarsenOperator(new CartesianOuterfaceDoubleWeightedAverage<DIM>());
   this->addSpatialCoarsenOperator(new pdat::OuternodeDoubleConstantCoarsen<DIM>());
   this->addSpatialCoarsenOperator(new CartesianOutersideDoubleWeightedAverage<DIM>());
   this->addSpatialCoarsenOperator(new CartesianSideDoubleWeightedAverage<DIM>());

   /*
    * Standard spatial refining operators.
    */
   this->addSpatialRefineOperator(new CartesianCellDoubleConservativeLinearRefine<DIM>());
   this->addSpatialRefineOperator(new pdat::CellDoubleConstantRefine<DIM>());
   this->addSpatialRefineOperator(new CartesianCellDoubleLinearRefine<DIM>());
   this->addSpatialRefineOperator(new CartesianEdgeDoubleConservativeLinearRefine<DIM>());
   this->addSpatialRefineOperator(new pdat::EdgeDoubleConstantRefine<DIM>());
   this->addSpatialRefineOperator(new pdat::EdgeIntegerConstantRefine<DIM>());
   this->addSpatialRefineOperator(new pdat::CellIntegerConstantRefine<DIM>());
   this->addSpatialRefineOperator(new CartesianFaceDoubleConservativeLinearRefine<DIM>());
   this->addSpatialRefineOperator(new pdat::FaceDoubleConstantRefine<DIM>());
   this->addSpatialRefineOperator(new pdat::FaceIntegerConstantRefine<DIM>());
   this->addSpatialRefineOperator(new CartesianNodeDoubleLinearRefine<DIM>());
   this->addSpatialRefineOperator(new pdat::OuterfaceDoubleConstantRefine<DIM>());
   this->addSpatialRefineOperator(new CartesianSideDoubleConservativeLinearRefine<DIM>());
   this->addSpatialRefineOperator(new pdat::SideDoubleConstantRefine<DIM>());
   this->addSpatialRefineOperator(new pdat::SideIntegerConstantRefine<DIM>());

   /*
    * Standard linear time interpolation operators.
    */
   this->addTimeInterpolateOperator(new pdat::CellDoubleLinearTimeInterpolateOp<DIM>());
   this->addTimeInterpolateOperator(new pdat::EdgeDoubleLinearTimeInterpolateOp<DIM>());
   this->addTimeInterpolateOperator(new pdat::FaceDoubleLinearTimeInterpolateOp<DIM>());
   this->addTimeInterpolateOperator(new pdat::NodeDoubleLinearTimeInterpolateOp<DIM>());
   this->addTimeInterpolateOperator(new pdat::OuterfaceDoubleLinearTimeInterpolateOp<DIM>());
   this->addTimeInterpolateOperator(new pdat::OutersideDoubleLinearTimeInterpolateOp<DIM>());
   this->addTimeInterpolateOperator(new pdat::SideDoubleLinearTimeInterpolateOp<DIM>());

}


/*
*************************************************************************
*                                                                       *
* Create CartesianPatchGeometry geometry object, initializing its  *
* boundary and grid information and assign it to the given patch.       *
*                                                                       *
*************************************************************************
*/

template<int DIM> void CartesianGridGeometry<DIM>::setGeometryDataOnPatch(
   hier::Patch<DIM>& patch,
   const hier::IntVector<DIM>& ratio_to_level_zero,
   const tbox::Array< tbox::Array<bool> >& touches_regular_bdry,
   const tbox::Array< tbox::Array<bool> >& touches_periodic_bdry) const
{
#ifdef DEBUG_CHECK_ASSERTIONS
   /*
    * All components of ratio must be nonzero.  Additionally,
    * all components not equal to 1 must have the same sign.
    */
   TBOX_ASSERT(ratio_to_level_zero != hier::IntVector<DIM>(0));

   if (DIM > 1) {
      for (int i = 0; i < DIM; i++) {
	 TBOX_ASSERT( (ratio_to_level_zero(i)*ratio_to_level_zero((i+1)%DIM) > 0)
		 || (ratio_to_level_zero(i) == 1)
		 || (ratio_to_level_zero((i+1)%DIM) == 1) );
      }
   }
#endif

   double dx[DIM];
   double x_lo[DIM];
   double x_up[DIM];

   bool coarsen = false;
   if ( ratio_to_level_zero(0) < 0 ) coarsen = true;
   hier::IntVector<DIM> tmp_rat = ratio_to_level_zero;
   for (int id2 = 0; id2 < DIM; id2++) {
      tmp_rat(id2) = abs(ratio_to_level_zero(id2));
   }

   hier::Box<DIM> index_box = d_domain_box;
   hier::Box<DIM> box = patch.getBox();

   if ( coarsen ) {
      index_box.coarsen(tmp_rat);
      for (int id3 = 0; id3 < DIM; id3++) {
         dx[id3]   = d_dx[id3] * ((double) tmp_rat(id3));
      }
   } else {
      index_box.refine(tmp_rat);
      for (int id4 = 0; id4 < DIM; id4++) {
         dx[id4]   = d_dx[id4] / ((double) tmp_rat(id4));
      }
   }

   for (int id5 = 0; id5 < DIM; id5++) {
      x_lo[id5] = d_x_lo[id5]
                  + ((double) (box.lower(id5)-index_box.lower(id5))) * dx[id5];
      x_up[id5] = x_lo[id5] + ((double) box.numberCells(id5)) * dx[id5];
   }

   tbox::Pointer<CartesianPatchGeometry<DIM> > geom =
      new CartesianPatchGeometry<DIM>(ratio_to_level_zero,
                                      touches_regular_bdry,
                                      touches_periodic_bdry,
                                      dx, x_lo, x_up);

   patch.setPatchGeometry(geom);

}

/*
*************************************************************************
*                                                                       *
* Print CartesianGridGeometry class data.                          *
*                                                                       *
*************************************************************************
*/

template<int DIM> void CartesianGridGeometry<DIM>::printClassData(std::ostream& os) const
{
   os << "Printing CartesianGridGeometry data: this = "
      << (CartesianGridGeometry<DIM> *)this << std::endl;
   os << "d_object_name = " << d_object_name << std::endl;

   int id;
   os << "d_x_lo = ";
   for (id = 0; id < DIM; id++) {
      os << d_x_lo[id] << "   ";
   }
   os << std::endl;
   os << "d_x_up = ";
   for (id = 0; id < DIM; id++) {
      os << d_x_up[id] << "   ";
   }
   os << std::endl;
   os << "d_dx = ";
   for (id = 0; id < DIM; id++) {
      os << d_dx[id] << "   ";
   }
   os << std::endl;

   os << "d_domain_box = " << d_domain_box << std::endl;

   xfer::Geometry<DIM>::printClassData(os);
}

/*
*************************************************************************
*                                                                       *
* Write class version number and object state to database.              *
*                                                                       *
*************************************************************************
*/

template<int DIM> void CartesianGridGeometry<DIM>::putToDatabase(
   tbox::Pointer<tbox::Database> db)
{
#ifdef DEBUG_CHECK_ASSERTIONS
   TBOX_ASSERT(!db.isNull());
#endif
   db->putInteger("GEOM_CARTESIAN_GRID_GEOMETRY_VERSION",
      GEOM_CARTESIAN_GRID_GEOMETRY_VERSION);
   tbox::Array<tbox::DatabaseBox> temp_box_array = this -> getPhysicalDomain();
   db->putDatabaseBoxArray("d_physical_domain", temp_box_array);

   db->putDoubleArray("d_dx", d_dx, DIM);
   db->putDoubleArray("d_x_lo", d_x_lo, DIM);
   db->putDoubleArray("d_x_up", d_x_up, DIM);

   hier::IntVector<DIM> level0_shift = this->getPeriodicShift(hier::IntVector<DIM>(1));
   int* temp_shift = level0_shift;
   db->putIntegerArray("d_periodic_shift", temp_shift, DIM);

   db->putBool("d_using_original_locations", d_using_original_locations);
}


/*
*************************************************************************
*                                                                       *
* Data is read from input only if the simulation is not from restart.   *
* Otherwise, all values specifed in the input database are ignored.	*
* In this method data from the database are read to local 		*
* variables and the setGeometryData() method is called to 		*
* initialize the data members.						*
*                                                                       *
*************************************************************************
*/

template<int DIM> void CartesianGridGeometry<DIM>::getFromInput(
   tbox::Pointer<tbox::Database> db,
   bool is_from_restart)
{
#ifdef DEBUG_CHECK_ASSERTIONS
   TBOX_ASSERT(!db.isNull());
#endif

   if (!is_from_restart) {

      hier::BoxArray<DIM> domain;
      if (db->keyExists("domain_boxes")) {
         domain = db->getDatabaseBoxArray("domain_boxes");
         if (domain.getNumberOfBoxes() == 0) {
            TBOX_ERROR("CartesianGridGeometry<DIM>::getFromInput() error...\n"
               << "    geometry object with name = " << d_object_name
               << "\n    Empty `domain_boxes' array found in input." << std::endl);
         }
      } else {
         TBOX_ERROR("CartesianGridGeometry<DIM>::getFromInput() error...\n"
               << "    geometry object with name = " << d_object_name
               << "\n    Key data `domain_boxes' not found in input." << std::endl);
      }

      double x_lo[DIM], x_up[DIM];

      if (db->keyExists("x_lo")) {
         db->getDoubleArray("x_lo",x_lo, DIM);
      } else {
         TBOX_ERROR("CartesianGridGeometry<DIM>::getFromInput() error...\n"
               << "    geometry object with name = " << d_object_name
               << "\n    Key data `x_lo' not found in input."<< std::endl);
      }
      if (db->keyExists("x_up")) {
         db->getDoubleArray("x_up",x_up, DIM);
      } else {
         TBOX_ERROR("CartesianGridGeometry<DIM>::getFromInput() error...\n"
               << "    geometry object with name = " << d_object_name
               << "\n   Key data `x_up' not found in input." << std::endl);
      }

      int pbc[DIM];
      hier::IntVector<DIM> per_bc(0);
      if (db->keyExists("periodic_dimension")) {
         db->getIntegerArray("periodic_dimension", pbc, DIM);
         for (int i = 0; i < DIM; i++) {
            per_bc(i) = ((pbc[i] == 0) ? 0 : 1);
         }
      }

      if (DIM > 3) {
         d_using_original_locations = false;
      } else {
         d_using_original_locations = true;
      }
      if (db->keyExists("use_original_location_indices")) {
         d_using_original_locations =
            db->getBool("use_original_location_indices");
      }

      setGeometryData(x_lo, x_up, domain);

      this->initializePeriodicShift(per_bc);

   }
}

/*
*************************************************************************
*                                                                       *
* Checks to see if the version number for the class is the same as	*
* as the version number of the restart file.				*
* If they are equal, then the data from the database are read to local	*
* variables and the setGeometryData() method is called to 		*
* initialize the data members.						*
*                                                                       *
*************************************************************************
*/
template<int DIM> void CartesianGridGeometry<DIM>::getFromRestart()
{
   tbox::Pointer<tbox::Database> restart_db =
      tbox::RestartManager::getManager()->getRootDatabase();

   tbox::Pointer<tbox::Database> db;

   if ( restart_db->isDatabase(d_object_name) ) {
      db = restart_db->getDatabase(d_object_name);
   } else {
      TBOX_ERROR("CartesianGridGeometry<DIM>::getFromRestart() error...\n"
                 << "    database with name " << d_object_name
                 << " not found in the restart file" << std::endl);
   }

   int ver = db->getInteger("GEOM_CARTESIAN_GRID_GEOMETRY_VERSION");
   if (ver != GEOM_CARTESIAN_GRID_GEOMETRY_VERSION) {
      TBOX_ERROR("CartesianGridGeometry<DIM>::getFromRestart() error...\n"
         << "    geometry object with name = " << d_object_name
         << "Restart file version is different than class version" << std::endl);
   }
   hier::BoxArray<DIM> domain = db->getDatabaseBoxArray("d_physical_domain");
   double x_lo[DIM], x_up[DIM];
   db->getDoubleArray("d_x_lo", x_lo, DIM);
   db->getDoubleArray("d_x_up", x_up, DIM);

   setGeometryData(x_lo, x_up, domain);

   hier::IntVector<DIM> periodic_shift;
   int* temp_shift = periodic_shift;
   db->getIntegerArray("d_periodic_shift", temp_shift, DIM);
   this->initializePeriodicShift(periodic_shift);

   d_using_original_locations = db->getBool("d_using_original_locations");
}

}
}
#endif
