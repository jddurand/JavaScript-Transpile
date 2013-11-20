
/* @(#)s_finite.c 1.3 95/01/18 */
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
 * fdlibm_finite(x) returns 1 is x is fdlibm_finite, else 0;
 * no branching!
 */

#include "fdlibm.h"

#ifdef __STDC__
	int fdlibm_finite(double x)
#else
	int fdlibm_finite(x)
	double x;
#endif
{
	int hx; 
	hx = __FDLIBM_HI(x);
	return  (unsigned)((hx&0x7fffffff)-0x7ff00000)>>31;
}