
/* @(#)w_fmod.c 1.3 95/01/18 */
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
 * wrapper fdlibm_fmod(x,y)
 */

#include "fdlibm.h"


#ifdef __STDC__
	double fdlibm_fmod(double x, double y)	/* wrapper fdlibm_fmod */
#else
	double fdlibm_fmod(x,y)		/* wrapper fdlibm_fmod */
	double x,y;
#endif
{
#ifdef _IEEE_LIBM
	return __fdlibm_ieee754_fmod(x,y);
#else
	double z;
	z = __fdlibm_ieee754_fmod(x,y);
	if(_FDLIBM_LIB_VERSION == _FDLIBM_IEEE_ ||fdlibm_isnan(y)||fdlibm_isnan(x)) return z;
	if(y==0.0) {
	        return __fdlibm_kernel_standard(x,y,27); /* fdlibm_fmod(x,0) */
	} else
	    return z;
#endif
}
