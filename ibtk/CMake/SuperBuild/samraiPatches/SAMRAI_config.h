/* include/SAMRAI_config.h.  Generated from SAMRAI_config.h.in by configure.  */
/* config/SAMRAI_config.h.in.  Generated from configure.in by autoheader.  */



#ifndef INCLUDED_SAMRAI_CONFIG_H
#define INCLUDED_SAMRAI_CONFIG_H

#define SAMRAI_VERSION_MAJOR 2
#define SAMRAI_VERSION_MINOR 4
#define SAMRAI_VERSION_PATCHLEVEL 4


/* Define if bool type is not properly supported */
/* #undef BOOL_IS_BROKEN */

/* Define if DBL_MAX is not in float.h */
/* #undef DBL_MAX_IS_BROKEN */

/* Define if DBL_SNAN is not in float.h */
#define DBL_SNAN_IS_BROKEN 1

/* Enable assertion checking for debug mode */
/* #undef DEBUG_CHECK_ASSERTIONS */

/* Initialize new memory to undefined values in debug mode */
/* #undef DEBUG_INITIALIZE_UNDEFINED */

/* Disable inlining for debug mode */
/* #undef DEBUG_NO_INLINE */

/* Define to dummy `main' function (if any) required to link to the Fortran
   libraries. */
/* #undef F77_DUMMY_MAIN */

/* Define to a macro mangling the given C identifier (in lower and upper
   case), which must not contain underscores, for linking with Fortran. */
#define F77_FUNC(name,NAME) name ## _

/* As F77_FUNC, but for C identifiers containing underscores. */
#define F77_FUNC_(name,NAME) name ## _

/* Define if F77 and FC dummy `main' functions are identical. */
/* #undef FC_DUMMY_MAIN_EQ_F77 */

/* Define if FLT_MAX is not in float.h */
/* #undef FLT_MAX_IS_BROKEN */

/* Define if FLT_SNAN is not in float.h */
#define FLT_SNAN_IS_BROKEN 1

/* FORTRAN_CAPS */
/* #undef FORTRAN_CAPS */

/* FORTRAN_DOUBLE_UNDERSCORE */
/* #undef FORTRAN_DOUBLE_UNDERSCORE */

/* FORTRAN_NO_UNDERSCORE */
/* #undef FORTRAN_NO_UNDERSCORE */

/* FORTRAN_UNDERSCORE */
/* #undef FORTRAN_UNDERSCORE */

/* BLASLAPACK library is available so use it */
/* #undef HAVE_BLASLAPACK */

/* Build SAMRAI with instantiated bool datatypes */
/* #undef HAVE_BOOL */

/* Build SAMRAI with instantiated char datatypes */
/* #undef HAVE_CHAR */

/* HAVE_CMATH */
#define HAVE_CMATH 1

/* HAVE_CMATH_ISNAN */
#define HAVE_CMATH_ISNAN 1

/* Configured with Cubes library */
/* #undef HAVE_CUBES */

/* Build SAMRAI with instantiated double-complex datatypes */
/* #undef HAVE_DCOMPLEX */

/* Configured with Eleven library */
/* #undef HAVE_ELEVEN */

/* HAVE_EXCEPTION_HANDLING */
#define HAVE_EXCEPTION_HANDLING 1

/* Build SAMRAI with instantiated float datatypes */
/* #undef HAVE_FLOAT */

/* HDF5 library is available so use it */
#define HAVE_HDF5 1

/* HYPRE library is available so use it */
/* #undef HAVE_HYPRE */

/* HAVE_INLINE_ISNAND */
/* #undef HAVE_INLINE_ISNAND */

/* Define to 1 if you have the <inttypes.h> header file. */
#define HAVE_INTTYPES_H 1

/* HAVE_IOMANIP_LEFT */
#define HAVE_IOMANIP_LEFT 1

/* HAVE_ISNAN */
/* #undef HAVE_ISNAN */

/* HAVE_ISNAND */
/* #undef HAVE_ISNAND */

/* HAVE_ISNAN_TEMPLATE */
/* #undef HAVE_ISNAN_TEMPLATE */

/* HAVE_ISO_SSTREAM */
#define HAVE_ISO_SSTREAM 1

/* Define if you have the 'mallinfo' function. */
#define HAVE_MALLINFO 1

/* HAVE_MALLOC_H */
#define HAVE_MALLOC_H 1

/* HAVE_MEMBER_FUNCTION_SPECIALIZATION */
#define HAVE_MEMBER_FUNCTION_SPECIALIZATION 1

/* Define to 1 if you have the <memory.h> header file. */
#define HAVE_MEMORY_H 1

/* MPI library is present */
#define HAVE_MPI 1

/* HAVE_NAMESPACE */
#define HAVE_NAMESPACE 1

/* HAVE_NEW_PLACEMENT_OPERATOR */
#define HAVE_NEW_PLACEMENT_OPERATOR 1

/* PETSC library is available so use it */
/* #undef HAVE_PETSC */

/* HAVE_PRAGMA_STATIC_DATA_SPECIALIZATION */
/* #undef HAVE_PRAGMA_STATIC_DATA_SPECIALIZATION */

/* SILO library is available so use it */
#define HAVE_SILO 1

/* HAVE_SSTREAM */
#define HAVE_SSTREAM 1

/* HAVE_STANDARD_STATIC_DATA_SPECIALIZATION */
#define HAVE_STANDARD_STATIC_DATA_SPECIALIZATION 1

/* HAVE_STATIC_DATA_INSTANTIATION */
#define HAVE_STATIC_DATA_INSTANTIATION 1

/* Define to 1 if you have the <stdint.h> header file. */
#define HAVE_STDINT_H 1

/* Define to 1 if you have the <stdlib.h> header file. */
#define HAVE_STDLIB_H 1

/* Define to 1 if cpp supports the ANSI # stringizing operator. */
#define HAVE_STRINGIZE 1

/* Define to 1 if you have the <strings.h> header file. */
#define HAVE_STRINGS_H 1

/* Define to 1 if you have the <string.h> header file. */
#define HAVE_STRING_H 1

/* HAVE_SUNDIALS */
/* #undef HAVE_SUNDIALS */

/* Define to 1 if you have the <sys/stat.h> header file. */
#define HAVE_SYS_STAT_H 1

/* Define to 1 if you have the <sys/types.h> header file. */
#define HAVE_SYS_TYPES_H 1

/* HAVE_TAU */
/* #undef HAVE_TAU */

/* HAVE_TEMPLATE_COMPLEX */
#define HAVE_TEMPLATE_COMPLEX 1

/* Define to 1 if you have the <unistd.h> header file. */
#define HAVE_UNISTD_H 1

/* HAVE_VAMPIR */
/* #undef HAVE_VAMPIR */

/* X11 library is present */
/* #undef HAVE_X11 */

/* "Compiling with XDR support" */
/* #undef HAVE_XDR */

/* Define if the host system is Solaris */
/* #undef HOST_OS_IS_SOLARIS */

/* Hypre library is configured for sequential mode */
/* #undef HYPRE_SEQUENTIAL */

/* "Compiling without deprecated features" */
#define INCLUDE_DEPRECATED 9999999

/* INCLUDE_TEMPLATE_IMPLEMENTATION */
#define INCLUDE_TEMPLATE_IMPLEMENTATION 1

/* Header file for iomanip */
#define IOMANIP_HEADER_FILE <iomanip>

/* The iomanip header file is broken */
/* #undef IOMANIP_IS_BROKEN */

/* Header file for iostream */
#define IOSTREAM_HEADER_FILE <iostream>

/* The iostream header file is broken */
/* #undef IOSTREAM_IS_BROKEN */

/* LACKS_CMATH */
/* #undef LACKS_CMATH */

/* LACKS_CMATH_ISNAN */
/* #undef LACKS_CMATH_ISNAN */

/* Configured without Cubes library */
#define LACKS_CUBES 1

/* Configured without Eleven library */
#define LACKS_ELEVEN 1

/* LACKS_EXCEPTION_HANDLING */
/* #undef LACKS_EXCEPTION_HANDLING */

/* Hypre library is missing */
#define LACKS_HYPRE 1

/* LACKS_INLINE_ISNAND */
/* #undef LACKS_INLINE_ISNAND */

/* LACKS_IOMANIP_LEFT */
/* #undef LACKS_IOMANIP_LEFT */

/* LACKS_ISNAN */
/* #undef LACKS_ISNAN */

/* LACKS_ISNAND */
/* #undef LACKS_ISNAND */

/* LACKS_ISNAN_TEMPLATE */
#define LACKS_ISNAN_TEMPLATE 1

/* LACKS_MEMBER_FUNCTION_SPECIALIZATION */
/* #undef LACKS_MEMBER_FUNCTION_SPECIALIZATION */

/* MPI library is missing */
/* #undef LACKS_MPI */

/* LACKS_NAMESPACE */
/* #undef LACKS_NAMESPACE */

/* LACKS_NEW_PLACEMENT_OPERATOR */
/* #undef LACKS_NEW_PLACEMENT_OPERATOR */

/* LACKS_PRAGMA_STATIC_DATA_SPECIALIZATION */
/* #undef LACKS_PRAGMA_STATIC_DATA_SPECIALIZATION */

/* LACKS_PROPER_XDR_HEADER */
#define LACKS_PROPER_XDR_HEADER 1

/* LACKS_SSTREAM */
/* #undef LACKS_SSTREAM */

/* LACKS_STANDARD_STATIC_DATA_SPECIALIZATION */
/* #undef LACKS_STANDARD_STATIC_DATA_SPECIALIZATION */

/* LACKS_STATIC_DATA_INSTANTIATION */
/* #undef LACKS_STATIC_DATA_INSTANTIATION */

/* LACKS_SUNDIALS */
#define LACKS_SUNDIALS 1

/* LACKS_TAU */
#define LACKS_TAU 1

/* LACKS_TEMPLATE_COMPLEX */
/* #undef LACKS_TEMPLATE_COMPLEX */

/* LACKS_VAMPIR */
#define LACKS_VAMPIR 1

/* X11 library is missing */
#define LACKS_X11 1

/* LACK_ISO_SSTREAM */
/* #undef LACK_ISO_SSTREAM */

/* Define if namespace is not properly supported */
/* #undef NAMESPACE_IS_BROKEN */

/* Define if NAN is not in float.h */
#define NAN_IS_BROKEN 1

/* The type ostringstream is broken */
/* #undef OSTRINGSTREAM_TYPE_IS_BROKEN */

/* The type ostrstream is broken */
#define OSTRSTREAM_TYPE_IS_BROKEN 1

/* Define to the address where bug reports for this package should be sent. */
/* #undef PACKAGE_BUGREPORT */

/* Define to the full name of this package. */
/* #undef PACKAGE_NAME */

/* Define to the full name and version of this package. */
/* #undef PACKAGE_STRING */

/* Define to the one symbol short name of this package. */
/* #undef PACKAGE_TARNAME */

/* Define to the version of this package. */
/* #undef PACKAGE_VERSION */

/* Define if restrict is not properly supported */
/* #undef RESTRICT_IS_BROKEN */

/* Define to 1 if you have the ANSI C header files. */
#define STDC_HEADERS 1

/* Header file for stl-sstream */
#define STL_SSTREAM_HEADER_FILE <sstream>

/* The stl-sstream header file is broken */
/* #undef STL_SSTREAM_IS_BROKEN */

/* Define to 1 if the X Window System is missing or not being used. */
#define X_DISPLAY_MISSING 1

/* Kludgey thing inserted by configure.in */
/* #undef _POWER */


/********************************************************************/
/********************* Hardwired defines ****************************/
/********************************************************************/

/*
 * Some compilers require cmath to be included before the regular
 * C math.h and stdlib.h headers are brought in, otherwise
 * the compiler will get conflicting definitions for the functions.
 */
#if defined(__xlC__)
#define REQUIRES_CMATH 1
#endif

#define STL_SSTREAM_HEADER_FILE <sstream>
#define LACKS_STRSTREAM

/*
 * A few things for the MSVC++ version.
 */
#ifdef _MSC_VER

/*
 * Move this bad stuff to the utility class, not POSIX
 */
#define drand48() ((double)rand()/(double)RAND_MAX)
/*
 * This is not correct, the range is wrong, need to find
 * a better solution
 */
#define mrand48() (rand())

/*
 * Some IEEE stuff is not under the normal names.
 *
 */
#define isnan _isnan

#endif

#endif

