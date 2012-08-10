
set(TEST_NAME navier_stokes_ex0)

if(IBAMR_BUILD_2D_LIBS)
  build_2d_target(input2d input2d.forced_flow) 
endif()

build_3d_target(input3d) 