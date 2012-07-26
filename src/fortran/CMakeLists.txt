set(KIT fortran)

set(kit_SRCS 
  sqrtm.f
  )
   
set(kit_SRCS3D 
  ${kit_SRCS}
  )  

include(${IBAMR_MODULE_PATH}/KitCommonBlock.cmake)  
