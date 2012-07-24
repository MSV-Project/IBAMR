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

  # Set PETSc specific environment variables
  set(ENV{PETSC_DIR} ${CMAKE_BINARY_DIR}/${proj})
  
  ExternalProject_Add(${proj}
    SOURCE_DIR ${CMAKE_BINARY_DIR}/${proj}
    BINARY_DIR ${CMAKE_BINARY_DIR}/${proj}
    PREFIX ${proj}${ep_suffix}
    URL http://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-3.3-p2.tar.gz
    UPDATE_COMMAND ""
    INSTALL_COMMAND ""
#     INSTALL_COMMAND "export PETSC_DIR=${CMAKE_BINARY_DIR}/${proj} && export PETSC_ARCH=build  && make install"
    CONFIGURE_COMMAND ./configure
      --prefix=${ep_install_dir}
      --CFLAGS=${ep_common_c_flags}
      --CXXFLAGS=${ep_common_cxx_flags}
      --FCFLAGS=${CMAKE_F_FLAGS}
      --FFLAGS=${CMAKE_F_FLAGS}
      --COPTFLAGS=${CMAKE_C_FLAGS_RELEASE}
      --CXXOPTFLAGS=${CMAKE_CXX_FLAGS_RELEASE}
      --FOPTFLAGS=${CMAKE_F_FLAGS_RELEASE}
      --LDFLAGS="-L${ep_install_dir}/lib -Wl,-rpath,${ep_install_dir}/lib"
      --PETSC_ARCH=build
      --with-default-arch=0 
      --with-debugging=0 
      --with-c++-support
      --with-hypre=1
      --with-hypre-dir=${ep_install_dir}
      --with-mpi=1
      --with-mpi-dir=${ep_install_dir}
      --with-x=0
#     TEST_BEFORE_INSTALL 1
    LOG_CONFIGURE 1
    LOG_BUILD 1
    LOG_INSTALL 1
#     TEST_COMMAND make PETSC_DIR=${CMAKE_BINARY_DIR}/${proj} PETSC_ARCH=build test
    BUILD_COMMAND make PETSC_DIR=${CMAKE_BINARY_DIR}/${proj} PETSC_ARCH=build all
    DEPENDS
      ${PETSC_DEPENDENCIES}
    )
    set(${proj}_DIR ${CMAKE_BINARY_DIR}/${proj})
    set(${proj}_ARCH build)

else()
  msvMacroEmptyExternalProject(${proj} "${proj_DEPENDENCIES}")
endif()

list(APPEND IBTK_SUPERBUILD_EP_ARGS -DPETSC_DIR:PATH=$ENV{PETSC_DIR})
list(APPEND IBTK_SUPERBUILD_EP_ARGS -DPETSC_ARCH:STRING="build")

