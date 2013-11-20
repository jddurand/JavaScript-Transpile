
/* @(#)s_asinh.c 1.3 95/01/18 */
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

/* fdlibm_asinh(x)
 * Method :
 *	Based on 
 *		fdlibm_asinh(x) = sign(x) * fdlibm_log [ |x| + fdlibm_sqrt(x*x+1) ]
 *	we have
 *	fdlibm_asinh(x) := x  if  1+x*x=1,
 *		 := sign(x)*(fdlibm_log(x)+ln2)) for large |x|, else
 *		 := sign(x)*fdlibm_log(2|x|+1/(|x|+fdlibm_sqrt(x*x+1))) if|x|>2, else
 *		 := sign(x)*fdlibm_log1p(|x| + x^2/(1 + fdlibm_sqrt(1+x^2)))  
 */

#include "fdlibm.h"

#ifdef __STDC__
static const double 
#else
static double 
#endif
one =  1.00000000000000000000e+00, /* 0x3FF00000, 0x00000000 */
ln2 =  6.93147180559945286227e-01, /* 0x3FE62E42, 0xFEFA39EF */
huge=  1.00000000000000000000e+300; 

#ifdef __STDC__
	double fdlibm_asinh(double x)
#else
	double fdlibm_asinh(x)
	double x;
#endif
{	
	double t,w;
	int hx,ix;
	hx = __FDLIBM_HI(x);
	ix = hx&0x7fffffff;
	if(ix>=0x7ff00000) return x+x;	/* x is inf or NaN */
	if(ix< 0x3e300000) {	/* |x|<2**-28 */
	    if(huge+x>one) return x;	/* return x inexact except 0 */
	} 
	if(ix>0x41b00000) {	/* |x| > 2**28 */
	    w = __fdlibm_ieee754_log(fdlibm_fabs(x))+ln2;
	} else if (ix>0x40000000) {	/* 2**28 > |x| > 2.0 */
	    t = fdlibm_fabs(x);
	    w = __fdlibm_ieee754_log(2.0*t+one/(fdlibm_sqrt(x*x+one)+t));
	} else {		/* 2.0 > |x| > 2**-28 */
	    t = x*x;
	    w =fdlibm_log1p(fdlibm_fabs(x)+t/(one+fdlibm_sqrt(one+t)));
	}
	if(hx>0) return w; else return -w;
}
