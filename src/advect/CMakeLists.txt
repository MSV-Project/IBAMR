set(KIT advect)

set(kit_SRCS
  AdvectorExplicitPredictorStrategy.cpp
  AdvectorPredictorCorrectorHyperbolicPatchOps.cpp
  )

set(FortranSRCS
  fortran/advect_centered_derivatives3d.f.m4
  fortran/advect_detect3d.f.m4
  fortran/advect_diff3d.f.m4
  fortran/advect_helpers.f.m4
  fortran/advect_predictors3d.f.m4
  fortran/advect_stable3d.f.m4
#   fortran/godunov_helpers.f.m4
#   fortran/godunov_predictors3d.f.m4 
  )

ParseM4Sources(
  OutputFiles3D
  FileExt ".f"
  M4args -DSAMRAI_FORTDIR=${SAMRAI_FORTDIR} -DTOP_SRCDIR=${PROJECT_SOURCE_DIR}
  InputFiles ${FortranSRCS} )

set(kit_SRCS3D
  ${kit_SRCS}
  ${OutputFiles3D}
  )

set(FortranSRCS
  fortran/advect_centered_derivatives2d.f.m4
  fortran/advect_detect2d.f.m4
  fortran/advect_diff2d.f.m4
  fortran/advect_predictors2d.f.m4
  fortran/advect_stable2d.f.m4
#   fortran/godunov_predictors2d.f.m4 
  )

ParseM4Sources(
  OutputFiles2D
  FileExt ".f"
  M4args -DSAMRAI_FORTDIR=${SAMRAI_FORTDIR} -DTOP_SRCDIR=${PROJECT_SOURCE_DIR}
  InputFiles ${FortranSRCS} )

set(kit_SRCS2D
  ${kit_SRCS}
  ${OutputFiles2D}
  )

#
# Include the common target module
#
include(KitCommonBlock)


include_directories(
  ${CMAKE_CURRENT_SOURCE_DIR}
  )
