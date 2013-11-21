
/* @(#)s_tanh.c 1.3 95/01/18 */
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

/* Tanh(x)
 * Return the Hyperbolic Tangent of x
 *
 * Method :
 *				       x    -x
 *				      e  - e
 *	0. fdlibm_tanh(x) is defined to be -----------
 *				       x    -x
 *				      e  + e
 *	1. reduce x to non-negative by fdlibm_tanh(-x) = -fdlibm_tanh(x).
 *	2.  0      <= x <= 2**-55 : fdlibm_tanh(x) := x*(one+x)
 *					        -t
 *	    2**-55 <  x <=  1     : fdlibm_tanh(x) := -----; t = fdlibm_expm1(-2x)
 *					       t + 2
 *						     2
 *	    1      <= x <=  22.0  : fdlibm_tanh(x) := 1-  ----- ; t=fdlibm_expm1(2x)
 *						   t + 2
 *	    22.0   <  x <= INF    : fdlibm_tanh(x) := 1.
 *
 * Special cases:
 *	fdlibm_tanh(NaN) is NaN;
 *	only fdlibm_tanh(0)=0 is exact for fdlibm_finite argument.
 */

#include "fdlibm.h"

#ifndef _DOUBLE_IS_32BITS

#ifdef __STDC__
static const double one=1.0, two=2.0, tiny = 1.0e-300;
#else
static double one=1.0, two=2.0, tiny = 1.0e-300;
#endif

#ifdef __STDC__
	double fdlibm_tanh(double x)
#else
	double fdlibm_tanh(x)
	double x;
#endif
{
	double t,z;
	int32_t jx,ix;

    /* High word of |x|. */
	GET_HIGH_WORD(jx,x);
	ix = jx&0x7fffffff;

    /* x is INF or NaN */
	if(ix>=0x7ff00000) { 
	    if (jx>=0) return one/x+one;    /* fdlibm_tanh(+-inf)=+-1 */
	    else       return one/x-one;    /* fdlibm_tanh(NaN) = NaN */
	}

    /* |x| < 22 */
	if (ix < 0x40360000) {		/* |x|<22 */
	    if (ix<0x3c800000) 		/* |x|<2**-55 */
		return x*(one+x);    	/* fdlibm_tanh(small) = small */
	    if (ix>=0x3ff00000) {	/* |x|>=1  */
		t = fdlibm_expm1(two*fdlibm_fabs(x));
		z = one - two/(t+two);
	    } else {
	        t = fdlibm_expm1(-two*fdlibm_fabs(x));
	        z= -t/(t+two);
	    }
    /* |x| > 22, return +-1 */
	} else {
	    z = one - tiny;		/* raised inexact flag */
	}
	return (jx>=0)? z: -z;
}
#endif /* _DOUBLE_IS_32BITS */  
