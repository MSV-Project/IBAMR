#
macro(BUILD_2D_TARGET)
  add_executable(${TEST_NAME}_2d main.cpp)
  target_link_libraries(${TEST_NAME}_2d ${IBTK_LIBRARIES2D} ${IBTK_EXTERNAL_LIBRARIES})
  set_target_properties(${TEST_NAME}_2d PROPERTIES COMPILE_FLAGS -DNDIM=2)
  if(BUILD_TESTING)
    foreach( input ${ARGN} )
      add_test(${TEST_NAME}_2d_${input} 
	${MPIEXEC} 
	${MPIEXEC_NUMPROC_FLAG} 2 
	${IBTK_CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${TEST_NAME}_2d 
	${CMAKE_CURRENT_SOURCE_DIR}/${input}
	WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})
    endforeach()
  endif()  
endmacro()
macro(BUILD_3D_TARGET)
  add_executable(${TEST_NAME}_3d main.cpp)
  target_link_libraries(${TEST_NAME}_3d ${IBTK_LIBRARIES3D} ${IBTK_EXTERNAL_LIBRARIES})
  set_target_properties(${TEST_NAME}_3d PROPERTIES COMPILE_FLAGS -DNDIM=3)
  if(BUILD_TESTING)
    foreach( input ${ARGN} )
      add_test(${TEST_NAME}_3d_${input}
	${MPIEXEC} 
	${MPIEXEC_NUMPROC_FLAG} 2 
	${MPIEXEC_PREFLAGS} 
	${IBTK_CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${TEST_NAME}_3d 
	${MPIEXEC_POSTFLAGS}
	${CMAKE_CURRENT_SOURCE_DIR}/${input}
	WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})
    endforeach()
  endif()  
endmacro()

add_subdirectory(CCLaplace)
add_subdirectory(CCPoisson)
add_subdirectory(PhysBdryOps)
add_subdirectory(SCLaplace)
add_subdirectory(VCLaplace)

