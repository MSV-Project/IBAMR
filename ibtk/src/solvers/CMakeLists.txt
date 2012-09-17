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

add_m4_sources(FORTRAN_SRCS3D -DSAMRAI_FORTDIR=${SAMRAI_FORTDIR} .f
  impls/fortran/patchsmoothers3d.f.m4)
  
set(kit_SRCS3D 
  ${kit_SRCS}
  ${FORTRAN_SRCS3D}
  )
  
add_m4_sources(FORTRAN_SRCS2D -DSAMRAI_FORTDIR=${SAMRAI_FORTDIR} .f
  impls/fortran/patchsmoothers2d.f.m4)
set(kit_SRCS2D 
  ${kit_SRCS}
  ${FORTRAN_SRCS2D}
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
