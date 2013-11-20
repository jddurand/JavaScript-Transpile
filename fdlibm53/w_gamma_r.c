
/* @(#)w_gamma_r.c 1.3 95/01/18 */
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
 * wrapper double fdlibm_gamma_r(double x, int *signgamp)
 */

#include "fdlibm.h"


#ifdef __STDC__
	double fdlibm_gamma_r(double x, int *signgamp) /* wrapper fdlibm_lgamma_r */
#else
	double fdlibm_gamma_r(x,signgamp)              /* wrapper fdlibm_lgamma_r */
        double x; int *signgamp;
#endif
{
#ifdef _IEEE_LIBM
	return __fdlibm_ieee754_gamma_r(x,signgamp);
#else
        double y;
        y = __fdlibm_ieee754_gamma_r(x,signgamp);
        if(_FDLIBM_LIB_VERSION == _FDLIBM_IEEE_) return y;
        if(!fdlibm_finite(y)&&fdlibm_finite(x)) {
            if(fdlibm_floor(x)==x&&x<=0.0)
                return __fdlibm_kernel_standard(x,x,41); /* fdlibm_gamma pole */
            else
                return __fdlibm_kernel_standard(x,x,40); /* fdlibm_gamma overflow */
        } else
            return y;
#endif
}             
