set(KIT solvers)
set(UKIT SOLVERS)


set(kit_SRCS
  wrappers/PETScSAMRAIVectorReal.cpp
  wrappers/PETScSNESFunctionGOWrapper.cpp
  wrappers/PETScSNESJacobianJOWrapper.cpp
  wrappers/PETScPCLSWrapper.cpp
  wrappers/PETScMatLOWrapper.cpp
  impls/CCPoissonPointRelaxationFACOperator.cpp
  impls/BJacobiPreconditioner.cpp
  impls/PETScMultiVec.cpp
  impls/PoissonFACPreconditionerStrategy.cpp
  impls/KrylovLinearSolverManager.cpp
  impls/CCPoissonSolverManager.cpp
  impls/PETScKrylovLinearSolver.cpp
  impls/PETScNewtonKrylovSolver.cpp
  impls/PoissonSolver.cpp
  impls/PETScLevelSolver.cpp
  impls/SCPoissonPETScLevelSolver.cpp
  impls/SCPoissonSolverManager.cpp
  impls/CCLaplaceOperator.cpp
  impls/SCPoissonHypreLevelSolver.cpp
  impls/NewtonKrylovSolverManager.cpp
  impls/LaplaceOperator.cpp
  impls/PoissonFACPreconditioner.cpp
  impls/PETScMFFDJacobianOperator.cpp
  impls/CCPoissonHypreLevelSolver.cpp
  impls/CCPoissonPETScLevelSolver.cpp
  impls/FACPreconditioner.cpp
  impls/SCPoissonPointRelaxationFACOperator.cpp
  impls/SCLaplaceOperator.cpp
  impls/BGaussSeidelPreconditioner.cpp
  impls/PETScKrylovPoissonSolver.cpp
  impls/KrylovLinearSolverPoissonSolverInterface.cpp
  interfaces/GeneralSolver.cpp
  interfaces/LinearSolver.cpp
  interfaces/LinearOperator.cpp
  interfaces/KrylovLinearSolver.cpp
  interfaces/GeneralOperator.cpp
  interfaces/JacobianOperator.cpp
  interfaces/NewtonKrylovSolver.cpp
  interfaces/FACPreconditionerStrategy.cpp
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
