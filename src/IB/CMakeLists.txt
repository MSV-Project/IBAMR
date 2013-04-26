set(KIT IB)
set(UKIT IB)

set(kit_SRCS
  IBAnchorPointSpec.C
  IBAnchorPointSpecFactory.C
  IBBeamForceSpecFactory.C
  IBBeamForceGen.C
  IBBeamForceSpec.C
  IBDataPostProcessor.C
  IBEulerianForceFunction.C
  IBEulerianSourceFunction.C
  IBFEHierarchyIntegrator.C
  IBHDF5Initializer.C
  IBHierarchyIntegrator.C
  IBImplicitHierarchyIntegrator.C
  IBImplicitJacobian.C
  IBImplicitModHelmholtzOperator.C
  IBImplicitModHelmholtzPETScLevelSolver.C
  IBImplicitOperator.C
  IBImplicitSFROperator.C
  IBImplicitSJROperator.C
  IBInstrumentPanel.C
  IBInstrumentationSpec.C
  IBInstrumentationSpecFactory.C
  IBKirchhoffRodForceGen.C
  IBLagrangianForceStrategy.C
  IBLagrangianForceStrategySet.C
  IBLagrangianSourceStrategy.C
  IBMovingTargetPointForceGen.C
  IBMovingTargetPointForceSpec.C
  IBMovingTargetPointForceSpecFactory.C
  IBRodForceSpec.C
  IBRodForceSpecFactory.C
  IBSourceSpec.C
  IBSourceSpecFactory.C
  IBSpringForceGen.C
  IBSpringForceSpec.C
  IBSpringForceSpecFactory.C
  IBStaggeredHierarchyIntegrator.C
  IBStandardForceGen.C
  IBStandardInitializer.C
  IBStandardSourceGen.C
  IBTargetPointForceSpec.C
  IBTargetPointForceGen.C
  IBMethodPostProcessStrategy.C
  IBTargetPointForceSpecFactory.C
  )

set(kit_SRCS2D
  ${kit_SRCS}
  )

set(kit_SRCS3D
  ${kit_SRCS}
  )

#
# Include the common target module
#
include(KitCommonBlock)


include_directories(
  ${CMAKE_CURRENT_SOURCE_DIR}

  )
