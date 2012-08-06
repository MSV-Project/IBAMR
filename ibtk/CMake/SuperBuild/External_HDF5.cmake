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
# HDF5
#

# Make sure this file is included only once
get_filename_component(CMAKE_CURRENT_LIST_FILENAME ${CMAKE_CURRENT_LIST_FILE} NAME_WE)
if(${CMAKE_CURRENT_LIST_FILENAME}_FILE_INCLUDED)
  return()
endif()
set(${CMAKE_CURRENT_LIST_FILENAME}_FILE_INCLUDED 1)

# Sanity checks
if(DEFINED HDF5_DIR AND NOT EXISTS ${HDF5_DIR})
  message(FATAL_ERROR "HDF5_DIR variable is defined but corresponds to non-existing directory")
endif()

#set(HDF5_enabling_variable HDF5_LIBRARIES)

set(HDF5_DEPENDENCIES "")

# Include dependent projects if any
CheckExternalProjectDependency(HDF5)
set(proj HDF5)

if(NOT DEFINED HDF5_DIR)

  # Set CMake OSX variable to pass down the external project
  set(CMAKE_OSX_EXTERNAL_PROJECT_ARGS)
  if(APPLE)
    list(APPEND CMAKE_OSX_EXTERNAL_PROJECT_ARGS
      -DCMAKE_OSX_ARCHITECTURES=${CMAKE_OSX_ARCHITECTURES}
      -DCMAKE_OSX_SYSROOT=${CMAKE_OSX_SYSROOT}
      -DCMAKE_OSX_DEPLOYMENT_TARGET=${CMAKE_OSX_DEPLOYMENT_TARGET})
  endif()

  set(IBTKSuperBuild_CMAKE_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR})
  set(Hdf5_source ${IBTK_BINARY_DIR}/SuperBuild/${proj})

  configure_file(${IBTKSuperBuild_CMAKE_SOURCE_DIR}/hdf5_patch_step.cmake.in
    ${CMAKE_CURRENT_BINARY_DIR}/hdf5_patch_step.cmake
    @ONLY)
  
  set(Hdf5_PATCH_COMMAND ${CMAKE_COMMAND} -P ${CMAKE_CURRENT_BINARY_DIR}/hdf5_patch_step.cmake)
  
#     message(STATUS "Adding project:${proj}")
  ExternalProject_Add(${proj}
    SOURCE_DIR ${IBTK_BINARY_DIR}/SuperBuild/${proj}
    BINARY_DIR ${IBTK_BINARY_DIR}/SuperBuild/${proj}-build
    PREFIX ${proj}${ep_suffix}
    URL ${HDF5_URL}/${HDF5_GZ}
    URL_MD5 ${HDF5_MD5}
    PATCH_COMMAND ${Hdf5_PATCH_COMMAND}
    UPDATE_COMMAND ""
    INSTALL_COMMAND make install
    CMAKE_GENERATOR ${gen}
    CMAKE_ARGS
      ${CMAKE_OSX_EXTERNAL_PROJECT_ARGS}
      -DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS}
      -DCMAKE_BUILD_TYPE:STRING=Release#${CMAKE_BUILD_TYPE}
      -DCMAKE_CXX_FLAGS:STRING=${ep_common_cxx_flags}
      -DCMAKE_C_FLAGS:STRING=${ep_common_c_flags}
      -DCMAKE_INSTALL_PREFIX:PATH=${ep_install_dir}
      -DADDITIONAL_C_FLAGS:STRING=${ADDITIONAL_C_FLAGS}
      -DADDITIONAL_CXX_FLAGS:STRING=${ADDITIONAL_CXX_FLAGS}
      -DHDF5_BUILD_HL_LIB:BOOL=ON
    LOG_DOWNLOAD 1
    LOG_CONFIGURE 1
    LOG_TEST 1
    LOG_BUILD 1
    LOG_INSTALL 1
#     TEST_COMMAND make check
    DEPENDS
      ${HDF5_DEPENDENCIES}
    )
  set(${proj}_DIR ${IBTK_BINARY_DIR}/SuperBuild/${proj}-build)

else()
  msvMacroEmptyExternalProject(${proj} "${proj_DEPENDENCIES}")
endif()

list(APPEND IBTK_SUPERBUILD_EP_ARGS -DHDF5_ROOT_DIR_HINT:PATH=${HDF5_DIR} -DHDF5_DIR:PATH=${HDF5_DIR})
list(APPEND IBTK_SUPERBUILD_EP_ARGS -DHDF5_INCLUDE_PATH:PATH=${ep_install_dir}/include)

list(APPEND INCLUDE_PATHS ${ep_install_dir}/include)
list(APPEND EXTERNAL_LIBRARIES -lhdf5 -lhdf5_hl)
