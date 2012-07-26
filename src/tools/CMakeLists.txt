set(KIT navier_stokes)

set(kit_SRCS 
  m3D_hdf5_marker_converter.C
  m3D_hdf5_strain_analyzer.C
  marker_flooder.C
  m3D_hdf5_fiber_converter.C
  hdf2vertex.C
  ascii2hdf.C
  )
  
set(kit_SRCS3D 
  ${kit_SRCS}
  )
  
if(IBTK_BUILD_2D_LIBRARY)
  set(kit_SRCS2D 
    ${kit_SRCS}
    )
endif()    

include(${IBAMR_MODULE_PATH}/KitCommonBlock.cmake)  
