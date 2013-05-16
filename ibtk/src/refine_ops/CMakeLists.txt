set(KIT refine_ops)
set(UKIT REFINE_OPS)


set(kit_SRCS
  CartCellDoubleBoundsPreservingConservativeLinearRefine.cpp
  LMarkerRefine.cpp
  CartSideDoubleSpecializedConstantRefine.cpp
  CartCellDoubleQuadraticRefine.cpp
  CartSideDoubleSpecializedLinearRefine.cpp
  VecCellRefineAdapter.cpp
  CartSideDoubleDivPreservingRefine.cpp
)

set(FortranSRCS fortran/divpreservingrefine3d.f.m4
  fortran/cart_side_refine3d.f.m4)

ParseM4Sources(
  OutputFiles3D
  FileExt ".f"
  M4args -DSAMRAI_FORTDIR=${SAMRAI_FORTDIR} -DTOP_SRCDIR=${PROJECT_SOURCE_DIR}
  InputFiles ${FortranSRCS} )


set(kit_SRCS3D
  ${kit_SRCS}
  ${OutputFiles3D}
  )

set(FortranSRCS fortran/cart_side_refine2d.f.m4
  fortran/divpreservingrefine2d.f.m4)

ParseM4Sources(
  OutputFiles2D
  FileExt ".f"
  M4args -DSAMRAI_FORTDIR=${SAMRAI_FORTDIR} -DTOP_SRCDIR=${PROJECT_SOURCE_DIR}
  InputFiles ${FortranSRCS} )

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
