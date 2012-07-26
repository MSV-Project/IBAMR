set(KIT boundary)
set(UKIT BOUNDARY)

set(kit_SRCS cf_interface/CartCellDoubleLinearCFInterpolation.C
  cf_interface/CoarseFineBoundaryRefinePatchStrategy.C
  cf_interface/CartSideDoubleQuadraticCFInterpolation.C
  cf_interface/CartCellDoubleQuadraticCFInterpolation.C
  physical_boundary/muParserRobinBcCoefs.C
  physical_boundary/CartCellRobinPhysBdryOp.C
  physical_boundary/CartExtrapPhysBdryOp.C
  physical_boundary/CartSideRobinPhysBdryOp.C
  physical_boundary/ExtendedRobinBcCoefStrategy.C
  physical_boundary/PhysicalBoundaryUtilities.C
  HierarchyGhostCellInterpolation.C
  )

set(kit_SRCS2D 
  ${kit_SRCS} 
  physical_boundary/fortran/cartphysbdryop2d.f
  cf_interface/fortran/linearcfinterpolation2d.f
  cf_interface/fortran/quadcfinterpolation2d.f
  )

set(kit_SRCS3D 
  ${kit_SRCS} 
  physical_boundary/fortran/cartphysbdryop3d.f
  cf_interface/fortran/linearcfinterpolation3d.f
  cf_interface/fortran/quadcfinterpolation3d.f
  )

include(${IBTK_MODULE_PATH}/KitCommonBlock.cmake)  
 