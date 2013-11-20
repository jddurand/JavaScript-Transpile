
/* @(#)w_j0.c 1.3 95/01/18 */
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
 * wrapper fdlibm_j0(double x), fdlibm_y0(double x)
 */

#include "fdlibm.h"

#ifdef __STDC__
	double fdlibm_j0(double x)		/* wrapper fdlibm_j0 */
#else
	double fdlibm_j0(x)			/* wrapper fdlibm_j0 */
	double x;
#endif
{
#ifdef _IEEE_LIBM
	return __fdlibm_ieee754_j0(x);
#else
	double z = __fdlibm_ieee754_j0(x);
	if(_FDLIBM_LIB_VERSION == _FDLIBM_IEEE_ || fdlibm_isnan(x)) return z;
	if(fdlibm_fabs(x)>FDLIBM_X_TLOSS) {
	        return __fdlibm_kernel_standard(x,x,34); /* fdlibm_j0(|x|>FDLIBM_X_TLOSS) */
	} else
	    return z;
#endif
}

#ifdef __STDC__
	double fdlibm_y0(double x)		/* wrapper fdlibm_y0 */
#else
	double fdlibm_y0(x)			/* wrapper fdlibm_y0 */
	double x;
#endif
{
#ifdef _IEEE_LIBM
	return __fdlibm_ieee754_y0(x);
#else
	double z;
	z = __fdlibm_ieee754_y0(x);
	if(_FDLIBM_LIB_VERSION == _FDLIBM_IEEE_ || fdlibm_isnan(x) ) return z;
        if(x <= 0.0){
                if(x==0.0)
                    /* d= -one/(x-x); */
                    return __fdlibm_kernel_standard(x,x,8);
                else
                    /* d = zero/(x-x); */
                    return __fdlibm_kernel_standard(x,x,9);
        }
	if(x>FDLIBM_X_TLOSS) {
	        return __fdlibm_kernel_standard(x,x,35); /* fdlibm_y0(x>FDLIBM_X_TLOSS) */
	} else
	    return z;
#endif
}
