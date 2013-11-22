
/* @(#)fdlibm.h 1.5 04/04/22 */
/*
 * ====================================================
 * Copyright (C) 2004 by Sun Microsystems, Inc. All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this
 * software is freely granted, provided that this notice 
 * is preserved.
 * ====================================================
 */

#ifndef __CLASSPATH_FDLIBM_H__
#define __CLASSPATH_FDLIBM_H__

/*
 * On AIX we need _ALL_SOURCE defined to compile/configure native-lib, but can't
 *  have it defined to compile fdlibm.  UGH.
 */
#ifdef _AIX
#undef _ALL_SOURCE
#endif

#include <config.h>
#include <stdlib.h>

/*
 * AIX includes a header that defines hz,
 * which conflicts with an fdlibm variable in some functions.
 */
#ifdef _AIX
#undef hz
#endif

/* GCJ LOCAL: Include files.  */
#include "ieeefp.h"
/* CLASSPATH LOCAL: */
#include "namespace.h"

#include "mprec.h"

/* CYGNUS LOCAL: Default to XOPEN_MODE.  */
#define _XOPEN_MODE

#ifdef __FDLIBM_P
#undef __FDLIBM_P
#endif

/* Sometimes it's necessary to define __LITTLE_ENDIAN explicitly
   but these catch some common cases. */

#if 0
#if defined(i386) || defined(i486) || \
	defined(intel) || defined(x86) || defined(i86pc) || \
	defined(__alpha) || defined(__osf__)
#define __LITTLE_ENDIAN
#endif

#ifdef __LITTLE_ENDIAN
#define __FDLIBM_HI(x) *(1+(int*)&x)
#define __FDLIBM_LO(x) *(int*)&x
#define __FDLIBM_HIp(x) *(1+(int*)x)
#define __FDLIBM_LOp(x) *(int*)x
#else
#define __FDLIBM_HI(x) *(int*)&x
#define __FDLIBM_LO(x) *(1+(int*)&x)
#define __FDLIBM_HIp(x) *(int*)x
#define __FDLIBM_LOp(x) *(1+(int*)x)
#endif
#endif

#ifdef __STDC__
#define	__FDLIBM_P(p)	p
#else
#define	__FDLIBM_P(p)	()
#endif

/*
 * ANSI/POSIX
 */

extern int fdlibm_signgam;

#define	FDLIBM_MAXFLOAT	((float)3.40282346638528860e+38)

enum fdlibm_fdversion {fdlibm_ieee = -1, fdlibm_svid, fdlibm_xopen, fdlibm_posix};

#define _FDLIBM_LIB_VERSION_TYPE enum fdlibm_fdversion
/* For pure convenience because we are building a shared lib, propagate
   the fixed version in this macro */
static int _fdlib_version = fdlibm_ieee;
#define _FDLIBM_LIB_VERSION _fdlib_version  

/* if global variable _FDLIBM_LIB_VERSION is not desirable, one may 
 * change the following to be a constant by: 
 *	#define _FDLIBM_LIB_VERSION_TYPE const enum version
 * In that case, after one initializes the value _FDLIBM_LIB_VERSION (see
 * s_lib_version.c) during compile time, it cannot be modified
 * in the middle of a program
 */ 
extern  _FDLIBM_LIB_VERSION_TYPE  _FDLIBM_LIB_VERSION;

#define _FDLIBM_IEEE_  fdlibm_ieee
#define _FDLIBM_SVID_  fdlibm_svid
#define _FDLIBM_XOPEN_ fdlibm_xopen
#define _FDLIBM_POSIX_ fdlibm_posix

struct fdlibm_exception {
	int type;
	char *name;
	double arg1;
	double arg2;
	double retval;
};

#define	FDLIBM_HUGE		FDLIBM_MAXFLOAT

/* 
 * set FDLIBM_X_TLOSS = pi*2**52, which is possibly defined in <values.h>
 * (one may replace the following line by "#include <values.h>")
 */

#define FDLIBM_X_TLOSS		1.41484755040568800000e+16 

#define	FDLIBM_DOMAIN		1
#define	FDLIBM_SING		2
#define	FDLIBM_OVERFLOW	3
#define	FDLIBM_UNDERFLOW	4
#define	FDLIBM_TLOSS		5
#define	FDLIBM_PLOSS		6

/* These typedefs are true for the targets running Java. */

#define _IEEE_LIBM

#ifdef __cplusplus
extern "C" {
#endif

/*
 * ANSI/POSIX
 */
extern double fdlibm_acos __FDLIBM_P((double));
extern double fdlibm_asin __FDLIBM_P((double));
extern double fdlibm_atan __FDLIBM_P((double));
extern double fdlibm_atan2 __FDLIBM_P((double, double));
extern double fdlibm_cos __FDLIBM_P((double));
extern double fdlibm_sin __FDLIBM_P((double));
extern double fdlibm_tan __FDLIBM_P((double));

extern double fdlibm_cosh __FDLIBM_P((double));
extern double fdlibm_sinh __FDLIBM_P((double));
extern double fdlibm_tanh __FDLIBM_P((double));

extern double fdlibm_exp __FDLIBM_P((double));
extern double fdlibm_frexp __FDLIBM_P((double, int *));
extern double fdlibm_ldexp __FDLIBM_P((double, int));
extern double fdlibm_log __FDLIBM_P((double));
extern double fdlibm_log10 __FDLIBM_P((double));
extern double fdlibm_modf __FDLIBM_P((double, double *));

extern double fdlibm_pow __FDLIBM_P((double, double));
extern double fdlibm_sqrt __FDLIBM_P((double));

extern double fdlibm_ceil __FDLIBM_P((double));
extern double fdlibm_fabs __FDLIBM_P((double));
extern double fdlibm_floor __FDLIBM_P((double));
extern double fdlibm_fmod __FDLIBM_P((double, double));

extern double fdlibm_erf __FDLIBM_P((double));
extern double fdlibm_erfc __FDLIBM_P((double));
extern double fdlibm_gamma __FDLIBM_P((double));
extern double fdlibm_hypot __FDLIBM_P((double, double));

#if !defined(fdlibm_isnan)
#define fdlibm_isnan(x) ((x) != (x))
#endif

extern int fdlibm_finite __FDLIBM_P((double));
extern double fdlibm_j0 __FDLIBM_P((double));
extern double fdlibm_j1 __FDLIBM_P((double));
extern double fdlibm_jn __FDLIBM_P((int, double));
extern double fdlibm_lgamma __FDLIBM_P((double));
extern double fdlibm_y0 __FDLIBM_P((double));
extern double fdlibm_y1 __FDLIBM_P((double));
extern double fdlibm_yn __FDLIBM_P((int, double));

extern double fdlibm_acosh __FDLIBM_P((double));
extern double fdlibm_asinh __FDLIBM_P((double));
extern double fdlibm_atanh __FDLIBM_P((double));
extern double fdlibm_cbrt __FDLIBM_P((double));
extern double fdlibm_logb __FDLIBM_P((double));
extern double fdlibm_nextafter __FDLIBM_P((double, double));
extern double fdlibm_remainder __FDLIBM_P((double, double));
#ifdef _SCALB_INT
extern double fdlibm_scalb __FDLIBM_P((double, int));
#else
extern double fdlibm_scalb __FDLIBM_P((double, double));
#endif

extern int fdlibm_matherr __FDLIBM_P((struct fdlibm_exception *));

/*
 * IEEE Test Vector
 */
extern double fdlibm_significand __FDLIBM_P((double));

/*
 * Functions callable from C, intended to support IEEE arithmetic.
 */
extern double fdlibm_copysign __FDLIBM_P((double, double));
extern int fdlibm_ilogb __FDLIBM_P((double));
extern double fdlibm_rint __FDLIBM_P((double));
extern double fdlibm_scalbn __FDLIBM_P((double, int));

/*
 * BSD math library entry points
 */
extern double fdlibm_expm1 __FDLIBM_P((double));
extern double fdlibm_log1p __FDLIBM_P((double));

/*
 * Reentrant version of fdlibm_gamma & fdlibm_lgamma; passes fdlibm_signgam back by reference
 * as the second argument; user must allocate space for fdlibm_signgam.
 */
#ifdef _REENTRANT
extern double fdlibm_gamma_r __FDLIBM_P((double, int *));
extern double fdlibm_lgamma_r __FDLIBM_P((double, int *));
#endif	/* _REENTRANT */

/* ieee style elementary functions */
extern double __fdlibm_ieee754_sqrt __FDLIBM_P((double));			
extern double __fdlibm_ieee754_acos __FDLIBM_P((double));			
extern double __fdlibm_ieee754_acosh __FDLIBM_P((double));			
extern double __fdlibm_ieee754_log __FDLIBM_P((double));			
extern double __fdlibm_ieee754_atanh __FDLIBM_P((double));			
extern double __fdlibm_ieee754_asin __FDLIBM_P((double));			
extern double __fdlibm_ieee754_atan2 __FDLIBM_P((double,double));			
extern double __fdlibm_ieee754_exp __FDLIBM_P((double));
extern double __fdlibm_ieee754_cosh __FDLIBM_P((double));
extern double __fdlibm_ieee754_fmod __FDLIBM_P((double,double));
extern double __fdlibm_ieee754_pow __FDLIBM_P((double,double));
extern double __fdlibm_ieee754_lgamma_r __FDLIBM_P((double,int *));
extern double __fdlibm_ieee754_gamma_r __FDLIBM_P((double,int *));
extern double __fdlibm_ieee754_lgamma __FDLIBM_P((double));
extern double __fdlibm_ieee754_gamma __FDLIBM_P((double));
extern double __fdlibm_ieee754_log10 __FDLIBM_P((double));
extern double __fdlibm_ieee754_sinh __FDLIBM_P((double));
extern double __fdlibm_ieee754_hypot __FDLIBM_P((double,double));
extern double __fdlibm_ieee754_j0 __FDLIBM_P((double));
extern double __fdlibm_ieee754_j1 __FDLIBM_P((double));
extern double __fdlibm_ieee754_y0 __FDLIBM_P((double));
extern double __fdlibm_ieee754_y1 __FDLIBM_P((double));
extern double __fdlibm_ieee754_jn __FDLIBM_P((int,double));
extern double __fdlibm_ieee754_yn __FDLIBM_P((int,double));
extern double __fdlibm_ieee754_remainder __FDLIBM_P((double,double));
extern int32_t    __fdlibm_ieee754_rem_pio2 __FDLIBM_P((double,double*));
#ifdef _SCALB_INT
extern double __fdlibm_ieee754_scalb __FDLIBM_P((double,int));
#else
extern double __fdlibm_ieee754_scalb __FDLIBM_P((double,double));
#endif

/* fdlibm kernel function */
extern double __fdlibm_kernel_standard __FDLIBM_P((double,double,int));	
extern double __fdlibm_kernel_sin __FDLIBM_P((double,double,int));
extern double __fdlibm_kernel_cos __FDLIBM_P((double,double));
extern double __fdlibm_kernel_tan __FDLIBM_P((double,double,int));
extern int    __fdlibm_kernel_rem_pio2 __FDLIBM_P((double*,double*,int,int,int,const int*));

/* Classpath extensions */

/* The original code used statements like  
   n0 = ((*(int*)&one)>>29)^1;             * index of high word *  
   ix0 = *(n0+(int*)&x);                   * high word of x *  
   ix1 = *((1-n0)+(int*)&x);               * low word of x *  
   to dig two 32 bit words out of the 64 bit IEEE floating point  
   value.  That is non-ANSI, and, moreover, the gcc instruction  
   scheduler gets it wrong.  We instead use the following macros.  
   Unlike the original code, we determine the endianness at compile  
   time, not at run time; I don't see much benefit to selecting  
   endianness at run time.  */  
   
#ifndef __IEEE_BIG_ENDIAN  
#ifndef __IEEE_LITTLE_ENDIAN  
#error Must define endianness  
#endif  
#endif  
   
/* A union which permits us to convert between a double and two 32 bit  
   ints.  */  
   
#ifdef __IEEE_BIG_ENDIAN  
   
  typedef union  
  {  
    double value;  
    struct  
    {  
      uint32_t msw;  
      uint32_t lsw;  
    } parts;  
  } ieee_double_shape_type;  
   
#endif  
   
#ifdef __IEEE_LITTLE_ENDIAN  
   
  typedef union  
  {  
    double value;  
    struct  
    {  
      uint32_t lsw;  
      uint32_t msw;  
    } parts;  
  } ieee_double_shape_type;  
   
#endif  
   
  /* Get two 32 bit ints from a double.  */  
   
#define EXTRACT_WORDS(ix0,ix1,d)                                  \
  do {                                                            \
    ieee_double_shape_type ew_u;                                  \
    ew_u.value = (d);                                             \
    (ix0) = ew_u.parts.msw;                                       \
    (ix1) = ew_u.parts.lsw;                                       \
  } while (0)  
        
/* Get the more significant 32 bit int from a double.  */  
        
#define GET_HIGH_WORD(i,d)                                      \
  do {                                                            \
    ieee_double_shape_type gh_u;                                  \
    gh_u.value = (d);                                             \
    (i) = gh_u.parts.msw;                                         \
  } while (0)  
        
/* Get the less significant 32 bit int from a double.  */  
        
#define GET_LOW_WORD(i,d)                                       \
  do {                                                            \
    ieee_double_shape_type gl_u;                                  \
    gl_u.value = (d);                                             \
    (i) = gl_u.parts.lsw;                                         \
  } while (0)  
        
/* Set a double from two 32 bit ints.  */  
        
#define INSERT_WORDS(d,ix0,ix1)                                 \
  do {                                                            \
    ieee_double_shape_type iw_u;                                  \
    iw_u.parts.msw = (ix0);                                       \
    iw_u.parts.lsw = (ix1);                                       \
    (d) = iw_u.value;                                             \
  } while (0)  
        
/* Set the more significant 32 bits of a double from an int.  */  
        
#define SET_HIGH_WORD(d,v)                                      \
  do {                                                            \
    ieee_double_shape_type sh_u;                                  \
    sh_u.value = (d);                                             \
    sh_u.parts.msw = (v);                                         \
    (d) = sh_u.value;                                             \
  } while (0)  
        
/* Set the less significant 32 bits of a double from an int.  */  
        
#define SET_LOW_WORD(d,v)                                       \
  do {                                                            \
    ieee_double_shape_type sl_u;                                  \
    sl_u.value = (d);                                             \
    sl_u.parts.lsw = (v);                                         \
    (d) = sl_u.value;                                             \
  } while (0)  

/* A union which permits us to convert between a float and a 32 bit
   int.  */

typedef union
{
  float value;
  uint32_t word;
} ieee_float_shape_type;

/* Get a 32 bit int from a float.  */

#define GET_FLOAT_WORD(i,d)					\
do {								\
  ieee_float_shape_type gf_u;					\
  gf_u.value = (d);						\
  (i) = gf_u.word;						\
} while (0)

/* Set a float from a 32 bit int.  */

#define SET_FLOAT_WORD(d,i)					\
do {								\
  ieee_float_shape_type sf_u;					\
  sf_u.word = (i);						\
  (d) = sf_u.value;						\
} while (0)

#ifdef __cplusplus
}
#endif

#endif /* __CLASSPATH_FDLIBM_H__ */

