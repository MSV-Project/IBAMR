
set(TEST_NAME adv_diff)

if(IBAMR_BUILD_2D_LIBS)
  add_library(adv_diff_functions2d STATIC QInit.C UFunction.C)
  target_link_libraries(adv_diff_functions2d)
  set_target_properties(adv_diff_functions2d PROPERTIES COMPILE_FLAGS -DNDIM=2)
  build_2d_target(input2d)
  target_link_libraries(${TEST_NAME}_2d adv_diff_functions2d)
endif()

add_library(adv_diff_functions3d STATIC QInit.C UFunction.C)
target_link_libraries(adv_diff_functions3d)
set_target_properties(adv_diff_functions3d PROPERTIES COMPILE_FLAGS -DNDIM=3)

build_3d_target(input3d)

target_link_libraries(${TEST_NAME}_3d adv_diff_functions3d)