
/* @(#)e_lgamma.c 1.3 95/01/18 */
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

/* __fdlibm_ieee754_lgamma(x)
 * Return the logarithm of the Gamma function of x.
 *
 * Method: call __fdlibm_ieee754_lgamma_r
 */

#include "fdlibm.h"

extern int fdlibm_signgam;

#ifdef __STDC__
	double __fdlibm_ieee754_lgamma(double x)
#else
	double __fdlibm_ieee754_lgamma(x)
	double x;
#endif
{
	return __fdlibm_ieee754_lgamma_r(x,&fdlibm_signgam);
}
