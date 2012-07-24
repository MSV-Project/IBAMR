set(KIT fortran)
set(UKIT FORTRAN)


set(kit_SRCS minmod.f
)

if(IBTK_BUILD_2D_LIBS)
  set(kit_SRCS2D ${kit_SRCS})
endif()

set(kit_SRCS3D ${kit_SRCS})

include(${IBTK_MODULE_PATH}/KitCommonBlock.cmake)  

