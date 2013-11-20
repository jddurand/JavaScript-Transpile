
/* @(#)w_acos.c 1.3 95/01/18 */
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
 * wrap_acos(x)
 */

#include "fdlibm.h"


#ifdef __STDC__
	double fdlibm_acos(double x)		/* wrapper fdlibm_acos */
#else
	double fdlibm_acos(x)			/* wrapper fdlibm_acos */
	double x;
#endif
{
#ifdef _IEEE_LIBM
	return __fdlibm_ieee754_acos(x);
#else
	double z;
	z = __fdlibm_ieee754_acos(x);
	if(_FDLIBM_LIB_VERSION == _FDLIBM_IEEE_ || fdlibm_isnan(x)) return z;
	if(fdlibm_fabs(x)>1.0) {
	        return __fdlibm_kernel_standard(x,x,1); /* fdlibm_acos(|x|>1) */
	} else
	    return z;
#endif
}
