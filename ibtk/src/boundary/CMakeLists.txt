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

add_m4_sources(FORTRAN_SRCS3D -DSAMRAI_FORTDIR=${SAMRAI_FORTDIR} .f
  physical_boundary/fortran/cartphysbdryop3d.f.m4
  cf_interface/fortran/linearcfinterpolation3d.f.m4
  cf_interface/fortran/quadcfinterpolation3d.f.m4)

set(kit_SRCS3D
  ${kit_SRCS}
  ${FORTRAN_SRCS3D}
  )

add_m4_sources(FORTRAN_SRCS2D -DSAMRAI_FORTDIR=${SAMRAI_FORTDIR} .f
  physical_boundary/fortran/cartphysbdryop2d.f.m4
  cf_interface/fortran/linearcfinterpolation2d.f.m4
  cf_interface/fortran/quadcfinterpolation2d.f.m4)

set(kit_SRCS2D
  ${kit_SRCS}
  ${FORTRAN_SRCS2D}
  )

#
# Include the common target module
#
include(${IBTK_MODULE_PATH}/KitCommonBlock.cmake)

include_directories(
  ${CMAKE_CURRENT_SOURCE_DIR}
  ${CMAKE_CURRENT_SOURCE_DIR}/cf_interface
  ${CMAKE_CURRENT_SOURCE_DIR}/physical_boundary

  )

