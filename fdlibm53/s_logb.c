
/* @(#)s_logb.c 1.3 95/01/18 */
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
 * double fdlibm_logb(x)
 * IEEE 754 fdlibm_logb. Included to pass IEEE test suite. Not recommend.
 * Use fdlibm_ilogb instead.
 */

#include "fdlibm.h"

#ifdef __STDC__
	double fdlibm_logb(double x)
#else
	double fdlibm_logb(x)
	double x;
#endif
{
	int lx,ix;
	ix = (__FDLIBM_HI(x))&0x7fffffff;	/* high |x| */
	lx = __FDLIBM_LO(x);			/* low x */
	if((ix|lx)==0) return -1.0/fdlibm_fabs(x);
	if(ix>=0x7ff00000) return x*x;
	if((ix>>=20)==0) 			/* IEEE 754 fdlibm_logb */
		return -1022.0; 
	else
		return (double) (ix-1023); 
}
