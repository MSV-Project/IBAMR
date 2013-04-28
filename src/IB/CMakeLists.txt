set(KIT IB)
set(UKIT IB)

set(kit_SRCS
  IBStandardSourceGen.C
  IBKirchhoffRodForceGen.C
  IBSpringForceSpec.C
  SimplifiedIBFEMethod.C
  MaterialPointSpecFactory.C
  IBRodForceSpec.C
  IBStandardInitializer.C
  MaterialPointSpec.C
  IBLagrangianForceStrategySet.C
  IMPMethod.C
  IBImplicitStaggeredPETScLevelSolver.C
  IBHierarchyIntegrator.C
  IBRodForceSpecFactory.C
  GeneralizedIBMethod.C
  IBMethod.C
  IMPInitializer.C
  IBBeamForceSpecFactory.C
  IBInstrumentPanel.C
  IBImplicitStaggeredHierarchyIntegrator.C
  IBAnchorPointSpecFactory.C
  IBSourceSpec.C
  IBMethodPostProcessStrategy.C
  IBTargetPointForceSpec.C
  IBAnchorPointSpec.C
  IBEulerianForceFunction.C
  IBStrategySet.C
  IBSourceSpecFactory.C
  IBStandardForceGen.C
  IBLagrangianForceStrategy.C
  IBLagrangianSourceStrategy.C
  IBInstrumentationSpecFactory.C
  IBEulerianSourceFunction.C
  IBFEMethod.C
  IBBeamForceSpec.C
  IBExplicitHierarchyIntegrator.C
  PenaltyIBMethod.C
  IBInstrumentationSpec.C
  IBTargetPointForceSpecFactory.C
  IBStrategy.C
  IBSpringForceSpecFactory.C
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
