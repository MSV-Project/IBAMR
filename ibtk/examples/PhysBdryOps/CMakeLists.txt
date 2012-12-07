# A test program to check that the physical boundary condition helper
# objects are working correctly.

set(TEST_NAME PhysBdryOps)

if(IBTK_BUILD_2D_LIBRARY)
  build_2d_target(input2d) 
endif()

build_3d_target(input3d) 