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
# LAPACK
#

# Make sure this file is included only once
get_filename_component(CMAKE_CURRENT_LIST_FILENAME ${CMAKE_CURRENT_LIST_FILE} NAME_WE)
if(${CMAKE_CURRENT_LIST_FILENAME}_FILE_INCLUDED)
  return()
endif()
set(${CMAKE_CURRENT_LIST_FILENAME}_FILE_INCLUDED 1)

# Sanity checks
if(DEFINED LAPACK_DIR AND NOT EXISTS ${LAPACK_DIR})
  message(FATAL_ERROR "LAPACK_DIR variable is defined but corresponds to non-existing directory")
endif()

# Set dependency list
set(LAPACK_DEPENDENCIES "")

# Include dependent projects if any
CheckExternalProjectDependency(LAPACK)
set(proj LAPACK)

if(NOT DEFINED LAPACK_DIR)
  #message(STATUS "${__indent}Adding project ${proj}")

  # Set CMake OSX variable to pass down the external project
  set(CMAKE_OSX_EXTERNAL_PROJECT_ARGS)
  if(APPLE)
    list(APPEND CMAKE_OSX_EXTERNAL_PROJECT_ARGS
      -DCMAKE_OSX_ARCHITECTURES=${CMAKE_OSX_ARCHITECTURES}
      -DCMAKE_OSX_SYSROOT=${CMAKE_OSX_SYSROOT}
      -DCMAKE_OSX_DEPLOYMENT_TARGET=${CMAKE_OSX_DEPLOYMENT_TARGET})
  endif()

  ExternalProject_Add(${proj}
    SOURCE_DIR ${CMAKE_BINARY_DIR}/${proj}
    BINARY_DIR ${CMAKE_BINARY_DIR}/${proj}-build
    PREFIX ${proj}${ep_suffix}
    SVN_REPOSITORY https://icl.cs.utk.edu/svn/lapack-dev/lapack/trunk
    UPDATE_COMMAND svn up
    INSTALL_COMMAND make install
    CMAKE_GENERATOR ${gen}
    CMAKE_ARGS
      -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
      -DCMAKE_CXX_FLAGS:STRING=${ep_common_cxx_flags}
      -DCMAKE_C_FLAGS:STRING=${ep_common_c_flags}
      -DCMAKE_INSTALL_PREFIX:PATH=${ep_install_dir}
      ${CMAKE_OSX_EXTERNAL_PROJECT_ARGS}
      -DADDITIONAL_C_FLAGS:STRING=${ADDITIONAL_C_FLAGS}
      -DADDITIONAL_CXX_FLAGS:STRING=${ADDITIONAL_CXX_FLAGS}
      -DBUILD_TESTING:BOOL=OFF
      -DBUILD_COMPLEX:BOOL=ON
      -DBUILD_COMPLEX16:BOOL=ON
      -DBUILD_DOUBLE:BOOL=ON
      -DBUILD_SHARED_LIBS:BOOL=OFF
      -DBUILD_STATIC_LIBS:BOOL=ON
      -DUSE_OPTIMIZED_BLAS:BOOL=OFF
      -DUSE_OPTIMIZED_LAPACK:BOOL=OFF
      -DUSE_XBLAS:BOOL=OFF
      -DLAPACKE:BOOL=OFF
    DEPENDS
      ${LAPACK_DEPENDENCIES}
    )
  set(${proj}_DIR ${CMAKE_BINARY_DIR}/${proj}-build)

else()
  # The project is provided using LAPACK_DIR, nevertheless since other project may depend on LAPACK,
  # let's add an 'empty' one
  msvMacroEmptyExternalProject(${proj} "${LAPACK_DEPENDENCIES}")
endif()

list(APPEND IBTK_SUPERBUILD_EP_ARGS -DLAPACK_DIR:PATH=${LAPACK_DIR})

