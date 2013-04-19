###########################################################################
#
# Library: IBAMR
#
###########################################################################
#
# SAMRAI - Structured Adaptive Mesh Refinement Application Interface
# Copyright:   (c) 1997-2008 Lawrence Livermore National Security, LLC
#
# NOTICE
#
# This work was produced at the University of California, Lawrence Livermore
# National Laboratory (UC LLNL) under contract no. W-7405-ENG-48 (Contract 48)
# between the U.S. Department of Energy (DOE) and The Regents of the University
# of California (University) for the operation of UC LLNL. The rights of the
# Federal Government are reserved under Contract 48 subject to the restrictions
# agreed upon by the DOE and University as allowed under DOE Acquisition Letter
# 97-1.
#
# DISCLAIMER
#
# This work was prepared as an account of work sponsored by an agency of the
# United States Government. Neither the United States Government nor the
# University of California nor any of their employees, makes any warranty,
# express or implied, or assumes any liability or responsibility for the
# accuracy, completeness, or usefulness of any information, apparatus,
# product, or process disclosed, or represents that its use would not
# infringe privately-owned rights. Reference herein to any specific commercial
# products, process, or service by trade name, trademark, manufacturer or
# otherwise does not necessarily constitute or imply its endorsement,
# recommendation, or favoring by the United States Government or the
# University of California. The views and opinions of authors expressed herein
# do not necessarily state or reflect those of the United States Government or
# the University of California, and shall not be used for advertising or product
# endorsement purposes.
#
# NOTICE: COMMERCIAL USE
#
# SAMRAI is intended for research and development purposes only.
# If you wish to use this software commercially, please contact the author or
# LLNL Industrial Partnerships Office (https://ipo.llnl.gov/).
#
###########################################################################
set(SAMRAI_REGISTER
"**************************************************************************\n"
"-- Please register to use SAMRAI at:\n"
"--  https://computation.llnl.gov/casc/SAMRAI/register/get_info.html\n"
"-- **************************************************************************")
# Make sure this file is included only once
get_filename_component(CMAKE_CURRENT_LIST_FILENAME ${CMAKE_CURRENT_LIST_FILE} NAME_WE)
if(${CMAKE_CURRENT_LIST_FILENAME}_FILE_INCLUDED)
  return()
endif()
set(${CMAKE_CURRENT_LIST_FILENAME}_FILE_INCLUDED 1)

# Sanity checks
if(DEFINED SAMRAI_DIR AND NOT EXISTS ${SAMRAI_DIR})
  message(FATAL_ERROR
  "SAMRAI_DIR variable is defined but corresponds to non-existing directory")
endif()

#set(SAMRAI_enabling_variable SAMRAI_LIBRARIES)

set(SAMRAI_DEPENDENCIES "SILO;OPENMPI;HDF5")

# Include dependent projects if any
message(STATUS ${SAMRAI_REGISTER})
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

  set(IBAMRSuperBuild_CMAKE_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/CMake/SuperBuild)
  set(Samrai_source ${IBAMR_BINARY_DIR}/SuperBuild/${proj})
  set(Samrai_build ${IBAMR_BINARY_DIR}/SuperBuild/${proj}-build)

  configure_file(${IBAMRSuperBuild_CMAKE_SOURCE_DIR}/samrai_patch_step.cmake.in
    ${CMAKE_CURRENT_BINARY_DIR}/SuperBuild/samrai_patch_step.cmake
    @ONLY)

  set(Samrai_PATCH_COMMAND ${CMAKE_COMMAND}
    -P ${CMAKE_CURRENT_BINARY_DIR}/SuperBuild/samrai_patch_step.cmake)

  ExternalProject_Add(${proj}
    SOURCE_DIR ${Samrai_source}
    BINARY_DIR ${Samrai_build}
    PREFIX CMake/${proj}${ep_suffix}
    URL ${SAMRAI_URL}/${SAMRAI_GZ}
    URL_MD5 ${SAMRAI_MD5}
    PATCH_COMMAND ${Samrai_PATCH_COMMAND}
    UPDATE_COMMAND ""
    INSTALL_COMMAND make install
    CMAKE_GENERATOR ${gen}
    CMAKE_ARGS
      ${CMAKE_OSX_EXTERNAL_PROJECT_ARGS}
      -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
      -DCMAKE_CXX_FLAGS:STRING=${ep_common_cxx_flags}
      -DCMAKE_INSTALL_PREFIX:PATH=${ep_install_dir}
      -DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS}
      -DM4=${IBAMR_MODULE_PATH}/FindM4.cmake
      -DHDF5_ROOT=${ep_install_dir}
      -DSILO_ROOT=${ep_install_dir}
      -DMPI_CXX_COMPILER=${ep_install_dir}/bin/mpicxx
    LOG_DOWNLOAD 1
    LOG_CONFIGURE 1
    LOG_INSTALL 1
    LOG_PATCH 1
    DEPENDS
      ${SAMRAI_DEPENDENCIES}
    )
  set(${proj}_DIR ${IBAMR_BINARY_DIR}/${proj}-build)

else()
  msvMacroEmptyExternalProject(${proj} "${proj_DEPENDENCIES}")
endif()

list(APPEND IBAMR_SUPERBUILD_EP_ARGS
  -DSAMRAI_DIR:PATH=${ep_install_dir}/samrai )
list(APPEND IBAMR_SUPERBUILD_EP_ARGS
  -DSAMRAI_INCLUDE_PATH:PATH=${ep_install_dir}/include/samrai)
list(APPEND IBAMR_SUPERBUILD_EP_ARGS
  -DSAMRAI_FORTDIR:PATH=${ep_install_dir}/include/samrai)

list(APPEND INCLUDE_PATHS ${ep_install_dir}/include/samrai)
list(APPEND LIBRARY_PATHS ${ep_install_dir}/lib)
list(INSERT EXTERNAL_LIBRARIES 0 -lSAMRAI)
