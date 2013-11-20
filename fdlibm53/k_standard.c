
/* @(#)k_standard.c 1.3 95/01/18 */
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

#include "fdlibm.h"
#include <errno.h>

#ifndef _USE_WRITE
#include <stdio.h>			/* fputs(), stderr */
#define	WRITE2(u,v)	fputs(u, stderr)
#else	/* !defined(_USE_WRITE) */
#include <unistd.h>			/* write */
#define	WRITE2(u,v)	write(2, u, v)
#undef fflush
#endif	/* !defined(_USE_WRITE) */

static double zero = 0.0;	/* used as const */

/* 
 * Standard conformance (non-IEEE) on exception cases.
 * Mapping:
 *	1 -- fdlibm_acos(|x|>1)
 *	2 -- fdlibm_asin(|x|>1)
 *	3 -- fdlibm_atan2(+-0,+-0)
 *	4 -- fdlibm_hypot overflow
 *	5 -- fdlibm_cosh overflow
 *	6 -- fdlibm_exp overflow
 *	7 -- fdlibm_exp underflow
 *	8 -- fdlibm_y0(0)
 *	9 -- fdlibm_y0(-ve)
 *	10-- fdlibm_y1(0)
 *	11-- fdlibm_y1(-ve)
 *	12-- fdlibm_yn(0)
 *	13-- fdlibm_yn(-ve)
 *	14-- fdlibm_lgamma(fdlibm_finite) overflow
 *	15-- fdlibm_lgamma(-integer)
 *	16-- fdlibm_log(0)
 *	17-- fdlibm_log(x<0)
 *	18-- fdlibm_log10(0)
 *	19-- fdlibm_log10(x<0)
 *	20-- fdlibm_pow(0.0,0.0)
 *	21-- fdlibm_pow(x,y) overflow
 *	22-- fdlibm_pow(x,y) underflow
 *	23-- fdlibm_pow(0,negative) 
 *	24-- fdlibm_pow(neg,non-integral)
 *	25-- fdlibm_sinh(fdlibm_finite) overflow
 *	26-- fdlibm_sqrt(negative)
 *      27-- fdlibm_fmod(x,0)
 *      28-- fdlibm_remainder(x,0)
 *	29-- fdlibm_acosh(x<1)
 *	30-- fdlibm_atanh(|x|>1)
 *	31-- fdlibm_atanh(|x|=1)
 *	32-- fdlibm_scalb overflow
 *	33-- fdlibm_scalb underflow
 *	34-- fdlibm_j0(|x|>FDLIBM_X_TLOSS)
 *	35-- fdlibm_y0(x>FDLIBM_X_TLOSS)
 *	36-- fdlibm_j1(|x|>FDLIBM_X_TLOSS)
 *	37-- fdlibm_y1(x>FDLIBM_X_TLOSS)
 *	38-- fdlibm_jn(|x|>FDLIBM_X_TLOSS, n)
 *	39-- fdlibm_yn(x>FDLIBM_X_TLOSS, n)
 *	40-- fdlibm_gamma(fdlibm_finite) overflow
 *	41-- fdlibm_gamma(-integer)
 *	42-- fdlibm_pow(NaN,0.0)
 */


#ifdef __STDC__
	double __fdlibm_kernel_standard(double x, double y, int type) 
#else
	double __fdlibm_kernel_standard(x,y,type) 
	double x,y; int type;
#endif
{
	struct fdlibm_exception exc;
#ifndef HUGE_VAL	/* this is the only routine that uses HUGE_VAL */ 
#define HUGE_VAL inf
	double inf = 0.0;

	__FDLIBM_HI(inf) = 0x7ff00000;	/* set inf to infinite */
#endif

#ifdef _USE_WRITE
	(void) fflush(stdout);
#endif
	exc.arg1 = x;
	exc.arg2 = y;
	switch(type) {
	    case 1:
		/* fdlibm_acos(|x|>1) */
		exc.type = FDLIBM_DOMAIN;
		exc.name = "fdlibm_acos";
		exc.retval = zero;
		if (_FDLIBM_LIB_VERSION == _FDLIBM_POSIX_)
		  errno = EDOM;
		else if (!fdlibm_matherr(&exc)) {
		  if(_FDLIBM_LIB_VERSION == _FDLIBM_SVID_) {
		    (void) WRITE2("fdlibm_acos: FDLIBM_DOMAIN error\n", 19);
		  }
		  errno = EDOM;
		}
		break;
	    case 2:
		/* fdlibm_asin(|x|>1) */
		exc.type = FDLIBM_DOMAIN;
		exc.name = "fdlibm_asin";
		exc.retval = zero;
		if(_FDLIBM_LIB_VERSION == _FDLIBM_POSIX_)
		  errno = EDOM;
		else if (!fdlibm_matherr(&exc)) {
		  if(_FDLIBM_LIB_VERSION == _FDLIBM_SVID_) {
		    	(void) WRITE2("fdlibm_asin: FDLIBM_DOMAIN error\n", 19);
		  }
		  errno = EDOM;
		}
		break;
	    case 3:
		/* fdlibm_atan2(+-0,+-0) */
		exc.arg1 = y;
		exc.arg2 = x;
		exc.type = FDLIBM_DOMAIN;
		exc.name = "fdlibm_atan2";
		exc.retval = zero;
		if(_FDLIBM_LIB_VERSION == _FDLIBM_POSIX_)
		  errno = EDOM;
		else if (!fdlibm_matherr(&exc)) {
		  if(_FDLIBM_LIB_VERSION == _FDLIBM_SVID_) {
			(void) WRITE2("fdlibm_atan2: FDLIBM_DOMAIN error\n", 20);
		      }
		  errno = EDOM;
		}
		break;
	    case 4:
		/* fdlibm_hypot(fdlibm_finite,fdlibm_finite) overflow */
		exc.type = FDLIBM_OVERFLOW;
		exc.name = "fdlibm_hypot";
		if (_FDLIBM_LIB_VERSION == _FDLIBM_SVID_)
		  exc.retval = FDLIBM_HUGE;
		else
		  exc.retval = HUGE_VAL;
		if (_FDLIBM_LIB_VERSION == _FDLIBM_POSIX_)
		  errno = ERANGE;
		else if (!fdlibm_matherr(&exc)) {
			errno = ERANGE;
		}
		break;
	    case 5:
		/* fdlibm_cosh(fdlibm_finite) overflow */
		exc.type = FDLIBM_OVERFLOW;
		exc.name = "fdlibm_cosh";
		if (_FDLIBM_LIB_VERSION == _FDLIBM_SVID_)
		  exc.retval = FDLIBM_HUGE;
		else
		  exc.retval = HUGE_VAL;
		if (_FDLIBM_LIB_VERSION == _FDLIBM_POSIX_)
		  errno = ERANGE;
		else if (!fdlibm_matherr(&exc)) {
			errno = ERANGE;
		}
		break;
	    case 6:
		/* fdlibm_exp(fdlibm_finite) overflow */
		exc.type = FDLIBM_OVERFLOW;
		exc.name = "fdlibm_exp";
		if (_FDLIBM_LIB_VERSION == _FDLIBM_SVID_)
		  exc.retval = FDLIBM_HUGE;
		else
		  exc.retval = HUGE_VAL;
		if (_FDLIBM_LIB_VERSION == _FDLIBM_POSIX_)
		  errno = ERANGE;
		else if (!fdlibm_matherr(&exc)) {
			errno = ERANGE;
		}
		break;
	    case 7:
		/* fdlibm_exp(fdlibm_finite) underflow */
		exc.type = FDLIBM_UNDERFLOW;
		exc.name = "fdlibm_exp";
		exc.retval = zero;
		if (_FDLIBM_LIB_VERSION == _FDLIBM_POSIX_)
		  errno = ERANGE;
		else if (!fdlibm_matherr(&exc)) {
			errno = ERANGE;
		}
		break;
	    case 8:
		/* fdlibm_y0(0) = -inf */
		exc.type = FDLIBM_DOMAIN;	/* should be FDLIBM_SING for IEEE */
		exc.name = "fdlibm_y0";
		if (_FDLIBM_LIB_VERSION == _FDLIBM_SVID_)
		  exc.retval = -FDLIBM_HUGE;
		else
		  exc.retval = -HUGE_VAL;
		if (_FDLIBM_LIB_VERSION == _FDLIBM_POSIX_)
		  errno = EDOM;
		else if (!fdlibm_matherr(&exc)) {
		  if (_FDLIBM_LIB_VERSION == _FDLIBM_SVID_) {
			(void) WRITE2("fdlibm_y0: FDLIBM_DOMAIN error\n", 17);
		      }
		  errno = EDOM;
		}
		break;
	    case 9:
		/* fdlibm_y0(x<0) = NaN */
		exc.type = FDLIBM_DOMAIN;
		exc.name = "fdlibm_y0";
		if (_FDLIBM_LIB_VERSION == _FDLIBM_SVID_)
		  exc.retval = -FDLIBM_HUGE;
		else
		  exc.retval = -HUGE_VAL;
		if (_FDLIBM_LIB_VERSION == _FDLIBM_POSIX_)
		  errno = EDOM;
		else if (!fdlibm_matherr(&exc)) {
		  if (_FDLIBM_LIB_VERSION == _FDLIBM_SVID_) {
			(void) WRITE2("fdlibm_y0: FDLIBM_DOMAIN error\n", 17);
		      }
		  errno = EDOM;
		}
		break;
	    case 10:
		/* fdlibm_y1(0) = -inf */
		exc.type = FDLIBM_DOMAIN;	/* should be FDLIBM_SING for IEEE */
		exc.name = "fdlibm_y1";
		if (_FDLIBM_LIB_VERSION == _FDLIBM_SVID_)
		  exc.retval = -FDLIBM_HUGE;
		else
		  exc.retval = -HUGE_VAL;
		if (_FDLIBM_LIB_VERSION == _FDLIBM_POSIX_)
		  errno = EDOM;
		else if (!fdlibm_matherr(&exc)) {
		  if (_FDLIBM_LIB_VERSION == _FDLIBM_SVID_) {
			(void) WRITE2("fdlibm_y1: FDLIBM_DOMAIN error\n", 17);
		      }
		  errno = EDOM;
		}
		break;
	    case 11:
		/* fdlibm_y1(x<0) = NaN */
		exc.type = FDLIBM_DOMAIN;
		exc.name = "fdlibm_y1";
		if (_FDLIBM_LIB_VERSION == _FDLIBM_SVID_)
		  exc.retval = -FDLIBM_HUGE;
		else
		  exc.retval = -HUGE_VAL;
		if (_FDLIBM_LIB_VERSION == _FDLIBM_POSIX_)
		  errno = EDOM;
		else if (!fdlibm_matherr(&exc)) {
		  if (_FDLIBM_LIB_VERSION == _FDLIBM_SVID_) {
			(void) WRITE2("fdlibm_y1: FDLIBM_DOMAIN error\n", 17);
		      }
		  errno = EDOM;
		}
		break;
	    case 12:
		/* fdlibm_yn(n,0) = -inf */
		exc.type = FDLIBM_DOMAIN;	/* should be FDLIBM_SING for IEEE */
		exc.name = "fdlibm_yn";
		if (_FDLIBM_LIB_VERSION == _FDLIBM_SVID_)
		  exc.retval = -FDLIBM_HUGE;
		else
		  exc.retval = -HUGE_VAL;
		if (_FDLIBM_LIB_VERSION == _FDLIBM_POSIX_)
		  errno = EDOM;
		else if (!fdlibm_matherr(&exc)) {
		  if (_FDLIBM_LIB_VERSION == _FDLIBM_SVID_) {
			(void) WRITE2("fdlibm_yn: FDLIBM_DOMAIN error\n", 17);
		      }
		  errno = EDOM;
		}
		break;
	    case 13:
		/* fdlibm_yn(x<0) = NaN */
		exc.type = FDLIBM_DOMAIN;
		exc.name = "fdlibm_yn";
		if (_FDLIBM_LIB_VERSION == _FDLIBM_SVID_)
		  exc.retval = -FDLIBM_HUGE;
		else
		  exc.retval = -HUGE_VAL;
		if (_FDLIBM_LIB_VERSION == _FDLIBM_POSIX_)
		  errno = EDOM;
		else if (!fdlibm_matherr(&exc)) {
		  if (_FDLIBM_LIB_VERSION == _FDLIBM_SVID_) {
			(void) WRITE2("fdlibm_yn: FDLIBM_DOMAIN error\n", 17);
		      }
		  errno = EDOM;
		}
		break;
	    case 14:
		/* fdlibm_lgamma(fdlibm_finite) overflow */
		exc.type = FDLIBM_OVERFLOW;
		exc.name = "fdlibm_lgamma";
                if (_FDLIBM_LIB_VERSION == _FDLIBM_SVID_)
                  exc.retval = FDLIBM_HUGE;
                else
                  exc.retval = HUGE_VAL;
                if (_FDLIBM_LIB_VERSION == _FDLIBM_POSIX_)
			errno = ERANGE;
                else if (!fdlibm_matherr(&exc)) {
                        errno = ERANGE;
		}
		break;
	    case 15:
		/* fdlibm_lgamma(-integer) or fdlibm_lgamma(0) */
		exc.type = FDLIBM_SING;
		exc.name = "fdlibm_lgamma";
                if (_FDLIBM_LIB_VERSION == _FDLIBM_SVID_)
                  exc.retval = FDLIBM_HUGE;
                else
                  exc.retval = HUGE_VAL;
		if (_FDLIBM_LIB_VERSION == _FDLIBM_POSIX_)
		  errno = EDOM;
		else if (!fdlibm_matherr(&exc)) {
		  if (_FDLIBM_LIB_VERSION == _FDLIBM_SVID_) {
			(void) WRITE2("fdlibm_lgamma: FDLIBM_SING error\n", 19);
		      }
		  errno = EDOM;
		}
		break;
	    case 16:
		/* fdlibm_log(0) */
		exc.type = FDLIBM_SING;
		exc.name = "fdlibm_log";
		if (_FDLIBM_LIB_VERSION == _FDLIBM_SVID_)
		  exc.retval = -FDLIBM_HUGE;
		else
		  exc.retval = -HUGE_VAL;
		if (_FDLIBM_LIB_VERSION == _FDLIBM_POSIX_)
		  errno = ERANGE;
		else if (!fdlibm_matherr(&exc)) {
		  if (_FDLIBM_LIB_VERSION == _FDLIBM_SVID_) {
			(void) WRITE2("fdlibm_log: FDLIBM_SING error\n", 16);
		      }
		  errno = EDOM;
		}
		break;
	    case 17:
		/* fdlibm_log(x<0) */
		exc.type = FDLIBM_DOMAIN;
		exc.name = "fdlibm_log";
		if (_FDLIBM_LIB_VERSION == _FDLIBM_SVID_)
		  exc.retval = -FDLIBM_HUGE;
		else
		  exc.retval = -HUGE_VAL;
		if (_FDLIBM_LIB_VERSION == _FDLIBM_POSIX_)
		  errno = EDOM;
		else if (!fdlibm_matherr(&exc)) {
		  if (_FDLIBM_LIB_VERSION == _FDLIBM_SVID_) {
			(void) WRITE2("fdlibm_log: FDLIBM_DOMAIN error\n", 18);
		      }
		  errno = EDOM;
		}
		break;
	    case 18:
		/* fdlibm_log10(0) */
		exc.type = FDLIBM_SING;
		exc.name = "fdlibm_log10";
		if (_FDLIBM_LIB_VERSION == _FDLIBM_SVID_)
		  exc.retval = -FDLIBM_HUGE;
		else
		  exc.retval = -HUGE_VAL;
		if (_FDLIBM_LIB_VERSION == _FDLIBM_POSIX_)
		  errno = ERANGE;
		else if (!fdlibm_matherr(&exc)) {
		  if (_FDLIBM_LIB_VERSION == _FDLIBM_SVID_) {
			(void) WRITE2("fdlibm_log10: FDLIBM_SING error\n", 18);
		      }
		  errno = EDOM;
		}
		break;
	    case 19:
		/* fdlibm_log10(x<0) */
		exc.type = FDLIBM_DOMAIN;
		exc.name = "fdlibm_log10";
		if (_FDLIBM_LIB_VERSION == _FDLIBM_SVID_)
		  exc.retval = -FDLIBM_HUGE;
		else
		  exc.retval = -HUGE_VAL;
		if (_FDLIBM_LIB_VERSION == _FDLIBM_POSIX_)
		  errno = EDOM;
		else if (!fdlibm_matherr(&exc)) {
		  if (_FDLIBM_LIB_VERSION == _FDLIBM_SVID_) {
			(void) WRITE2("fdlibm_log10: FDLIBM_DOMAIN error\n", 20);
		      }
		  errno = EDOM;
		}
		break;
	    case 20:
		/* fdlibm_pow(0.0,0.0) */
		/* error only if _FDLIBM_LIB_VERSION == _FDLIBM_SVID_ */
		exc.type = FDLIBM_DOMAIN;
		exc.name = "fdlibm_pow";
		exc.retval = zero;
		if (_FDLIBM_LIB_VERSION != _FDLIBM_SVID_) exc.retval = 1.0;
		else if (!fdlibm_matherr(&exc)) {
			(void) WRITE2("fdlibm_pow(0,0): FDLIBM_DOMAIN error\n", 23);
			errno = EDOM;
		}
		break;
	    case 21:
		/* fdlibm_pow(x,y) overflow */
		exc.type = FDLIBM_OVERFLOW;
		exc.name = "fdlibm_pow";
		if (_FDLIBM_LIB_VERSION == _FDLIBM_SVID_) {
		  exc.retval = FDLIBM_HUGE;
		  y *= 0.5;
		  if(x<zero&&fdlibm_rint(y)!=y) exc.retval = -FDLIBM_HUGE;
		} else {
		  exc.retval = HUGE_VAL;
		  y *= 0.5;
		  if(x<zero&&fdlibm_rint(y)!=y) exc.retval = -HUGE_VAL;
		}
		if (_FDLIBM_LIB_VERSION == _FDLIBM_POSIX_)
		  errno = ERANGE;
		else if (!fdlibm_matherr(&exc)) {
			errno = ERANGE;
		}
		break;
	    case 22:
		/* fdlibm_pow(x,y) underflow */
		exc.type = FDLIBM_UNDERFLOW;
		exc.name = "fdlibm_pow";
		exc.retval =  zero;
		if (_FDLIBM_LIB_VERSION == _FDLIBM_POSIX_)
		  errno = ERANGE;
		else if (!fdlibm_matherr(&exc)) {
			errno = ERANGE;
		}
		break;
	    case 23:
		/* 0**neg */
		exc.type = FDLIBM_DOMAIN;
		exc.name = "fdlibm_pow";
		if (_FDLIBM_LIB_VERSION == _FDLIBM_SVID_) 
		  exc.retval = zero;
		else
		  exc.retval = -HUGE_VAL;
		if (_FDLIBM_LIB_VERSION == _FDLIBM_POSIX_)
		  errno = EDOM;
		else if (!fdlibm_matherr(&exc)) {
		  if (_FDLIBM_LIB_VERSION == _FDLIBM_SVID_) {
			(void) WRITE2("fdlibm_pow(0,neg): FDLIBM_DOMAIN error\n", 25);
		      }
		  errno = EDOM;
		}
		break;
	    case 24:
		/* neg**non-integral */
		exc.type = FDLIBM_DOMAIN;
		exc.name = "fdlibm_pow";
		if (_FDLIBM_LIB_VERSION == _FDLIBM_SVID_) 
		    exc.retval = zero;
		else 
		    exc.retval = zero/zero;	/* X/Open allow NaN */
		if (_FDLIBM_LIB_VERSION == _FDLIBM_POSIX_) 
		   errno = EDOM;
		else if (!fdlibm_matherr(&exc)) {
		  if (_FDLIBM_LIB_VERSION == _FDLIBM_SVID_) {
			(void) WRITE2("neg**non-integral: FDLIBM_DOMAIN error\n", 32);
		      }
		  errno = EDOM;
		}
		break;
	    case 25:
		/* fdlibm_sinh(fdlibm_finite) overflow */
		exc.type = FDLIBM_OVERFLOW;
		exc.name = "fdlibm_sinh";
		if (_FDLIBM_LIB_VERSION == _FDLIBM_SVID_)
		  exc.retval = ( (x>zero) ? FDLIBM_HUGE : -FDLIBM_HUGE);
		else
		  exc.retval = ( (x>zero) ? HUGE_VAL : -HUGE_VAL);
		if (_FDLIBM_LIB_VERSION == _FDLIBM_POSIX_)
		  errno = ERANGE;
		else if (!fdlibm_matherr(&exc)) {
			errno = ERANGE;
		}
		break;
	    case 26:
		/* fdlibm_sqrt(x<0) */
		exc.type = FDLIBM_DOMAIN;
		exc.name = "fdlibm_sqrt";
		if (_FDLIBM_LIB_VERSION == _FDLIBM_SVID_)
		  exc.retval = zero;
		else
		  exc.retval = zero/zero;
		if (_FDLIBM_LIB_VERSION == _FDLIBM_POSIX_)
		  errno = EDOM;
		else if (!fdlibm_matherr(&exc)) {
		  if (_FDLIBM_LIB_VERSION == _FDLIBM_SVID_) {
			(void) WRITE2("fdlibm_sqrt: FDLIBM_DOMAIN error\n", 19);
		      }
		  errno = EDOM;
		}
		break;
            case 27:
                /* fdlibm_fmod(x,0) */
                exc.type = FDLIBM_DOMAIN;
                exc.name = "fdlibm_fmod";
                if (_FDLIBM_LIB_VERSION == _FDLIBM_SVID_)
                    exc.retval = x;
		else
		    exc.retval = zero/zero;
                if (_FDLIBM_LIB_VERSION == _FDLIBM_POSIX_)
                  errno = EDOM;
                else if (!fdlibm_matherr(&exc)) {
                  if (_FDLIBM_LIB_VERSION == _FDLIBM_SVID_) {
                    (void) WRITE2("fdlibm_fmod:  FDLIBM_DOMAIN error\n", 20);
                  }
                  errno = EDOM;
                }
                break;
            case 28:
                /* fdlibm_remainder(x,0) */
                exc.type = FDLIBM_DOMAIN;
                exc.name = "fdlibm_remainder";
                exc.retval = zero/zero;
                if (_FDLIBM_LIB_VERSION == _FDLIBM_POSIX_)
                  errno = EDOM;
                else if (!fdlibm_matherr(&exc)) {
                  if (_FDLIBM_LIB_VERSION == _FDLIBM_SVID_) {
                    (void) WRITE2("fdlibm_remainder: FDLIBM_DOMAIN error\n", 24);
                  }
                  errno = EDOM;
                }
                break;
            case 29:
                /* fdlibm_acosh(x<1) */
                exc.type = FDLIBM_DOMAIN;
                exc.name = "fdlibm_acosh";
                exc.retval = zero/zero;
                if (_FDLIBM_LIB_VERSION == _FDLIBM_POSIX_)
                  errno = EDOM;
                else if (!fdlibm_matherr(&exc)) {
                  if (_FDLIBM_LIB_VERSION == _FDLIBM_SVID_) {
                    (void) WRITE2("fdlibm_acosh: FDLIBM_DOMAIN error\n", 20);
                  }
                  errno = EDOM;
                }
                break;
            case 30:
                /* fdlibm_atanh(|x|>1) */
                exc.type = FDLIBM_DOMAIN;
                exc.name = "fdlibm_atanh";
                exc.retval = zero/zero;
                if (_FDLIBM_LIB_VERSION == _FDLIBM_POSIX_)
                  errno = EDOM;
                else if (!fdlibm_matherr(&exc)) {
                  if (_FDLIBM_LIB_VERSION == _FDLIBM_SVID_) {
                    (void) WRITE2("fdlibm_atanh: FDLIBM_DOMAIN error\n", 20);
                  }
                  errno = EDOM;
                }
                break;
            case 31:
                /* fdlibm_atanh(|x|=1) */
                exc.type = FDLIBM_SING;
                exc.name = "fdlibm_atanh";
		exc.retval = x/zero;	/* sign(x)*inf */
                if (_FDLIBM_LIB_VERSION == _FDLIBM_POSIX_)
                  errno = EDOM;
                else if (!fdlibm_matherr(&exc)) {
                  if (_FDLIBM_LIB_VERSION == _FDLIBM_SVID_) {
                    (void) WRITE2("fdlibm_atanh: FDLIBM_SING error\n", 18);
                  }
                  errno = EDOM;
                }
                break;
	    case 32:
		/* fdlibm_scalb overflow; SVID also returns +-HUGE_VAL */
		exc.type = FDLIBM_OVERFLOW;
		exc.name = "fdlibm_scalb";
		exc.retval = x > zero ? HUGE_VAL : -HUGE_VAL;
		if (_FDLIBM_LIB_VERSION == _FDLIBM_POSIX_)
		  errno = ERANGE;
		else if (!fdlibm_matherr(&exc)) {
			errno = ERANGE;
		}
		break;
	    case 33:
		/* fdlibm_scalb underflow */
		exc.type = FDLIBM_UNDERFLOW;
		exc.name = "fdlibm_scalb";
		exc.retval = fdlibm_copysign(zero,x);
		if (_FDLIBM_LIB_VERSION == _FDLIBM_POSIX_)
		  errno = ERANGE;
		else if (!fdlibm_matherr(&exc)) {
			errno = ERANGE;
		}
		break;
	    case 34:
		/* fdlibm_j0(|x|>FDLIBM_X_TLOSS) */
                exc.type = FDLIBM_TLOSS;
                exc.name = "fdlibm_j0";
                exc.retval = zero;
                if (_FDLIBM_LIB_VERSION == _FDLIBM_POSIX_)
                        errno = ERANGE;
                else if (!fdlibm_matherr(&exc)) {
                        if (_FDLIBM_LIB_VERSION == _FDLIBM_SVID_) {
                                (void) WRITE2(exc.name, 2);
                                (void) WRITE2(": FDLIBM_TLOSS error\n", 14);
                        }
                        errno = ERANGE;
                }        
		break;
	    case 35:
		/* fdlibm_y0(x>FDLIBM_X_TLOSS) */
                exc.type = FDLIBM_TLOSS;
                exc.name = "fdlibm_y0";
                exc.retval = zero;
                if (_FDLIBM_LIB_VERSION == _FDLIBM_POSIX_)
                        errno = ERANGE;
                else if (!fdlibm_matherr(&exc)) {
                        if (_FDLIBM_LIB_VERSION == _FDLIBM_SVID_) {
                                (void) WRITE2(exc.name, 2);
                                (void) WRITE2(": FDLIBM_TLOSS error\n", 14);
                        }
                        errno = ERANGE;
                }        
		break;
	    case 36:
		/* fdlibm_j1(|x|>FDLIBM_X_TLOSS) */
                exc.type = FDLIBM_TLOSS;
                exc.name = "fdlibm_j1";
                exc.retval = zero;
                if (_FDLIBM_LIB_VERSION == _FDLIBM_POSIX_)
                        errno = ERANGE;
                else if (!fdlibm_matherr(&exc)) {
                        if (_FDLIBM_LIB_VERSION == _FDLIBM_SVID_) {
                                (void) WRITE2(exc.name, 2);
                                (void) WRITE2(": FDLIBM_TLOSS error\n", 14);
                        }
                        errno = ERANGE;
                }        
		break;
	    case 37:
		/* fdlibm_y1(x>FDLIBM_X_TLOSS) */
                exc.type = FDLIBM_TLOSS;
                exc.name = "fdlibm_y1";
                exc.retval = zero;
                if (_FDLIBM_LIB_VERSION == _FDLIBM_POSIX_)
                        errno = ERANGE;
                else if (!fdlibm_matherr(&exc)) {
                        if (_FDLIBM_LIB_VERSION == _FDLIBM_SVID_) {
                                (void) WRITE2(exc.name, 2);
                                (void) WRITE2(": FDLIBM_TLOSS error\n", 14);
                        }
                        errno = ERANGE;
                }        
		break;
	    case 38:
		/* fdlibm_jn(|x|>FDLIBM_X_TLOSS) */
                exc.type = FDLIBM_TLOSS;
                exc.name = "fdlibm_jn";
                exc.retval = zero;
                if (_FDLIBM_LIB_VERSION == _FDLIBM_POSIX_)
                        errno = ERANGE;
                else if (!fdlibm_matherr(&exc)) {
                        if (_FDLIBM_LIB_VERSION == _FDLIBM_SVID_) {
                                (void) WRITE2(exc.name, 2);
                                (void) WRITE2(": FDLIBM_TLOSS error\n", 14);
                        }
                        errno = ERANGE;
                }        
		break;
	    case 39:
		/* fdlibm_yn(x>FDLIBM_X_TLOSS) */
                exc.type = FDLIBM_TLOSS;
                exc.name = "fdlibm_yn";
                exc.retval = zero;
                if (_FDLIBM_LIB_VERSION == _FDLIBM_POSIX_)
                        errno = ERANGE;
                else if (!fdlibm_matherr(&exc)) {
                        if (_FDLIBM_LIB_VERSION == _FDLIBM_SVID_) {
                                (void) WRITE2(exc.name, 2);
                                (void) WRITE2(": FDLIBM_TLOSS error\n", 14);
                        }
                        errno = ERANGE;
                }        
		break;
	    case 40:
		/* fdlibm_gamma(fdlibm_finite) overflow */
		exc.type = FDLIBM_OVERFLOW;
		exc.name = "fdlibm_gamma";
                if (_FDLIBM_LIB_VERSION == _FDLIBM_SVID_)
                  exc.retval = FDLIBM_HUGE;
                else
                  exc.retval = HUGE_VAL;
                if (_FDLIBM_LIB_VERSION == _FDLIBM_POSIX_)
		  errno = ERANGE;
                else if (!fdlibm_matherr(&exc)) {
                  errno = ERANGE;
                }
		break;
	    case 41:
		/* fdlibm_gamma(-integer) or fdlibm_gamma(0) */
		exc.type = FDLIBM_SING;
		exc.name = "fdlibm_gamma";
                if (_FDLIBM_LIB_VERSION == _FDLIBM_SVID_)
                  exc.retval = FDLIBM_HUGE;
                else
                  exc.retval = HUGE_VAL;
		if (_FDLIBM_LIB_VERSION == _FDLIBM_POSIX_)
		  errno = EDOM;
		else if (!fdlibm_matherr(&exc)) {
		  if (_FDLIBM_LIB_VERSION == _FDLIBM_SVID_) {
			(void) WRITE2("fdlibm_gamma: FDLIBM_SING error\n", 18);
		      }
		  errno = EDOM;
		}
		break;
	    case 42:
		/* fdlibm_pow(NaN,0.0) */
		/* error only if _FDLIBM_LIB_VERSION == _FDLIBM_SVID_ & _FDLIBM_XOPEN_ */
		exc.type = FDLIBM_DOMAIN;
		exc.name = "fdlibm_pow";
		exc.retval = x;
		if (_FDLIBM_LIB_VERSION == _FDLIBM_IEEE_ ||
		    _FDLIBM_LIB_VERSION == _FDLIBM_POSIX_) exc.retval = 1.0;
		else if (!fdlibm_matherr(&exc)) {
			errno = EDOM;
		}
		break;
	}
	return exc.retval; 
}
