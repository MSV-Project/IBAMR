set(KIT refine_ops)
set(UKIT REFINE_OPS)


set(kit_SRCS CartCellDoubleBoundsPreservingConservativeLinearRefine.C
  LMarkerRefine.C
  CartSideDoubleSpecializedConstantRefine.C
  CartCellDoubleQuadraticRefine.C
  CartSideDoubleSpecializedLinearRefine.C
  VecCellRefineAdapter.C
  CartSideDoubleDivPreservingRefine.C

)

add_m4_sources(FORTRAN_SRCS3D -DSAMRAI_FORTDIR=${SAMRAI_FORTDIR} .f
  fortran/divpreservingrefine3d.f.m4
  fortran/cart_side_refine3d.f.m4)
  
set(kit_SRCS3D 
  ${kit_SRCS}
  ${FORTRAN_SRCS3D}
  )

add_m4_sources(FORTRAN_SRCS2D -DSAMRAI_FORTDIR=${SAMRAI_FORTDIR} .f
  fortran/cart_side_refine2d.f.m4
  fortran/divpreservingrefine2d.f.m4)
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
  
  )
