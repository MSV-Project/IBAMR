
set(TEST_NAME adv_diff_ex0)

if(IBAMR_BUILD_2D_LIBRARY)
  add_library(adv_diff_functions2d STATIC QInit.cpp UFunction.cpp)
  target_link_libraries(adv_diff_functions2d)
  set_target_properties(adv_diff_functions2d PROPERTIES COMPILE_FLAGS -DNDIM=2)
  add_dependencies(adv_diff_functions2d IBTK-Build)
  build_2d_target(input2d)
  target_link_libraries(${TEST_NAME}_2d adv_diff_functions2d)
endif()

add_library(adv_diff_functions3d STATIC QInit.cpp UFunction.cpp)
target_link_libraries(adv_diff_functions3d)
set_target_properties(adv_diff_functions3d PROPERTIES COMPILE_FLAGS -DNDIM=3)
add_dependencies(adv_diff_functions3d IBTK-Build)

build_3d_target(input3d)

target_link_libraries(${TEST_NAME}_3d adv_diff_functions3d)
