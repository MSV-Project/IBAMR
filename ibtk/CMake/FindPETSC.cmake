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

set(PETSC_FOUND FALSE)
# include this to handle the QUIETLY and REQUIRED arguments
include(FindPackageHandleStandardArgs)
include(GetPrerequisites)

find_path(PETSC_HEADER_PATH1 petsc.h
        HINTS ${PETSC_DIR}
        PATH_SUFFIXES include)

set(PETSC_INCLUDE_PATH_WORK ${PETSC_HEADER_PATH})

find_path(PETSC_HEADER_PATH2 petscconf.h
        HINTS ${PETSC_DIR}/${PETSC_ARCH}
        PATH_SUFFIXES include)

set(PETSC_INCLUDE_PATH_WORK ${PETSC_HEADER_PATH1} ${PETSC_HEADER_PATH2})

set(PETSC_LIB "PETSC_LIB-NOTFOUND" CACHE FILEPATH "Cleared" FORCE)
find_library(PETSC_LIB
  NAMES         petsc
  HINTS         ${PETSC_DIR}/${PETSC_ARCH}
  PATH_SUFFIXES lib)
set(PETSC_LIBRARIES_WORK ${PETSC_LIB})

set(PETSC_INCLUDE_PATH  ${PETSC_INCLUDE_PATH_WORK} CACHE STRING "PETSC include paths" FORCE)
set(PETSC_LIBRARIES ${PETSC_LIBRARIES_WORK} CACHE STRING "PETSC library to link against" FORCE)
set(PETSC_COMPILE_FLAGS "-L${PETSC_DIR}/${PETSC_ARCH}/lib" CACHE STRING "PETSC compilation flags" FORCE)
set(PETSC_LINK_FLAGS "-L${PETSC_DIR}/${PETSC_ARCH}/lib -Wl,-rpath,${PETSC_DIR}/${PETSC_ARCH}/lib" CACHE STRING "PETSC linking flags" FORCE)

# finally set a found variable
if (PETSC_INCLUDE_PATH AND PETSC_LIBRARIES)
  set(PETSC_FOUND TRUE)
else()
  set(PETSC_FOUND FALSE)
endif()
