
/* @(#)s_tan.c 1.3 95/01/18 */
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

/* fdlibm_tan(x)
 * Return tangent function of x.
 *
 * kernel function:
 *	__fdlibm_kernel_tan		... tangent function on [-pi/4,pi/4]
 *	__fdlibm_ieee754_rem_pio2	... argument reduction routine
 *
 * Method.
 *      Let S,C and T denote the fdlibm_sin, fdlibm_cos and fdlibm_tan respectively on 
 *	[-PI/4, +PI/4]. Reduce the argument x to fdlibm_y1+y2 = x-k*pi/2 
 *	in [-pi/4 , +pi/4], and let n = k mod 4.
 *	We have
 *
 *          n        fdlibm_sin(x)      fdlibm_cos(x)        fdlibm_tan(x)
 *     ----------------------------------------------------------
 *	    0	       S	   C		 T
 *	    1	       C	  -S		-1/T
 *	    2	      -S	  -C		 T
 *	    3	      -C	   S		-1/T
 *     ----------------------------------------------------------
 *
 * Special cases:
 *      Let trig be any of fdlibm_sin, fdlibm_cos, or fdlibm_tan.
 *      trig(+-INF)  is NaN, with signals;
 *      trig(NaN)    is that NaN;
 *
 * Accuracy:
 *	TRIG(x) returns trig(x) nearly rounded 
 */

#include "fdlibm.h"

#ifndef _DOUBLE_IS_32BITS

#ifdef __STDC__
	double fdlibm_tan(double x)
#else
	double fdlibm_tan(x)
	double x;
#endif
{
	double y[2],z=0.0;
	int32_t n, ix;

    /* High word of x. */
	GET_HIGH_WORD(ix,x);

    /* |x| ~< pi/4 */
	ix &= 0x7fffffff;
	if(ix <= 0x3fe921fb) return __fdlibm_kernel_tan(x,z,1);

    /* fdlibm_tan(Inf or NaN) is NaN */
	else if (ix>=0x7ff00000) return x-x;		/* NaN */

    /* argument reduction needed */
	else {
	    n = __fdlibm_ieee754_rem_pio2(x,y);
	    return __fdlibm_kernel_tan(y[0],y[1],1-((n&1)<<1)); /*   1 -- n even
							-1 -- n odd */
	}
}
#endif /* _DOUBLE_IS_32BITS */
