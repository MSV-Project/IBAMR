###########################################################################
#
#  Library: IBAMR
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

set(IBAMR_DEPENDENCIES BLITZ PETSC SAMRAI SILO)

#-----------------------------------------------------------------------------
# WARNING - No change should be required after this comment
#           when you are adding a new external project dependency.
#-----------------------------------------------------------------------------

#-----------------------------------------------------------------------------
# Git protocol option
#
option(IBAMR_USE_GIT_PROTOCOL "If behind a firewall turn this OFF to use http instead." ON)

set(git_protocol "git")
if(NOT IBAMR_USE_GIT_PROTOCOL)
  set(git_protocol "http")
endif()

#-----------------------------------------------------------------------------
# Enable and setup External project global properties
#
include(ExternalProject)
include(EmptyExternalProject)
include(CheckExternalProjectDependency)

set(ep_install_dir ${CMAKE_BINARY_DIR}/SuperBuild/Install)
set(ep_suffix      "-cmake")

set(ep_common_c_flags "${CMAKE_C_FLAGS_INIT} ${ADDITIONAL_C_FLAGS}")
set(ep_common_cxx_flags "${CMAKE_CXX_FLAGS_INIT} ${ADDITIONAL_CXX_FLAGS}")

# Compute -G arg for configuring external projects with the same CMake generator:
if(CMAKE_EXTRA_GENERATOR)
  set(gen "${CMAKE_EXTRA_GENERATOR} - ${CMAKE_GENERATOR}")
else()
  set(gen "${CMAKE_GENERATOR}")
endif()

# Use this value where semi-colons are needed in ep_add args:
set(sep "^^")

# This variable will contain the list of CMake variable specific to each external project
# that should passed to IBAMR.
# The item of this list should have the following form: -D<EP>_DIR:PATH=${<EP>_DIR}
# where '<EP>' is an external project name.
set(IBAMR_SUPERBUILD_EP_ARGS)

CheckExternalProjectDependency(IBAMR)

#-----------------------------------------------------------------------------
# Makes sure ${IBAMR_BINARY_DIR}/IBAMR-build/bin exists
IF(NOT EXISTS ${IBAMR_BINARY_DIR}/IBAMR-build/bin)
  FILE(MAKE_DIRECTORY ${IBAMR_BINARY_DIR}/IBAMR-build/bin)
ENDIF()

#-----------------------------------------------------------------------------
# Set CMake OSX variable to pass down the external project
set(CMAKE_OSX_EXTERNAL_PROJECT_ARGS)
if(APPLE)
  list(APPEND CMAKE_OSX_EXTERNAL_PROJECT_ARGS
    -DCMAKE_OSX_ARCHITECTURES=${CMAKE_OSX_ARCHITECTURES}
    -DCMAKE_OSX_SYSROOT=${CMAKE_OSX_SYSROOT}
    -DCMAKE_OSX_DEPLOYMENT_TARGET=${CMAKE_OSX_DEPLOYMENT_TARGET})
endif()



#-----------------------------------------------------------------------------
# IBAMR Configure
#
SET(proj IBAMR-Configure)

ExternalProject_Add(${proj}
  DOWNLOAD_COMMAND ""
  CMAKE_GENERATOR ${gen}
  CMAKE_ARGS
    ${CMAKE_OSX_EXTERNAL_PROJECT_ARGS}
    -DIBAMR_SUPERBUILD:BOOL=OFF
    -DDOCUMENTATION_ARCHIVES_OUTPUT_DIRECTORY:PATH=${DOCUMENTATION_ARCHIVES_OUTPUT_DIRECTORY}
    -DDOXYGEN_EXECUTABLE:FILEPATH=${DOXYGEN_EXECUTABLE}
    -DIBAMR_SUPERBUILD_BINARY_DIR:PATH=${IBAMR_BINARY_DIR}
    -DIBAMR_CMAKE_ARCHIVE_OUTPUT_DIRECTORY:PATH=${IBAMR_CMAKE_ARCHIVE_OUTPUT_DIRECTORY}
    -DIBAMR_CMAKE_LIBRARY_OUTPUT_DIRECTORY:PATH=${IBAMR_CMAKE_LIBRARY_OUTPUT_DIRECTORY}
    -DIBAMR_CMAKE_RUNTIME_OUTPUT_DIRECTORY:PATH=${IBAMR_CMAKE_RUNTIME_OUTPUT_DIRECTORY}
    -DIBAMR_INSTALL_BIN_DIR:STRING=${IBAMR_INSTALL_BIN_DIR}
    -DIBAMR_INSTALL_LIB_DIR:STRING=${IBAMR_INSTALL_LIB_DIR}
    -DIBAMR_INSTALL_INCLUDE_DIR:STRING=${IBAMR_INSTALL_INCLUDE_DIR}
    -DIBAMR_INSTALL_DOC_DIR:STRING=${IBAMR_INSTALL_DOC_DIR}
    -DIBAMR_BUILD_SHARED_LIBS:BOOL=${IBAMR_BUILD_SHARED_LIBS}
    -DCMAKE_INSTALL_PREFIX:PATH=${ep_install_dir}
    -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
    -DIBAMR_CXX_FLAGS:STRING=${IBAMR_CXX_FLAGS}
    -DIBAMR_C_FLAGS:STRING=${IBAMR_C_FLAGS}
    -DIBAMR_F_FLAGS:STRING=${IBAMR_F_FLAGS}
    -DIBAMR_EXTERNAL_LIBRARY_DIRS:STRING=${IBAMR_EXTERNAL_LIBRARY_DIRS}
    -DGIT_EXECUTABLE:FILEPATH=${GIT_EXECUTABLE}
    ${IBAMR_SUPERBUILD_EP_ARGS}
    
  SOURCE_DIR ${IBAMR_SOURCE_DIR}
  BINARY_DIR ${IBAMR_BINARY_DIR}/IBAMR-build
  BUILD_COMMAND ""
  INSTALL_COMMAND ""
  DEPENDS
    ${IBAMR_DEPENDENCIES}
  )

if(CMAKE_GENERATOR MATCHES ".*Makefiles.*")
  set(ibamr_build_cmd "$(MAKE)")
else()
  set(ibamr_build_cmd ${CMAKE_COMMAND} --build ${IBAMR_BINARY_DIR}/IBAMR-build --config ${CMAKE_CFG_INTDIR})
endif()

#-----------------------------------------------------------------------------
# IBAMR
#
if(NOT DEFINED SUPERBUILD_EXCLUDE_IBAMRBUILD_TARGET OR NOT SUPERBUILD_EXCLUDE_IBAMRBUILD_TARGET)
  set(IBAMRBUILD_TARGET_ALL_OPTION "ALL")
else()
  set(IBAMRBUILD_TARGET_ALL_OPTION "")
endif()

add_custom_target(IBAMR-build ${IBAMRBUILD_TARGET_ALL_OPTION}
  COMMAND ${ibamr_build_cmd}
  WORKING_DIRECTORY ${IBAMR_BINARY_DIR}/IBAMR-build
  )
add_dependencies(IBAMR-build IBAMR-Configure)

#-----------------------------------------------------------------------------
# Custom target allowing to drive the build of IBAMR project itself
#
add_custom_target(IBAMR
  COMMAND ${ibamr_build_cmd}
  WORKING_DIRECTORY ${IBAMR_BINARY_DIR}/IBAMR-build
  )
