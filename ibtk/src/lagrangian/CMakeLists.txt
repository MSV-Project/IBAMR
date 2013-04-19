set(KIT lagrangian)
set(UKIT LAGRANGIAN)


set(kit_SRCS LSiloDataWriter.C
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
#   FEDataManager.C
  LInitStrategy.C
  LSet.C
  LIndexSetData.C
)
add_m4_sources(FORTRAN_COMMON -DSAMRAI_FORTDIR=${SAMRAI_FORTDIR} .f
  fortran/lagrangian_delta.f.m4)

add_m4_sources(FORTRAN_SRCS3D -DSAMRAI_FORTDIR=${SAMRAI_FORTDIR} .f
  fortran/lagrangian_interaction3d.f.m4)

set(kit_SRCS3D
  ${kit_SRCS}
  ${FORTRAN_SRCS3D}
  ${FORTRAN_COMMON}
  )

add_m4_sources(FORTRAN_SRCS2D -DSAMRAI_FORTDIR=${SAMRAI_FORTDIR} .f
  fortran/lagrangian_interaction2d.f.m4)

set(kit_SRCS2D
  ${kit_SRCS}
  ${FORTRAN_SRCS2D}
  ${FORTRAN_COMMON}
  )

#
# Include the common target module
#
include(${IBTK_MODULE_PATH}/KitCommonBlock.cmake)

include_directories(
  ${CMAKE_CURRENT_SOURCE_DIR}
  )

