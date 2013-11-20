
/* @(#)s_rint.c 1.3 95/01/18 */
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
 * fdlibm_rint(x)
 * Return x rounded to integral value according to the prevailing
 * rounding mode.
 * Method:
 *	Using floating addition.
 * Exception:
 *	Inexact flag raised if x not equal to fdlibm_rint(x).
 */

#include "fdlibm.h"

#ifdef __STDC__
static const double
#else
static double 
#endif
TWO52[2]={
  4.50359962737049600000e+15, /* 0x43300000, 0x00000000 */
 -4.50359962737049600000e+15, /* 0xC3300000, 0x00000000 */
};

#ifdef __STDC__
	double fdlibm_rint(double x)
#else
	double fdlibm_rint(x)
	double x;
#endif
{
	int i0,fdlibm_j0,sx;
	unsigned i,i1;
	double w,t;
	i0 =  __FDLIBM_HI(x);
	sx = (i0>>31)&1;
	i1 =  __FDLIBM_LO(x);
	fdlibm_j0 = ((i0>>20)&0x7ff)-0x3ff;
	if(fdlibm_j0<20) {
	    if(fdlibm_j0<0) { 	
		if(((i0&0x7fffffff)|i1)==0) return x;
		i1 |= (i0&0x0fffff);
		i0 &= 0xfffe0000;
		i0 |= ((i1|-i1)>>12)&0x80000;
		__FDLIBM_HI(x)=i0;
	        w = TWO52[sx]+x;
	        t =  w-TWO52[sx];
	        i0 = __FDLIBM_HI(t);
	        __FDLIBM_HI(t) = (i0&0x7fffffff)|(sx<<31);
	        return t;
	    } else {
		i = (0x000fffff)>>fdlibm_j0;
		if(((i0&i)|i1)==0) return x; /* x is integral */
		i>>=1;
		if(((i0&i)|i1)!=0) {
		    if(fdlibm_j0==19) i1 = 0x40000000; else
		    i0 = (i0&(~i))|((0x20000)>>fdlibm_j0);
		}
	    }
	} else if (fdlibm_j0>51) {
	    if(fdlibm_j0==0x400) return x+x;	/* inf or NaN */
	    else return x;		/* x is integral */
	} else {
	    i = ((unsigned)(0xffffffff))>>(fdlibm_j0-20);
	    if((i1&i)==0) return x;	/* x is integral */
	    i>>=1;
	    if((i1&i)!=0) i1 = (i1&(~i))|((0x40000000)>>(fdlibm_j0-20));
	}
	__FDLIBM_HI(x) = i0;
	__FDLIBM_LO(x) = i1;
	w = TWO52[sx]+x;
	return w-TWO52[sx];
}
