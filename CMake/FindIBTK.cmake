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

set(IBTK_FOUND FALSE)
# include this to handle the QUIETLY and REQUIRED arguments
include(FindPackageHandleStandardArgs)
include(GetPrerequisites)

find_path(IBTK_HEADER_PATH blitz.h
        HINTS ${IBTK_DIR}
        PATH_SUFFIXES include/blitz Inc)

set(IBTK_INCLUDE_PATH_WORK ${IBTK_HEADER_PATH})

set(IBTK_LIB "IBTK_LIB-NOTFOUND" CACHE FILEPATH "Cleared" FORCE)

if(NOT IBAMR_BUILD_SINGLE_LIBRARY)
  set(IBTK_LIBRARIES3D_NAMES ibtkutilities3D ibtklagrangian3D ibtkcoarsen_ops3D ibtkboundary3D
    ibtkmath3D ibtksolvers3D ibtkrefine_ops3D ibtkpatch_data3D ibtkfortran3D
    )
else()
  set(IBTK_LIBRARIES3D_NAMES ibtk3D)
endif()

set(IBTK_LIBRARIES_WORK)
foreach(lib ${IBTK_LIBRARIES3D_NAMES)
  find_library(IBTK_LIB
    NAMES         ${lib}
    HINTS         ${IBTK_DIR}
    PATH_SUFFIXES lib lib/${MS_IBTK_ARCH_DIR} Lib Lib/${MS_IBTK_ARCH_DIR})

  list(APPEND IBTK_LIBRARIES_WORK ${IBTK_LIB})

endforeach()

if(IBAMR_BUILD_2D_LIBRARY)
  if(NOT IBAMR_BUILD_SINGLE_LIBRARY)
    set(IBTK_LIBRARIES2D ibtkutilities2D ibtklagrangian2D ibtkcoarsen_ops2D ibtkboundary2D
      ibtkmath2D  ibtksolvers2D ibtkrefine_ops2D ibtkpatch_data2D ibtkfortran2D
      )
  else()
    set(IBTK_LIBRARIES3D_NAMES ibtk2D)
  endif()
  foreach(lib ${IBTK_LIBRARIES3D_NAMES)
  find_library(IBTK_LIB
    NAMES         ${lib}
    HINTS         ${IBTK_DIR}
    PATH_SUFFIXES lib lib/${MS_IBTK_ARCH_DIR} Lib Lib/${MS_IBTK_ARCH_DIR})

  list(APPEND IBTK_LIBRARIES_WORK ${IBTK_LIB})

endif()

set(IBTK_INCLUDE_PATH  ${IBTK_INCLUDE_PATH_WORK} CACHE STRING "IBTK include path" FORCE)
set(IBTK_LIBRARIES ${IBTK_LIBRARIES_WORK} CACHE STRING "IBTK library to link against" FORCE)
set(IBTK_COMPILE_FLAGS "-L${IBTK_DIR}/lib" CACHE STRING "IBTK compilation flags" FORCE)

# finally set a found variable
if (IBTK_INCLUDE_PATH AND IBTK_LIBRARIES)
  set(IBTK_FOUND TRUE)
else()
  set(IBTK_FOUND FALSE)
endif()
