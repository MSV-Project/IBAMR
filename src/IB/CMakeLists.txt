set(KIT IB)
set(UKIT IB)

set(kit_SRCS 
  IBStandardInitializer.C
  IBLagrangianForceStrategySet.C
  IBSourceSpec.C
  IBAnchorPointSpec.C
  IBLagrangianSourceStrategy.C
  IBHDF5Initializer.C
  IBBeamForceSpecFactory.C
  IBRodForceSpecFactory.C
  IBTargetPointForceSpec.C
  IBStandardForceGen.C
  IBSourceSpecFactory.C
  IBInstrumentationSpec.C
  IBInstrumentPanel.C
  IBStrategy.C
  IBHierarchyIntegrator.C
  IBMethod.C
  IBMethodPostProcessStrategy.C
#   IBFEMethod.C

  IBRodForceSpec.C
  IBLagrangianForceStrategy.C
  IBTargetPointForceSpecFactory.C
  IBSpringForceSpec.C
  IBStrategySet.C
  PenaltyIBMethod.C
  GeneralizedIBMethod.C
  IBStandardSourceGen.C
  IBBeamForceSpec.C
  IBEulerianSourceFunction.C
  IBInstrumentationSpecFactory.C
  IBSpringForceSpecFactory.C
  IBKirchhoffRodForceGen.C
  IBEulerianForceFunction.C
  IBAnchorPointSpecFactory.C
  )

set(kit_SRCS2D 
  ${kit_SRCS}
  )

set(kit_SRCS3D 
  ${kit_SRCS} 
  )

include(KitCommonBlock)
 