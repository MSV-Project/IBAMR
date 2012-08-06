set(KIT coarsen_ops)
set(UKIT COARSEN_OPS)


set(kit_SRCS LMarkerCoarsen.C
  VecCellCoarsenAdapter.C
  CartCellDoubleCubicCoarsen.C
  CartSideDoubleCubicCoarsen.C
)

add_m4_sources(FORTRAN_SRCS3D -DSAMRAI_FORTDIR=${SAMRAI_FORTDIR}  
  fortran/cubiccoarsen3d.f.m4)
  
set(kit_SRCS3D 
  ${kit_SRCS}
  ${FORTRAN_SRCS3D}
  )
  
add_m4_sources(FORTRAN_SRCS2D -DSAMRAI_FORTDIR=${SAMRAI_FORTDIR}
  fortran/cubiccoarsen2d.f.m4)
  
set(kit_SRCS2D 
  ${kit_SRCS}
  ${FORTRAN_SRCS2D}
  )  


include(${IBTK_MODULE_PATH}/KitCommonBlock.cmake) 
