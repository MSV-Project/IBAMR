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

set(MUPARSER_FOUND FALSE)
# include this to handle the QUIETLY and REQUIRED arguments
include(FindPackageHandleStandardArgs)
include(GetPrerequisites)

find_path(MUPARSER_HEADER_PATH muParser.h
        HINTS ${MUPARSER_DIR}
        PATH_SUFFIXES include Inc)

set(MUPARSER_INCLUDE_PATH_WORK ${MUPARSER_HEADER_PATH})

set(MUPARSER_LIB "MUPARSER_LIB-NOTFOUND" CACHE FILEPATH "Cleared" FORCE)
find_library(MUPARSER_LIB
  NAMES         muparser
  HINTS         ${MUPARSER_DIR}
  PATH_SUFFIXES lib lib/${MS_MUPARSER_ARCH_DIR} Lib Lib/${MS_MUPARSER_ARCH_DIR})
set(MUPARSER_LIBRARIES_WORK ${MUPARSER_LIB})

set(MUPARSER_INCLUDE_PATH  ${MUPARSER_INCLUDE_PATH_WORK} CACHE STRING "MuParser include path" FORCE)
set(MUPARSER_LIBRARIES ${MUPARSER_LIBRARIES_WORK} CACHE STRING "MuParser library to link against" FORCE)
set(MUPARSER_COMPILE_FLAGS "-L${MUPARSER_DIR}/lib" CACHE STRING "MuParser compilation flags" FORCE)
# set(MUPARSER_LINK_FLAGS -lHYPRE CACHE STRING "Hypre linking flags" FORCE)

# finally set a found variable
if (MUPARSER_INCLUDE_PATH AND MUPARSER_LIBRARIES)
  set(MUPARSER_FOUND TRUE)
else()
  set(MUPARSER_FOUND FALSE)
endif()
