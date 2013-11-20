
/* @(#)w_acosh.c 1.3 95/01/18 */
/*
 * ====================================================
 * Copyright (C) 1993 by Sun Microsystems, Inc. All rights reserved.
 *
 * Developed at SunSoft, a Sun Microsystems, Inc. business.
 * Permission to use, copy, modify, and distribute this
 * software is freely granted, provided that this notice 
 * is preserved.
 * ====================================================
 *
 */

/* 
 * wrapper fdlibm_acosh(x)
 */

#include "fdlibm.h"

#ifdef __STDC__
	double fdlibm_acosh(double x)		/* wrapper fdlibm_acosh */
#else
	double fdlibm_acosh(x)			/* wrapper fdlibm_acosh */
	double x;
#endif
{
#ifdef _IEEE_LIBM
	return __fdlibm_ieee754_acosh(x);
#else
	double z;
	z = __fdlibm_ieee754_acosh(x);
	if(_FDLIBM_LIB_VERSION == _FDLIBM_IEEE_ || fdlibm_isnan(x)) return z;
	if(x<1.0) {
	        return __fdlibm_kernel_standard(x,x,29); /* fdlibm_acosh(x<1) */
	} else
	    return z;
#endif
}
