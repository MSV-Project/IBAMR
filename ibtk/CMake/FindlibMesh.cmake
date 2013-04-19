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
set(LIBMESH_LIBRARIES_WORK ${LIBMESH_LIB})

set(LIBMESH_INCLUDE_PATH  ${LIBMESH_INCLUDE_PATH_WORK} CACHE STRING "libMesh include path" FORCE)
set(LIBMESH_LIBRARIES ${LIBMESH_LIBRARIES_WORK} CACHE STRING "libMesh library to link against" FORCE)
set(LIBMESH_COMPILE_FLAGS "-L${LIBMESH_DIR}/lib" CACHE STRING "libMesh compilation flags" FORCE)

# finally set a found variable
if (LIBMESH_INCLUDE_PATH AND LIBMESH_LIBRARIES)
  set(LIBMESH_FOUND TRUE)
else()
  set(LIBMESH_FOUND FALSE)
endif()
