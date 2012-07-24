set(KIT solvers)
set(UKIT SOLVERS)


set(kit_SRCS 
  wrappers/PETScSAMRAIVectorReal.C
  wrappers/PETScSNESFunctionGOWrapper.C
  wrappers/PETScSNESJacobianJOWrapper.C
  wrappers/PETScPCLSWrapper.C
  wrappers/PETScMatLOWrapper.C
  impls/BJacobiPreconditioner.C
  impls/PETScMultiVec.C
  impls/SCPoissonFACOperator.C
  impls/DiagonalScalingPreconditioner.C
  impls/CCDivGradHypreLevelSolver.C
  impls/PETScKrylovLinearSolver.C
  impls/PETScNewtonKrylovSolver.C
  impls/SCPoissonPETScLevelSolver.C
  impls/CCLaplaceOperator.C
  impls/DiagonalScalingOperator.C
  impls/SCPoissonHypreLevelSolver.C
  impls/CCDivGradOperator.C
  impls/CCPoissonFACOperator.C
  impls/PETScMFFDJacobianOperator.C
  impls/CCPoissonHypreLevelSolver.C
  impls/CCPoissonPETScLevelSolver.C
  impls/FACPreconditioner.C
  impls/SCLaplaceOperator.C
  impls/BGaussSeidelPreconditioner.C
  interfaces/LinearSolver.C
  interfaces/LinearOperator.C
  interfaces/KrylovLinearSolver.C
  interfaces/GeneralOperator.C
  interfaces/JacobianOperator.C
  interfaces/NewtonKrylovSolver.C
  interfaces/FACPreconditionerStrategy.C

)

set(kit_SRCS2D ${kit_SRCS}
  impls/fortran/patchsmoothers2d.f
)

set(kit_SRCS3D ${kit_SRCS}
  impls/fortran/patchsmoothers3d.f
)

include(${IBTK_MODULE_PATH}/KitCommonBlock.cmake)
