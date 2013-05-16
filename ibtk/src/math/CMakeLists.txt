set(KIT math)
set(UKIT MATH)


set(kit_SRCS
  PETScMatUtilities.cpp
  PatchVecCellDataBasicOps.cpp
  HierarchyVecCellDataOpsReal.cpp
  PatchMathOps.cpp
  PoissonUtilities.cpp
  HierarchyMathOps.cpp
  PETScVecUtilities.cpp
  PatchVecCellDataOpsReal.cpp
)

set(FortranSRCS   
  fortran/flux3d.f.m4
  fortran/interp3d.f.m4
  fortran/grad3d.f.m4
  fortran/miscmath3d.f.m4
  fortran/graddetect3d.f.m4
  fortran/curl3d.f.m4
  fortran/div3d.f.m4
  fortran/laplace3d.f.m4)

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
  fortran/laplace2d.f.m4
  fortran/vclaplace2d.f.m4
  fortran/div2d.f.m4
  fortran/interp2d.f.m4
  fortran/curl2d.f.m4
  fortran/graddetect2d.f.m4
  fortran/miscmath2d.f.m4
  fortran/grad2d.f.m4
  fortran/flux2d.f.m4)

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
include(${IBTK_MODULE_PATH}/KitCommonBlock.cmake)

include_directories(
  ${CMAKE_CURRENT_SOURCE_DIR}

  )

