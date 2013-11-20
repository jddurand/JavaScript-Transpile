

/* @(#)w_pow.c 1.3 95/01/18 */
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
 * wrapper fdlibm_pow(x,y) return x**y
 */

#include "fdlibm.h"


#ifdef __STDC__
	double fdlibm_pow(double x, double y)	/* wrapper fdlibm_pow */
#else
	double fdlibm_pow(x,y)			/* wrapper fdlibm_pow */
	double x,y;
#endif
{
#ifdef _IEEE_LIBM
	return  __fdlibm_ieee754_pow(x,y);
#else
	double z;
	z=__fdlibm_ieee754_pow(x,y);
	if(_FDLIBM_LIB_VERSION == _FDLIBM_IEEE_|| fdlibm_isnan(y)) return z;
	if(fdlibm_isnan(x)) {
	    if(y==0.0) 
	        return __fdlibm_kernel_standard(x,y,42); /* fdlibm_pow(NaN,0.0) */
	    else 
		return z;
	}
	if(x==0.0){ 
	    if(y==0.0)
	        return __fdlibm_kernel_standard(x,y,20); /* fdlibm_pow(0.0,0.0) */
	    if(fdlibm_finite(y)&&y<0.0)
	        return __fdlibm_kernel_standard(x,y,23); /* fdlibm_pow(0.0,negative) */
	    return z;
	}
	if(!fdlibm_finite(z)) {
	    if(fdlibm_finite(x)&&fdlibm_finite(y)) {
	        if(fdlibm_isnan(z))
	            return __fdlibm_kernel_standard(x,y,24); /* fdlibm_pow neg**non-int */
	        else 
	            return __fdlibm_kernel_standard(x,y,21); /* fdlibm_pow overflow */
	    }
	} 
	if(z==0.0&&fdlibm_finite(x)&&fdlibm_finite(y))
	    return __fdlibm_kernel_standard(x,y,22); /* fdlibm_pow underflow */
	return z;
#endif
}
