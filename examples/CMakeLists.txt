

macro(BUILD_2D_TARGET)
  add_executable(${TEST_NAME}_2d main.C)
  target_link_libraries(${TEST_NAME}_2d ${IBAMR_LIBRARIES2D})
  set_target_properties(${TEST_NAME}_2d PROPERTIES COMPILE_FLAGS -DNDIM=2)
  if(BUILD_TESTING)
    foreach( input ${ARGN} )
      add_test(${TEST_NAME}_2d_${input} 
	${MPIEXEC} 
	${MPIEXEC_NUMPROC_FLAG} 2 
	${IBAMR_CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${TEST_NAME}_2d 
	${MPIEXEC_POSTFLAGS} ${CMAKE_CURRENT_SOURCE_DIR}/${input}
	WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})
    endforeach()
  endif()  
endmacro()

macro(BUILD_3D_TARGET)
  add_executable(${TEST_NAME}_3d main.C)
  target_link_libraries(${TEST_NAME}_3d ${IBAMR_LIBRARIES3D})
  set_target_properties(${TEST_NAME}_3d PROPERTIES COMPILE_FLAGS -DNDIM=3)
  if(BUILD_TESTING)
    foreach( input ${ARGN} )
      add_test(${TEST_NAME}_3d_${input}
	${MPIEXEC} 
	${MPIEXEC_NUMPROC_FLAG} 2 
	${IBAMR_CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${TEST_NAME}_3d 
	${MPIEXEC_POSTFLAGS} ${CMAKE_CURRENT_SOURCE_DIR}/${input}
	WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})
    endforeach()
  endif()  
endmacro()  

add_subdirectory(IB)
# add_subdirectory(IBFE)
add_subdirectory(adv_diff)
add_subdirectory(advect)
add_subdirectory(navier_stokes)
