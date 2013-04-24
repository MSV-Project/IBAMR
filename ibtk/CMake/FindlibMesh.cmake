###########################################################################
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

set(LIBMESH_FOUND FALSE)
# include this to handle the QUIETLY and REQUIRED arguments
include(FindPackageHandleStandardArgs)
include(GetPrerequisites)
find_path(LIBMESH_HEADER_PATH libmesh.h
        HINTS ${LIBMESH_DIR}
        PATH_SUFFIXES include/libmesh)

set(LIBMESH_INCLUDE_PATH_WORK ${LIBMESH_HEADER_PATH})

set(LIBMESH_LIB "LIBMESH_LIB-NOTFOUND" CACHE FILEPATH "Cleared" FORCE)
find_library(LIBMESH_LIB
  NAMES         mesh
  HINTS         ${LIBMESH_DIR}
  PATH_SUFFIXES lib/x86_64-opt-linux-gnu_opt
  )

find_library(EXODUSII_LIB
  NAMES         exodusii
  HINTS         ${LIBMESH_DIR}/contrib
  PATH_SUFFIXES lib/x86_64-opt-linux-gnu_opt
  )
if(EXODUSII_LIB)
  set(HAVE_LIBEXODUSII 1)
endif()

find_library(FPARSER_LIB
  NAMES         fparser
  HINTS         ${LIBMESH_DIR}/contrib
  PATH_SUFFIXES lib/x86_64-opt-linux-gnu_opt
  )
if(FPARSER_LIB)
  set(HAVE_LIBFPARSER 1)
endif()

find_library(GK_LIB
  NAMES         GK
  HINTS         ${LIBMESH_DIR}/contrib
  PATH_SUFFIXES lib/x86_64-opt-linux-gnu_opt
  )
if(GK_LIB)
  set(HAVE_LIBGK 1)
endif()

find_library(GMV_LIB
  NAMES         gmv
  HINTS         ${LIBMESH_DIR}/contrib
  PATH_SUFFIXES lib/x86_64-opt-linux-gnu_opt
  )
if(GMV_LIB)
  set(HAVE_LIBGMV 1)
endif()

find_library(GZSTREAM_LIB
  NAMES         gzstream
  HINTS         ${LIBMESH_DIR}/contrib
  PATH_SUFFIXES lib/x86_64-opt-linux-gnu_opt
  )
if(GZSTREAM_LIB)
  set(HAVE_LIBGZSTREAM 1)
endif()

find_library(HILBERT_LIB
  NAMES         Hilbert
  HINTS         ${LIBMESH_DIR}/contrib
  PATH_SUFFIXES lib/x86_64-opt-linux-gnu_opt
  )
if(HILBERT_LIB)
  set(HAVE_LIBHILBERT 1)
endif()

find_library(LASPACK_LIB
  NAMES         laspack
  HINTS         ${LIBMESH_DIR}/contrib
  PATH_SUFFIXES lib/x86_64-opt-linux-gnu_opt
  )
if(LASPACK_LIB)
  set(HAVE_LIBLASPACK 1)
endif()

find_library(METIS_LIB
  NAMES         metis
  HINTS         ${LIBMESH_DIR}/contrib
  PATH_SUFFIXES lib/x86_64-opt-linux-gnu_opt
  )
if(METIS_LIB)
  set(HAVE_LIBMETIS 1)
endif()

find_library(NEMESIS_LIB
  NAMES         nemesis
  HINTS         ${LIBMESH_DIR}/contrib
  PATH_SUFFIXES lib/x86_64-opt-linux-gnu_opt
  )
if(NEMESIS_LIB)
  set(HAVE_LIBNEMESIS 1)
endif()

find_library(NETCDF_LIB
  NAMES         netcdf
  HINTS         ${LIBMESH_DIR}/contrib
  PATH_SUFFIXES lib/x86_64-opt-linux-gnu_opt
  )
if(NETCDF_LIB)
  set(HAVE_LIBNETCDF 1)
endif()

find_library(PARMETIS_LIB
  NAMES         parmetis
  HINTS         ${LIBMESH_DIR}/contrib
  PATH_SUFFIXES lib/x86_64-opt-linux-gnu_opt
  )
if(PARMETIS_LIB)
  set(HAVE_LIBPARMETIS 1)
endif()


find_library(SFCURVES_LIB
  NAMES         sfcurves
  HINTS         ${LIBMESH_DIR}/contrib
  PATH_SUFFIXES lib/x86_64-opt-linux-gnu_opt
  )
if(SFCURVES_LIB)
  set(HAVE_LIBSFCURVES 1)
endif()


find_library(TETGEN_LIB
  NAMES         tetgen
  HINTS         ${LIBMESH_DIR}/contrib
  PATH_SUFFIXES lib/x86_64-opt-linux-gnu_opt
  )
if(TETGEN_LIB)
  set(HAVE_LIBTETGEN 1)
endif()

find_library(TRIANGLE_LIB
  NAMES         triangle
  HINTS         ${LIBMESH_DIR}/contrib
  PATH_SUFFIXES lib/x86_64-opt-linux-gnu_opt
  )
if(TRIANGLE_LIB)
  set(HAVE_LIBTRIANGLE 1)
endif()


set(LIBMESH_LIBRARIES_WORK ${LIBMESH_LIB}
  ${EXODUSII_LIB}
  ${FPARSER_LIB}
  ${GK_LIB}
  ${GMV_LIB}
  ${GZSTREAM_LIB}
  ${HILBERT_LIB}
  ${LASPACK_LIB}
  ${METIS_LIB}
  ${NEMESIS_LIB}
  ${NETCDF_LIB}
  ${PARMETIS_LIB}
  ${SFCURVES_LIB}
  ${TETGEN_LIB}
  ${TRIANGLE_LIB})

set(LIBMESH_INCLUDE_PATH  ${LIBMESH_INCLUDE_PATH_WORK} CACHE STRING "libMesh include path" FORCE)
set(LIBMESH_LIBRARIES ${LIBMESH_LIBRARIES_WORK} CACHE STRING "libMesh library to link against" FORCE)
set(LIBMESH_COMPILE_FLAGS "-L${LIBMESH_DIR}/lib" CACHE STRING "libMesh compilation flags" FORCE)

# finally set a found variable
if (LIBMESH_INCLUDE_PATH AND LIBMESH_LIBRARIES)
  set(LIBMESH_FOUND TRUE)
else()
  set(LIBMESH_FOUND FALSE)
endif()

