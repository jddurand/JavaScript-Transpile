
/* @(#)w_atanh.c 1.3 95/01/18 */
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
 * wrapper fdlibm_atanh(x)
 */

#include "fdlibm.h"


#ifdef __STDC__
	double fdlibm_atanh(double x)		/* wrapper fdlibm_atanh */
#else
	double fdlibm_atanh(x)			/* wrapper fdlibm_atanh */
	double x;
#endif
{
#ifdef _IEEE_LIBM
	return __fdlibm_ieee754_atanh(x);
#else
	double z,y;
	z = __fdlibm_ieee754_atanh(x);
	if(_FDLIBM_LIB_VERSION == _FDLIBM_IEEE_ || fdlibm_isnan(x)) return z;
	y = fdlibm_fabs(x);
	if(y>=1.0) {
	    if(y>1.0)
	        return __fdlibm_kernel_standard(x,x,30); /* fdlibm_atanh(|x|>1) */
	    else 
	        return __fdlibm_kernel_standard(x,x,31); /* fdlibm_atanh(|x|==1) */
	} else
	    return z;
#endif
}
