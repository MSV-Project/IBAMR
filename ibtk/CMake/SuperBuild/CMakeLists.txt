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

set(IBTK_DEPENDENCIES PETSC SAMRAI SILO)

#-----------------------------------------------------------------------------
# WARNING - No change should be required after this comment
#           when you are adding a new external project dependency.
#-----------------------------------------------------------------------------

#-----------------------------------------------------------------------------
# Git protocol option
#
option(IBTK_USE_GIT_PROTOCOL "If behind a firewall turn this OFF to use http instead." ON)

set(git_protocol "git")
if(NOT IBTK_USE_GIT_PROTOCOL)
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
# that should passed to IBTK.
# The item of this list should have the following form: -D<EP>_DIR:PATH=${<EP>_DIR}
# where '<EP>' is an external project name.
set(IBTK_SUPERBUILD_EP_ARGS)

CheckExternalProjectDependency(IBTK)

#-----------------------------------------------------------------------------
# Makes sure ${IBTK_BINARY_DIR}/IBTK-build/bin exists
IF(NOT EXISTS ${IBTK_BINARY_DIR}/IBTK-build/bin)
  FILE(MAKE_DIRECTORY ${IBTK_BINARY_DIR}/IBTK-build/bin)
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
# IBTK Configure
#
SET(proj IBTK-Configure)

ExternalProject_Add(${proj}
  DOWNLOAD_COMMAND ""
  CMAKE_GENERATOR ${gen}
  CMAKE_ARGS
    ${CMAKE_OSX_EXTERNAL_PROJECT_ARGS}
    -DIBTK_BUILD_SINGLE_LIBRARY:BOOL=${IBTK_BUILD_SINGLE_LIBRARY}
    -DIBTK_IBTK_BUILD_2D_LIBS:BOOL=${IBTK_BUILD_2D_LIBS}
    -DIBTK_BUILD_SHARED_LIBS:BOOL=${IBTK_BUILD_SHARED_LIBS}
    -DIBTK_SUPERBUILD:BOOL=OFF
    -DDOCUMENTATION_ARCHIVES_OUTPUT_DIRECTORY:PATH=${DOCUMENTATION_ARCHIVES_OUTPUT_DIRECTORY}
    -DDOXYGEN_EXECUTABLE:FILEPATH=${DOXYGEN_EXECUTABLE}
    -DIBTK_SUPERBUILD_BINARY_DIR:PATH=${IBTK_BINARY_DIR}
    -DIBTK_CMAKE_ARCHIVE_OUTPUT_DIRECTORY:PATH=${IBTK_CMAKE_ARCHIVE_OUTPUT_DIRECTORY}
    -DIBTK_CMAKE_LIBRARY_OUTPUT_DIRECTORY:PATH=${IBTK_CMAKE_LIBRARY_OUTPUT_DIRECTORY}
    -DIBTK_CMAKE_RUNTIME_OUTPUT_DIRECTORY:PATH=${IBTK_CMAKE_RUNTIME_OUTPUT_DIRECTORY}
    -DIBTK_INSTALL_BIN_DIR:STRING=${IBTK_INSTALL_BIN_DIR}
    -DIBTK_INSTALL_LIB_DIR:STRING=${IBTK_INSTALL_LIB_DIR}
    -DIBTK_INSTALL_INCLUDE_DIR:STRING=${IBTK_INSTALL_INCLUDE_DIR}
    -DIBTK_INSTALL_DOC_DIR:STRING=${IBTK_INSTALL_DOC_DIR}
    -DCMAKE_INSTALL_PREFIX:PATH=${ep_install_dir}
    -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
    -DIBTK_CXX_FLAGS:STRING=${IBTK_CXX_FLAGS}
    -DIBTK_C_FLAGS:STRING=${IBTK_C_FLAGS}
    -DIBTK_F_FLAGS:STRING=${IBTK_F_FLAGS}
    -DIBTK_EXTERNAL_LIBRARY_DIRS:STRING=${IBTK_EXTERNAL_LIBRARY_DIRS}
    -DGIT_EXECUTABLE:FILEPATH=${GIT_EXECUTABLE}
    ${IBTK_SUPERBUILD_EP_ARGS}
    
  SOURCE_DIR ${IBTK_SOURCE_DIR}
  BINARY_DIR ${IBTK_BINARY_DIR}/IBTK-build
  BUILD_COMMAND ""
  INSTALL_COMMAND ""
  DEPENDS
    ${IBTK_DEPENDENCIES}
  )

if(CMAKE_GENERATOR MATCHES ".*Makefiles.*")
  set(ibamr_build_cmd "$(MAKE)")
else()
  set(ibamr_build_cmd ${CMAKE_COMMAND} --build ${IBTK_BINARY_DIR}/IBTK-build --config ${CMAKE_CFG_INTDIR})
endif()

#-----------------------------------------------------------------------------
# IBTK
#
if(NOT DEFINED SUPERBUILD_EXCLUDE_IBTKBUILD_TARGET OR NOT SUPERBUILD_EXCLUDE_IBTKBUILD_TARGET)
  set(IBTKBUILD_TARGET_ALL_OPTION "ALL")
else()
  set(IBTKBUILD_TARGET_ALL_OPTION "")
endif()

add_custom_target(IBTK-build ${IBTKBUILD_TARGET_ALL_OPTION}
  COMMAND ${ibamr_build_cmd}
  WORKING_DIRECTORY ${IBTK_BINARY_DIR}/IBTK-build
  )
add_dependencies(IBTK-build IBTK-Configure)

#-----------------------------------------------------------------------------
# Custom target allowing to drive the build of IBTK project itself
#
add_custom_target(IBTK
  COMMAND ${ibamr_build_cmd}
  WORKING_DIRECTORY ${IBTK_BINARY_DIR}/IBTK-build
  )
