
set(TEST_NAME adv_diff_ex1)

if(IBAMR_BUILD_2D_LIBRARY)
  build_2d_target(input2d)
endif()

build_3d_target(input3d)

