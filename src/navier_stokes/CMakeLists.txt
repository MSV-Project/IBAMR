set(KIT navier_stokes)

set(kit_SRCS
  INSStaggeredHierarchyIntegrator.C
  INSIntermediateVelocityBcCoef.C
  StaggeredStokesPETScVecUtilities.C
  StaggeredStokesProjectionPreconditioner.C
  INSStaggeredVelocityBcCoef.C
  StaggeredStokesSolver.C
  INSStaggeredPressureBcCoef.C
  INSStaggeredStochasticForcing.C
  INSHierarchyIntegrator.C
  StaggeredStokesBlockPreconditioner.C
  StaggeredStokesBlockFactorizationPreconditioner.C
  StaggeredStokesPhysicalBoundaryHelper.C
  INSStaggeredUpwindConvectiveOperator.C
  INSStaggeredPPMConvectiveOperator.C
  StaggeredStokesPETScLevelSolver.C
  StaggeredStokesFACPreconditioner.C
  INSCollocatedConvectiveOperatorManager.C
  INSCollocatedCenteredConvectiveOperator.C
  StaggeredStokesBoxRelaxationFACOperator.C
  StaggeredStokesPETScMatUtilities.C
  StaggeredStokesSolverManager.C
  KrylovLinearSolverStaggeredStokesSolverInterface.C
  StaggeredStokesOpenBoundaryStabilizer.C
  StaggeredStokesFACPreconditionerStrategy.C
  StokesBcCoefStrategy.C
  PETScKrylovStaggeredStokesSolver.C
  SpongeLayerForceFunction.C
  INSCollocatedHierarchyIntegrator.C
  INSProjectionBcCoef.C
  StaggeredStokesOperator.C
  INSCollocatedPPMConvectiveOperator.C
  INSStaggeredCenteredConvectiveOperator.C
  INSStaggeredConvectiveOperatorManager.C
  StokesSpecifications.C
  INSStaggeredStabilizedPPMConvectiveOperator.C
  )

set(FortranSRCS
  fortran/navier_stokes_staggered_helpers3d.f.m4
  fortran/navier_stokes_bdryop3d.f.m4
  fortran/navier_stokes_divsource3d.f.m4
  fortran/navier_stokes_stochastic_forcing3d.f.m4
  fortran/navier_stokes_staggered_derivatives3d.f.m4
  fortran/navier_stokes_stabledt3d.f.m4 )

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
  fortran/navier_stokes_stabledt2d.f.m4
  fortran/navier_stokes_staggered_helpers2d.f.m4
  fortran/navier_stokes_staggered_derivatives2d.f.m4
  fortran/navier_stokes_bdryop2d.f.m4
  fortran/navier_stokes_stochastic_forcing2d.f.m4
  fortran/navier_stokes_divsource2d.f.m4 )

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
