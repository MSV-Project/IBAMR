set(KIT adv_diff)

set(kit_SRCS
  AdvDiffSemiImplicitHierarchyIntegrator.cpp
  AdvDiffCenteredConvectiveOperator.cpp
  AdvDiffConvectiveOperatorManager.cpp
  AdvDiffPPMConvectiveOperator.cpp
  AdvDiffHierarchyIntegrator.cpp
  AdvDiffStochasticForcing.cpp
  AdvDiffPredictorCorrectorHyperbolicPatchOps.cpp
  AdvDiffPhysicalBoundaryUtilities.cpp
  AdvDiffPredictorCorrectorHierarchyIntegrator.cpp
  )

ParseM4Sources(
  OutputFiles3D
  FileExt ".f"
  M4args -DSAMRAI_FORTDIR=${SAMRAI_FORTDIR} -DTOP_SRCDIR=${PROJECT_SOURCE_DIR}
  InputFiles fortran/adv_diff_consdiff3d.f.m4 )

set(kit_SRCS3D
  ${kit_SRCS}
  ${OutputFiles3D}
  )

ParseM4Sources(
  OutputFiles2D
  FileExt ".f"
  M4args -DSAMRAI_FORTDIR=${SAMRAI_FORTDIR} -DTOP_SRCDIR=${PROJECT_SOURCE_DIR}
  InputFiles fortran/adv_diff_consdiff2d.f.m4 )

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
