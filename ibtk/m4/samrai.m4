AC_DEFUN([CONFIGURE_SAMRAI],[

if test -d "${SAMRAI_DIR}/lib" ; then
  LDFLAGS="-L${SAMRAI_DIR}/lib $LDFLAGS"
fi
if test -d "${SAMRAI_DIR}/include" ; then
  CPPFLAGS="-I${SAMRAI_DIR}/include $CPPFLAGS"
fi

AC_SUBST(SAMRAI_DIR,[${SAMRAI_DIR}])
AC_SUBST(SAMRAI_FORTDIR,[${SAMRAI_DIR}/include])

AC_CHECK_HEADER([SAMRAI_config.h],,AC_MSG_ERROR([could not find header file SAMRAI_config.h]))

AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[
#include <SAMRAI_config.h>
]], [[
#ifdef INCLUDE_TEMPLATE_IMPLEMENTATION
#if (INCLUDE_TEMPLATE_IMPLEMENTATION == 1)
asdf
#endif
#endif
]])],[SAMRAI_HAS_IMPLICIT_TEMPLATE_INSTANTIATION=false],[SAMRAI_HAS_IMPLICIT_TEMPLATE_INSTANTIATION=true])

if test "$SAMRAI_HAS_IMPLICIT_TEMPLATE_INSTANTIATION" == "false"; then
  AC_MSG_ERROR([SAMRAI must be configured with implicit template instantiation enabled
reconfigure and recompile SAMRAI with the flag --enable-implicit-template-instantiation])
fi

AC_LIB_HAVE_LINKFLAGS([SAMRAI])
LIBS="$LIBSAMRAI $LIBS"

AC_ARG_ENABLE([samrai-2d],
  AS_HELP_STRING(--enable-samrai-2d,enable optional support for two-dimensional SAMRAI objects @<:@default=yes@:>@),
  [SAMRAI2D=$enablevar], [SAMRAI2D=yes])
AM_CONDITIONAL([SAMRAI2D_ENABLED],[test "$SAMRAI2D" == "yes"])

if test "$SAMRAI2D" == "yes"; then
  AC_LIB_HAVE_LINKFLAGS([SAMRAI2d_hier])
  LIBS="$LIBSAMRAI2D_HIER $LIBS"

  AC_LIB_HAVE_LINKFLAGS([SAMRAI2d_xfer])
  LIBS="$LIBSAMRAI2D_XFER $LIBS"

  AC_LIB_HAVE_LINKFLAGS([SAMRAI2d_pdat_std])
  LIBS="$LIBSAMRAI2D_PDAT_STD $LIBS"

  AC_LIB_HAVE_LINKFLAGS([SAMRAI2d_math_std])
  LIBS="$LIBSAMRAI2D_MATH_STD $LIBS"

  AC_LIB_HAVE_LINKFLAGS([SAMRAI2d_mesh])
  LIBS="$LIBSAMRAI2D_MESH $LIBS"

  AC_LIB_HAVE_LINKFLAGS([SAMRAI2d_geom])
  LIBS="$LIBSAMRAI2D_GEOM $LIBS"

  AC_LIB_HAVE_LINKFLAGS([SAMRAI2d_solv])
  LIBS="$LIBSAMRAI2D_SOLV $LIBS"

  AC_LIB_HAVE_LINKFLAGS([SAMRAI2d_algs])
  LIBS="$LIBSAMRAI2D_ALGS $LIBS"

  AC_LIB_HAVE_LINKFLAGS([SAMRAI2d_appu])
  LIBS="$LIBSAMRAI2D_APPU $LIBS"
else
  AC_MSG_WARN([configuring without the two-dimensional SAMRAI library])
fi

AC_ARG_ENABLE([samrai-3d],
  AS_HELP_STRING(--enable-samrai-3d,enable optional support for three-dimensional SAMRAI objects @<:@default=yes@:>@),
  [SAMRAI3D=$enablevar], [SAMRAI3D=yes])
AM_CONDITIONAL([SAMRAI3D_ENABLED],[test "$SAMRAI3D" == "yes"])

if test "$SAMRAI3D" == "yes"; then
  AC_LIB_HAVE_LINKFLAGS([SAMRAI3d_hier])
  LIBS="$LIBSAMRAI3D_HIER $LIBS"

  AC_LIB_HAVE_LINKFLAGS([SAMRAI3d_xfer])
  LIBS="$LIBSAMRAI3D_XFER $LIBS"

  AC_LIB_HAVE_LINKFLAGS([SAMRAI3d_pdat_std])
  LIBS="$LIBSAMRAI3D_PDAT_STD $LIBS"

  AC_LIB_HAVE_LINKFLAGS([SAMRAI3d_math_std])
  LIBS="$LIBSAMRAI3D_MATH_STD $LIBS"

  AC_LIB_HAVE_LINKFLAGS([SAMRAI3d_mesh])
  LIBS="$LIBSAMRAI3D_MESH $LIBS"

  AC_LIB_HAVE_LINKFLAGS([SAMRAI3d_geom])
  LIBS="$LIBSAMRAI3D_GEOM $LIBS"

  AC_LIB_HAVE_LINKFLAGS([SAMRAI3d_solv])
  LIBS="$LIBSAMRAI3D_SOLV $LIBS"

  AC_LIB_HAVE_LINKFLAGS([SAMRAI3d_algs])
  LIBS="$LIBSAMRAI3D_ALGS $LIBS"

  AC_LIB_HAVE_LINKFLAGS([SAMRAI3d_appu])
  LIBS="$LIBSAMRAI3D_APPU $LIBS"
else
  AC_MSG_WARN([configuring without the three-dimensional SAMRAI library])
fi

])