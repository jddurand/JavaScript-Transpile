
/* @(#)s_modf.c 1.3 95/01/18 */
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
 * fdlibm_modf(double x, double *iptr) 
 * return fraction part of x, and return x's integral part in *iptr.
 * Method:
 *	Bit twiddling.
 *
 * Exception:
 *	No exception.
 */

#include "fdlibm.h"

#ifdef __STDC__
static const double one = 1.0;
#else
static double one = 1.0;
#endif

#ifdef __STDC__
	double fdlibm_modf(double x, double *iptr)
#else
	double fdlibm_modf(x, iptr)
	double x,*iptr;
#endif
{
	int i0,i1,fdlibm_j0;
	unsigned i;
	i0 =  __FDLIBM_HI(x);		/* high x */
	i1 =  __FDLIBM_LO(x);		/* low  x */
	fdlibm_j0 = ((i0>>20)&0x7ff)-0x3ff;	/* exponent of x */
	if(fdlibm_j0<20) {			/* integer part in high x */
	    if(fdlibm_j0<0) {			/* |x|<1 */
		__FDLIBM_HIp(iptr) = i0&0x80000000;
		__FDLIBM_LOp(iptr) = 0;		/* *iptr = +-0 */
		return x;
	    } else {
		i = (0x000fffff)>>fdlibm_j0;
		if(((i0&i)|i1)==0) {		/* x is integral */
		    *iptr = x;
		    __FDLIBM_HI(x) &= 0x80000000;
		    __FDLIBM_LO(x)  = 0;	/* return +-0 */
		    return x;
		} else {
		    __FDLIBM_HIp(iptr) = i0&(~i);
		    __FDLIBM_LOp(iptr) = 0;
		    return x - *iptr;
		}
	    }
	} else if (fdlibm_j0>51) {		/* no fraction part */
	    *iptr = x*one;
	    __FDLIBM_HI(x) &= 0x80000000;
	    __FDLIBM_LO(x)  = 0;	/* return +-0 */
	    return x;
	} else {			/* fraction part in low x */
	    i = ((unsigned)(0xffffffff))>>(fdlibm_j0-20);
	    if((i1&i)==0) { 		/* x is integral */
		*iptr = x;
		__FDLIBM_HI(x) &= 0x80000000;
		__FDLIBM_LO(x)  = 0;	/* return +-0 */
		return x;
	    } else {
		__FDLIBM_HIp(iptr) = i0;
		__FDLIBM_LOp(iptr) = i1&(~i);
		return x - *iptr;
	    }
	}
}
