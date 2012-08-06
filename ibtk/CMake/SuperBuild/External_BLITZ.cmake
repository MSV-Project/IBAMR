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
# Blitz
#

# Make sure this file is included only once
get_filename_component(CMAKE_CURRENT_LIST_FILENAME ${CMAKE_CURRENT_LIST_FILE} NAME_WE)
if(${CMAKE_CURRENT_LIST_FILENAME}_FILE_INCLUDED)
  return()
endif()
set(${CMAKE_CURRENT_LIST_FILENAME}_FILE_INCLUDED 1)

# Sanity checks
if(DEFINED BLITZ_DIR AND NOT EXISTS ${BLITZ_DIR})
  message(FATAL_ERROR "BLITZ_DIR variable is defined but corresponds to non-existing directory")
endif()

set(BLITZ_DEPENDENCIES "")

# Include dependent projects if any
CheckExternalProjectDependency(BLITZ)
set(proj BLITZ)

if(NOT DEFINED BLITZ_DIR)

  # Set CMake OSX variable to pass down the external project
  set(CMAKE_OSX_EXTERNAL_PROJECT_ARGS)
  if(APPLE)
    list(APPEND CMAKE_OSX_EXTERNAL_PROJECT_ARGS
      -DCMAKE_OSX_ARCHITECTURES=${CMAKE_OSX_ARCHITECTURES}
      -DCMAKE_OSX_SYSROOT=${CMAKE_OSX_SYSROOT}
      -DCMAKE_OSX_DEPLOYMENT_TARGET=${CMAKE_OSX_DEPLOYMENT_TARGET})
  endif()
  
  set(IBTKSuperBuild_CMAKE_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR})
  set(Blitz_source ${IBTK_BINARY_DIR}/SuperBuild/${proj})

  configure_file(${IBTKSuperBuild_CMAKE_SOURCE_DIR}/blitz_patch_step.cmake.in
    ${CMAKE_CURRENT_BINARY_DIR}/blitz_patch_step.cmake
    @ONLY)
  
  set(Blitz_PATCH_COMMAND ${CMAKE_COMMAND} -P ${CMAKE_CURRENT_BINARY_DIR}/blitz_patch_step.cmake)
#     message(STATUS "Adding project:${proj}")

  ExternalProject_Add(${proj}
    SOURCE_DIR ${IBTK_BINARY_DIR}/SuperBuild/${proj}
    BINARY_DIR ${IBTK_BINARY_DIR}/SuperBuild/${proj}-build
    PREFIX ${proj}${ep_suffix}
    URL ${BLITZ_URL}/${BLITZ_GZ}
    URL_MD5 ${BLITZ_MD5}
    UPDATE_COMMAND ""
    INSTALL_COMMAND make install
    PATCH_COMMAND ${Blitz_PATCH_COMMAND}
    CONFIGURE_COMMAND ${IBTK_BINARY_DIR}/SuperBuild/${proj}/configure
      CC=gcc
      CXX=g++
      F77=gfortran
      FC=gfortran
      "CFLAGS=${ep_common_c_flags}"
      "CXXFLAGS=${ep_common_cxx_flags}"
      "FCFLAGS=${CMAKE_F_FLAGS}"
      "FFLAGS=${CMAKE_F_FLAGS}"
      --libdir=${ep_install_dir}/lib
      --prefix=${ep_install_dir}
      --enable-optimize
      --disable-debug
      --enable-shared
      --disable-dot
      --disable-doxygen
      --disable-html-docs
      --disable-latex-docs
#     TEST_BEFORE_INSTALL 1
    LOG_DOWNLOAD 1
    LOG_CONFIGURE 1
    LOG_TEST 1
    LOG_BUILD 1
    LOG_INSTALL 1
#     TEST_COMMAND make check-testsuite
    DEPENDS
      ${BLITZ_DEPENDENCIES}
    )
  set(${proj}_DIR ${IBTK_BINARY_DIR}/SuperBuild/${proj}-build)

else()
  msvMacroEmptyExternalProject(${proj} "${proj_DEPENDENCIES}")
endif()

list(APPEND IBTK_SUPERBUILD_EP_ARGS -DBLITZ_DIR:PATH=${BLITZ_DIR})
list(APPEND IBTK_SUPERBUILD_EP_ARGS -DBLITZ_INCLUDE_PATH:PATH=${BLITZ_DIR})

list(APPEND INCLUDE_PATHS ${BLITZ_DIR})
list(APPEND EXTERNAL_LIBRARIES -lblitz)
