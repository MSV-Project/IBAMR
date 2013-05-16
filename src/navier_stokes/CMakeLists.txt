set(KIT navier_stokes)

set(kit_SRCS
  INSStaggeredHierarchyIntegrator.cpp
  INSIntermediateVelocityBcCoef.cpp
  StaggeredStokesPETScVecUtilities.cpp
  StaggeredStokesProjectionPreconditioner.cpp
  INSStaggeredVelocityBcCoef.cpp
  StaggeredStokesSolver.cpp
  INSStaggeredPressureBcCoef.cpp
  INSStaggeredStochasticForcing.cpp
  INSHierarchyIntegrator.cpp
  StaggeredStokesBlockPreconditioner.cpp
  StaggeredStokesBlockFactorizationPreconditioner.cpp
  StaggeredStokesPhysicalBoundaryHelper.cpp
  INSStaggeredUpwindConvectiveOperator.cpp
  INSStaggeredPPMConvectiveOperator.cpp
  StaggeredStokesPETScLevelSolver.cpp
  StaggeredStokesFACPreconditioner.cpp
  INSCollocatedConvectiveOperatorManager.cpp
  INSCollocatedCenteredConvectiveOperator.cpp
  StaggeredStokesBoxRelaxationFACOperator.cpp
  StaggeredStokesPETScMatUtilities.cpp
  StaggeredStokesSolverManager.cpp
  KrylovLinearSolverStaggeredStokesSolverInterface.cpp
  StaggeredStokesOpenBoundaryStabilizer.cpp
  StaggeredStokesFACPreconditionerStrategy.cpp
  StokesBcCoefStrategy.cpp
  PETScKrylovStaggeredStokesSolver.cpp
  SpongeLayerForceFunction.cpp
  INSCollocatedHierarchyIntegrator.cpp
  INSProjectionBcCoef.cpp
  StaggeredStokesOperator.cpp
  INSCollocatedPPMConvectiveOperator.cpp
  INSStaggeredCenteredConvectiveOperator.cpp
  INSStaggeredConvectiveOperatorManager.cpp
  StokesSpecifications.cpp
  INSStaggeredStabilizedPPMConvectiveOperator.cpp
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
