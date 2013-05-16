set(KIT patch_data)
set(UKIT PATCH_DATA)


set(kit_SRCS 
  VecCellVariable.cpp
  VecCellDataFactory.cpp
  VecCellData.cpp
)

set(kit_SRCS2D ${kit_SRCS}
  )

set(kit_SRCS3D ${kit_SRCS}
  )

#
# Include the common target module
#
include(${IBTK_MODULE_PATH}/KitCommonBlock.cmake)  


include_directories(
  ${CMAKE_CURRENT_SOURCE_DIR}
  
  )
