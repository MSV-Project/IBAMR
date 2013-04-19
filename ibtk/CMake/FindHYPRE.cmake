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

set(HYPRE_FOUND FALSE)
# include this to handle the QUIETLY and REQUIRED arguments
include(FindPackageHandleStandardArgs)
include(GetPrerequisites)

find_path(HYPRE_HEADER_PATH HYPRE.h
        HINTS ${HYPRE_DIR}
        PATH_SUFFIXES include Inc)

set(HYPRE_INCLUDE_PATH_WORK ${HYPRE_HEADER_PATH})

set(HYPRE_LIB "HYPRE_LIB-NOTFOUND" CACHE FILEPATH "Cleared" FORCE)
find_library(HYPRE_LIB
  NAMES         HYPRE
  HINTS         ${HYPRE_DIR}
  PATH_SUFFIXES lib lib/${MS_HYPRE_ARCH_DIR} Lib Lib/${MS_HYPRE_ARCH_DIR})
set(HYPRE_LIBRARIES_WORK ${HYPRE_LIB})

set(HYPRE_INCLUDE_PATH  ${HYPRE_INCLUDE_PATH_WORK} CACHE STRING "Hypre include path" FORCE)
set(HYPRE_LIBRARIES ${HYPRE_LIBRARIES_WORK} CACHE STRING "Hypre library to link against" FORCE)
set(HYPRE_COMPILE_FLAGS "-L${HYPRE_DIR}/lib" CACHE STRING "Hypre compilation flags" FORCE)
# set(HYPRE_LINK_FLAGS -lHYPRE CACHE STRING "Hypre linking flags" FORCE)

# finally set a found variable
if (HYPRE_INCLUDE_PATH AND HYPRE_LIBRARIES)
  set(HYPRE_FOUND TRUE)
else()
  set(HYPRE_FOUND FALSE)
endif()
