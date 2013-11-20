
/* @(#)w_hypot.c 1.3 95/01/18 */
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
 * wrapper fdlibm_hypot(x,y)
 */

#include "fdlibm.h"


#ifdef __STDC__
	double fdlibm_hypot(double x, double y)/* wrapper fdlibm_hypot */
#else
	double fdlibm_hypot(x,y)		/* wrapper fdlibm_hypot */
	double x,y;
#endif
{
#ifdef _IEEE_LIBM
	return __fdlibm_ieee754_hypot(x,y);
#else
	double z;
	z = __fdlibm_ieee754_hypot(x,y);
	if(_FDLIBM_LIB_VERSION == _FDLIBM_IEEE_) return z;
	if((!fdlibm_finite(z))&&fdlibm_finite(x)&&fdlibm_finite(y))
	    return __fdlibm_kernel_standard(x,y,4); /* fdlibm_hypot overflow */
	else
	    return z;
#endif
}
