set(KIT patch_data)
set(UKIT PATCH_DATA)


set(kit_SRCS 
  VecCellVariable.C
  VecCellDataFactory.C
  VecCellData.C
)

if(IBTK_BUILD_2D_LIBS)
  set(kit_SRCS2D ${kit_SRCS}
  )
endif()

set(kit_SRCS3D ${kit_SRCS}
  )

include(${IBTK_MODULE_PATH}/KitCommonBlock.cmake)  
