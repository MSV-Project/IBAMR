
set(TEST_NAME navier_stokes_ex1)

if(IBAMR_BUILD_2D_LIBRARY)
  build_2d_target(input2d) 
  add_executable(convergence_tester convergence_tester.cpp)
  target_link_libraries(convergence_tester ${IBAMR_LIBRARIES2D})
  set_target_properties(convergence_tester PROPERTIES COMPILE_FLAGS -DNDIM=2)
  
  add_test(convergence_tester_input2d
	${MPIEXEC} 
	${MPIEXEC_NUMPROC_FLAG} 2 
	${IBAMR_CMAKE_RUNTIME_OUTPUT_DIRECTORY}/convergence_tester
	${MPIEXEC_POSTFLAGS} ${CMAKE_CURRENT_SOURCE_DIR}/input2d)
endif()

