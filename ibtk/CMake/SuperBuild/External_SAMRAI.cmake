###########################################################################
#
#  Library: IBTK
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

#
# SAMRAI
#

# Make sure this file is included only once
get_filename_component(CMAKE_CURRENT_LIST_FILENAME ${CMAKE_CURRENT_LIST_FILE} NAME_WE)
if(${CMAKE_CURRENT_LIST_FILENAME}_FILE_INCLUDED)
  return()
endif()
set(${CMAKE_CURRENT_LIST_FILENAME}_FILE_INCLUDED 1)

# Sanity checks
if(DEFINED SAMRAI_DIR AND NOT EXISTS ${SAMRAI_DIR})
  message(FATAL_ERROR "SAMRAI_DIR variable is defined but corresponds to non-existing directory")
endif()

#set(SAMRAI_enabling_variable SAMRAI_LIBRARIES)

set(SAMRAI_DEPENDENCIES "SILO;OPENMPI;HDF5")

# Include dependent projects if any
CheckExternalProjectDependency(SAMRAI)
set(proj SAMRAI)

if(NOT DEFINED SAMRAI_DIR)

  # Set CMake OSX variable to pass down the external project
  set(CMAKE_OSX_EXTERNAL_PROJECT_ARGS)
  if(APPLE)
    list(APPEND CMAKE_OSX_EXTERNAL_PROJECT_ARGS
      -DCMAKE_OSX_ARCHITECTURES=${CMAKE_OSX_ARCHITECTURES}
      -DCMAKE_OSX_SYSROOT=${CMAKE_OSX_SYSROOT}
      -DCMAKE_OSX_DEPLOYMENT_TARGET=${CMAKE_OSX_DEPLOYMENT_TARGET})
  endif()
  
  set(IBTKSuperBuild_CMAKE_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR})
  set(Samrai_source ${IBTK_BINARY_DIR}/SuperBuild/${proj})

  configure_file(${IBTKSuperBuild_CMAKE_SOURCE_DIR}/samrai_patch_step.cmake.in
    ${CMAKE_CURRENT_BINARY_DIR}/samrai_patch_step.cmake
    @ONLY)
    
  set(Samrai_PATCH_COMMAND ${CMAKE_COMMAND} -P ${CMAKE_CURRENT_BINARY_DIR}/samrai_patch_step.cmake)

  ExternalProject_Add(${proj}
    SOURCE_DIR ${IBTK_BINARY_DIR}/SuperBuild/${proj}
    BINARY_DIR ${IBTK_BINARY_DIR}/SuperBuild/${proj}-build
    PREFIX ${proj}${ep_suffix}
    URL ${SAMRAI_URL}/${SAMRAI_GZ}
    URL_MD5 ${SAMRAI_MD5}
    UPDATE_COMMAND ""
    INSTALL_COMMAND make install 
    PATCH_COMMAND ${Samrai_PATCH_COMMAND}
    CONFIGURE_COMMAND ${IBTK_BINARY_DIR}/SuperBuild/${proj}/configure
      "CFLAGS=${ep_common_c_flags}"
      "CXXFLAGS=${ep_common_cxx_flags}"
      "FCFLAGS=${CMAKE_F_FLAGS}"
      "FFLAGS=${CMAKE_F_FLAGS}"
      --libdir=${ep_install_dir}/lib
      --prefix=${ep_install_dir} 
      --with-CC=gcc 
      --with-CXX=g++ 
      --with-F77=gfortran 
      --with-MPICC=${ep_install_dir}/bin/mpicc 
      --with-hdf5=${ep_install_dir}
      --without-petsc 
      --without-hypre 
      --with-silo=${ep_install_dir}
      --without-blaslapack 
      --without-cubes 
      --without-eleven 
      --without-kinsol 
      --without-sundials 
      --without-x 
      --with-doxygen 
      --with-dot
      --enable-implicit-template-instantiation 
      --disable-deprecated
#     LOG_DOWNLOAD 1
    LOG_DOWNLOAD 1
    LOG_CONFIGURE 1
    LOG_TEST 1
    LOG_BUILD 1
    LOG_INSTALL 1
    DEPENDS
      ${SAMRAI_DEPENDENCIES}
    )
  set(${proj}_DIR ${IBTK_BINARY_DIR}/${proj}-build)

else()
  msvMacroEmptyExternalProject(${proj} "${proj_DEPENDENCIES}")
endif()

list(APPEND IBTK_SUPERBUILD_EP_ARGS -DSAMRAI_DIR:PATH=${ep_install_dir} )
list(APPEND IBTK_SUPERBUILD_EP_ARGS -DSAMRAI_INCLUDE_PATH:PATH=${ep_install_dir}/include)
list(APPEND IBTK_SUPERBUILD_EP_ARGS -DSAMRAI_FORTDIR:PATH=${ep_install_dir}/include)

list(APPEND INCLUDE_PATHS ${ep_install_dir}/include)
list(APPEND EXTERNAL_LIBRARIES -lSAMRAI)
set(SAMRAI_INCLUDE_PATH ${ep_install_dir}/include PARENT_SCOPE)
