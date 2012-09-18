

# we need the M4 macro processor
find_program( M4_EXECUTABLE m4 DOC "The M4 macro processor" )
if( NOT M4_EXECUTABLE )
   message( SEND_ERROR "Failed to find the M4 macro processor." )
endif( NOT M4_EXECUTABLE )

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

function( ADD_M4_SOURCES _OUTVAR _M4ARGS _FILE_EXT)
   set( outfiles )
   foreach( f ${ARGN} )
     # first we might need to make the input file absolute
     get_filename_component( f "${f}" ABSOLUTE )
     # get the relative path of the file to the current source dir
     file( RELATIVE_PATH rf "${CMAKE_CURRENT_SOURCE_DIR}" "${f}" )
     # strip the .m4 off the end if present and prepend the current binary dir
     get_filename_component( file_ext ${f} EXT )
     string( REGEX REPLACE "\\${file_ext}$" "${_FILE_EXT}"  of "${CMAKE_CURRENT_BINARY_DIR}/${rf}" )
     
     # append the output file to the list of outputs
     list( APPEND outfiles "${of}" )
     # create the output directory if it doesn't exist
     get_filename_component( d "${of}" PATH )
     if( NOT IS_DIRECTORY "${d}" )
       file( MAKE_DIRECTORY "${d}" )
     endif()
     
     # now add the custom command to generate the output file
     get_filename_component(file_path ${f} PATH)
     add_custom_command( OUTPUT "${of}"
       COMMAND ${M4_EXECUTABLE} ARGS "${_M4ARGS}" "${f}" > "${of}"
       DEPENDS "${f}"
       WORKING_DIRECTORY ${file_path}
       )
   endforeach( f )
   # set the output list in the calling scope
   set( ${_OUTVAR} ${outfiles} PARENT_SCOPE )
endfunction( ADD_M4_SOURCES )
  
  