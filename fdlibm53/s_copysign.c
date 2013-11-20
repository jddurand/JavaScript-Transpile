
/* @(#)s_copysign.c 1.3 95/01/18 */
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
 * fdlibm_copysign(double x, double y)
 * fdlibm_copysign(x,y) returns a value with the magnitude of x and
 * with the sign bit of y.
 */

#include "fdlibm.h"

#ifdef __STDC__
	double fdlibm_copysign(double x, double y)
#else
	double fdlibm_copysign(x,y)
	double x,y;
#endif
{
	__FDLIBM_HI(x) = (__FDLIBM_HI(x)&0x7fffffff)|(__FDLIBM_HI(y)&0x80000000);
        return x;
}
