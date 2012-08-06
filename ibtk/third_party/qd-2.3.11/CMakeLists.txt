project(qd CXX Fortran)

include_directories(include ./)

set(qd_SRCS 
  fortran/ddext.f
  fortran/qdext.f
  fortran/ddmod.f
  fortran/qdmod.f
  fortran/f_dd.cpp
  fortran/f_qd.cpp
  src/bits.cpp
  src/c_dd.cpp
  src/c_qd.cpp
  src/dd_const.cpp
  src/dd_real.cpp
  src/fpu.cpp
  src/qd_const.cpp
  src/qd_real.cpp
  src/util.cpp
)

SET(CMAKE_Fortran_MODULE_DIRECTORY ${IBTK_BINARY_DIR}/bin)
set(CMAKE_Fortran_FLAGS ${CMAKE_Fortran_FLAGS} -ffree-form)
add_library(qd ${qd_SRCS})