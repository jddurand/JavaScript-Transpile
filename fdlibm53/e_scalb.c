
/* @(#)e_scalb.c 1.3 95/01/18 */
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
 * __fdlibm_ieee754_scalb(x, fn) is provide for
 * passing various standard test suite. One 
 * should use fdlibm_scalbn() instead.
 */

#include "fdlibm.h"

#ifdef _SCALB_INT
#ifdef __STDC__
	double __fdlibm_ieee754_scalb(double x, int fn)
#else
	double __fdlibm_ieee754_scalb(x,fn)
	double x; int fn;
#endif
#else
#ifdef __STDC__
	double __fdlibm_ieee754_scalb(double x, double fn)
#else
	double __fdlibm_ieee754_scalb(x,fn)
	double x, fn;
#endif
#endif
{
#ifdef _SCALB_INT
	return fdlibm_scalbn(x,fn);
#else
	if (fdlibm_isnan(x)||fdlibm_isnan(fn)) return x*fn;
	if (!fdlibm_finite(fn)) {
	    if(fn>0.0) return x*fn;
	    else       return x/(-fn);
	}
	if (fdlibm_rint(fn)!=fn) return (fn-fn)/(fn-fn);
	if ( fn > 65000.0) return fdlibm_scalbn(x, 65000);
	if (-fn > 65000.0) return fdlibm_scalbn(x,-65000);
	return fdlibm_scalbn(x,(int)fn);
#endif
}
