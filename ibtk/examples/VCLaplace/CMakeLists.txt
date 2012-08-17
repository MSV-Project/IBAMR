# A test program to check that the side-centered variable-coefficient
# generalized Laplace operator discretization yields the expected order
# of accuracy.

set(TEST_NAME VCLaplace)

if(IBTK_BUILD_2D_LIBRARY)
  build_2d_target(input2d) 
endif()
