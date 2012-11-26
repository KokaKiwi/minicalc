# 
# Autoconf script for moulinette
# 

# Init
AC_PREREQ([2.68])
AC_INIT([minicalc], [0.1.0])
AC_LANG(C)
AC_CONFIG_HEADERS(include/[config.h])

# Options
AC_ARG_ENABLE(
    [parser-debug],
    [AS_HELP_STRING(
        [--enable-parser-debug],
        [Enable parser debugging.]
    )]
)

AS_IF(
    [test "x$enable_parser_debug" = "xyes"],
    [AC_DEFINE([YYDEBUG], [1], [Parser debugging.])],
    []
)

# Checks for programs.
AC_PROG_CC([gcc cc])
AC_PATH_TOOL([RM], [rm], [:])
AC_PATH_TOOL([INSTALL], [install], [:])
AC_PATH_TOOL([LEX], [flex lex], [:])
AC_PATH_TOOL([YACC], [yacc bison], [:])

# Checks for libraries.
AC_CHECK_LIB(gmp, __gmpz_mul_si, ,
       [AC_MSG_ERROR(
       [GNU MP not found, or not 3.1 or up, see http://gmplib.org/])])

# Checks for header files.
AC_HEADER_STDC
AC_CHECK_HEADERS([fcntl.h stdlib.h unistd.h gmp.h])

# Checks for typedefs, structures, and compiler characteristics.

# Checks for library functions.
AC_FUNC_MALLOC
AC_FUNC_MMAP
AC_CHECK_FUNCS([bzero gethostname memset munmap strcasecmp strtol])

AC_CONFIG_FILES([Makefile])
AC_OUTPUT
