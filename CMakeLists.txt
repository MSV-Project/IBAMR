
cmake_minimum_required(VERSION 2.8.10)

# -----------------------------------------------------------------------------
project(IBAMR C CXX Fortran)
# -----------------------------------------------------------------------------

#-----------------------------------------------------------------------------
# Set a default build type if none was specified
#-----------------------------------------------------------------------------
if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
  message(STATUS "Setting build type to 'Debug' as none was specified.")
  set(CMAKE_BUILD_TYPE Debug CACHE STRING "Choose the type of build." FORCE)
  # Set the possible values of build type for cmake-gui
  set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS "Debug" "Release"
    "MinSizeRel" "RelWithDebInfo")
endif()

#-----------------------------------------------------------------------------
# Library mode: SHARED (default) or STATIC
#-----------------------------------------------------------------------------
set(IBAMR_LIBRARY_MODE "SHARED")

option(BUILD_SHARED_LIBS "Build IBAMR with shared libraries." ON)
set(IBAMR_BUILD_SHARED_LIBS ${BUILD_SHARED_LIBS})
mark_as_advanced(BUILD_SHARED_LIBS)

# -----------------------------------------------------------------------------
# Set option to optionaly build 2d library as well (by default (and always) the
# 3D library is built)
# -----------------------------------------------------------------------------
option(IBAMR_BUILD_2D_LIBRARY "Build the optional 2D libraries." OFF)

# --------------------------------------------------------------------------
# Single or multiple (default) library build (needs CMake >= 2.8.8)
# --------------------------------------------------------------------------
option(IBAMR_BUILD_SINGLE_LIBRARY "Build IBAMR single library" OFF)
mark_as_advanced(IBAMR_BUILD_SINGLE_LIBRARY)

#----------------------------------------------------------------------------
# Superbuild Option - Enabled by default
# ---------------------------------------------------------------------------
option(IBAMR_SUPERBUILD
  "Build IBMR and the projects it depends on via SuperBuild.cmake." ON)
mark_as_advanced(IBAMR_SUPERBUILD)

option(CHECK_ASSERTIONS "Debug flag to check assertions in IBAMR." OFF)
if(CHECK_ASSERTIONS)
  add_definitions(-DDEBUG_CHECK_ASSERTIONS)
endif()


#-----------------------------------------------------------------------------
# Testing
#
option(BUILD_TESTING "Test the project" ON)
if(BUILD_TESTING)
  enable_testing()
  include(CTest)
  set(CPP_TEST_PATH ${CMAKE_RUNTIME_OUTPUT_DIRECTORY})

  # DashBoard
  configure_file(
    ${IBAMR_SOURCE_DIR}/CTestConfig.cmake
    ${IBAMR_BINARY_DIR}/CTestConfig.cmake
    COPYONLY)

  # Configuration for the CMake-generated test driver
  set(CMAKE_TESTDRIVER_EXTRA_INCLUDES "
#include <stdexcept>
#if defined(WIN32)
#  pragma warning(disable : 4996)
#endif")
  set(CMAKE_TESTDRIVER_BEFORE_TESTMAIN "
  try
    {")
  set(CMAKE_TESTDRIVER_AFTER_TESTMAIN "
    }
  catch( std::exception & e )
    {
    fprintf(stderr, \"Test driver caught exception: [%s]\\n\", e.what());
    return EXIT_FAILURE;
    }
  catch( ... )
    {
    printf(\"Exception caught by the test driver\\n\");
    return EXIT_FAILURE;
    }")
endif()

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
FIND_PACKAGE(Doxygen QUIET)

#-----------------------------------------------------------------------------
# Coverage
#
option(WITH_COVERAGE "Enable/Disable coverage" OFF)

#-----------------------------------------------------------------------------
# Set coverage Flags
#
if(WITH_COVERAGE)
  if("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")
    set(coverage_flags "-g -fprofile-arcs -ftest-coverage -O0 -DNDEBUG")
    set(COVERAGE_CXX_FLAGS ${coverage_flags})
    set(COVERAGE_C_FLAGS ${coverage_flags})
  endif()
endif()

# -----------------------------------------------------------------------------
# Path to IBAMR cmake modules
# -----------------------------------------------------------------------------
set(IBAMR_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/CMake)

#-----------------------------------------------------------------------------
# Update CMake module path
#
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${IBAMR_MODULE_PATH} ${IBAMR_MODULE_PATH}/SuperBuild)

#-----------------------------------------------------------------------------
# Path to IBTK
#
set(IBTK_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/ibtk" CACHE PATH "Path to IBTK.")

#-----------------------------------------------------------------------------
# Superbuild script
#-----------------------------------------------------------------------------
if(IBAMR_SUPERBUILD)
  include(SuperBuild)
  return()
endif()

# -----------------------------------------------------------------------------
# In-tree IBTK build.
# If IBTK is built out of tree then use its use and configuration files.
# -----------------------------------------------------------------------------
if(IBAMR_BUILD_2D_LIBRARY)
  set(IBTK_BUILD_2D_LIBRARY ON CACHE BOOL "Build the 2D version of the library."
  FORCE)
endif()

if(IBAMR_BUILD_SINGLE_LIBRARY)
  set(IBTK_BUILD_SINGLE_LIBRARY ON CACHE INTERNAL "Build IBTK single library"
  FORCE)
endif(IBAMR_BUILD_SINGLE_LIBRARY)

# -----------------------------------------------------------------------------
# IBAMR requires IBTK
# -----------------------------------------------------------------------------
add_subdirectory(${IBTK_SOURCE_DIR})

#-----------------------------------------------------------------------------
# Update CMake module path
#
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${IBTK_SOURCE_DIR}/CMake)

# ----------------------------------------------------------------------------
# We need the m4 macro preprocessor and helper macros
# ----------------------------------------------------------------------------
include(ParseM4Sources)

# ----------------------------------------------------------------------------
# Set IBAMR include directories
# ----------------------------------------------------------------------------
set(IBAMR_INCLUDE_DIRS
  ${IBTK_INCLUDE_PATH}
  ${CMAKE_CURRENT_BINARY_DIR}
  ${CMAKE_CURRENT_SOURCE_DIR}/include
  ${CMAKE_CURRENT_BINARY_DIR}/include
  ${CMAKE_CURRENT_SOURCE_DIR}/src/utilities)

include_directories(${IBAMR_INCLUDE_DIRS})

# ----------------------------------------------------------------------------
# Set IBAMR linker flags
# ----------------------------------------------------------------------------
set(IBAMR_EXE_LINKER_FLAGS "${IBAMR_EXE_LINKER_FLAGS} ${IBTK_EXE_LINKER_FLAGS}")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${IBAMR_EXE_EXTERNAL_LINKER_FLAGS}")

#----------------------------------------------------------------------------
# Output directories.
#----------------------------------------------------------------------------
# Makes sure ${IBAMR_BINARY_DIR}/bin exists
IF(NOT EXISTS ${IBAMR_BINARY_DIR}/bin)
  FILE(MAKE_DIRECTORY ${IBAMR_BINARY_DIR}/bin)
ENDIF()

set(IBAMR_CMAKE_RUNTIME_OUTPUT_DIRECTORY ${IBAMR_BINARY_DIR}/bin CACHE PATH "")
foreach(type LIBRARY ARCHIVE RUNTIME)
  # Make sure the directory exists
  if(DEFINED IBAMR_CMAKE_${type}_OUTPUT_DIRECTORY
     AND NOT EXISTS ${IBAMR_CMAKE_${type}_OUTPUT_DIRECTORY})
    message(FATAL_ERROR
      "IBAMR_CMAKE_${type}_OUTPUT_DIRECTORY is set to a non-existing
      directory [${IBAMR_CMAKE_${type}_OUTPUT_DIRECTORY}]")
  endif()

  if(NOT DEFINED IBAMR_CMAKE_${type}_OUTPUT_DIRECTORY)
    set(output_dir ${IBAMR_BINARY_DIR}/lib)
  else()
    set(output_dir ${IBAMR_CMAKE_${type}_OUTPUT_DIRECTORY})
  endif()
  set(CMAKE_${type}_OUTPUT_DIRECTORY ${output_dir} CACHE INTERNAL
    "Single output directory for building all libraries.")
endforeach()


#-----------------------------------------------------------------------------
# IBAMR version number.  An even minor number corresponds to releases.
#-----------------------------------------------------------------------------
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
#-----------------------------------------------------------------------------
# TODO Rename with SUBDIR suffix
if(NOT IBAMR_INSTALL_BIN_DIR)
  set(IBAMR_INSTALL_BIN_DIR "bin")
endif()
if(NOT IBAMR_INSTALL_LIB_DIR)
  set(IBAMR_INSTALL_LIB_DIR
    "lib/IBAMR-${IBAMR_MAJOR_VERSION}.${IBAMR_MINOR_VERSION}")
endif()
if(NOT IBAMR_INSTALL_INCLUDE_DIR)
  set(IBAMR_INSTALL_INCLUDE_DIR
    "include/IBAMR-${IBAMR_MAJOR_VERSION}.${IBAMR_MINOR_VERSION}")
endif()
if(NOT IBAMR_INSTALL_DOC_DIR)
  set(IBAMR_INSTALL_DOC_DIR "doc")
endif()

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
set(IBAMR_CXX_FLAGS
  "${CMAKE_CXX_FLAGS_INIT} ${VISIBILITY_CXX_FLAGS} ${ADDITIONAL_CXX_FLAGS}")
set(IBAMR_F_FLAGS
  "${CMAKE_F_FLAGS_INIT} ${VISIBILITY_F_FLAGS} ${ADDITIONAL_F_FLAGS}")

if(CMAKE_COMPILER_IS_GNUCXX)
  set(cflags
    "-Wall -Wextra -Wpointer-arith -Winvalid-pch -Wcast-align -Wwrite-strings")
  if(CMAKE_BUILD_TYPE MATCHES "Release")
    set(cflags "${cflags} -D_FORTIFY_SOURCE=2")
  endif()
  if(MINGW)
    # suppress warnings about auto imported symbols
    set(IBAMR_CXX_FLAGS "-Wl,--enable-auto-import ${IBAMR_CXX_FLAGS}")
  endif()

  set(IBAMR_C_FLAGS "${cflags} ${IBAMR_C_FLAGS}")
  set(IBAMR_CXX_FLAGS
    "${cflags} -Woverloaded-virtual -Wold-style-cast -Wstrict-null-sentinel -Wsign-promo ${IBAMR_CXX_FLAGS}")
endif()

if(MSVC)
  set(msvc_suppressed_warnings
    "/wd4290" # C++ exception specification ignored except to indicate a function is not __declspec(nothrow)
  )
  set(IBAMR_CXX_FLAGS "${IBAMR_CXX_FLAGS} ${msvc_suppressed_warnings}")
endif()

add_definitions(
  -D_CRT_NONSTDC_NO_DEPRECATE
  -D_CRT_SECURE_NO_WARNINGS
  -D_CRT_SECURE_NO_DEPRECATE
  -DOMPI_SKIP_MPICXX
  )

# Let's mark as advanced some default properties
mark_as_advanced(CMAKE_INSTALL_PREFIX)
mark_as_advanced(DART_TESTING_TIMEOUT)

# -----------------------------------------------------------------------------
# Set library sub-directories
# Order of project directory matters. Project should be topologically ordered
# -----------------------------------------------------------------------------
set(dirs
# FileWatcher
  )

list(APPEND dirs
    navier_stokes
    adv_diff
    advect
    IB
    fortran
    utilities
#     solid_mechanics
    )

# -----------------------------------------------------------------------------
# Loop over list of sub-directories
# -----------------------------------------------------------------------------
set(IBAMR_LIBRARIES3D)
set(IBAMR_LIBRARIES2D)
foreach(dir ${dirs})
  message(STATUS "Configuring sub-library: ${dir}")
  include_directories(src/${dir})
  add_subdirectory(src/${dir})
  list(APPEND IBAMR_LIBRARIES3D ibamr${dir}3D)
  if(IBAMR_BUILD_2D_LIBRARY)
    list(APPEND IBAMR_LIBRARIES2D ibamr${dir}2D)
  endif()
endforeach()

set(IBAMR_LIBRARIES
  ${IBAMR_LIBRARIES3D}
  ${IBAMR_LIBRARIES2D}
  ${IBTK_LIBRARIES}
  ${IBTK_EXTERNAL_LIBRARIES}
  CACHE INTERNAL "IBAMR library." FORCE )

# --------------------------------------------------------------------------
# Single or multiple (default) library build (needs CMake > 2.8.8)
# --------------------------------------------------------------------------
if(IBAMR_BUILD_SINGLE_LIBRARY)
  message(STATUS "Single library build is enabled.")
  file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/lib.cpp
    "// Dummy file needed to link sublibraries.")
  set(IBAMR_LIBRARY_TARGETS3D)
  foreach(lib ${IBAMR_LIBRARIES3D})
    list(APPEND IBAMR_LIBRARY_TARGETS3D $<TARGET_OBJECTS:${lib}>)
  endforeach()
  if(IBAMR_BUILD_2D_LIBRARY)
    set(IBAMR_LIBRARY_TARGETS2D)
    foreach(lib ${IBAMR_LIBRARIES2D})
      list(APPEND IBAMR_LIBRARY_TARGETS2D $<TARGET_OBJECTS:${lib}>)
    endforeach()
    add_library(ibamr2D ${CMAKE_CURRENT_BINARY_DIR}/lib.cpp
      ${IBAMR_LIBRARY_TARGETS2D})
    add_dependencies(ibamr2D IBTK)
    set(IBAMR_LIBRARIES2D ibamr2D)
  endif(IBAMR_BUILD_2D_LIBRARY)
  add_library(ibamr3D ${CMAKE_CURRENT_BINARY_DIR}/lib.cpp
    ${IBAMR_LIBRARY_TARGETS3D})
  add_dependencies(ibamr3D IBTK)
  set(IBAMR_LIBRARIES3D ibamr3D)
else(IBAMR_BUILD_SINGLE_LIBRARY)
  message(STATUS "Single library build is disabled.")
endif(IBAMR_BUILD_SINGLE_LIBRARY)

add_subdirectory(src/tools)

# --------------------------------------------------------------------------
# Export all targets created
# --------------------------------------------------------------------------
set(IBAMR_TARGETS_FILE ${CMAKE_CURRENT_BINARY_DIR}/IBAMRTargets.cmake)
export(TARGETS ${IBAMR_LIBRARIES3D} FILE ${IBAMR_TARGETS_FILE})
if(IBAMR_BUILD_2D_LIBRARY)
  export(TARGETS ${IBAMR_LIBRARIES2D} APPEND FILE ${IBAMR_TARGETS_FILE})
endif()

set(IBAMR_USE_FILE "${IBAMR_SOURCE_DIR}/UseIBAMR.cmake")

# --------------------------------------------------------------------------
# Sets configuration header
# --------------------------------------------------------------------------
include(GenerateIBAMRConfig)

# --------------------------------------------------------------------------
# add testing
# --------------------------------------------------------------------------
if(BUILD_TESTING)
    add_subdirectory(examples)
endif()
