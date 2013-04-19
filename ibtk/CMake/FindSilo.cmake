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

set(SILO_FOUND FALSE)
# include this to handle the QUIETLY and REQUIRED arguments
include(FindPackageHandleStandardArgs)
include(GetPrerequisites)

find_path(SILO_HEADER_PATH silo.h
        HINTS ${SILO_DIR}
        PATH_SUFFIXES include Inc)

set(SILO_INCLUDE_PATH_WORK ${SILO_HEADER_PATH})

set(SILO_LIB "SILO_LIB-NOTFOUND" CACHE FILEPATH "Cleared" FORCE)
find_library(SILO_LIB
  NAMES         silo
  HINTS         ${SILO_DIR}
  PATH_SUFFIXES lib lib/${MS_SILO_ARCH_DIR} Lib Lib/${MS_SILO_ARCH_DIR})
set(SILO_LIBRARIES_WORK ${SILO_LIB})

set(SILO_INCLUDE_PATH  ${SILO_INCLUDE_PATH_WORK} CACHE STRING "Silo include path" FORCE)
set(SILO_LIBRARIES ${SILO_LIBRARIES_WORK} CACHE STRING "Silo library to link against" FORCE)
set(SILO_COMPILE_FLAGS "-L${SILO_DIR}/lib" CACHE STRING "Silo compilation flags" FORCE)
# set(SILO_LINK_FLAGS -lHYPRE CACHE STRING "Silo linking flags" FORCE)

# finally set a found variable
if (SILO_INCLUDE_PATH AND SILO_LIBRARIES)
  set(SILO_FOUND TRUE)
else()
  set(SILO_FOUND FALSE)
endif()
