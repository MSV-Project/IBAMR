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

set(QD_FOUND FALSE)
# include this to handle the QUIETLY and REQUIRED arguments
include(FindPackageHandleStandardArgs)
include(GetPrerequisites)

find_path(QD_HEADER_PATH qd_real.h
        HINTS ${QD_DIR}
        PATH_SUFFIXES include qd Inc)

set(QD_INCLUDE_PATH_WORK ${QD_HEADER_PATH})

set(QD_LIB "QD_LIB-NOTFOUND" CACHE FILEPATH "Cleared" FORCE)
find_library(QD_LIB0
  NAMES         qd
  HINTS         ${QD_DIR}
  PATH_SUFFIXES lib lib/${MS_QD_ARCH_DIR} Lib Lib/${MS_QD_ARCH_DIR})
set(QD_LIBRARIES_WORK ${QD_LIB0})

find_library(QD_LIB1
  NAMES         qdmod
  HINTS         ${QD_DIR}
  PATH_SUFFIXES lib lib/${MS_QD_ARCH_DIR} Lib Lib/${MS_QD_ARCH_DIR})

set(QD_LIBRARIES_WORK ${QD_LIB1} ${QD_LIB0})

set(QD_INCLUDE_PATH  ${QD_INCLUDE_PATH_WORK} CACHE STRING "QD include path" FORCE)
set(QD_LIBRARIES ${QD_LIBRARIES_WORK} CACHE STRING "QD library to link against" FORCE)
set(QD_COMPILE_FLAGS "-L${QD_DIR}/lib" CACHE STRING "QD compilation flags" FORCE)
# set(QD_LINK_FLAGS -lHYPRE CACHE STRING "Hypre linking flags" FORCE)

set(CMAKE_Fortran_MODULE_DIRECTORY ${QD_INCLUDE_PATH})

# finally set a found variable
if (QD_INCLUDE_PATH AND QD_LIBRARIES)
  set(QD_FOUND TRUE)
else()
  set(QD_FOUND FALSE)
endif()
