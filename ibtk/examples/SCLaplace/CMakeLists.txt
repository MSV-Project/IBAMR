# A test program to check that the side-centered Laplace operator
# discretization yields the expected order of accuracy.

set(TEST_NAME SCLaplace)

if(IBTK_BUILD_2D_LIBS)
  add_executable(${TEST_NAME}2d main.C)
  target_link_libraries(${TEST_NAME}2d ${IBTK_LIBRARIES2D} ${IBTK_EXTERNAL_LIBRARIES})
  set_target_properties(${TEST_NAME}2d PROPERTIES COMPILE_FLAGS -DNDIM=2)
  if(BUILD_TESTING)
    add_test(${TEST_NAME}2d 
      ${MPIEXEC} ${MPIEXEC_NUMPROC_FLAG} 2 ${MPIEXEC_PREFLAGS} ${IBTK_CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${TEST_NAME}2d ${MPIEXEC_POSTFLAGS} ${CMAKE_CURRENT_SOURCE_DIR}/input2d WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})
  endif()  
endif()
add_executable(${TEST_NAME}3d main.C)
target_link_libraries(${TEST_NAME}3d ${IBTK_LIBRARIES3D} ${IBTK_EXTERNAL_LIBRARIES})
set_target_properties(${TEST_NAME}3d PROPERTIES COMPILE_FLAGS -DNDIM=3)

if(BUILD_TESTING)
  add_test(${TEST_NAME}3d 
    ${MPIEXEC} ${MPIEXEC_NUMPROC_FLAG} 2 ${MPIEXEC_PREFLAGS} ${IBTK_CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${TEST_NAME}3d ${MPIEXEC_POSTFLAGS} ${CMAKE_CURRENT_SOURCE_DIR}/input3d WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})
endif()  
