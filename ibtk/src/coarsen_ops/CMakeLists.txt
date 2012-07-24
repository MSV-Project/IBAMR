set(KIT coarsen_ops)
set(UKIT COARSEN_OPS)


set(kit_SRCS LMarkerCoarsen.C
  VecCellCoarsenAdapter.C
  CartCellDoubleCubicCoarsen.C
  CartSideDoubleCubicCoarsen.C
)

set(kit_SRCS2D ${kit_SRCS}
  fortran/cubiccoarsen2d.f
)

set(kit_SRCS3D ${kit_SRCS}
  fortran/cubiccoarsen3d.f
)

include(${IBTK_MODULE_PATH}/KitCommonBlock.cmake) 
