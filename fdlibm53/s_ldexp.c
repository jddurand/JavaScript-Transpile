
/* @(#)s_ldexp.c 1.3 95/01/18 */
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

#include "fdlibm.h"
#include <errno.h>

#ifdef __STDC__
	double fdlibm_ldexp(double value, int fdlibm_exp)
#else
	double fdlibm_ldexp(value, fdlibm_exp)
	double value; int fdlibm_exp;
#endif
{
	if(!fdlibm_finite(value)||value==0.0) return value;
	value = fdlibm_scalbn(value,fdlibm_exp);
	if(!fdlibm_finite(value)||value==0.0) errno = ERANGE;
	return value;
}
