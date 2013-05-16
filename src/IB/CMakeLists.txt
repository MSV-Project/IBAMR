set(KIT IB)
set(UKIT IB)

set(kit_SRCS
  IBStandardSourceGen.cpp
  IBKirchhoffRodForceGen.cpp
  IBSpringForceSpec.cpp
  SimplifiedIBFEMethod.cpp
  MaterialPointSpecFactory.cpp
  IBRodForceSpec.cpp
  IBStandardInitializer.cpp
  MaterialPointSpec.cpp
  IBLagrangianForceStrategySet.cpp
  IMPMethod.cpp
  IBImplicitStaggeredPETScLevelSolver.cpp
  IBHierarchyIntegrator.cpp
  IBRodForceSpecFactory.cpp
  GeneralizedIBMethod.cpp
  IBMethod.cpp
  IMPInitializer.cpp
  IBBeamForceSpecFactory.cpp
  IBInstrumentPanel.cpp
  IBImplicitStaggeredHierarchyIntegrator.cpp
  IBAnchorPointSpecFactory.cpp
  IBSourceSpec.cpp
  IBMethodPostProcessStrategy.cpp
  IBTargetPointForceSpec.cpp
  IBAnchorPointSpec.cpp
  IBEulerianForceFunction.cpp
  IBStrategySet.cpp
  IBSourceSpecFactory.cpp
  IBStandardForceGen.cpp
  IBLagrangianForceStrategy.cpp
  IBLagrangianSourceStrategy.cpp
  IBInstrumentationSpecFactory.cpp
  IBEulerianSourceFunction.cpp
  IBFEMethod.cpp
  IBBeamForceSpec.cpp
  IBExplicitHierarchyIntegrator.cpp
  PenaltyIBMethod.cpp
  IBInstrumentationSpec.cpp
  IBTargetPointForceSpecFactory.cpp
  IBStrategy.cpp
  IBSpringForceSpecFactory.cpp
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
