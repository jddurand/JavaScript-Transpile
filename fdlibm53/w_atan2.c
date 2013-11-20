
/* @(#)w_atan2.c 1.3 95/01/18 */
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
 * wrapper fdlibm_atan2(y,x)
 */

#include "fdlibm.h"


#ifdef __STDC__
	double fdlibm_atan2(double y, double x)	/* wrapper fdlibm_atan2 */
#else
	double fdlibm_atan2(y,x)			/* wrapper fdlibm_atan2 */
	double y,x;
#endif
{
#ifdef _IEEE_LIBM
	return __fdlibm_ieee754_atan2(y,x);
#else
	double z;
	z = __fdlibm_ieee754_atan2(y,x);
	if(_FDLIBM_LIB_VERSION == _FDLIBM_IEEE_||fdlibm_isnan(x)||fdlibm_isnan(y)) return z;
	if(x==0.0&&y==0.0) {
	        return __fdlibm_kernel_standard(y,x,3); /* fdlibm_atan2(+-0,+-0) */
	} else
	    return z;
#endif
}
