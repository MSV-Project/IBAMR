set(KIT tools)

# -----------------------------------------------------------------------------
# FindHDF5
# -----------------------------------------------------------------------------
find_package(HDF5 CONFIG )
if(NOT HDF5_FOUND)
  message(FATAL_ERROR "Must specify HDF5 installation directory.")
endif()

set(kit_SRCS
  m3D_hdf5_marker_converter.C
  m3D_hdf5_strain_analyzer.C
  marker_flooder.C
  m3D_hdf5_fiber_converter.C
  hdf2vertex.C
  ascii2hdf.C
  )

add_executable(m3D_hdf5_marker_converter m3D_hdf5_marker_converter.C)
target_link_libraries(m3D_hdf5_marker_converter ${IBAMR_LIBRARIES} )
set_target_properties(m3D_hdf5_marker_converter PROPERTIES COMPILE_DEFINITIONS NDIM=3)
add_dependencies(m3D_hdf5_marker_converter IBTK-Build)

add_executable(m3D_hdf5_strain_analyzer m3D_hdf5_strain_analyzer.C)
target_link_libraries(m3D_hdf5_strain_analyzer ${IBAMR_LIBRARIES} )
set_target_properties(m3D_hdf5_strain_analyzer PROPERTIES COMPILE_DEFINITIONS NDIM=3)
add_dependencies(m3D_hdf5_strain_analyzer IBTK-Build)

add_executable(marker_flooder marker_flooder.C)
target_link_libraries(marker_flooder ${IBAMR_LIBRARIES} )
set_target_properties(marker_flooder PROPERTIES COMPILE_DEFINITIONS NDIM=3)
add_dependencies(marker_flooder IBTK-Build)

add_executable(m3D_hdf5_fiber_converter m3D_hdf5_fiber_converter.C)
target_link_libraries(m3D_hdf5_fiber_converter ${IBAMR_LIBRARIES} )
set_target_properties(m3D_hdf5_fiber_converter PROPERTIES COMPILE_DEFINITIONS NDIM=3)
add_dependencies(m3D_hdf5_fiber_converter IBTK-Build)

add_executable(ascii2hdf ascii2hdf.C)
target_link_libraries(ascii2hdf ${IBAMR_LIBRARIES} )
set_target_properties(ascii2hdf PROPERTIES COMPILE_DEFINITIONS NDIM=3)
add_dependencies(ascii2hdf IBTK-Build)

add_executable(hdf2vertex hdf2vertex.C)
target_link_libraries(hdf2vertex ${IBAMR_LIBRARIES} )
set_target_properties(hdf2vertex PROPERTIES COMPILE_DEFINITIONS NDIM=3)
add_dependencies(hdf2vertex IBTK-Build)
