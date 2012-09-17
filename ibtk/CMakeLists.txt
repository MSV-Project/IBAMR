
cmake_minimum_required(VERSION 2.8.8)
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

#----------------------------------------------------------------------------
# Set include dirs variable
# ---------------------------------------------------------------------------
set(IBTK_INCLUDE_PATH ${PROJECT_SOURCE_DIR}/include 
    ${IBTK_BINARY_DIR}/include
    CACHE INTERNAL "IBTK include paths.") 

# ---------------------------------------------------------------------------
# Set library names 
# ---------------------------------------------------------------------------
set(IBTK_EXTERNAL_LIBRARIES CACHE INTERNAL "IBTK external libraries.")
set(IBTK_LIBRARIES3D CACHE INTERNAL "IBTK 3D library.")
if(IBTK_BUILD_2D_LIBRARY)
  set(IBTK_LIBRARIES2D CACHE INTERNAL "IBTK 2D library.")
endif()

#----------------------------------------------------------------------------
# Superbuild Option - Enabled by default
# ---------------------------------------------------------------------------
option(IBTK_SUPERBUILD 
  "Build IBTK and the projects it depends on via SuperBuild.cmake." ON)
mark_as_advanced(IBTK_SUPERBUILD)

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
  ${IBTK_MODULE_PATH} 
  ${IBTK_MODULE_PATH}/SuperBuild
  ${CMAKE_MODULE_PATH})
  
# ----------------------------------------------------------------------------
# We need the m4 macro preprocessor and helper macros
# ----------------------------------------------------------------------------
include(${CMAKE_CURRENT_SOURCE_DIR}/CMake/FindM4.cmake)

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
  set(cflags "-Wall -Wextra -Wpointer-arith -Winvalid-pch -Wcast-align -Wwrite-strings -D_FORTIFY_SOURCE=2")

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

#
set(IBTK_SUPERBUILD_BINARY_DIR ${IBTK_BINARY_DIR}/SuperBuild CACHE INTERNAL 
  "")

#-----------------------------------------------------------------------------
# Superbuild script
# -----------------------------------------------------------------------------
if(IBTK_SUPERBUILD)
  add_subdirectory("${IBTK_MODULE_PATH}/SuperBuild")
  return()
endif()

# -----------------------------------------------------------------------------
# Detect the API by which C and Fortran languages interact.
# Creates the header file fortran_interfaces.h containing macro definitions
# -----------------------------------------------------------------------------
include(FortranCInterface)
FortranCInterface_VERIFY(CXX QUIET)
FortranCInterface_HEADER(${IBTK_INCLUDE_BINARY_PATH}/fortran_interfaces.h MACRO_NAMESPACE "FC_")

list(APPEND IBTK_INCLUDE_PATH ${IBTK_INCLUDE_BINARY_PATH})


# -----------------------------------------------------------------------------
# FindMPI
# -----------------------------------------------------------------------------
find_package(MPI)
if(NOT MPI_CXX_FOUND OR NOT MPI_Fortran_FOUND OR NOT MPI_C_FOUND)
  message(FATAL_ERROR "MPI not found.")
endif()
set(MPI_LIBS ${MPI_CXX_LIBRARIES})
list(APPEND IBTK_INCLUDE_PATH ${MPI_CXX_INCLUDE_PATH})
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${MPI_CXX_LINK_FLAGS}")
list(APPEND IBTK_EXTERNAL_LIBRARIES
  ${MPI_CXX_LIBRARIES}
  ${MPI_Fortran_LIBRARIES}
  ${MPI_C_LIBRARIES} -lopen-rte -lopen-pal
  )

# -----------------------------------------------------------------------------
# Find HDF5
# -----------------------------------------------------------------------------
find_package(HDF5)
if(NOT HDF5_FOUND)
  message(FATAL_ERROR "Must specify HDF5 installation directory.")
endif()  
set(HDF5_LIBS hdf5 hdf5_hl)
list(APPEND IBTK_INCLUDE_PATH ${HDF5_INCLUDE_PATH})
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -L${HDF_DIR}/lib")
list(APPEND IBTK_EXTERNAL_LIBRARIES
  ${HDF5_LIBS} 
  )

# -----------------------------------------------------------------------------
# Find LAPACK
# -----------------------------------------------------------------------------
set(LAPACK_DIR CACHE PATH "LAPACK installation directory.")
if(NOT LAPACK_DIR)
  message(FATAL_ERROR "Must specify LAPACK installation directory.")
endif()  
set(LAPACK_LIBS -lgfortran -llapack -lblas)
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -L${LAPACK_DIR}/lib")
list(APPEND IBTK_EXTERNAL_LIBRARIES
  ${LAPACK_LIBS}
  )

# -----------------------------------------------------------------------------
# Find PETSc 
# -----------------------------------------------------------------------------
set(PETSC_DIR CACHE PATH "Petsc installation directory.")
set(PETSC_ARCH CACHE STRING "Petsc architecture.")
if(NOT PETSC_DIR)
  message(FATAL_ERROR "Must specify PETSC_DIR and PETSC_ARCH(If not sys lib).")
endif()  
set(PETSC_LIBS -lpetsc -lX11)
list(APPEND IBTK_INCLUDE_PATH ${PETSC_INCLUDE_PATH} ${PETSC_DIR}/${PETSC_ARCH}/include)
set(CMAKE_EXE_LINKER_FLAGS 
  "${CMAKE_EXE_LINKER_FLAGS} -L${PETSC_DIR}/${PETSC_ARCH}/lib -Wl,-rpath,${PETSC_DIR}/${PETSC_ARCH}/lib ")
list(APPEND IBTK_EXTERNAL_LIBRARIES
  ${PETSC_LIBS} 
  )

# -----------------------------------------------------------------------------
# Find SAMRAI
# -----------------------------------------------------------------------------
set(SAMRAI_DIR CACHE PATH "SAMRAI installation directory.")
if(NOT SAMRAI_DIR)
  message(FATAL_ERROR "Must specify SAMRAI installation directory.")
endif()  
set(SAMRAI_LIBS
    -lSAMRAI
    )
list(APPEND IBTK_INCLUDE_PATH ${SAMRAI_INCLUDE_PATH})
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -L${SAMRAI_DIR}/lib")
list(APPEND IBTK_EXTERNAL_LIBRARIES
  ${SAMRAI_LIBS}
  )

# -----------------------------------------------------------------------------
# Find HYPRE
# -----------------------------------------------------------------------------
set(HYPRE_DIR CACHE PATH "HYPRE installation directory.")
if(NOT HYPRE_DIR)
  message(FATAL_ERROR "Must specify HYPRE installation directory.")
endif()  
set(HYPRE_LIBS -lHYPRE)
list(APPEND IBTK_INCLUDE_PATH ${HYPRE_INCLUDE_PATH})
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -L${HYPRE_DIR}/lib")
list(APPEND IBTK_EXTERNAL_LIBRARIES
  ${HYPRE_LIBS} 
  )

# -----------------------------------------------------------------------------
# Find Blitz++
#
set(BLITZ_DIR CACHE PATH "Blitz++ installation directory.")
if(NOT BLITZ_DIR)
  message(FATAL_ERROR "Must specify Blitz++ installation directory.")
endif() 
set(BLITZ_LIBS -lblitz)
list(APPEND IBTK_INCLUDE_PATH ${BLITZ_INCLUDE_PATH})
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -L${BLITZ_DIR}/lib")
list(APPEND IBTK_EXTERNAL_LIBRARIES
  ${BLITZ_LIBS} 
  )

# -----------------------------------------------------------------------------
# Build with SILO support (default: YES)
# -----------------------------------------------------------------------------
option(WITH_SILO "Build with SILO support." ON)
if(WITH_SILO)
  set(SILO_DIR CACHE PATH "SILO installation directory.")
  if(NOT SILO_DIR)
    message(FATAL_ERROR "Must specify SILO_DIR.")
  endif()
  add_definitions(-DHAVE_LIBSILO)
  set(SILO_LIBS -lsilo)
endif()  
list(APPEND IBTK_INCLUDE_PATH ${SILO_INCLUDE_PATH})
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -L${SILO_DIR}/lib")
list(APPEND IBTK_EXTERNAL_LIBRARIES
  ${SILO_LIBS} 
  )
  
# --------------------------------------------------------------------------
# Find qd library
# --------------------------------------------------------------------------
set(QD_DIR CACHE PATH "QD Directory.")
if(NOT QD_DIR)
  message(FATAL_ERROR "Must specify QD installation directory.")
endif() 
set(QD_LIBS -lqdmod -lqd)
list(APPEND IBTK_INCLUDE_PATH ${QD_INCLUDE_PATH})
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -L${QD_DIR}/lib")
list(APPEND IBTK_EXTERNAL_LIBRARIES
  ${QD_LIBS} 
  )

# --------------------------------------------------------------------------
# Find muParser library
# --------------------------------------------------------------------------
set(MUPARSER_DIR CACHE PATH "MUPARSER Directory.")
if(NOT MUPARSER_DIR)
  message(FATAL_ERROR "Must specify MUPARSER installation directory.")
endif() 
set(MUPARSER_LIBS -lmuparser)
list(APPEND IBTK_INCLUDE_PATH ${MUPARSER_INCLUDE_PATH})
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -L${MUPARSER_DIR}/lib")
list(APPEND IBTK_EXTERNAL_LIBRARIES
  ${MUPARSER_LIBS} 
  )

# -----------------------------------------------------------------------------
# Set some gcc optimizations
# -----------------------------------------------------------------------------
if(CMAKE_COMPILER_IS_GNUCXX)
  add_definitions(-DIBTK_HAVE_BUILTIN_EXPECT -DIBTK_HAVE_BUILTIN_PREFETCH)
endif()

include_directories(${IBTK_INCLUDE_PATH})

# -----------------------------------------------------------------------------
# Add options: USING_LARGE_GHOST_CELL_WIDTH (default 0) and 
# 		USING_EXPENSIVE_CF_INTERPOLATION (default 0)
# -----------------------------------------------------------------------------
if(NOT DEFINED ENABLE_LARGE_GHOST_CELL_WIDTH)
  option(ENABLE_LARGE_GHOST_CELL_WIDTH "This enables the use of large ghost 
    cell regions (this feature must be enabled for certain types of physical 
    boundary condition routines to function properly)" OFF)
endif()
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
if(NOT DEFINED ENABLE_EXPENSIVE_CF_INTERPOLATION)
  option(ENABLE_EXPENSIVE_CF_INTERPOLATION "This enables the use of the 
    expensive version of the quadratic coarse-fine interface interpolation 
    code (this feature must be enabled for certain use cases, e.g. 
    general anisotropic diffusion tensors)" OFF)
endif() 
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
# Set library sub-directories
# Order of project directory matters. Project should be topologically ordered
# -----------------------------------------------------------------------------
set(dirs)  
list(APPEND dirs
  fortran
  patch_data
  refine_ops
  solvers
  math
  boundary
  coarsen_ops
  utilities
  lagrangian
  )

# -----------------------------------------------------------------------------
# Loop over list of sub-directories 
# -----------------------------------------------------------------------------
foreach(dir ${dirs})
  message(STATUS "Configuring sub-library: ${dir}")
  add_subdirectory(src/${dir})
  list(APPEND IBTK_LIBRARIES3D ibtk${dir}3D)
  if(IBTK_BUILD_2D_LIBRARY)
    list(APPEND IBTK_LIBRARIES2D ibtk${dir}2D)
  endif()
endforeach()

# --------------------------------------------------------------------------
# Single or multiple (default) library build (needs CMake 2.8.8)
# -------------------------------------------------------------------------- 
if(IBTK_BUILD_SINGLE_LIBRARY)
  message(STATUS "Single library build is enabled.")
  file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/lib.C "// Dummy file needed 
    // to link sublibraries.")
  set(IBTK_LIBRARY_TARGETS3D)
  foreach(lib ${IBTK_LIBRARIES3D})
    list(APPEND IBTK_LIBRARY_TARGETS3D $<TARGET_OBJECTS:${lib}>)
  endforeach()
  if(IBTK_BUILD_2D_LIBRARY)
    set(IBTK_LIBRARY_TARGETS2D)
    foreach(lib ${IBTK_LIBRARIES2D})
      list(APPEND IBTK_LIBRARY_TARGETS2D $<TARGET_OBJECTS:${lib}>)
    endforeach()
    add_library(ibtk2D ${CMAKE_CURRENT_BINARY_DIR}/lib.C 
      ${IBTK_LIBRARY_TARGETS2D})
    set(IBTK_LIBRARIES2D ibtk2D)
  endif()
  add_library(ibtk3D ${CMAKE_CURRENT_BINARY_DIR}/lib.C 
    ${IBTK_LIBRARY_TARGETS3D})
  set(IBTK_LIBRARIES3D ibtk3D)
else()
  message(STATUS "Single library build is disabled.")
endif()

# --------------------------------------------------------------------------
# Export all targets used here 
# --------------------------------------------------------------------------
export(TARGETS ${IBTK_LIBRARIES3D} FILE ${IBTK_TARGETS_FILE})
if(IBTK_BUILD_2D_LIBRARY)
  export(TARGETS ${IBTK_LIBRARIES2D} APPEND FILE ${IBTK_TARGETS_FILE})
endif()

# --------------------------------------------------------------------------
# add testing
# --------------------------------------------------------------------------
INCLUDE(CTest)
IF(BUILD_TESTING)
    ADD_SUBDIRECTORY(examples)
ENDIF()  
