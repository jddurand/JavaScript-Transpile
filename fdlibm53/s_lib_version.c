
/* @(#)s_lib_version.c 1.3 95/01/18 */
/*
 * ====================================================
 * Copyright (C) 1993 by Sun Microsystems, Inc. All rights reserved.
 *
 * Developed at SunSoft, a Sun Microsystems, Inc. business.
 * Permission to use, copy, modify, and distribute this
 * software is freely granted, provided that this notice 
 * is preserved.
 * ====================================================
 */

/*
 * MACRO for standards
 */

#include "fdlibm.h"

/*
 * define and initialize _FDLIBM_LIB_VERSION
 */
#ifdef _POSIX_MODE
enum fdlibm_fdversion _FDLIBM_LIB_VERSION = _FDLIBM_POSIX_;
#else
#ifdef _XOPEN_MODE
enum fdlibm_fdversion _FDLIBM_LIB_VERSION = _FDLIBM_XOPEN_;
#else
#ifdef _SVID3_MODE
enum fdlibm_fdversion _FDLIBM_LIB_VERSION = _FDLIBM_SVID_;
#else					/* default _IEEE_MODE */
enum fdlibm_fdversion _FDLIBM_LIB_VERSION = _FDLIBM_IEEE_;
#endif
#endif
#endif
