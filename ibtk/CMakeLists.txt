
cmake_minimum_required(VERSION 2.8.10)
#
project(IBTK C CXX Fortran)
#

# -----------------------------------------------------------------------------
# Library mode: SHARED (default)  or STATIC
# -----------------------------------------------------------------------------
set(IBTK_LIBRARY_MODE "SHARED")
if(NOT DEFINED BUILD_SHARED_LIBS)
  option(BUILD_SHARED_LIBS "Build IBTK with shared libraries." ON)
  set(IBTK_BUILD_SHARED_LIBS ${BUILD_SHARED_LIBS})
  mark_as_advanced(BUILD_SHARED_LIBS)
endif()

# -----------------------------------------------------------------------------
# Set export file location
# -----------------------------------------------------------------------------
if(NOT DEFINED IBTK_TARGETS_FILE)
  set(IBTK_TARGETS_FILE
    ${CMAKE_CURRENT_BINARY_DIR}/IBTKTargets.cmake
    CACHE INTERNAL "IBTK library export file.")
endif()

# -----------------------------------------------------------------------------
# Set option to build 2d library as well (by default the 3D library is built)
# -----------------------------------------------------------------------------
if(NOT DEFINED IBTK_BUILD_2D_LIBRARY)
  option(IBTK_BUILD_2D_LIBRARY "Build the optional 2D libraries." OFF)
endif()

# --------------------------------------------------------------------------
# Single or multiple (default) library build (needs CMake 2.8.8)
# --------------------------------------------------------------------------
if(NOT DEFINED IBTK_BUILD_SINGLE_LIBRARY)
  option(IBTK_BUILD_SINGLE_LIBRARY "Build single library" OFF)
endif()

# --------------------------------------------------------------------------
# Find the M4 macro processor
# --------------------------------------------------------------------------
find_program( M4_EXECUTABLE m4 DOC "The M4 macro processor" )
if( NOT M4_EXECUTABLE )
   message( SEND_ERROR "Failed to find the M4 macro processor." )
endif( NOT M4_EXECUTABLE )

#----------------------------------------------------------------------------
# Output directories.
#----------------------------------------------------------------------------
foreach(type LIBRARY ARCHIVE RUNTIME)
  # Make sure the directory exists
  if(DEFINED IBTK_CMAKE_${type}_OUTPUT_DIRECTORY
     AND NOT EXISTS ${IBTK_CMAKE_${type}_OUTPUT_DIRECTORY})
    message(FATAL_ERROR
      "IBTK_CMAKE_${type}_OUTPUT_DIRECTORY is set to a non-existing
      directory [${IBTK_CMAKE_${type}_OUTPUT_DIRECTORY}]")
  endif()

  if(IBTK_SUPERBUILD)
    set(output_dir ${IBTK_BINARY_DIR}/lib)
    if(NOT DEFINED IBTK_CMAKE_${type}_OUTPUT_DIRECTORY)
      set(IBTK_CMAKE_${type}_OUTPUT_DIRECTORY ${IBTK_BINARY_DIR}/lib)
    endif()
  else()
    if(NOT DEFINED IBTK_CMAKE_${type}_OUTPUT_DIRECTORY)
      set(output_dir ${IBTK_BINARY_DIR}/lib)
    else()
      set(output_dir ${IBTK_CMAKE_${type}_OUTPUT_DIRECTORY})
    endif()
  endif()
  set(CMAKE_${type}_OUTPUT_DIRECTORY ${output_dir} CACHE INTERNAL
    "Single output directory for building all libraries.")
endforeach()

#-----------------------------------------------------------------------------
# Install directories, used for install rules.
#----------------------------------------------------------------------------
if(NOT IBTK_INSTALL_BIN_DIR)
  set(IBTK_INSTALL_BIN_DIR "bin")
endif()
if(NOT IBTK_INSTALL_LIB_DIR)
  set(IBTK_INSTALL_LIB_DIR
    "lib/IBTK-${IBTK_MAJOR_VERSION}.${IBTK_MINOR_VERSION}")
endif()
if(NOT IBTK_INSTALL_INCLUDE_DIR)
  set(IBTK_INSTALL_INCLUDE_DIR
    "include/IBTK-${IBTK_MAJOR_VERSION}.${IBTK_MINOR_VERSION}")
endif()
if(NOT IBTK_INSTALL_DOC_DIR)
  set(IBTK_INSTALL_DOC_DIR "doc")
endif()

# -----------------------------------------------------------------------------
# Path to IBTK cmake modules
# -----------------------------------------------------------------------------
set(IBTK_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/CMake)

#------------------------------------------------------------------------------
# Update CMake module path
#------------------------------------------------------------------------------
set(CMAKE_MODULE_PATH
  ${IBTK_MODULE_PATH} ${CMAKE_MODULE_PATH})

# -----------------------------------------------------------------------------
# Include the M4 parsing function
# -----------------------------------------------------------------------------
include(ParseM4Sources)

# ----------------------------------------------------------------------------
# IBTK version number.  An even minor number corresponds to releases.
# ----------------------------------------------------------------------------
set(IBTK_MAJOR_VERSION 0)
set(IBTK_MINOR_VERSION 0)
set(IBTK_BUILD_VERSION 1)
set(IBTK_VERSION
    "${IBTK_MAJOR_VERSION}.${IBTK_MINOR_VERSION}.${IBTK_BUILD_VERSION}")

# Append the library version information to the library target
# properties.  A parent project may set its own properties and/or may
# block this.
if(NOT IBTK_NO_LIBRARY_VERSION)
  set(IBTK_LIBRARY_PROPERTIES ${IBTK_LIBRARY_PROPERTIES}
    VERSION "${IBTK_VERSION}"
    SOVERSION "${IBTK_MAJOR_VERSION}.${IBTK_MINOR_VERSION}"
    )
endif()

#-----------------------------------------------------------------------------
# Attempt to discover Doxygen so that DOXYGEN_EXECUTABLE is set to an
# appropriate default value
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
# IBTK C/CXX Flags
#
set(IBTK_C_FLAGS "${CMAKE_C_FLAGS_INIT} ${ADDITIONAL_C_FLAGS}")
set(IBTK_CXX_FLAGS "${CMAKE_CXX_FLAGS_INIT} ${VISIBILITY_CXX_FLAGS} ${ADDITIONAL_CXX_FLAGS}")
set(IBTK_Fortran_FLAGS "${CMAKE_F_FLAGS_INIT} ${VISIBILITY_F_FLAGS} ${ADDITIONAL_F_FLAGS}")

if(CMAKE_COMPILER_IS_GNUCXX)
  set(cflags "-Wall -Wextra -Wpointer-arith -Winvalid-pch -Wcast-align -Wwrite-strings")
  if(CMAKE_BUILD_TYPE MATCHES "Release")
    set(cflags "${cflags} -D_FORTIFY_SOURCE=2")
  endif()

  if(MINGW)
    # suppress warnings about auto imported symbols
    set(IBTK_CXX_FLAGS "-Wl,--enable-auto-import ${IBTK_CXX_FLAGS}")
  endif()

  set(IBTK_C_FLAGS "${cflags} ${IBTK_C_FLAGS}")
  set(IBTK_CXX_FLAGS "${cflags} -Woverloaded-virtual -Wold-style-cast -Wstrict-null-sentinel -Wsign-promo ${IBTK_CXX_FLAGS}")
endif()

if(MSVC)
  set(msvc_suppressed_warnings
    "/wd4290" # C++ exception specification ignored except to indicate
	      # a function is not __declspec(nothrow)
  )
  set(IBTK_CXX_FLAGS "${IBTK_CXX_FLAGS} ${msvc_suppressed_warnings}")
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

set(IBTK_EXTERNAL_INCLUDE_PATHS)
set(IBTK_EXE_EXTERNAL_LINKER_FLAGS)

# -----------------------------------------------------------------------------
# FindMPI
# -----------------------------------------------------------------------------
find_package(MPI)
if(NOT MPI_CXX_FOUND OR NOT MPI_Fortran_FOUND OR NOT MPI_C_FOUND)
  message(FATAL_ERROR "MPI not found.")
endif()

list(APPEND IBTK_EXTERNAL_INCLUDE_PATHS ${MPI_CXX_INCLUDE_PATH})
set(IBTK_EXE_EXTERNAL_LINKER_FLAGS "${IBTK_EXE_EXTERNAL_LINKER_FLAGS} ${MPI_CXX_LINK_FLAGS}")
list(INSERT IBTK_EXTERNAL_LIBS 0
  -pthread
  ${MPI_CXX_LIBRARIES}
  ${MPI_Fortran_LIBRARIES}
  ${MPI_C_LIBRARIES}
  )

# -----------------------------------------------------------------------------
# FindHDF5
# -----------------------------------------------------------------------------
find_package(HDF5)
if(NOT HDF5_FOUND)
  message(FATAL_ERROR "Must specify HDF5 installation directory.")
endif()
list(APPEND IBTK_EXTERNAL_INCLUDE_PATHS ${HDF5_INCLUDE_PATH} ${HDF5_INCLUDE_DIR_HL})
list(INSERT IBTK_EXTERNAL_LIBS 0
  ${HDF5_LIBRARIES}
  )

# -----------------------------------------------------------------------------
# FindLAPACK
# -----------------------------------------------------------------------------
find_package(LAPACK)
if(NOT LAPACK_FOUND)
  message(FATAL_ERROR "Must specify LAPACK installation directory.")
endif()

set(IBTK_EXE_EXTERNAL_LINKER_FLAGS "${IBTK_EXE_EXTERNAL_LINKER_FLAGS} ${LAPACK_LINKER_FLAGS}")
list(INSERT IBTK_EXTERNAL_LIBS 0
  -lgfortran
  ${LAPACK_LIBRARIES}
  )

# -----------------------------------------------------------------------------
# Find HYPRE
# -----------------------------------------------------------------------------
find_package(HYPRE)
if(NOT HYPRE_FOUND)
  message(FATAL_ERROR "Must specify HYPRE installation directory.")
endif()
list(APPEND IBTK_EXTERNAL_INCLUDE_PATHS ${HYPRE_INCLUDE_PATH})
set(IBTK_EXE_EXTERNAL_LINKER_FLAGS "${IBTK_EXE_EXTERNAL_LINKER_FLAGS} ${HYPRE_COMPILE_FLAGS}")
list(INSERT IBTK_EXTERNAL_LIBS 0
  ${HYPRE_LIBRARIES}
  )

# -----------------------------------------------------------------------------
# Find PETSc
# -----------------------------------------------------------------------------
find_package(PETSC)
if(NOT PETSC_FOUND)
  message(FATAL_ERROR "Must specify PETSC installation directory.")
endif()
list(APPEND IBTK_EXTERNAL_INCLUDE_PATHS ${PETSC_INCLUDE_PATH})
set(IBTK_EXE_EXTERNAL_LINKER_FLAGS "${IBTK_EXE_EXTERNAL_LINKER_FLAGS} ${PETSC_LINK_FLAGS}")
list(INSERT IBTK_EXTERNAL_LIBS 0
  ${PETSC_LIBRARIES}
  )

# -----------------------------------------------------------------------------
# Build with SILO support (default: YES)
# -----------------------------------------------------------------------------
option(WITH_SILO "Build with SILO support." ON)
if(WITH_SILO)
  find_package(Silo)
  if(NOT SILO_FOUND)
    message(FATAL_ERROR "Must specify SILO_DIR..")
  endif()
  add_definitions(-DHAVE_LIBSILO)
endif()

list(APPEND IBTK_EXTERNAL_INCLUDE_PATHS ${SILO_INCLUDE_PATH})
set(IBTK_EXE_EXTERNAL_LINKER_FLAGS "${IBTK_EXE_EXTERNAL_LINKER_FLAGS} ${SILO_COMPILE_FLAGS}")
list(INSERT IBTK_EXTERNAL_LIBS 0
  ${SILO_LIBRARIES}
  )

# -----------------------------------------------------------------------------
# Find SAMRAI
# -----------------------------------------------------------------------------
find_package(SAMRAI)
if(NOT SAMRAI_FOUND)
  message(FATAL_ERROR "Must specify SAMRAI installation directory.")
endif()
list(APPEND IBTK_EXTERNAL_INCLUDE_PATHS ${SAMRAI_INCLUDE_PATH})
set(IBTK_EXE_EXTERNAL_LINKER_FLAGS "${IBTK_EXE_EXTERNAL_LINKER_FLAGS} ${SAMRAI_COMPILE_FLAGS}")
list(INSERT IBTK_EXTERNAL_LIBS 0
  ${SAMRAI_LIBRARIES}
  )

# -----------------------------------------------------------------------------
# Find Blitz++
#
find_package(BLITZ++)
if(NOT BLITZ_FOUND)
  message(FATAL_ERROR "Must specify Blitz++ installation directory.")
endif()

list(APPEND IBTK_EXTERNAL_INCLUDE_PATHS ${BLITZ_INCLUDE_PATH})
set(IBTK_EXE_EXTERNAL_LINKER_FLAGS "${IBTK_EXE_EXTERNAL_LINKER_FLAGS} ${BLITZ_COMPILE_FLAGS}")
list(INSERT IBTK_EXTERNAL_LIBS 0
  ${BLITZ_LIBRARIES}
  )

# --------------------------------------------------------------------------
# Find qd library
# --------------------------------------------------------------------------
find_package(QD)
if(NOT QD_FOUND)
  message(FATAL_ERROR "Must specify QD installation directory.")
endif()

list(APPEND IBTK_EXTERNAL_INCLUDE_PATHS ${QD_INCLUDE_PATH})
set(IBTK_EXE_EXTERNAL_LINKER_FLAGS "${IBTK_EXE_EXTERNAL_LINKER_FLAGS} ${QD_COMPILE_FLAGS}")
list(INSERT IBTK_EXTERNAL_LIBS 0
  ${QD_LIBRARIES}
  )

# --------------------------------------------------------------------------
# Find muParser library
# --------------------------------------------------------------------------
find_package(MuParser)
if(NOT MUPARSER_FOUND)
  message(FATAL_ERROR "Must specify MUPARSER installation directory.")
endif()
list(APPEND IBTK_EXTERNAL_INCLUDE_PATHS ${MUPARSER_INCLUDE_PATH})
set(IBTK_EXE_EXTERNAL_LINKER_FLAGS "${IBTK_EXE_EXTERNAL_LINKER_FLAGS} ${MUPARSER_COMPILE_FLAGS}")
list(INSERT IBTK_EXTERNAL_LIBS 0
  ${MUPARSER_LIBRARIES}
  )

# --------------------------------------------------------------------------
# Find libMesh library
# --------------------------------------------------------------------------
find_package(libMesh)
if(NOT LIBMESH_FOUND)
  message(FATAL_ERROR "Must specify LIBMESH installation directory.")
endif()
list(APPEND IBTK_EXTERNAL_INCLUDE_PATHS ${LIBMESH_INCLUDE_PATH})
set(IBTK_EXE_EXTERNAL_LINKER_FLAGS "${IBTK_EXE_EXTERNAL_LINKER_FLAGS} ${LIBMESH_COMPILE_FLAGS}")
list(INSERT IBTK_EXTERNAL_LIBS 0
  ${LIBMESH_LIBRARIES}
  )
list(REMOVE_DUPLICATES IBTK_EXTERNAL_LIBS)
list(REMOVE_DUPLICATES IBTK_EXTERNAL_INCLUDE_PATHS)
#----------------------------------------------------------------------------
# Set include dirs variable, and linker flags
# ---------------------------------------------------------------------------
set(IBTK_INCLUDE_PATH ${PROJECT_SOURCE_DIR}/include
    ${CMAKE_CURRENT_BINARY_DIR}
    ${CMAKE_CURRENT_BINARY_DIR}/include
    ${IBTK_EXTERNAL_INCLUDE_PATHS}
    CACHE INTERNAL "IBTK include paths.")

set(IBTK_EXE_LINKER_FLAGS ${IBTK_EXE_EXTERNAL_LINKER_FLAGS} CACHE INTERNAL "IBTK Exe linker flags.")

# ---------------------------------------------------------------------------
# Set library names
# ---------------------------------------------------------------------------
set(IBTK_EXTERNAL_LIBRARIES ${IBTK_EXTERNAL_LIBS} CACHE INTERNAL "IBTK external libraries.")

include_directories(${IBTK_INCLUDE_PATH})

# ----------------------------------------------------------------------------
# Set IBTK linker flags
# ----------------------------------------------------------------------------
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${IBTK_EXE_EXTERNAL_LINKER_FLAGS}")

# -----------------------------------------------------------------------------
# Set library sub-directories
# Order of project directory matters. Project should be topologically ordered
# -----------------------------------------------------------------------------
set(dirs
  patch_data
  solvers
  math
  boundary
  utilities
  refine_ops
  coarsen_ops
  lagrangian
  fortran
  )

# -----------------------------------------------------------------------------
# Loop over list of sub-directories
# -----------------------------------------------------------------------------
set(IBTK_LIBRARIES2D)
set(IBTK_LIBRARIES3D)

foreach(dir ${dirs})
  message(STATUS "Configuring sub-library: ${dir}")
  add_subdirectory(src/${dir})
  include_directories(src/${dir})
  list(APPEND IBTK_LIBRARIES3D ibtk${dir}3D)
  if(IBTK_BUILD_2D_LIBRARY)
    list(APPEND IBTK_LIBRARIES2D ibtk${dir}2D)
  endif()
endforeach()

set(IBTK_LIBRARIES ${IBTK_LIBRARIES3D} ${IBTK_LIBRARIES2D} CACHE INTERNAL "IBTK 3D library.")

# --------------------------------------------------------------------------
# Single or multiple (default) library build (needs CMake 2.8.8)
# --------------------------------------------------------------------------
if(IBTK_BUILD_SINGLE_LIBRARY)
  message(STATUS "Single library build is enabled.")
  file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/lib.cpp
    "// Dummy file needed to link sublibraries.")
  set(IBTK_LIBRARY_TARGETS3D)
  foreach(lib ${IBTK_LIBRARIES3D})
    list(APPEND IBTK_LIBRARY_TARGETS3D $<TARGET_OBJECTS:${lib}>)
  endforeach()
  if(IBTK_BUILD_2D_LIBRARY)
    set(IBTK_LIBRARY_TARGETS2D)
    foreach(lib ${IBTK_LIBRARIES2D})
      list(APPEND IBTK_LIBRARY_TARGETS2D $<TARGET_OBJECTS:${lib}>)
    endforeach()
    add_library(ibtk2D ${CMAKE_CURRENT_BINARY_DIR}/lib.cpp
      ${IBTK_LIBRARY_TARGETS2D})
    set(IBTK_LIBRARIES2D ibtk2D)
  endif()
  add_library(ibtk3D ${CMAKE_CURRENT_BINARY_DIR}/lib.cpp
    ${IBTK_LIBRARY_TARGETS3D})
  set(IBTK_LIBRARIES3D ibtk3D)
else()
  message(STATUS "Single library build is disabled.")
endif()

# --------------------------------------------------------------------------
# Export all targets used here
# --------------------------------------------------------------------------
export(TARGETS ${IBTK_LIBRARIES} FILE ${IBTK_TARGETS_FILE})

# --------------------------------------------------------------------------
# Sets configuration header
# --------------------------------------------------------------------------
include(GenerateIBTKConfig)

# --------------------------------------------------------------------------
# add testing
# --------------------------------------------------------------------------
INCLUDE(CTest)
IF(BUILD_TESTING)
    ADD_SUBDIRECTORY(examples)
ENDIF()
