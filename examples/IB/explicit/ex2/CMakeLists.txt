
set(TEST_NAME IBexplicit2)

if(IBAMR_BUILD_2D_LIBS)
  build_2d_target(input2d.cylinder) 
endif()

build_3d_target(input3d.cylinder input3d.sphere) 