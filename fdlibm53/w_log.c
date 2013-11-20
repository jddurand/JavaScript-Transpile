
/* @(#)w_log.c 1.3 95/01/18 */
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
 * wrapper fdlibm_log(x)
 */

#include "fdlibm.h"


#ifdef __STDC__
	double fdlibm_log(double x)		/* wrapper fdlibm_log */
#else
	double fdlibm_log(x)			/* wrapper fdlibm_log */
	double x;
#endif
{
#ifdef _IEEE_LIBM
	return __fdlibm_ieee754_log(x);
#else
	double z;
	z = __fdlibm_ieee754_log(x);
	if(_FDLIBM_LIB_VERSION == _FDLIBM_IEEE_ || fdlibm_isnan(x) || x > 0.0) return z;
	if(x==0.0)
	    return __fdlibm_kernel_standard(x,x,16); /* fdlibm_log(0) */
	else 
	    return __fdlibm_kernel_standard(x,x,17); /* fdlibm_log(x<0) */
#endif
}
