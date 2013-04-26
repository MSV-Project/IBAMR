
include(CMakeParseArguments)

#
# RequiredVariables(FunctionName function KeyList key1 key2 .. keyN)
#
#        FunctionName  - Function name
#        KeyList - List of variables names to check
#
# Ensure the specified variables are not empty, otherwise a fatal error is emmited.
#
function(RequiredVariables)
  cmake_parse_arguments(RV "" "FunctionName" "KeyList" ${ARGN})
  if (RV_UNPARSED_ARGUMENTS)
      message(WARNING "${RV_FunctionName}(): Unparsed arguments: ${RV_UNPARSED_ARGUMENTS}")
  endif()
  foreach(Key ${RV_KeyList})
    if (NOT ${Key})
  string(REGEX REPLACE "[A-Za-z]+_" "" Key ${Key})
        message(FATAL_ERROR "${RV_FunctionName}(): Missing parameter: ${Key}.")
    endif()
  endforeach()
endfunction()

# - Pass a list of files through the M4 macro processor
#
# If the source files have a .m4 suffix it is stripped from the output
# file name. The output files are placed in the same relative location
# to CMAKE_CURRENT_BINARY_DIR as they are to CMAKE_CURRENT_SOURCE_DIR.
#
# Usage:
#  add_m4_sources( SRCS src/test1.m4 src/test2.m4 -DM4ARG1=arg1 .cxx )
#  add_executable( test ${SRCS} )
#

function( ParseM4Sources _VarOut)
# -- Parse arguments
  set(options
    )
  set(oneValueKeys
    FileExt
    )
  set(multiValueKeys
    InputFiles
    M4args )

  cmake_parse_arguments(PMS "${options}" "${oneValueKeys}" "${multiValueKeys}" ${ARGN} )
# -- end parse arguments

  RequiredVariables(FunctionName "ParseM4Sources" KeyList PMS_FileExt PMS_InputFiles)

#   if(PMS_M4args)
#     string(REPLACE ";" " " PMS_M4args "${PMS_M4args}")
#   endif()
  set( outfiles )
  foreach( f ${PMS_InputFiles} )
    # first we might need to make the input file absolute
    get_filename_component( f "${f}" ABSOLUTE )
    if(NOT EXISTS ${f})
      message(FATAL_ERROR "Non existent file: ${f}")
    endif()
    # get the relative path of the file to the current source dir
    file( RELATIVE_PATH rf "${CMAKE_CURRENT_SOURCE_DIR}" "${f}" )
    # strip the .m4 off the end if present and prepend the current binary dir
    get_filename_component( file_ext ${f} EXT )
    string( REGEX REPLACE "\\${file_ext}$" "${PMS_FileExt}"  of "${CMAKE_CURRENT_BINARY_DIR}/${rf}" )

    # append the output file to the list of outputs
    list( APPEND outfiles "${of}" )
    # create the output directory if it doesn't exist
    get_filename_component( d "${of}" PATH )
    if( NOT IS_DIRECTORY "${d}" )
      file( MAKE_DIRECTORY "${d}" )
    endif()

    # now add the custom command to generate the output file
    get_filename_component(file_path ${f} PATH)
#     message("f = ${f}")
#     message("of = ${of}")
    add_custom_command( OUTPUT "${of}"
      COMMAND ${M4_EXECUTABLE} ARGS ${PMS_M4args} ${f} > ${of}
      DEPENDS ${f}
      WORKING_DIRECTORY ${file_path} VERBATIM
      )
#     if(NOT EXISTS ${of})
#       message("command = ${M4_EXECUTABLE} ${PMS_M4args} ${f} > ${of}")
#       message(FATAL_ERROR "M4 failed to parse the file: ${f}")
#     endif()
  endforeach( f )
  # set the output list in the calling scope
  set( ${_VarOut} ${outfiles} PARENT_SCOPE )
endfunction( ParseM4Sources )
