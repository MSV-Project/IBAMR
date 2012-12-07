set(KIT advect)

set(kit_SRCS 
  AdvectHypPatchOps.C
  GodunovAdvector.C
  )
  
add_m4_sources(FORTRAN_SRCS3D -DSAMRAI_FORTDIR=${SAMRAI_FORTDIR} .f
  fortran/advect_diff3d.f.m4
  fortran/advect_stable3d.f.m4
  fortran/advect_detect3d.f.m4
  fortran/godunov_predictors3d.f.m4
  fortran/advect_centered_derivatives3d.f.m4
  fortran/godunov_helpers.f.m4
  )
  
set(kit_SRCS3D 
  ${kit_SRCS}
  ${FORTRAN_SRCS3D}
  )

add_m4_sources(FORTRAN_SRCS2D -DSAMRAI_FORTDIR=${SAMRAI_FORTDIR} .f
  fortran/godunov_predictors2d.f.m4
  fortran/advect_centered_derivatives2d.f.m4
  fortran/advect_detect2d.f.m4
  fortran/advect_stable2d.f.m4
  fortran/advect_diff2d.f.m4
  )
set(kit_SRCS2D 
  ${kit_SRCS}
  ${FORTRAN_SRCS2D}
  )
  
#
# Include the common target module
#
include(KitCommonBlock)  


include_directories(
  ${CMAKE_CURRENT_SOURCE_DIR}
  
  )
