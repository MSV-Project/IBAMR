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

add_m4_sources(FORTRAN_SRCS3D -DSAMRAI_FORTDIR=${SAMRAI_FORTDIR}  
  fortran/miscmath3d.f.m4
  fortran/div3d.f.m4
  fortran/flux3d.f.m4
  fortran/interp3d.f.m4
  fortran/laplace3d.f.m4
  fortran/grad3d.f.m4
  fortran/graddetect3d.f.m4
  fortran/curl3d.f.m4)
  
set(kit_SRCS3D 
  ${kit_SRCS}
  ${FORTRAN_SRCS3D}
  )

if(IBTK_BUILD_2D_LIBS)
  add_m4_sources(FORTRAN_SRCS2D -DSAMRAI_FORTDIR=${SAMRAI_FORTDIR}
    fortran/laplace2d.f.m4
    fortran/div2d.f.m4
    fortran/graddetect2d.f.m4
    fortran/curl2d.f.m4
    fortran/vclaplace2d.f.m4
    fortran/miscmath2d.f.m4
    fortran/flux2d.f.m4
    fortran/grad2d.f.m4
    fortran/interp2d.f.m4)
  set(kit_SRCS2D 
    ${kit_SRCS}
    ${FORTRAN_SRCS2D}
    )  
endif()

include(${IBTK_MODULE_PATH}/KitCommonBlock.cmake)

