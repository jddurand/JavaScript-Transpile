
/* @(#)w_remainder.c 1.3 95/01/18 */
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
 * wrapper fdlibm_remainder(x,p)
 */

#include "fdlibm.h"

#ifdef __STDC__
	double fdlibm_remainder(double x, double y)	/* wrapper fdlibm_remainder */
#else
	double fdlibm_remainder(x,y)			/* wrapper fdlibm_remainder */
	double x,y;
#endif
{
#ifdef _IEEE_LIBM
	return __fdlibm_ieee754_remainder(x,y);
#else
	double z;
	z = __fdlibm_ieee754_remainder(x,y);
	if(_FDLIBM_LIB_VERSION == _FDLIBM_IEEE_ || fdlibm_isnan(y)) return z;
	if(y==0.0) 
	    return __fdlibm_kernel_standard(x,y,28); /* fdlibm_remainder(x,0) */
	else
	    return z;
#endif
}
