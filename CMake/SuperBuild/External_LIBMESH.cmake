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
# LIBMESH
#

# Make sure this file is included only once
get_filename_component(CMAKE_CURRENT_LIST_FILENAME ${CMAKE_CURRENT_LIST_FILE} NAME_WE)
if(${CMAKE_CURRENT_LIST_FILENAME}_FILE_INCLUDED)
  return()
endif()
set(${CMAKE_CURRENT_LIST_FILENAME}_FILE_INCLUDED 1)

# Sanity checks
if(DEFINED LIBMESH_DIR AND NOT EXISTS ${LIBMESH_DIR})
  message(FATAL_ERROR "LIBMESH_DIR variable is defined but corresponds to non-existing directory")
endif()

#set(LIBMESH_enabling_variable LIBMESH_LIBRARIES)

set(additional_vtk_cmakevars )
if(MINGW)
  list(APPEND additional_vtk_cmakevars -DCMAKE_USE_PTHREADS:BOOL=OFF)
endif()

set(LIBMESH_DEPENDENCIES "OPENMPI")
# Include dependent projects if any
CheckExternalProjectDependency(LIBMESH)
set(proj LIBMESH)

if(NOT DEFINED LIBMESH_DIR)

  # Set CMake OSX variable to pass down the external project
  set(build x86_64-opt-linux)
  set(CMAKE_OSX_EXTERNAL_PROJECT_ARGS)
  if(APPLE)
    set(build x86_64-opt-osx)
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
    SOURCE_DIR ${IBAMR_BINARY_DIR}/SuperBuild/${proj}
    BINARY_DIR ${IBAMR_BINARY_DIR}/SuperBuild/${proj}/libmesh
    PREFIX CMake/${proj}${ep_suffix}
    GIT_REPOSITORY ${LIBMESH_URL}
    GIT_TAG ${LIBMESH_TAG}
    UPDATE_COMMAND ""
    INSTALL_COMMAND ""
    BUILD_COMMAND make AR=/usr/bin/ar
    CONFIGURE_COMMAND ${IBAMR_BINARY_DIR}/SuperBuild/${proj}/libmesh/configure
      "CFLAGS=${ep_common_c_flags}"
      "CXXFLAGS=${ep_common_cxx_flags}"
      "FCFLAGS=${CMAKE_Fortran_FLAGS}"
      "FFLAGS=${CMAKE_Fortran_FLAGS}"
      "LDFLAGS=-L${ep_install_dir}/lib -Wl,-rpath,${ep_install_dir}/lib"
      --build=${build}
      --prefix=${ep_install_dir}
      --libdir=${ep_install_dir}/lib
      --with-cxx=${ep_install_dir}/bin/mpicxx
      --with-cc=${ep_install_dir}/bin/mpicc
      --with-fc=${ep_install_dir}/bin/mpif90
      --with-f77=${ep_install_dir}/bin/mpif90
      ${SHARED_LIB_CONF}
      --enable-mpi
#       --enable-petsc
      --enable-tetgen
      --enable-triangle
      --enable-vtk
      --with-mpi=${ep_install_dir}
      --with-vtk-include=${ep_install_dir}/include/vtk-5.9
      --with-vtk-lib=${ep_install_dir}/lib/vtk-5.9
#     LOG_CONFIGURE 1
#     LOG_BUILD 1
#     LOG_INSTALL 1
    DEPENDS
      ${LIBMESH_DEPENDENCIES}
    )
  set(${proj}_DIR ${IBAMR_BINARY_DIR}/SuperBuild/${proj}/libmesh)

else()
  msvMacroEmptyExternalProject(${proj} "${proj_DEPENDENCIES}")
endif()

list(APPEND IBAMR_SUPERBUILD_EP_ARGS -DLIBMESH_DIR:PATH=${LIBMESH_DIR})
list(APPEND IBAMR_SUPERBUILD_EP_ARGS -DLIBMESH_INCLUDE_PATH:PATH=${LIBMESH_DIR}/include)

list(APPEND INCLUDE_PATHS $ENV{PETSC_DIR}/build/include ${ep_install_dir}/include)
list(APPEND LIBRARY_PATHS ${ep_install_dir}/lib)
