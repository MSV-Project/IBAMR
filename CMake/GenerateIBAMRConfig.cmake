#
# Generate configuration header
#
include(CheckIncludeFiles)
include(CheckIncludeFile)
include(TestForSTDNamespace)

# -----------------------------------------------------------------------------
# FindMPI
# -----------------------------------------------------------------------------
find_package(MPI QUIET)

# -----------------------------------------------------------------------------
# FindHDF5
# -----------------------------------------------------------------------------
find_package(HDF5 CONFIG QUIET)

# -----------------------------------------------------------------------------
# FindLAPACK
# -----------------------------------------------------------------------------
find_package(LAPACK QUIET)

# -----------------------------------------------------------------------------
# Find HYPRE
# -----------------------------------------------------------------------------
find_package(HYPRE QUIET)

# -----------------------------------------------------------------------------
# Find PETSc
# -----------------------------------------------------------------------------
find_package(PETSC QUIET)

# -----------------------------------------------------------------------------
# Find SILO
# -----------------------------------------------------------------------------
find_package(Silo QUIET)

# -----------------------------------------------------------------------------
# Find SAMRAI
# -----------------------------------------------------------------------------
find_package(SAMRAI QUIET)

# -----------------------------------------------------------------------------
# Find Blitz++
#
find_package(BLITZ++ QUIET)

# --------------------------------------------------------------------------
# Find qd library
# --------------------------------------------------------------------------
find_package(QD QUIET)

# --------------------------------------------------------------------------
# Find muParser library
# --------------------------------------------------------------------------
find_package(MuParser QUIET)

# --------------------------------------------------------------------------
# Find libMesh library
# --------------------------------------------------------------------------
find_package(libMesh QUIET)


if(MPI_FOUND)
  set(HAVE_MPI TRUE)
endif()

if(HDF5_FOUND)
  set(HAVE_LIBHDF5 TRUE)
  set(HAVE_LIBHDF5_HL TRUE)
endif()

if(LAPACK_FOUND)
  set(HAVE_BLAS TRUE)
  set(HAVE_LAPACK TRUE)
endif()

if(HYPRE_FOUND)
  set(HAVE_LIBHYPRE TRUE)
endif()

if(PETSC_FOUND)
  set(HAVE_LIBPETSC TRUE)
endif()

if(SILO_FOUND)
  set(HAVE_LIBSILO TRUE)
endif()

if(SAMRAI_FOUND)
  set(HAVE_LIBSAMRAI TRUE)
endif()

if(BLITZ_FOUND)
  set(HAVE_LIBBLITZ TRUE)
endif()

if(QD_FOUND)
  set(HAVE_QD TRUE)
endif()

if(MUPARSER_FOUND)
  set(HAVE_MUPARSER TRUE)
endif()

if(LIBMESH_FOUND)
  set(HAVE_LIBMESH TRUE)
endif()

# -----------------------------------------------------------------------------
# Add options: USING_LARGE_GHOST_CELL_WIDTH (default 0) and
# USING_EXPENSIVE_CF_INTERPOLATION (default 0)
# -----------------------------------------------------------------------------
option(ENABLE_LARGE_GHOST_CELL_WIDTH "This enables the use of large ghost
  cell regions (this feature must be enabled for certain types of physical
  boundary condition routines to function properly)" OFF)
if(ENABLE_LARGE_GHOST_CELL_WIDTH)
  message(STATUS "Large ghost cell widths are ENABLED!")
else()
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
  message(STATUS "Expensive version of the quadratic coarse-fine interface
    interpolation code is ENABLED!")
else()
  message(STATUS "Expensive version of the quadratic coarse-fine interface
    interpolation code is DISABLED! this feature must be enabled for certain
    use cases, e.g. general anisotropic diffusion tensors if you wish to
    enable support for large ghost cell widths, enable this option")
endif()

set(USING_LARGE_GHOST_CELL_WIDTH "false")
if(ENABLE_LARGE_GHOST_CELL_WIDTH)
  set(USING_LARGE_GHOST_CELL_WIDTH "true")
endif()

set(USING_EXPENSIVE_CF_INTERPOLATION "false")
if(ENABLE_EXPENSIVE_CF_INTERPOLATION)
  set(USING_EXPENSIVE_CF_INTERPOLATION "true")
endif()

if(NOT CMAKE_NO_STD_NAMESPACE)
  set(HAVE_STL TRUE)
  set(HAVE_NAMESPACES TRUE)
endif()
CHECK_INCLUDE_FILES("stdlib.h;string.h;stdarg.h;float.h" STDC_HEADERS)
CHECK_INCLUDE_FILE("memory.h" HAVE_MEMORY_H)
CHECK_INCLUDE_FILE("stdint.h" HAVE_STDINT_H)
CHECK_INCLUDE_FILE("inttypes.h" HAVE_INTTYPES_H)
CHECK_INCLUDE_FILE("stdlib.h" HAVE_STDLIB_H)
CHECK_INCLUDE_FILE("strings.h" HAVE_STRINGS_H)
CHECK_INCLUDE_FILE("string.h" HAVE_STRING_H)
CHECK_INCLUDE_FILE("sys/stat.h" HAVE_SYS_STAT_H)
CHECK_INCLUDE_FILE("sys/types.h" HAVE_SYS_TYPES_H)
CHECK_INCLUDE_FILE("unistd.h" HAVE_UNISTD_H)
CHECK_SYMBOL_EXISTS(major "sys/mkdev.h" MAJOR_IN_MKDEV)
CHECK_SYMBOL_EXISTS(major "sys/sysmacros.h" MAJOR_IN_SYSMACROS)

# Detect the API by which C and Fortran languages interact.
# Creates the header file FCMangle.h containing macro definitions
set(FORTRAN_INTERFACE_FILENAME FCMangle.h)
include(FortranCInterface)
FortranCInterface_VERIFY(CXX QUIET)
FortranCInterface_HEADER(${CMAKE_CURRENT_BINARY_DIR}/include/${FORTRAN_INTERFACE_FILENAME} MACRO_NAMESPACE "FC_")

set(FC_FUNC "FC_GLOBAL")
set(FC_FUNC_ "FC_GLOBAL_")

# ----------------------------------------------------------------------------
# Set subdomain indices option
#-----------------------------------------------------------------------------
option(ENABLE_SUBDOMAIN_INDICES
  "Enable the use of subdomain indices for standard IB mechanical elements"
  OFF)
set(SUBDOMAIN_INDICES_ENABLED "false")
if(ENABLE_SUBDOMAIN_INDICES)
  set(SUBDOMAIN_INDICES_ENABLED "true")
endif()

file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/testBuiltinExpect.cxx
  "int main() { return __builtin_expect(1, 1) ? 1 : 0; }")

try_compile(HAVE_BUILTIN_EXPECT ${CMAKE_CURRENT_BINARY_DIR}
  ${CMAKE_CURRENT_BINARY_DIR}/testBuiltinExpect.cxx
  OUTPUT_VARIABLE OUTPUT
  )

file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/testBuiltinPrefetch.cxx
  "int main() { __builtin_prefetch(0); }")

try_compile(HAVE_BUILTIN_PREFETCH ${CMAKE_CURRENT_BINARY_DIR}
  ${CMAKE_CURRENT_BINARY_DIR}/testBuiltinPrefetch.cxx
  OUTPUT_VARIABLE OUTPUT
  )

file(REMOVE ${CMAKE_CURRENT_BINARY_DIR}/testBuiltinExpect.cxx)
file(REMOVE ${CMAKE_CURRENT_BINARY_DIR}/testBuiltinPrefetch.cxx)

configure_file(${IBAMR_MODULE_PATH}/IBAMR_config.h.in
  ${CMAKE_CURRENT_BINARY_DIR}/include/IBAMR_config.h @ONLY)
