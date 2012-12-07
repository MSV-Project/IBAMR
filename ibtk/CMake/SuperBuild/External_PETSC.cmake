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
# PETSc
#

# Make sure this file is included only once
get_filename_component(CMAKE_CURRENT_LIST_FILENAME ${CMAKE_CURRENT_LIST_FILE} NAME_WE)
if(${CMAKE_CURRENT_LIST_FILENAME}_FILE_INCLUDED)
  return()
endif()
set(${CMAKE_CURRENT_LIST_FILENAME}_FILE_INCLUDED 1)

# Sanity checks
if(DEFINED PETSC_DIR AND NOT EXISTS ${PETSC_DIR})
  message(FATAL_ERROR "PETSC_DIR variable is defined but corresponds to non-existing directory")
endif()

#set(PETSC_enabling_variable PETSC_LIBRARIES)

set(PETSC_DEPENDENCIES "HYPRE;OPENMPI")

# Include dependent projects if any
CheckExternalProjectDependency(PETSC)
set(proj PETSC)

if(NOT DEFINED PETSC_DIR)

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
    set(SHARED_LIB_CONF --with-shared-libraries=1)
  else()
    set(SHARED_LIB_CONF --with-shared-libraries=0)
  endif() 
  # Set PETSc specific environment variables
  set(ENV{PETSC_DIR} ${IBTK_BINARY_DIR}/SuperBuild/${proj})
  
  ExternalProject_Add(${proj}
    SOURCE_DIR ${IBTK_BINARY_DIR}/SuperBuild/${proj}
    BINARY_DIR ${IBTK_BINARY_DIR}/SuperBuild/${proj}
    PREFIX ${proj}${ep_suffix}
    URL ${PETSC_URL}/${PETSC_GZ}
    URL_MD5 ${PETSC_MD5}
    UPDATE_COMMAND ""
    INSTALL_COMMAND ""
    CONFIGURE_COMMAND ./configure
      "--CFLAGS=${ep_common_c_flags}"
      "--CXXFLAGS=${ep_common_cxx_flags}"
      "--FCFLAGS=${CMAKE_Fortran_FLAGS}"
      "--FFLAGS=${CMAKE_Fortran_FLAGS}"
      "--COPTFLAGS=${CMAKE_C_FLAGS_RELEASE}"
      "--CXXOPTFLAGS=${CMAKE_CXX_FLAGS_RELEASE}"
      "--FOPTFLAGS=${CMAKE_F_FLAGS_RELEASE}"
      "--LDFLAGS=-Wl,-rpath -Wl,${ep_install_dir}/lib"
      "--LIBS=-Wl,-rpath -Wl,${ep_install_dir}/lib"
      --PETSC_ARCH=build
      --with-default-arch=0 
      --with-debugging=0 
      --with-c++-support
      --with-hypre=1
      --with-hypre-dir=${ep_install_dir}
      --with-mpi=1
      --with-mpi-dir=${ep_install_dir}
      --with-x=0
      ${SHARED_LIB_CONF}
    LOG_DOWNLOAD 1
    LOG_CONFIGURE 1
    LOG_TEST 1
    LOG_BUILD 1
    LOG_INSTALL 1
    BUILD_COMMAND make PETSC_DIR=${IBTK_BINARY_DIR}/SuperBuild/${proj} PETSC_ARCH=build all
    DEPENDS
      ${PETSC_DEPENDENCIES}
    )
    set(${proj}_DIR ${IBTK_BINARY_DIR}/SuperBuild/${proj})
    set(${proj}_ARCH build)

else()
  msvMacroEmptyExternalProject(${proj} "${proj_DEPENDENCIES}")
endif()

list(APPEND IBTK_SUPERBUILD_EP_ARGS -DPETSC_DIR:PATH=$ENV{PETSC_DIR})
list(APPEND IBTK_SUPERBUILD_EP_ARGS -DPETSC_ARCH:STRING=build)
list(APPEND IBTK_SUPERBUILD_EP_ARGS -DPETSC_INCLUDE_PATH:PATH=$ENV{PETSC_DIR}/include)

list(APPEND INCLUDE_PATHS $ENV{PETSC_DIR}/build/include $ENV{PETSC_DIR}/include)
list(APPEND LIBRARY_PATHS $ENV{PETSC_DIR}/build/lib)
list(INSERT EXTERNAL_LIBRARIES 0 -lpetsc)
