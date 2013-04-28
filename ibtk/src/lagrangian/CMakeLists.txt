set(KIT lagrangian)
set(UKIT LAGRANGIAN)


set(kit_SRCS FEDataManager.C
  LSiloDataWriter.C
  LSetDataIterator.C
  LNode.C
  LSetDataFactory.C
  LMarker.C
  LNodeIndex.C
  LIndexSetDataFactory.C
  LTransaction.C
  LIndexSetVariable.C
  LSetData.C
  LSetVariable.C
  LM3DDataWriter.C
  LEInteractor.C
  LMesh.C
  LDataManager.C
  LData.C
  FEDataManager.C
  LInitStrategy.C
  LSet.C
  LIndexSetData.C
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

