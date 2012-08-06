set(KIT tools)

set(kit_SRCS 
  m3D_hdf5_marker_converter.C
  m3D_hdf5_strain_analyzer.C
  marker_flooder.C
  m3D_hdf5_fiber_converter.C
#   hdf2vertex.C
  ascii2hdf.C
  )
    
add_executable(m3D_hdf5_marker_converter m3D_hdf5_marker_converter.C)
add_executable(m3D_hdf5_strain_analyzer m3D_hdf5_strain_analyzer.C)
add_executable(marker_flooder marker_flooder.C)
add_executable(m3D_hdf5_fiber_converter m3D_hdf5_fiber_converter.C)
add_executable(ascii2hdf ascii2hdf.C)