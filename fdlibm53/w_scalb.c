
/* @(#)w_scalb.c 1.3 95/01/18 */
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
 * wrapper fdlibm_scalb(double x, double fn) is provide for
 * passing various standard test suite. One 
 * should use fdlibm_scalbn() instead.
 */

#include "fdlibm.h"

#include <errno.h>

#ifdef __STDC__
#ifdef _SCALB_INT
	double fdlibm_scalb(double x, int fn)		/* wrapper fdlibm_scalb */
#else
	double fdlibm_scalb(double x, double fn)	/* wrapper fdlibm_scalb */
#endif
#else
	double fdlibm_scalb(x,fn)			/* wrapper fdlibm_scalb */
#ifdef _SCALB_INT
	double x; int fn;
#else
	double x,fn;
#endif
#endif
{
#ifdef _IEEE_LIBM
	return __fdlibm_ieee754_scalb(x,fn);
#else
	double z;
	z = __fdlibm_ieee754_scalb(x,fn);
	if(_FDLIBM_LIB_VERSION == _FDLIBM_IEEE_) return z;
	if(!(fdlibm_finite(z)||fdlibm_isnan(z))&&fdlibm_finite(x)) {
	    return __fdlibm_kernel_standard(x,(double)fn,32); /* fdlibm_scalb overflow */
	}
	if(z==0.0&&z!=x) {
	    return __fdlibm_kernel_standard(x,(double)fn,33); /* fdlibm_scalb underflow */
	} 
#ifndef _SCALB_INT
	if(!fdlibm_finite(fn)) errno = ERANGE;
#endif
	return z;
#endif 
}
