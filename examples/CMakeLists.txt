

macro(BUILD_2D_TARGET)
  add_executable(${TEST_NAME}2d main.C)
  target_link_libraries(${TEST_NAME}2d ${IBAMR_LIBRARIES2D})
  set_target_properties(${TEST_NAME}2d PROPERTIES COMPILE_FLAGS -DNDIM=2)
  if(BUILD_TESTING)
    foreach( input ${ARGN} )
      add_test(${TEST_NAME}2d_${input} 
	${MPIEXEC} 
	${MPIEXEC_NUMPROC_FLAG} 2 
	${IBAMR_CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${TEST_NAME}2d 
	${MPIEXEC_POSTFLAGS} ${CMAKE_CURRENT_SOURCE_DIR}/${input})
    endforeach()
  endif()  
endmacro()

macro(BUILD_3D_TARGET)
  add_executable(${TEST_NAME}3d main.C)
  target_link_libraries(${TEST_NAME}3d ${IBAMR_LIBRARIES3D})
  set_target_properties(${TEST_NAME}3d PROPERTIES COMPILE_FLAGS -DNDIM=3)
  if(BUILD_TESTING)
    foreach( input ${ARGN} )
      add_test(${TEST_NAME}3d_${input}
	${MPIEXEC} 
	${MPIEXEC_NUMPROC_FLAG} 2 
	${IBAMR_CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${TEST_NAME}3d 
	${MPIEXEC_POSTFLAGS} ${CMAKE_CURRENT_SOURCE_DIR}/${input})
    endforeach()
  endif()  
endmacro()  

add_subdirectory(IB)
# add_subdirectory(IBFE)
# add_subdirectory(adv_diff)
# add_subdirectory(advect)
# add_subdirectory(navier_stokes)