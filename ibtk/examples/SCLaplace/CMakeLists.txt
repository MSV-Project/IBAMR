# A test program to check that the side-centered Laplace operator
# discretization yields the expected order of accuracy.

set(TEST_NAME SCLaplace)

if(IBTK_BUILD_2D_LIBRARY)
  build_2d_target(input2d) 
endif()

build_3d_target(input3d) 
