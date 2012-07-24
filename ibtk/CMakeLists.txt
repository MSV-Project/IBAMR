cmake_minimum_required(VERSION 2.8.8)

#
project(IBTK C CXX Fortran)
#

# -----------------------------------------------------------------------------
# Library mode: SHARED (default)  or STATIC
#
set(IBTK_LIBRARY_MODE "SHARED")

option(BUILD_SHARED_LIBS "Build IBTK with shared libraries." ON)
set(IBTK_BUILD_SHARED_LIBS ${BUILD_SHARED_LIBS})
mark_as_advanced(BUILD_SHARED_LIBS)

# -----------------------------------------------------------------------------
# Set option to optionaly build 2d library as well (by default 
# the 3D library is built)
#
option(IBTK_BUILD_2D_LIBS "Build the optional 2D libraries." OFF)

# -----------------------------------------------------------------------------
# Path to IBTK cmake modules
#
set(IBTK_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/CMake)

# -----------------------------------------------------------------------------
# FindMPI
#
find_package(MPI)
if(NOT MPI_CXX_FOUND OR NOT MPI_Fortran_FOUND OR NOT MPI_C_FOUND)
  message(FATAL_ERROR "MPI not found.")
endif()

# -----------------------------------------------------------------------------
# Find PETSc 
#
set(PETSC_DIR CACHE PATH "Petsc installation directory.")
set(PETSC_ARCH CACHE STRING "Petsc architecture.")
if(NOT PETSC_DIR)
  message(FATAL_ERROR "Must specify PETSC_DIR and PETSC_ARCH(If not sys lib).")
endif()  
set(PETSC_LIBS 
  -L${PETSC_DIR}/${PETSC_ARCH}/lib 
  -lpetsc 
  -lX11
  )

# -----------------------------------------------------------------------------
# Find SAMRAI
#
set(SAMRAI_DIR CACHE PATH "SAMRAI installation directory.")
if(NOT SAMRAI_DIR)
  message(FATAL_ERROR "Must specify SAMRAI installation directory.")
endif()  
set(SAMRAI_LIBS3D 
    -L${SAMRAI_DIR}/lib 
    -lSAMRAI
#     -lSAMRAI3d_hier 
#     -lSAMRAI3d_xfer 
#     -lSAMRAI3d_pdat_std 
#     -lSAMRAI3d_math_std 
#     -lSAMRAI3d_mesh 
#     -lSAMRAI3d_geom 
#     -lSAMRAI3d_solv 
#     -lSAMRAI3d_algs 
#     -lSAMRAI3d_appu
    )
if(IBTK_BUILD_2D_LIBS)
  set(SAMRAI_LIBS2D 
    -L${SAMRAI_DIR}/lib  
    -lSAMRAI
#     -lSAMRAI2d_hier 
#     -lSAMRAI2d_xfer 
#     -lSAMRAI2d_pdat_std 
#     -lSAMRAI2d_math_std 
#     -lSAMRAI2d_mesh 
#     -lSAMRAI2d_geom 
#     -lSAMRAI2d_solv 
#     -lSAMRAI2d_algs 
#     -lSAMRAI2d_appu
    )
endif()  

# -----------------------------------------------------------------------------
# Find HYPRE
#
set(HYPRE_DIR CACHE PATH "HYPRE installation directory.")
if(NOT HYPRE_DIR)
  message(FATAL_ERROR "Must specify HYPRE installation directory.")
endif()  
set(HYPRE_LIBS -L${HYPRE_DIR}/lib -lHYPRE)

# -----------------------------------------------------------------------------
# Find HDF5
#
set(HDF5_DIR CACHE PATH "HDF5 installation directory.")
if(NOT HDF5_DIR)
  message(FATAL_ERROR "Must specify HDF5 installation directory.")
endif()  
set(HDF5_LIBS -L${HDF5_DIR}/lib -lhdf5 -lhdf5_hl)

# -----------------------------------------------------------------------------
# Find LAPACK
#
set(LAPACK_DIR CACHE PATH "LAPACK installation directory.")
if(NOT LAPACK_DIR)
  message(FATAL_ERROR "Must specify LAPACK installation directory.")
endif()  
set(LAPACK_LIBS -L${LAPACK_DIR}/lib -lgfortran -llapack -lblas)

# -----------------------------------------------------------------------------
# Find Blitz++
#
set(BLITZ_DIR CACHE PATH "Blitz++ installation directory.")
if(NOT BLITZ_DIR)
  message(FATAL_ERROR "Must specify Blitz++ installation directory.")
endif() 
set(BLITZ_LIBS -L${BLITZ_DIR}/lib -Wl,-rpath,${BLITZ_DIR}/lib -lblitz)

# -----------------------------------------------------------------------------
# Build with SILO support (default: YES)
#
option(WITH_SILO "Build IBTK with support." ON)
if(WITH_SILO)
  set(SILO_DIR CACHE PATH "SILO installation directory.")
  if(NOT SILO_DIR)
    message(FATAL_ERROR "Must specify SILO_DIR.")
  endif()
  add_definitions(-DHAVE_LIBSILO)
  set(SILO_LIBS -L${SILO_DIR}/lib -lsilo)
endif()  

# --------------------------------------------------------------------------
# add qd library
# --------------------------------------------------------------------------
set(QD_DIR third_party/qd-2.3.11)
add_subdirectory(${QD_DIR})
set(QD_LIBS qd)

# --------------------------------------------------------------------------
# add muParser library
# --------------------------------------------------------------------------
set(MUPARSER_DIR src/third_party/muParser)
add_subdirectory(${MUPARSER_DIR})
set(MUPARSER_LIBS muParser)

# -----------------------------------------------------------------------------
# Detect the API by which C and Fortran languages interact.
# Creates the header file fortran_interfaces.h containing macro definitions
#
include(FortranCInterface)
FortranCInterface_VERIFY(CXX QUIET)
FortranCInterface_HEADER(include/fortran_interfaces.h MACRO_NAMESPACE "FC_")

# -----------------------------------------------------------------------------
# Set some gcc optimizations
#
if(CMAKE_COMPILER_IS_GNUCXX)
  add_definitions(-DIBTK_HAVE_BUILTIN_EXPECT -DIBTK_HAVE_BUILTIN_PREFETCH)
endif()

# -----------------------------------------------------------------------------
# Set Blitz++, PETSc and SAMRAI include directories
#
set(IBTK_Libs_INCLUDE_DIRS ${PROJECT_SOURCE_DIR}/include CACHE INTERNAL "IBTK Libs includes" FORCE)
include_directories(
  ${IBTK_Libs_INCLUDE_DIRS}
  ${SAMRAI}/include/
  ${PETSC_DIR}/include
  ${PETSC_DIR}/${PETSC_ARCH}/include
  ${BLITZ_DIR}/include
  ${SILO_DIR}/include
  ${CMAKE_CURRENT_BINARY_DIR}/include
)

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
# Set library sub-directories
# Order of project directory matters. Project should be topologically ordered
# -----------------------------------------------------------------------------
set(dirs
# FileWatcher
  )
  
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
set(IBTK_LIBRARIES3D)
if(IBTK_BUILD_2D_LIBS)
  set(IBTK_LIBRARIES2D)
endif()
foreach(dir ${dirs})
  message(STATUS "Configuring sub-library: ${dir}")
  add_subdirectory(src/${dir})
  list(APPEND IBTK_LIBRARIES3D ibtk${dir}3D)
  if(IBTK_BUILD_2D_LIBS)
    list(APPEND IBTK_LIBRARIES2D ibtk${dir}2D)
  endif()
endforeach()

# --------------------------------------------------------------------------
# Single or multiple (default) library build (needs CMake 2.8.8)
# -------------------------------------------------------------------------- 
option(IBTK_BUILD_SINGLE_LIBRARY "Build single library" OFF)
if(IBTK_BUILD_SINGLE_LIBRARY)
  message(STATUS "Single library build is enabled.")
  file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/lib.C "// Dummy file needed 
    // to link sublibraries.")
  set(IBTK_LIBRARY_TARGETS3D)
  foreach(lib ${IBTK_LIBRARIES3D})
    list(APPEND IBTK_LIBRARY_TARGETS3D $<TARGET_OBJECTS:${lib}>)
  endforeach()
  if(IBTK_BUILD_2D_LIBS)
    set(IBTK_LIBRARY_TARGETS2D)
    foreach(lib ${IBTK_LIBRARIES2D})
      list(APPEND IBTK_LIBRARY_TARGETS2D $<TARGET_OBJECTS:${lib}>)
    endforeach()
    add_library(ibtk2D ${CMAKE_CURRENT_BINARY_DIR}/lib.C ${IBTK_LIBRARY_TARGETS2D})
    set(IBTK_LIBRARIES2D ibtk2D)
  endif()
  add_library(ibtk3D ${CMAKE_CURRENT_BINARY_DIR}/lib.C ${IBTK_LIBRARY_TARGETS3D})
  set(IBTK_LIBRARIES3D ibtk3D)
else()
  message(STATUS "Single library build is disabled.")
endif()

# --------------------------------------------------------------------------
# Append necessary libs to compile apps
list(APPEND IBTK_LIBRARIES3D 
  ${SAMRAI_LIBS3D} 
  ${BLITZ_LIBS} 
  ${SILO_LIBS} 
  ${QD_LIBS} 
  ${MUPARSER_LIBS} 
  ${PETSC_LIBS} 
  ${HYPRE_LIBS} 
  ${HDF5_LIBS} 
  ${LAPACK_LIBS}
  )
if(IBTK_BUILD_2D_LIBS)
  list(APPEND IBTK_LIBRARIES2D 
    ${SAMRAI_LIBS2D} 
    ${PETSC_LIBS} 
    ${BLITZ_LIBS} 
    ${SILO_LIBS} 
    ${QD_LIBS} 
    ${MUPARSER_LIBS} 
    ${HYPRE_LIBS} 
    ${HDF5_LIBS} 
    ${LAPACK_LIBS}
    )
endif()

# --------------------------------------------------------------------------
# add testing
# --------------------------------------------------------------------------
INCLUDE(CTest)
IF(BUILD_TESTING)
    ADD_SUBDIRECTORY(examples)
ENDIF()
