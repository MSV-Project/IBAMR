set(KIT fortran)

set(kit_SRCS 
  sqrtm.f
  )
   
set(kit_SRCS3D 
  ${kit_SRCS}
  )  
  
set(kit_SRCS2D 
  ${kit_SRCS}
  )  
#
# Include the common target module
#
include(KitCommonBlock)  


include_directories(
  ${CMAKE_CURRENT_SOURCE_DIR}
  
  )