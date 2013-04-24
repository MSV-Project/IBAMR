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

set(HDF5_FOUND FALSE)
# include this to handle the QUIETLY and REQUIRED arguments
include(FindPackageHandleStandardArgs)
include(GetPrerequisites)

find_path(HDF5_HEADER_PATH NAMES hdf5.h hdf5_hl.h
        HINTS ${HDF5_DIR}
        PATH_SUFFIXES include)

set(HDF5_INCLUDE_PATH_WORK ${HDF5_HEADER_PATH})

set(HDF5_LIB "HDF5_LIB-NOTFOUND" CACHE FILEPATH "Cleared" FORCE)
find_library(HDF5_LIB0
  NAMES         hdf5
  HINTS         ${HDF5_DIR}
  PATH_SUFFIXES lib lib/${MS_HDF5_ARCH_DIR} Lib Lib/${MS_HDF5_ARCH_DIR})
set(HDF5_LIBRARIES_WORK ${HDF5_LIB0})

find_library(HDF5_LIB1
  NAMES         hdf5_hl
  HINTS         ${HDF5_DIR}
  PATH_SUFFIXES lib lib/${MS_HDF5_ARCH_DIR} Lib Lib/${MS_HDF5_ARCH_DIR})

set(HDF5_LIBRARIES_WORK ${HDF5_LIB1} ${HDF5_LIB0})

set(HDF5_INCLUDE_PATH  ${HDF5_INCLUDE_PATH_WORK} CACHE STRING "QD include path" FORCE)
set(HDF5_LIBRARIES ${HDF5_LIBRARIES_WORK} CACHE STRING "QD library to link against" FORCE)
set(HDF5_COMPILE_FLAGS "-L${HDF5_DIR}/lib" CACHE STRING "QD compilation flags" FORCE)
# set(HDF5_LINK_FLAGS -lHYPRE CACHE STRING "Hypre linking flags" FORCE)

message("HDF5_LIBRARIES = ${HDF5_LIBRARIES}")
# finally set a found variable
if (HDF5_INCLUDE_PATH AND HDF5_LIBRARIES)
  set(HDF5_FOUND TRUE)
else()
  set(HDF5_FOUND FALSE)
endif()
