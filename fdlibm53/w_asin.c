
/* @(#)w_asin.c 1.3 95/01/18 */
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
 * wrapper fdlibm_asin(x)
 */


#include "fdlibm.h"


#ifdef __STDC__
	double fdlibm_asin(double x)		/* wrapper fdlibm_asin */
#else
	double fdlibm_asin(x)			/* wrapper fdlibm_asin */
	double x;
#endif
{
#ifdef _IEEE_LIBM
	return __fdlibm_ieee754_asin(x);
#else
	double z;
	z = __fdlibm_ieee754_asin(x);
	if(_FDLIBM_LIB_VERSION == _FDLIBM_IEEE_ || fdlibm_isnan(x)) return z;
	if(fdlibm_fabs(x)>1.0) {
	        return __fdlibm_kernel_standard(x,x,2); /* fdlibm_asin(|x|>1) */
	} else
	    return z;
#endif
}
