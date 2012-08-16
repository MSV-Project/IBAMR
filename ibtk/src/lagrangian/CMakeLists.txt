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

# set(qd_Fortran_SRCS 
#   ${QD_DIR}/fortran/ddext.f
#   ${QD_DIR}/fortran/qdext.f
#   ${QD_DIR}/fortran/ddmod.f
#   ${QD_DIR}/fortran/qdmod.f
#   )
# set(qd_SRCS  
#   ${QD_DIR}/fortran/f_dd.cpp
#   ${QD_DIR}/fortran/f_qd.cpp
#   ${QD_DIR}/src/bits.cpp
#   ${QD_DIR}/src/c_dd.cpp
#   ${QD_DIR}/src/c_qd.cpp
#   ${QD_DIR}/src/dd_const.cpp
#   ${QD_DIR}/src/dd_real.cpp
#   ${QD_DIR}/src/fpu.cpp
#   ${QD_DIR}/src/qd_const.cpp
#   ${QD_DIR}/src/qd_real.cpp
#   ${QD_DIR}/src/util.cpp
# )

# include_directories(${QD_DIR}/include ${QD_DIR})

# add_library(qd_fortran ${qd_Fortran_SRCS})
# set_target_properties(qd_fortran PROPERTIES COMPILE_FLAGS "-ffree-form")

# add_library(qd ${qd_SRCS})

add_m4_sources(FORTRAN_SRCS3D -DSAMRAI_FORTDIR=${SAMRAI_FORTDIR}  
  fortran/lagrangian_interaction3d.f.m4)
  
set(kit_SRCS3D 
  ${kit_SRCS}
  ${FORTRAN_SRCS3D}
  )

if(IBTK_BUILD_2D_LIBS)
  add_m4_sources(FORTRAN_SRCS2D -DSAMRAI_FORTDIR=${SAMRAI_FORTDIR}
    fortran/lagrangian_interaction2d.f.m4)
  set(kit_SRCS2D 
    ${kit_SRCS}
    ${FORTRAN_SRCS2D}
    )  
endif()

#
# Include the common target module
#
include(${IBTK_MODULE_PATH}/KitCommonBlock.cmake)  
# target_link_libraries(ibtk${KIT}3D -L${QD_DIR}/lib ${QD_LIBS})

include_directories(
  ${CMAKE_CURRENT_SOURCE_DIR}
  
  )

