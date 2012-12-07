set(KIT fortran)
set(UKIT FORTRAN)


set(kit_SRCS minmod.f
)

set(kit_SRCS2D ${kit_SRCS})

set(kit_SRCS3D ${kit_SRCS})

include(${IBTK_MODULE_PATH}/KitCommonBlock.cmake)  

