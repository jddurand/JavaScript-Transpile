
/* @(#)w_cosh.c 1.3 95/01/18 */
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
 * wrapper fdlibm_cosh(x)
 */

#include "fdlibm.h"

#ifdef __STDC__
	double fdlibm_cosh(double x)		/* wrapper fdlibm_cosh */
#else
	double fdlibm_cosh(x)			/* wrapper fdlibm_cosh */
	double x;
#endif
{
#ifdef _IEEE_LIBM
	return __fdlibm_ieee754_cosh(x);
#else
	double z;
	z = __fdlibm_ieee754_cosh(x);
	if(_FDLIBM_LIB_VERSION == _FDLIBM_IEEE_ || fdlibm_isnan(x)) return z;
	if(fdlibm_fabs(x)>7.10475860073943863426e+02) {	
	        return __fdlibm_kernel_standard(x,x,5); /* fdlibm_cosh overflow */
	} else
	    return z;
#endif
}
