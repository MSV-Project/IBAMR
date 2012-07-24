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
  fortran/lagrangian_delta.f
)

if(IBTK_BUILD_2D_LIBS)
  set(kit_SRCS2D ${kit_SRCS}
    fortran/lagrangian_interaction2d.f
  )
endif()

set(kit_SRCS3D ${kit_SRCS}
  fortran/lagrangian_interaction3d.f
  )


include(${IBTK_MODULE_PATH}/KitCommonBlock.cmake)  

# target_link_libraries(ibtk${KIT}3D qd)

