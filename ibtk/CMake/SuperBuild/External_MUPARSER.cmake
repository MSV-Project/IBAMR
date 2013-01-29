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
# MUPARSER
#

# Make sure this file is included only once
get_filename_component(CMAKE_CURRENT_LIST_FILENAME ${CMAKE_CURRENT_LIST_FILE} NAME_WE)
if(${CMAKE_CURRENT_LIST_FILENAME}_FILE_INCLUDED)
  return()
endif()
set(${CMAKE_CURRENT_LIST_FILENAME}_FILE_INCLUDED 1)

# Sanity checks
if(DEFINED MUPARSER_DIR AND NOT EXISTS ${MUPARSER_DIR})
  message(FATAL_ERROR "MUPARSER_DIR variable is defined but corresponds to non-existing directory")
endif()

set(MUPARSER_DEPENDENCIES "")

# Include dependent projects if any
CheckExternalProjectDependency(MUPARSER)
set(proj MUPARSER)

if(NOT DEFINED MUPARSER_DIR)

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
    URL ${MUPARSER_URL}/${MUPARSER_GZ}
    URL_MD5 ${MUPARSER_MD5}
    UPDATE_COMMAND ""
    INSTALL_COMMAND make install
    BUILD_COMMAND make lib
    CONFIGURE_COMMAND ${IBTK_BINARY_DIR}/SuperBuild/${proj}/configure
      "CFLAGS=${ep_common_c_flags}"
      "CXXFLAGS=${ep_common_cxx_flags}"
      "FCFLAGS=${CMAKE_F_FLAGS}"
      "FFLAGS=${CMAKE_F_FLAGS}"
      CC=${CMAKE_C_COMPILER}
      CXX=${CMAKE_CXX_COMPILER}
      F77=${CMAKE_Fortran_COMPILER}
      FC=${CMAKE_Fortran_COMPILER}
      --libdir=${ep_install_dir}/lib
      --prefix=${ep_install_dir}
      ${SHARED_LIB_CONF}
    LOG_DOWNLOAD 1
    LOG_CONFIGURE 1
    LOG_TEST 1
    LOG_BUILD 1
    LOG_INSTALL 1
    DEPENDS
      ${MUPARSER_DEPENDENCIES}
    )
  set(${proj}_DIR ${IBTK_BINARY_DIR}/SuperBuild/${proj}-build)

else()
  msvMacroEmptyExternalProject(${proj} "${proj_DEPENDENCIES}")
endif()

list(APPEND IBTK_SUPERBUILD_EP_ARGS -DMUPARSER_DIR:PATH=${ep_install_dir})
list(APPEND IBTK_SUPERBUILD_EP_ARGS -DMUPARSER_INCLUDE_PATH:PATH=${ep_install_dir}/include)

list(APPEND INCLUDE_PATHS ${ep_install_dir}/include)
list(APPEND LIBRARY_PATHS ${ep_install_dir}/lib)
list(INSERT EXTERNAL_LIBRARIES 0 -lmuparser)
