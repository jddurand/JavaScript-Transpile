
/* @(#)w_sinh.c 1.3 95/01/18 */
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
 * wrapper fdlibm_sinh(x)
 */

#include "fdlibm.h"

#ifdef __STDC__
	double fdlibm_sinh(double x)		/* wrapper fdlibm_sinh */
#else
	double fdlibm_sinh(x)			/* wrapper fdlibm_sinh */
	double x;
#endif
{
#ifdef _IEEE_LIBM
	return __fdlibm_ieee754_sinh(x);
#else
	double z; 
	z = __fdlibm_ieee754_sinh(x);
	if(_FDLIBM_LIB_VERSION == _FDLIBM_IEEE_) return z;
	if(!fdlibm_finite(z)&&fdlibm_finite(x)) {
	    return __fdlibm_kernel_standard(x,x,25); /* fdlibm_sinh overflow */
	} else
	    return z;
#endif
}
