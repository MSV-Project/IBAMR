# A test program to check that the side-centered variable-coefficient
# generalized Laplace operator discretization yields the expected order
# of accuracy.

set(TEST_NAME VCLaplace)

if(IBTK_BUILD_2D_LIBS)
  add_executable(${TEST_NAME}2d main.C)
  target_link_libraries(${TEST_NAME}2d ${IBTK_LIBRARIES2D})
  set_target_properties(${TEST_NAME}2d PROPERTIES COMPILE_FLAGS -DNDIM=2)
  if(BUILD_TESTING)
    add_test(${TEST_NAME}2d ${MPIEXEC} -np 2 ${CMAKE_CURRENT_BINARY_DIR}/${TEST_NAME}2d ${CMAKE_CURRENT_SOURCE_DIR}/input2d)
  endif()  
endif()
