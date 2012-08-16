# A test program to check that the cell-centered Poisson solver achieves
# the expected order of accuracy.

set(TEST_NAME CCPoisson)

if(IBAMR_BUILD_2D_LIBS)
  build_2d_target(input2d) 
endif()

build_3d_target(input3d) 
