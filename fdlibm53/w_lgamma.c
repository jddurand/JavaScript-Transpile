
/* @(#)w_lgamma.c 1.3 95/01/18 */
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

/* double fdlibm_lgamma(double x)
 * Return the logarithm of the Gamma function of x.
 *
 * Method: call __fdlibm_ieee754_lgamma_r
 */

#include "fdlibm.h"

extern int fdlibm_signgam;

#ifdef __STDC__
	double fdlibm_lgamma(double x)
#else
	double fdlibm_lgamma(x)
	double x;
#endif
{
#ifdef _IEEE_LIBM
	return __fdlibm_ieee754_lgamma_r(x,&fdlibm_signgam);
#else
        double y;
        y = __fdlibm_ieee754_lgamma_r(x,&fdlibm_signgam);
        if(_FDLIBM_LIB_VERSION == _FDLIBM_IEEE_) return y;
        if(!fdlibm_finite(y)&&fdlibm_finite(x)) {
            if(fdlibm_floor(x)==x&&x<=0.0)
                return __fdlibm_kernel_standard(x,x,15); /* fdlibm_lgamma pole */
            else
                return __fdlibm_kernel_standard(x,x,14); /* fdlibm_lgamma overflow */
        } else
            return y;
#endif
}             
