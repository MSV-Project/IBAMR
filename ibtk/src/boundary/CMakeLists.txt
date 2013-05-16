set(KIT boundary)
set(UKIT BOUNDARY)

set(kit_SRCS cf_interface/CartCellDoubleLinearCFInterpolation.cpp
  cf_interface/CoarseFineBoundaryRefinePatchStrategy.cpp
  cf_interface/CartSideDoubleQuadraticCFInterpolation.cpp
  cf_interface/CartCellDoubleQuadraticCFInterpolation.cpp
  physical_boundary/StaggeredPhysicalBoundaryHelper.cpp
  physical_boundary/muParserRobinBcCoefs.cpp
  physical_boundary/CartCellRobinPhysBdryOp.cpp
  physical_boundary/CartExtrapPhysBdryOp.cpp
  physical_boundary/RobinPhysBdryPatchStrategy.cpp
  physical_boundary/CartSideRobinPhysBdryOp.cpp
  physical_boundary/ExtendedRobinBcCoefStrategy.cpp
  physical_boundary/PhysicalBoundaryUtilities.cpp
  HierarchyGhostCellInterpolation.cpp
  )

ParseM4Sources(
  OutputFiles3D
  FileExt ".f"
  M4args -DSAMRAI_FORTDIR=${SAMRAI_FORTDIR} -DTOP_SRCDIR=${PROJECT_SOURCE_DIR}
  InputFiles physical_boundary/fortran/cartphysbdryop3d.f.m4
             cf_interface/fortran/linearcfinterpolation3d.f.m4
             cf_interface/fortran/quadcfinterpolation3d.f.m4 )

set(kit_SRCS3D
  ${kit_SRCS}
  ${OutputFiles3D}
  )

ParseM4Sources(
  OutputFiles2D
  FileExt ".f"
  M4args -DSAMRAI_FORTDIR=${SAMRAI_FORTDIR} -DTOP_SRCDIR=${PROJECT_SOURCE_DIR}
  InputFiles physical_boundary/fortran/cartphysbdryop2d.f.m4
             cf_interface/fortran/linearcfinterpolation2d.f.m4
             cf_interface/fortran/quadcfinterpolation2d.f.m4 )

set(kit_SRCS2D
  ${kit_SRCS}
  ${OutputFiles2D}
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

