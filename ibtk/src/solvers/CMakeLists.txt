set(KIT solvers)
set(UKIT SOLVERS)


set(kit_SRCS
  wrappers/PETScSAMRAIVectorReal.C
  wrappers/PETScSNESFunctionGOWrapper.C
  wrappers/PETScSNESJacobianJOWrapper.C
  wrappers/PETScPCLSWrapper.C
  wrappers/PETScMatLOWrapper.C
  impls/CCPoissonPointRelaxationFACOperator.C
  impls/BJacobiPreconditioner.C
  impls/PETScMultiVec.C
  impls/PoissonFACPreconditionerStrategy.C
  impls/KrylovLinearSolverManager.C
  impls/CCPoissonSolverManager.C
  impls/PETScKrylovLinearSolver.C
  impls/PETScNewtonKrylovSolver.C
  impls/PoissonSolver.C
  impls/PETScLevelSolver.C
  impls/SCPoissonPETScLevelSolver.C
  impls/SCPoissonSolverManager.C
  impls/CCLaplaceOperator.C
  impls/SCPoissonHypreLevelSolver.C
  impls/NewtonKrylovSolverManager.C
  impls/LaplaceOperator.C
  impls/PoissonFACPreconditioner.C
  impls/PETScMFFDJacobianOperator.C
  impls/CCPoissonHypreLevelSolver.C
  impls/CCPoissonPETScLevelSolver.C
  impls/FACPreconditioner.C
  impls/SCPoissonPointRelaxationFACOperator.C
  impls/SCLaplaceOperator.C
  impls/BGaussSeidelPreconditioner.C
  impls/PETScKrylovPoissonSolver.C
  impls/KrylovLinearSolverPoissonSolverInterface.C
  interfaces/GeneralSolver.C
  interfaces/LinearSolver.C
  interfaces/LinearOperator.C
  interfaces/KrylovLinearSolver.C
  interfaces/GeneralOperator.C
  interfaces/JacobianOperator.C
  interfaces/NewtonKrylovSolver.C
  interfaces/FACPreconditionerStrategy.C
)

ParseM4Sources(
  OutputFiles3D
  FileExt ".f"
  M4args -DSAMRAI_FORTDIR=${SAMRAI_FORTDIR} -DTOP_SRCDIR=${PROJECT_SOURCE_DIR}
  InputFiles impls/fortran/patchsmoothers3d.f.m4 )

set(kit_SRCS3D
  ${kit_SRCS}
  ${OutputFiles3D}
  )

ParseM4Sources(
  OutputFiles2D
  FileExt ".f"
  M4args -DSAMRAI_FORTDIR=${SAMRAI_FORTDIR} -DTOP_SRCDIR=${PROJECT_SOURCE_DIR}
  InputFiles impls/fortran/patchsmoothers2d.f.m4 )

set(kit_SRCS2D
  ${kit_SRCS}
  ${OutputFiles2D}
  )
#
# Include the common target module
#
include(${IBTK_MODULE_PATH}/KitCommonBlock.cmake)


include_directories(
  ${CMAKE_CURRENT_SOURCE_DIR}/wrappers/
  ${CMAKE_CURRENT_SOURCE_DIR}/impls
  ${CMAKE_CURRENT_SOURCE_DIR}/interfaces

  )
