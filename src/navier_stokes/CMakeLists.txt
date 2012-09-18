set(KIT navier_stokes)

set(kit_SRCS 
  INSStaggeredHierarchyIntegrator.C
  INSIntermediateVelocityBcCoef.C
  INSStaggeredVelocityBcCoef.C
  INSStaggeredBoxRelaxationFACOperator.C
  INSStaggeredPhysicalBoundaryHelper.C
  INSStaggeredPressureBcCoef.C
  INSHierarchyIntegrator.C
  INSStaggeredProjectionPreconditioner.C
  INSStaggeredPPMConvectiveOperator.C
  INSStaggeredStokesOperator.C
  INSCollocatedCenteredConvectiveOperator.C
  ConvectiveOperator.C
  INSProblemCoefs.C
  INSStaggeredBlockFactorizationPreconditioner.C
  SpongeLayerForceFunction.C
  INSCollocatedHierarchyIntegrator.C
  INSProjectionBcCoef.C
  INSCollocatedPPMConvectiveOperator.C
  INSStaggeredCenteredConvectiveOperator.C
  )
  
add_m4_sources(FORTRAN_SRCS3D -DSAMRAI_FORTDIR=${SAMRAI_FORTDIR} .f
  fortran/navier_stokes_staggered_helpers3d.f.m4
  fortran/navier_stokes_bdryop3d.f.m4
  fortran/navier_stokes_divsource3d.f.m4
  fortran/navier_stokes_staggered_derivatives3d.f.m4
  fortran/navier_stokes_stabledt3d.f.m4
  )
  
set(kit_SRCS3D 
  ${kit_SRCS}
  ${FORTRAN_SRCS3D}
  )
  
add_m4_sources(FORTRAN_SRCS2D -DSAMRAI_FORTDIR=${SAMRAI_FORTDIR} .f 
  fortran/navier_stokes_stabledt2d.f.m4
  fortran/navier_stokes_staggered_helpers2d.f.m4
  fortran/navier_stokes_staggered_derivatives2d.f.m4
  fortran/navier_stokes_bdryop2d.f.m4
  fortran/navier_stokes_divsource2d.f.m4
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
