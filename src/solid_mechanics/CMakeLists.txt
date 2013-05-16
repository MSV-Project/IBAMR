set(KIT solid_mechanics)

set(kit_SRCS 
  ExplicitFEMechanicsSolver.cpp
  )
  
set(kit_SRCS3D 
  ${kit_SRCS}
  )
  
if(IBTK_BUILD_2D_LIBRARY)
  set(kit_SRCS2D  
    ${kit_SRCS}
    )
endif()    

include(KitCommonBlock) 
