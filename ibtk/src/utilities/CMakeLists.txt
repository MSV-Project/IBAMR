set(KIT utilities)
set(UKIT UTILITIES)


set(kit_SRCS
  StreamableFactory.cpp
  SideSynchCopyFillPattern.cpp
  muParserCartGridFunction.cpp
  EdgeSynchCopyFillPattern.cpp
  ParallelEdgeMap.cpp
  RefinePatchStrategySet.cpp
  StandardTagAndInitStrategySet.cpp
  FaceDataSynchronization.cpp
  LMarkerUtilities.cpp
  CopyToRootTransaction.cpp
  Streamable.cpp
  FaceSynchCopyFillPattern.cpp
  NodeDataSynchronization.cpp
  CartGridFunctionSet.cpp
  NormOps.cpp
  AppInitializer.cpp
  ParallelSet.cpp
  FixedSizedStream.cpp
  IndexUtilities.cpp
  ParallelMap.cpp
  EdgeDataSynchronization.cpp
  SideDataSynchronization.cpp
  CoarsenPatchStrategySet.cpp
  Interpolator.cpp
  DebuggingUtilities.cpp
  CopyToRootSchedule.cpp
  SideNoCornersFillPattern.cpp
  StreamableManager.cpp
  NodeSynchCopyFillPattern.cpp
  CellNoCornersFillPattern.cpp
  CartGridFunction.cpp
  HierarchyIntegrator.cpp
)

set(kit_SRCS2D ${kit_SRCS})

set(kit_SRCS3D ${kit_SRCS})

#
# Include the common target module
#
include(${IBTK_MODULE_PATH}/KitCommonBlock.cmake)


include_directories(
  ${CMAKE_CURRENT_SOURCE_DIR}/wrappers/
  ${CMAKE_CURRENT_SOURCE_DIR}/impls
  ${CMAKE_CURRENT_SOURCE_DIR}/interfaces

  )

