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

set(BLITZ_FOUND FALSE)
# include this to handle the QUIETLY and REQUIRED arguments
include(FindPackageHandleStandardArgs)
include(GetPrerequisites)

find_path(BLITZ_HEADER_PATH blitz/blitz.h
        HINTS ${BLITZ_DIR}
        PATH_SUFFIXES include Inc)

set(BLITZ_INCLUDE_PATH_WORK ${BLITZ_HEADER_PATH})
set(BLITZ_LIB "BLITZ_LIB-NOTFOUND" CACHE FILEPATH "Cleared" FORCE)
find_library(BLITZ_LIB
  NAMES         blitz
  HINTS         ${BLITZ_DIR}
  PATH_SUFFIXES lib lib/${MS_BLITZ_ARCH_DIR} Lib Lib/${MS_BLITZ_ARCH_DIR})
set(BLITZ_LIBRARIES_WORK ${BLITZ_LIB})

set(BLITZ_INCLUDE_PATH  ${BLITZ_INCLUDE_PATH_WORK} CACHE STRING "Blitz++ include path" FORCE)
set(BLITZ_LIBRARIES ${BLITZ_LIBRARIES_WORK} CACHE STRING "Blitz++ library to link against" FORCE)
set(BLITZ_COMPILE_FLAGS "-L${BLITZ_DIR}/lib" CACHE STRING "Blitz++ compilation flags" FORCE)
# set(BLITZ_LINK_FLAGS -lHYPRE CACHE STRING "Hypre linking flags" FORCE)

# finally set a found variable
if (BLITZ_INCLUDE_PATH AND BLITZ_LIBRARIES)
  set(BLITZ_FOUND TRUE)
else()
  set(BLITZ_FOUND FALSE)
endif()
