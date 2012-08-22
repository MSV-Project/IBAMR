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
# SAMRAI
#

# Make sure this file is included only once
get_filename_component(CMAKE_CURRENT_LIST_FILENAME ${CMAKE_CURRENT_LIST_FILE} NAME_WE)
if(${CMAKE_CURRENT_LIST_FILENAME}_FILE_INCLUDED)
  return()
endif()
set(${CMAKE_CURRENT_LIST_FILENAME}_FILE_INCLUDED 1)

# Sanity checks
if(DEFINED SAMRAI_DIR AND NOT EXISTS ${SAMRAI_DIR})
  message(FATAL_ERROR "SAMRAI_DIR variable is defined but corresponds to non-existing directory")
endif()

#set(SAMRAI_enabling_variable SAMRAI_LIBRARIES)

set(SAMRAI_DEPENDENCIES "SILO;OPENMPI;HDF5")

# Include dependent projects if any
CheckExternalProjectDependency(SAMRAI)
set(proj SAMRAI)

if(NOT DEFINED SAMRAI_DIR)

  # Set CMake OSX variable to pass down the external project
  set(CMAKE_OSX_EXTERNAL_PROJECT_ARGS)
  if(APPLE)
    list(APPEND CMAKE_OSX_EXTERNAL_PROJECT_ARGS
      -DCMAKE_OSX_ARCHITECTURES=${CMAKE_OSX_ARCHITECTURES}
      -DCMAKE_OSX_SYSROOT=${CMAKE_OSX_SYSROOT}
      -DCMAKE_OSX_DEPLOYMENT_TARGET=${CMAKE_OSX_DEPLOYMENT_TARGET})
  endif()
  
  set(IBTKSuperBuild_CMAKE_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR})
  set(Samrai_source ${IBTK_BINARY_DIR}/SuperBuild/${proj})
  set(Samrai_build ${IBTK_BINARY_DIR}/SuperBuild/${proj}-build)

  configure_file(${IBTKSuperBuild_CMAKE_SOURCE_DIR}/samrai_patch_step.cmake.in
    ${CMAKE_CURRENT_BINARY_DIR}/samrai_patch_step.cmake
    @ONLY)

  set(Samrai_PATCH_COMMAND ${CMAKE_COMMAND} -P ${CMAKE_CURRENT_BINARY_DIR}/samrai_patch_step.cmake)

  ExternalProject_Add(${proj}
    SOURCE_DIR ${Samrai_source}
    BINARY_DIR ${Samrai_build}
    PREFIX ${proj}${ep_suffix}
    URL ${SAMRAI_URL}/${SAMRAI_GZ}
    URL_MD5 ${SAMRAI_MD5}
    PATCH_COMMAND ${Samrai_PATCH_COMMAND}
    UPDATE_COMMAND ""
    INSTALL_COMMAND make install
    CMAKE_GENERATOR ${gen}
    CMAKE_ARGS
      ${CMAKE_OSX_EXTERNAL_PROJECT_ARGS}
      -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
      -DCMAKE_CXX_FLAGS:STRING=${ep_common_cxx_flags}
      -DCMAKE_INSTALL_PREFIX:PATH=${ep_install_dir}
      -DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS}
      -DFIND_M4=${IBTK_MODULE_PATH}/FindM4.cmake
      -DHDF5_ROOT=${ep_install_dir}
      -DSILO_ROOT=${ep_install_dir}
      -DMPI_CXX_COMPILER=${ep_install_dir}/bin/mpicxx
    LOG_DOWNLOAD 1
    LOG_CONFIGURE 1
    LOG_INSTALL 1
    LOG_PATCH 1
    DEPENDS
      ${SAMRAI_DEPENDENCIES}
    )
  set(${proj}_DIR ${IBTK_BINARY_DIR}/${proj}-build)

else()
  msvMacroEmptyExternalProject(${proj} "${proj_DEPENDENCIES}")
endif()

list(APPEND IBTK_SUPERBUILD_EP_ARGS -DSAMRAI_DIR:PATH=${ep_install_dir} )
list(APPEND IBTK_SUPERBUILD_EP_ARGS -DSAMRAI_INCLUDE_PATH:PATH=${ep_install_dir}/include)
list(APPEND IBTK_SUPERBUILD_EP_ARGS -DSAMRAI_FORTDIR:PATH=${ep_install_dir}/include)

list(APPEND INCLUDE_PATHS ${ep_install_dir}/include)
list(INSERT EXTERNAL_LIBRARIES 0 -lSAMRAI)
set(SAMRAI_INCLUDE_PATH ${ep_install_dir}/include PARENT_SCOPE)
