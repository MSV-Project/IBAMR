
set(TEST_NAME IBexplicit_ex0)

if(IBAMR_BUILD_2D_LIBS)
  build_2d_target(input2d input2d.shell input2d.shell_circum_fibers)
endif()
