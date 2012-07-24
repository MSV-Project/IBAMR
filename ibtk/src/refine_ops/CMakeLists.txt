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

set(kit_SRCS2D ${kit_SRCS}
  fortran/cart_side_refine2d.f
  fortran/divpreservingrefine2d.f
)

set(kit_SRCS3D ${kit_SRCS}
  fortran/divpreservingrefine3d.f
  fortran/cart_side_refine3d.f
)

include(${IBTK_MODULE_PATH}/KitCommonBlock.cmake)
