
set(TEST_NAME navier_stokes_ex2)

if(IBAMR_BUILD_2D_LIBRARY)
  build_2d_target(input2d input2d.forced_flow) 
endif()
