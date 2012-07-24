set(KIT math)
set(UKIT MATH)


set(kit_SRCS PETScMatUtilities.C
  PatchVecCellDataBasicOps.C
  HierarchyVecCellDataOpsReal.C
  PatchMathOps.C
  HierarchyMathOps.C
  PETScVecUtilities.C
  PatchVecCellDataOpsReal.C
)


set(kit_SRCS2D ${kit_SRCS}
  fortran/laplace2d.f
  fortran/div2d.f
  fortran/graddetect2d.f
  fortran/curl2d.f
  fortran/vclaplace2d.f
  fortran/miscmath2d.f
  fortran/flux2d.f
  fortran/grad2d.f
  fortran/interp2d.f
)

set(kit_SRCS3D ${kit_SRCS}
  fortran/miscmath3d.f
  fortran/div3d.f
  fortran/flux3d.f
  fortran/interp3d.f
  fortran/laplace3d.f
  fortran/grad3d.f
  fortran/graddetect3d.f
  fortran/curl3d.f  
)

include(${IBTK_MODULE_PATH}/KitCommonBlock.cmake)

