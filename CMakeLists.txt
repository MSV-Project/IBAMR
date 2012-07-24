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

cmake_minimum_required(VERSION 2.8.8)

#-----------------------------------------------------------------------------
project(IBAMR CXX Fortran)
#-----------------------------------------------------------------------------

# ----------------------------------------------------------------------------
# Specify IBTK library directory (default: current dir)
#
set(IBTK_DIR ${CMAKE_CURRENT_SOURCE_DIR}/ibtk CACHE FILEPATH "Path to IBTK.")

# -----------------------------------------------------------------------------
# Add options: USING_LARGE_GHOST_CELL_WIDTH (default 0) and 
# 	USING_EXPENSIVE_CF_INTERPOLATION (default 0)
#
# if(NOT ENABLE_LARGE_GHOST_CELL_WIDTH)
option(ENABLE_LARGE_GHOST_CELL_WIDTH "This enables the use of large ghost 
  cell regions (this feature must be enabled for certain types of physical 
  boundary condition routines to function properly)" OFF)
if(ENABLE_LARGE_GHOST_CELL_WIDTH)
  add_definitions(-DUSING_LARGE_GHOST_CELL_WIDTH=1)
  message(STATUS "Large ghost cell widths are ENABLED!")
else()
  add_definitions(-DUSING_LARGE_GHOST_CELL_WIDTH=0)
  message(STATUS "Large ghost cell widths are DISABLED!
    Certain physical boundary condition handling routines may
    not function properly if you wish to enable support for large 
    ghost cell widths, enable this option")
endif()

option(ENABLE_EXPENSIVE_CF_INTERPOLATION "This enables the use of the expensive 
  version of the quadratic coarse-fine interface interpolation code (this feature 
  must be enabled for certain use cases, e.g. general anisotropic 
  diffusion tensors)" OFF)
if(ENABLE_EXPENSIVE_CF_INTERPOLATION)
  add_definitions(-DUSING_EXPENSIVE_CF_INTERPOLATION=1)
  message(STATUS "Expensive version of the quadratic coarse-fine interface 
    interpolation code is ENABLED!")
else()
  add_definitions(-DUSING_EXPENSIVE_CF_INTERPOLATION=0)
  message(STATUS "Expensive version of the quadratic coarse-fine interface 
    interpolation code is DISABLED! this feature must be enabled for certain 
    use cases, e.g. general anisotropic diffusion tensors if you wish to 
    enable support for large ghost cell widths, enable this option")
endif() 

# -----------------------------------------------------------------------------
#
#-----------------------------------------------------------------------------
option(ENABLE_SUBDOMAIN_INDICES "enable the use of subdomain indices for 
  standard IB mechanical elements" OFF) 
if(ENABLE_SUBDOMAIN_INDICES)
  add_definitions(-DUSING_SUBDOMAIN_INDICES)
  message(STATUS "Subdomain indices are ENABLED!")
else()
  message(STATUS "Subdomain indices are DISABLED!")
endif() 

#-----------------------------------------------------------------------------
# Library mode: SHARED (default) or STATIC
#
set(IBAMR_LIBRARY_MODE "SHARED")

option(BUILD_SHARED_LIBS "Build IBAMR with shared libraries." ON)
set(IBAMR_BUILD_SHARED_LIBS ${BUILD_SHARED_LIBS})
mark_as_advanced(BUILD_SHARED_LIBS)

#-----------------------------------------------------------------------------
# Set a default build type if none was specified
#
if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
  message(STATUS "Setting build type to 'Debug' as none was specified.")
  set(CMAKE_BUILD_TYPE Debug CACHE STRING "Choose the type of build." FORCE)
  # Set the possible values of build type for cmake-gui
  set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS "Debug" "Release"
    "MinSizeRel" "RelWithDebInfo")
endif()

#-----------------------------------------------------------------------------
# Superbuild Option - Enabled by default
#
option(IBAMR_SUPERBUILD "Build IBAMR and the projects it depends on via SuperBuild.cmake." ON)
mark_as_advanced(IBAMR_SUPERBUILD)

#-----------------------------------------------------------------------------
# Output directories.
#
foreach(type LIBRARY RUNTIME ARCHIVE)
  # Make sure the directory exists
  if(DEFINED IBAMR_CMAKE_${type}_OUTPUT_DIRECTORY
     AND NOT EXISTS ${IBAMR_CMAKE_${type}_OUTPUT_DIRECTORY})
    message(FATAL_ERROR "IBAMR_CMAKE_${type}_OUTPUT_DIRECTORY is set to a non-existing directory [${IBAMR_CMAKE_${type}_OUTPUT_DIRECTORY}]")
  endif()

  if(IBAMR_SUPERBUILD)
    set(output_dir ${IBAMR_BINARY_DIR}/bin)
    if(NOT DEFINED IBAMR_CMAKE_${type}_OUTPUT_DIRECTORY)
      set(IBAMR_CMAKE_${type}_OUTPUT_DIRECTORY ${IBAMR_BINARY_DIR}/IBAMR-build/bin)
    endif()
  else()
    if(NOT DEFINED IBAMR_CMAKE_${type}_OUTPUT_DIRECTORY)
      set(output_dir ${IBAMR_BINARY_DIR}/bin)
    else()
      set(output_dir ${IBAMR_CMAKE_${type}_OUTPUT_DIRECTORY})
    endif()
  endif()
  set(CMAKE_${type}_OUTPUT_DIRECTORY ${output_dir} CACHE INTERNAL "Single output directory for building all libraries.")
endforeach()

#-----------------------------------------------------------------------------
# IBAMR version number.  An even minor number corresponds to releases.
#
set(IBAMR_MAJOR_VERSION 0)
set(IBAMR_MINOR_VERSION 1)
set(IBAMR_BUILD_VERSION 0)
set(IBAMR_VERSION
    "${IBAMR_MAJOR_VERSION}.${IBAMR_MINOR_VERSION}.${IBAMR_BUILD_VERSION}")

# Append the library version information to the library target
# properties.  A parent project may set its own properties and/or may
# block this.
if(NOT IBAMR_NO_LIBRARY_VERSION)
  set(IBAMR_LIBRARY_PROPERTIES ${IBAMR_LIBRARY_PROPERTIES}
    VERSION "${IBAMR_VERSION}"
    SOVERSION "${IBAMR_MAJOR_VERSION}.${IBAMR_MINOR_VERSION}"
    )
endif()

#-----------------------------------------------------------------------------
# Install directories, used for install rules.
#
# TODO Rename with SUBDIR suffix
if(NOT IBAMR_INSTALL_BIN_DIR)
  set(IBAMR_INSTALL_BIN_DIR "bin")
endif()
if(NOT IBAMR_INSTALL_LIB_DIR)
  set(IBAMR_INSTALL_LIB_DIR "lib/IBAMR-${IBAMR_MAJOR_VERSION}.${IBAMR_MINOR_VERSION}")
endif()
if(NOT IBAMR_INSTALL_INCLUDE_DIR)
  set(IBAMR_INSTALL_INCLUDE_DIR "include/IBAMR-${IBAMR_MAJOR_VERSION}.${IBAMR_MINOR_VERSION}")
endif()
if(NOT IBAMR_INSTALL_DOC_DIR)
  set(IBAMR_INSTALL_DOC_DIR "doc")
endif()

#-----------------------------------------------------------------------------
# Update CMake module path
#
set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/CMake" ${CMAKE_MODULE_PATH})

#-----------------------------------------------------------------------------
# Documentation
#
option(DOCUMENTATION_TARGET_IN_ALL "Include the custom target for building documentation in 'all'" OFF)
mark_as_advanced(DOCUMENTATION_TARGET_IN_ALL)

set(DOCUMENTATION_ARCHIVES_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
 CACHE PATH "Where documentation archives should be stored")
mark_as_advanced(DOCUMENTATION_ARCHIVES_OUTPUT_DIRECTORY)

#-----------------------------------------------------------------------------
# Attempt to discover Doxygen so that DOXYGEN_EXECUTABLE is set to an appropriate default value
#
find_package(Doxygen QUIET)

#-----------------------------------------------------------------------------
# Additional CXX/C Flags
#
set(ADDITIONAL_C_FLAGS "" CACHE STRING "Additional C Flags")
mark_as_advanced(ADDITIONAL_C_FLAGS)
set(ADDITIONAL_CXX_FLAGS "" CACHE STRING "Additional CXX Flags")
mark_as_advanced(ADDITIONAL_CXX_FLAGS)
set(ADDITIONAL_F_FLAGS "" CACHE STRING "Additional F Flags")
mark_as_advanced(ADDITIONAL_F_FLAGS)

#-----------------------------------------------------------------------------
# IBAMR C/CXX Flags
#
set(IBAMR_C_FLAGS "${CMAKE_C_FLAGS_INIT} ${ADDITIONAL_C_FLAGS}")
set(IBAMR_CXX_FLAGS "${CMAKE_CXX_FLAGS_INIT} ${VISIBILITY_CXX_FLAGS} ${ADDITIONAL_CXX_FLAGS}")
set(IBAMR_F_FLAGS "${CMAKE_F_FLAGS_INIT} ${VISIBILITY_F_FLAGS} ${ADDITIONAL_F_FLAGS}")

if(CMAKE_COMPILER_IS_GNUCXX)
  set(cflags "-Wall -Wextra -Wpointer-arith -Winvalid-pch -Wcast-align -Wwrite-strings -D_FORTIFY_SOURCE=2")

  if(MINGW)
    # suppress warnings about auto imported symbols
    set(IBAMR_CXX_FLAGS "-Wl,--enable-auto-import ${IBAMR_CXX_FLAGS}")
  endif()

  set(IBAMR_C_FLAGS "${cflags} ${IBAMR_C_FLAGS}")
  set(IBAMR_CXX_FLAGS "${cflags} -Woverloaded-virtual -Wold-style-cast -Wstrict-null-sentinel -Wsign-promo ${IBAMR_CXX_FLAGS}")
endif()

if(MSVC)
  set(msvc_suppressed_warnings
    "/wd4290" # C++ exception specification ignored except to indicate a function is not __declspec(nothrow)
  )
  set(IBAMR_CXX_FLAGS "${IBAMR_CXX_FLAGS} ${msvc_suppressed_warnings}")
endif()

add_definitions(-D_CRT_NONSTDC_NO_DEPRECATE -D_CRT_SECURE_NO_WARNINGS -D_CRT_SECURE_NO_DEPRECATE -DOMPI_SKIP_MPICXX)

# Let's mark as advanced some default properties
mark_as_advanced(CMAKE_INSTALL_PREFIX)
mark_as_advanced(DART_TESTING_TIMEOUT)

#-----------------------------------------------------------------------------
# Prerequisites
#-----------------------------------------------------------------------------
find_package(Git)
if(NOT GIT_FOUND)
  message(FATAL_ERROR "error: Install Git and try to re-configure")
endif()


#-----------------------------------------------------------------------------
# Superbuild script
#
if(IBAMR_SUPERBUILD)
  add_subdirectory("${CMAKE_CURRENT_SOURCE_DIR}/CMake/SuperBuild")
  return()
endif()

#-----------------------------------------------------------------------------
# IBAMR_SUPERBUILD_BINARY_DIR

# If IBAMR_SUPERBUILD_BINARY_DIR isn't defined, it means IBAMR is *NOT* build using Superbuild.
# In that specific case, IBAMR_SUPERBUILD_BINARY_DIR should default to IBAMR_BINARY_DIR
if(NOT DEFINED IBAMR_SUPERBUILD_BINARY_DIR)
  set(IBAMR_SUPERBUILD_BINARY_DIR ${IBAMR_BINARY_DIR})
endif()

#-----------------------------------------------------------------------------
# Set C/CXX Flags
#
set(CMAKE_CXX_FLAGS ${IBAMR_CXX_FLAGS} CACHE STRING "CMake C Flags" FORCE)
set(CMAKE_C_FLAGS ${IBAMR_C_FLAGS} CACHE STRING "CMake CXX Flags" FORCE)
set(CMAKE_F_FLAGS ${IBAMR_F_FLAGS} CACHE STRING "CMake F Flags" FORCE)

add_subdirectory(ibtk)
