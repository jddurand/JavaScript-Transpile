
/* @(#)e_cosh.c 1.3 95/01/18 */
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

/* __fdlibm_ieee754_cosh(x)
 * Method : 
 * mathematically fdlibm_cosh(x) if defined to be (fdlibm_exp(x)+fdlibm_exp(-x))/2
 *	1. Replace x by |x| (fdlibm_cosh(x) = fdlibm_cosh(-x)). 
 *	2. 
 *		                                        [ fdlibm_exp(x) - 1 ]^2 
 *	    0        <= x <= ln2/2  :  fdlibm_cosh(x) := 1 + -------------------
 *			       			           2*fdlibm_exp(x)
 *
 *		                                  fdlibm_exp(x) +  1/fdlibm_exp(x)
 *	    ln2/2    <= x <= 22     :  fdlibm_cosh(x) := -------------------
 *			       			          2
 *	    22       <= x <= lnovft :  fdlibm_cosh(x) := fdlibm_exp(x)/2 
 *	    lnovft   <= x <= ln2ovft:  fdlibm_cosh(x) := fdlibm_exp(x/2)/2 * fdlibm_exp(x/2)
 *	    ln2ovft  <  x	    :  fdlibm_cosh(x) := huge*huge (overflow)
 *
 * Special cases:
 *	fdlibm_cosh(x) is |x| if x is +INF, -INF, or NaN.
 *	only fdlibm_cosh(0)=1 is exact for fdlibm_finite x.
 */

#include "fdlibm.h"

#ifdef __STDC__
static const double one = 1.0, half=0.5, huge = 1.0e300;
#else
static double one = 1.0, half=0.5, huge = 1.0e300;
#endif

#ifdef __STDC__
	double __fdlibm_ieee754_cosh(double x)
#else
	double __fdlibm_ieee754_cosh(x)
	double x;
#endif
{	
	double t,w;
	int ix;
	unsigned lx;

    /* High word of |x|. */
	ix = __FDLIBM_HI(x);
	ix &= 0x7fffffff;

    /* x is INF or NaN */
	if(ix>=0x7ff00000) return x*x;	

    /* |x| in [0,0.5*ln2], return 1+fdlibm_expm1(|x|)^2/(2*fdlibm_exp(|x|)) */
	if(ix<0x3fd62e43) {
	    t = fdlibm_expm1(fdlibm_fabs(x));
	    w = one+t;
	    if (ix<0x3c800000) return w;	/* fdlibm_cosh(tiny) = 1 */
	    return one+(t*t)/(w+w);
	}

    /* |x| in [0.5*ln2,22], return (fdlibm_exp(|x|)+1/fdlibm_exp(|x|)/2; */
	if (ix < 0x40360000) {
		t = __fdlibm_ieee754_exp(fdlibm_fabs(x));
		return half*t+half/t;
	}

    /* |x| in [22, fdlibm_log(maxdouble)] return half*fdlibm_exp(|x|) */
	if (ix < 0x40862E42)  return half*__fdlibm_ieee754_exp(fdlibm_fabs(x));

    /* |x| in [fdlibm_log(maxdouble), overflowthresold] */
	lx = *( (((*(unsigned*)&one)>>29)) + (unsigned*)&x);
	if (ix<0x408633CE || 
	      (ix==0x408633ce)&&(lx<=(unsigned)0x8fb9f87d)) {
	    w = __fdlibm_ieee754_exp(half*fdlibm_fabs(x));
	    t = half*w;
	    return t*w;
	}

    /* |x| > overflowthresold, fdlibm_cosh(x) overflow */
	return huge*huge;
}
