###########################################################################
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
  set(SOURCE_DIR ${IBAMR_BINARY_DIR}/SuperBuild/${proj})
  set(BINARY_DIR ${IBAMR_BINARY_DIR}/SuperBuild/${proj}-build)
  # Set CMake OSX variable to pass down the external project
  set(CMAKE_OSX_EXTERNAL_PROJECT_ARGS)
  if(APPLE)
    list(APPEND CMAKE_OSX_EXTERNAL_PROJECT_ARGS
      -DCMAKE_OSX_ARCHITECTURES=${CMAKE_OSX_ARCHITECTURES}
      -DCMAKE_OSX_SYSROOT=${CMAKE_OSX_SYSROOT}
      -DCMAKE_OSX_DEPLOYMENT_TARGET=${CMAKE_OSX_DEPLOYMENT_TARGET})
  endif()

#     message(STATUS "Adding project:${proj}")
  # Clean if necessary
#   if(EXISTS ${BINARY_DIR})
#     execute_process(COMMAND make clean WORKING_DIRECTORY ${BINARY_DIR})
#   endif()
  set(SHARED_LIB_CONF)
  if(BUILD_SHARED_LIBS)
    set(SHARED_LIB_CONF --enable-shared --disable-static)

    if(NOT ${proj}_SHARED_BUILD AND EXISTS ${IBAMR_BINARY_DIR}/SuperBuild/${proj}-build)
      file(REMOVE_RECURSE ${IBAMR_BINARY_DIR}/SuperBuild/${proj}-build)
    endif()

    set(${proj}_SHARED_BUILD TRUE CACHE INTERNAL "" FORCE)
  else()
    set(SHARED_LIB_CONF --enable-static --disable-shared)

    if(${proj}_SHARED_BUILD AND EXISTS ${IBAMR_BINARY_DIR}/SuperBuild/${proj}-build)
      file(REMOVE_RECURSE ${IBAMR_BINARY_DIR}/SuperBuild/${proj}-build)
    endif()

    set(${proj}_SHARED_BUILD FALSE CACHE INTERNAL "" FORCE)
  endif()
  ExternalProject_Add(${proj}
    SOURCE_DIR ${IBAMR_BINARY_DIR}/SuperBuild/${proj}
    BINARY_DIR ${IBAMR_BINARY_DIR}/SuperBuild/${proj}-build
    PREFIX CMake/${proj}${ep_suffix}
    URL ${OPENMPI_URL}/${OPENMPI_GZ}
    URL_MD5 ${OPENMPI_MD5}
    UPDATE_COMMAND ""
    INSTALL_COMMAND make install
    CONFIGURE_COMMAND ${IBAMR_BINARY_DIR}/SuperBuild/${proj}/configure
      CC=${CMAKE_C_COMPILER}
      CXX=${CMAKE_CXX_COMPILER}
      F77=${CMAKE_Fortran_COMPILER}
      FC=${CMAKE_Fortran_COMPILER}
      "CFLAGS=${ep_common_c_flags} ${ep_build_type_c_flags}"
      "CXXFLAGS=${ep_common_cxx_flags} ${ep_build_type_cxx_flags}"
      "FCFLAGS=${CMAKE_Fortran_FLAGS} ${ep_build_type_fortran_flags}"
      "FFLAGS=${CMAKE_Fortran_FLAGS} ${ep_build_type_fortran_flags}"
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
  set(${proj}_DIR ${ep_install_dir})

else()
  msvMacroEmptyExternalProject(${proj} "${proj_DEPENDENCIES}")
endif()

set(MPI_CXX_COMPILER ${ep_install_dir}/bin/mpicxx CACHE INTERNAL "" FORCE)
set(MPI_C_COMPILER ${ep_install_dir}/bin/mpicc CACHE INTERNAL "" FORCE)
set(MPI_Fortran_COMPILER ${ep_install_dir}/bin/mpif90 CACHE INTERNAL "" FORCE)
set(MPIEXEC ${ep_install_dir}/bin/mpiexec CACHE INTERNAL "" FORCE)

list(APPEND IBAMR_SUPERBUILD_EP_ARGS -DMPI_CXX_COMPILER:PATH=${MPI_CXX_COMPILER})
list(APPEND IBAMR_SUPERBUILD_EP_ARGS -DMPI_C_COMPILER:PATH=${MPI_C_COMPILER})
list(APPEND IBAMR_SUPERBUILD_EP_ARGS -DMPI_Fortran_COMPILER:PATH=${MPI_Fortran_COMPILER})
list(APPEND IBAMR_SUPERBUILD_EP_ARGS -DMPIEXEC:PATH=${MPIEXEC})
list(APPEND EXTERNAL_LIBRARIES -lmpi_cxx -lmpi_f90 -lmpi_f77 -lmpi -lopen-rte -lopen-pal)
list(APPEND LIBRARY_PATHS ${ep_install_dir}/lib)
