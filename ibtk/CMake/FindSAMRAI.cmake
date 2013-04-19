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

set(SAMRAI_FOUND FALSE)
# include this to handle the QUIETLY and REQUIRED arguments
include(FindPackageHandleStandardArgs)
include(GetPrerequisites)

find_path(SAMRAI_HEADER_PATH SAMRAI_config.h
        HINTS ${SAMRAI_DIR}
        PATH_SUFFIXES include/samrai)

set(SAMRAI_INCLUDE_PATH_WORK ${SAMRAI_HEADER_PATH})

set(SAMRAI_LIB "SAMRAI_LIB-NOTFOUND" CACHE FILEPATH "Cleared" FORCE)
find_library(SAMRAI_LIB
  NAMES         SAMRAI
  HINTS         ${SAMRAI_DIR}
  PATH_SUFFIXES lib lib/${MS_SAMRAI_ARCH_DIR} Lib Lib/${MS_SAMRAI_ARCH_DIR})
set(SAMRAI_LIBRARIES_WORK ${SAMRAI_LIB})

set(SAMRAI_INCLUDE_PATH  ${SAMRAI_INCLUDE_PATH_WORK} CACHE STRING "SAMRAI include path" FORCE)
set(SAMRAI_LIBRARIES ${SAMRAI_LIBRARIES_WORK} CACHE STRING "SAMRAI library to link against" FORCE)
set(SAMRAI_COMPILE_FLAGS "-L${SAMRAI_DIR}/lib" CACHE STRING "SAMRAI compilation flags" FORCE)
# set(SAMRAI_LINK_FLAGS -lSAMRAI CACHE STRING "SAMRAI linking flags" FORCE)

set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${SAMRAI_COMPILE_FLAGS}")

# finally set a found variable
if (SAMRAI_INCLUDE_PATH AND SAMRAI_LIBRARIES)
  set(SAMRAI_FOUND TRUE)
else()
  set(SAMRAI_FOUND FALSE)
endif()
