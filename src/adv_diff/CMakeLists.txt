set(KIT adv_diff)

set(kit_SRCS 
  AdvDiffHypPatchOps.C
  AdvDiffHierarchyIntegrator.C
  )
    
add_m4_sources(FORTRAN_SRCS3D -DSAMRAI_FORTDIR=${SAMRAI_FORTDIR} fortran/adv_diff_consdiff3d.f.m4)
set(kit_SRCS3D 
  ${kit_SRCS}
  ${FORTRAN_SRCS3D}
  )

if(IBAMR_BUILD_2D_LIBS)
  add_m4_sources(FORTRAN_SRCS2D -DSAMRAI_FORTDIR=${SAMRAI_FORTDIR} fortran/adv_diff_consdiff2d.f.m4)
  set(kit_SRCS2D 
    ${kit_SRCS}
    ${FORTRAN_SRCS2D}
    )
endif()

include(${IBAMR_MODULE_PATH}/KitCommonBlock.cmake)  
