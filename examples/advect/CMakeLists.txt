
set(TEST_NAME advect)

if(IBAMR_BUILD_2D_LIBRARY)
  add_library(advection_functions2d STATIC QInit.cpp UFunction.cpp)
  target_link_libraries(advection_functions2d ${IBAMR_LIBRARIES2D})
  set_target_properties(advection_functions2d PROPERTIES COMPILE_FLAGS -DNDIM=2)
  build_2d_target(input2d)
  target_link_libraries(${TEST_NAME}_2d advection_functions2d)
endif()

add_library(advection_functions3d STATIC QInit.cpp UFunction.cpp)
target_link_libraries(advection_functions3d ${IBAMR_LIBRARIES3D})
set_target_properties(advection_functions3d PROPERTIES COMPILE_FLAGS -DNDIM=3)
build_3d_target(input3d)

target_link_libraries(${TEST_NAME}_3d advection_functions3d)
