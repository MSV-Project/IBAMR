# A test program to check that the cell-centered Poisson solver achieves
# the expected order of accuracy.

set(TEST_NAME CCPoisson)

if(IBTK_BUILD_2D_LIBS)
  add_executable(${TEST_NAME}2d main.C)
  target_link_libraries(${TEST_NAME}2d ${IBTK_LIBRARIES2D})
  set_target_properties(${TEST_NAME}2d PROPERTIES COMPILE_FLAGS -DNDIM=2)
  if(BUILD_TESTING)
    add_test(${TEST_NAME}2d ${MPIEXEC} -np 2 ${CMAKE_CURRENT_BINARY_DIR}/${TEST_NAME}2d ${CMAKE_CURRENT_SOURCE_DIR}/input2d)
  endif()  
endif()
add_executable(${TEST_NAME}3d main.C)
target_link_libraries(${TEST_NAME}3d ${IBTK_LIBRARIES3D})
set_target_properties(${TEST_NAME}3d PROPERTIES COMPILE_FLAGS -DNDIM=3)

if(BUILD_TESTING)
  add_test(${TEST_NAME}3d ${MPIEXEC} -np 2 ${CMAKE_CURRENT_BINARY_DIR}/${TEST_NAME}3d ${CMAKE_CURRENT_SOURCE_DIR}/input3d)
endif()  
