
/* @(#)w_sqrt.c 1.3 95/01/18 */
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
 * wrapper fdlibm_sqrt(x)
 */

#include "fdlibm.h"

#ifdef __STDC__
	double fdlibm_sqrt(double x)		/* wrapper fdlibm_sqrt */
#else
	double fdlibm_sqrt(x)			/* wrapper fdlibm_sqrt */
	double x;
#endif
{
#ifdef _IEEE_LIBM
	return __fdlibm_ieee754_sqrt(x);
#else
	double z;
	z = __fdlibm_ieee754_sqrt(x);
	if(_FDLIBM_LIB_VERSION == _FDLIBM_IEEE_ || fdlibm_isnan(x)) return z;
	if(x<0.0) {
	    return __fdlibm_kernel_standard(x,x,26); /* fdlibm_sqrt(negative) */
	} else
	    return z;
#endif
}
