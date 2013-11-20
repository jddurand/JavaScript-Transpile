
/* @(#)w_log10.c 1.3 95/01/18 */
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
 * wrapper fdlibm_log10(X)
 */

#include "fdlibm.h"


#ifdef __STDC__
	double fdlibm_log10(double x)		/* wrapper fdlibm_log10 */
#else
	double fdlibm_log10(x)			/* wrapper fdlibm_log10 */
	double x;
#endif
{
#ifdef _IEEE_LIBM
	return __fdlibm_ieee754_log10(x);
#else
	double z;
	z = __fdlibm_ieee754_log10(x);
	if(_FDLIBM_LIB_VERSION == _FDLIBM_IEEE_ || fdlibm_isnan(x)) return z;
	if(x<=0.0) {
	    if(x==0.0)
	        return __fdlibm_kernel_standard(x,x,18); /* fdlibm_log10(0) */
	    else 
	        return __fdlibm_kernel_standard(x,x,19); /* fdlibm_log10(x<0) */
	} else
	    return z;
#endif
}
