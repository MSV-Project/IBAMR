set(KIT utilities)
set(UKIT UTILITIES)


set(kit_SRCS StreamableFactory.C
  SideSynchCopyFillPattern.C
  muParserCartGridFunction.C
  EdgeSynchCopyFillPattern.C
  ParallelEdgeMap.C
  RefinePatchStrategySet.C
  StandardTagAndInitStrategySet.C
  FaceDataSynchronization.C
  LMarkerUtilities.C
  CopyToRootTransaction.C
  Streamable.C
  FaceSynchCopyFillPattern.C
  NodeDataSynchronization.C
  NormOps.C
  AppInitializer.C
  ParallelSet.C
  FixedSizedStream.C
  IndexUtilities.C
  ParallelMap.C
  EdgeDataSynchronization.C
  SideDataSynchronization.C
  CoarsenPatchStrategySet.C
  Interpolator.C
  DebuggingUtilities.C
  CopyToRootSchedule.C
  SideNoCornersFillPattern.C
  StreamableManager.C
  NodeSynchCopyFillPattern.C
  CellNoCornersFillPattern.C
  CartGridFunction.C
  HierarchyIntegrator.C

)


if(IBTK_BUILD_2D_LIBS)
  set(kit_SRCS2D ${kit_SRCS})
endif()

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

