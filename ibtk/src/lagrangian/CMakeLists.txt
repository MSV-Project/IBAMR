set(KIT lagrangian)
set(UKIT LAGRANGIAN)


set(kit_SRCS FEDataManager.cpp
  LSiloDataWriter.cpp
  LSetDataIterator.cpp
  LNode.cpp
  LSetDataFactory.cpp
  LMarker.cpp
  LNodeIndex.cpp
  LIndexSetDataFactory.cpp
  LTransaction.cpp
  LIndexSetVariable.cpp
  LSetData.cpp
  LSetVariable.cpp
  LM3DDataWriter.cpp
  LEInteractor.cpp
  LMesh.cpp
  LDataManager.cpp
  LData.cpp
  FEDataManager.cpp
  LInitStrategy.cpp
  LSet.cpp
  LIndexSetData.cpp
)



ParseM4Sources(
  OutputFilesCommon
  FileExt ".f"
  M4args -DSAMRAI_FORTDIR=${SAMRAI_FORTDIR} -DTOP_SRCDIR=${PROJECT_SOURCE_DIR}
  InputFiles fortran/lagrangian_delta.f.m4 )

ParseM4Sources(
  OutputFiles3D
  FileExt ".f"
  M4args -DSAMRAI_FORTDIR=${SAMRAI_FORTDIR} -DTOP_SRCDIR=${PROJECT_SOURCE_DIR}
  InputFiles fortran/lagrangian_interaction3d.f.m4 )

set(kit_SRCS3D
  ${kit_SRCS}
  ${OutputFiles3D}
  ${OutputFilesCommon}
  )

ParseM4Sources(
  OutputFiles2D
  FileExt ".f"
  M4args -DSAMRAI_FORTDIR=${SAMRAI_FORTDIR} -DTOP_SRCDIR=${PROJECT_SOURCE_DIR}
  InputFiles fortran/lagrangian_interaction2d.f.m4 )

set(kit_SRCS2D
  ${kit_SRCS}
  ${FORTRAN_SRCS2D}
  ${OutputFilesCommon}
  )

#
# Include the common target module
#
include(${IBTK_MODULE_PATH}/KitCommonBlock.cmake)

include_directories(
  ${CMAKE_CURRENT_SOURCE_DIR}
  )

