set(KIT coarsen_ops)
set(UKIT COARSEN_OPS)


set(kit_SRCS
  LMarkerCoarsen.cpp
  VecCellCoarsenAdapter.cpp
  CartCellDoubleCubicCoarsen.cpp
  CartSideDoubleCubicCoarsen.cpp
)

ParseM4Sources(
  OutputFiles3D
  FileExt ".f"
  M4args -DSAMRAI_FORTDIR=${SAMRAI_FORTDIR} -DTOP_SRCDIR=${PROJECT_SOURCE_DIR}
  InputFiles fortran/cubiccoarsen3d.f.m4 )

set(kit_SRCS3D
  ${kit_SRCS}
  ${OutputFiles3D}
  )

ParseM4Sources(
  OutputFiles2D
  FileExt ".f"
  M4args -DSAMRAI_FORTDIR=${SAMRAI_FORTDIR} -DTOP_SRCDIR=${PROJECT_SOURCE_DIR}
  InputFiles fortran/cubiccoarsen2d.f.m4 )

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
  )
