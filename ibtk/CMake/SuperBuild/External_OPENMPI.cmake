###########################################################################
#
#  Library: IBTK
#
#  Copyright (c) Kitware Inc.
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0.txt
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#
###########################################################################

#
# OpenMPI
#

# Make sure this file is included only once
get_filename_component(CMAKE_CURRENT_LIST_FILENAME ${CMAKE_CURRENT_LIST_FILE} NAME_WE)
if(${CMAKE_CURRENT_LIST_FILENAME}_FILE_INCLUDED)
  return()
endif()
set(${CMAKE_CURRENT_LIST_FILENAME}_FILE_INCLUDED 1)

# Sanity checks
if(DEFINED OPENMPI_DIR AND NOT EXISTS ${OPENMPI_DIR})
  message(FATAL_ERROR "OPENMPI_DIR variable is defined but corresponds to non-existing directory")
endif()

#set(OPENMPI_enabling_variable OPENMPI_LIBRARIES)

set(OPENMPI_DEPENDENCIES "")

# Include dependent projects if any
CheckExternalProjectDependency(OPENMPI)
set(proj OPENMPI)

if(NOT DEFINED OPENMPI_DIR)

  # Set CMake OSX variable to pass down the external project
  set(CMAKE_OSX_EXTERNAL_PROJECT_ARGS)
  if(APPLE)
    list(APPEND CMAKE_OSX_EXTERNAL_PROJECT_ARGS
      -DCMAKE_OSX_ARCHITECTURES=${CMAKE_OSX_ARCHITECTURES}
      -DCMAKE_OSX_SYSROOT=${CMAKE_OSX_SYSROOT}
      -DCMAKE_OSX_DEPLOYMENT_TARGET=${CMAKE_OSX_DEPLOYMENT_TARGET})
  endif()

#     message(STATUS "Adding project:${proj}")
  set(SHARED_LIB_CONF)
  if(BUILD_SHARED_LIBS)
    set(SHARED_LIB_CONF --enable-shared --disable-static)
  else()
    set(SHARED_LIB_CONF --enable-static --disable-shared)
  endif() 
  ExternalProject_Add(${proj}
    SOURCE_DIR ${IBTK_BINARY_DIR}/SuperBuild/${proj}
    BINARY_DIR ${IBTK_BINARY_DIR}/SuperBuild/${proj}-build
    PREFIX ${proj}${ep_suffix}
    URL ${OPENMPI_URL}/${OPENMPI_GZ}
    URL_MD5 ${OPENMPI_MD5}
    UPDATE_COMMAND ""
    INSTALL_COMMAND make install
    CONFIGURE_COMMAND ${IBTK_BINARY_DIR}/SuperBuild/${proj}/configure
      CC=${CMAKE_C_COMPILER}
      CXX=${CMAKE_CXX_COMPILER}
      F77=${CMAKE_Fortran_COMPILER}
      FC=${CMAKE_Fortran_COMPILER}
      "CFLAGS=${ep_common_c_flags}"
      "CXXFLAGS=${ep_common_cxx_flags}"
      "FCFLAGS=${CMAKE_Fortran_FLAGS}"
      "FFLAGS=${CMAKE_Fortran_FLAGS}"
      --libdir=${ep_install_dir}/lib
      --prefix=${ep_install_dir}
      --disable-dependency-tracking
      --enable-silent-rules
      --enable-orterun-prefix-by-default
      ${SHARED_LIB_CONF}
#     TEST_BEFORE_INSTALL 1
    LOG_DOWNLOAD 1
    LOG_CONFIGURE 1
    LOG_TEST 1
    LOG_BUILD 1
    LOG_INSTALL 1
#     TEST_COMMAND make check
    DEPENDS
      ${OPENMPI_DEPENDENCIES}
    )
  set(${proj}_DIR ${IBTK_BINARY_DIR}/SuperBuild/${proj}-build)

else()
  msvMacroEmptyExternalProject(${proj} "${proj_DEPENDENCIES}")
endif()

list(APPEND IBTK_SUPERBUILD_EP_ARGS -DMPI_CXX_COMPILER:PATH=${ep_install_dir}/bin/mpicxx)
list(APPEND IBTK_SUPERBUILD_EP_ARGS -DMPI_C_COMPILER:PATH=${ep_install_dir}/bin/mpicc)
list(APPEND IBTK_SUPERBUILD_EP_ARGS -DMPI_Fortran_COMPILER:PATH=${ep_install_dir}/bin/mpif90)
list(APPEND EXTERNAL_LIBRARIES -lmpi_cxx -lmpi_f90 -lmpi)
