#define PERL_NO_GET_CONTEXT
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "Av_CharPtrPtr.h"  /* XS_*_charPtrPtr() */

#include "ppport.h"

#include "fdlibm.h"

#include "const-c.inc"

MODULE = JavaScript::Transpile		PACKAGE = JavaScript::Transpile::Fdlibm

PROTOTYPES: ENABLE

INCLUDE: const-xs.inc

double
fdlibm_acos(arg0)
	double	arg0

double
fdlibm_asin(arg0)
	double	arg0

double
fdlibm_atan(arg0)
	double	arg0

double
fdlibm_atan2(arg0, arg1)
	double	arg0
	double	arg1

double
fdlibm_cbrt(arg0)
	double	arg0

double
fdlibm_ceil(arg0)
	double	arg0

double
fdlibm_copysign(arg0, arg1)
	double	arg0
	double	arg1

double
fdlibm_cos(arg0)
	double	arg0

double
fdlibm_cosh(arg0)
	double	arg0

double
fdlibm_exp(arg0)
	double	arg0

double
fdlibm_expm1(arg0)
	double	arg0

double
fdlibm_fabs(arg0)
	double	arg0

int
fdlibm_finite(arg0)
	double	arg0

double
fdlibm_floor(arg0)
	double	arg0

double
fdlibm_fmod(arg0, arg1)
	double	arg0
	double	arg1

double
fdlibm_hypot(arg0, arg1)
	double	arg0
	double	arg1

int
fdlibm_isnan(arg0)
	double	arg0

double
fdlibm_log(arg0)
	double	arg0

double
fdlibm_log10(arg0)
	double	arg0

double
fdlibm_log1p(arg0)
	double	arg0

double
fdlibm_pow(arg0, arg1)
	double	arg0
	double	arg1

double
fdlibm_remainder(arg0, arg1)
	double	arg0
	double	arg1

double
fdlibm_rint(arg0)
	double	arg0

double
fdlibm_scalbn(arg0, arg1)
	double	arg0
	int	arg1

double
fdlibm_sin(arg0)
	double	arg0

double
fdlibm_sinh(arg0)
	double	arg0

double
fdlibm_sqrt(arg0)
	double	arg0

double
fdlibm_tan(arg0)
	double	arg0

double
fdlibm_tanh(arg0)
	double	arg0

_Jv_Bigint *
_Jv_Balloc(p, k)
	struct _Jv_reent *	p
	int	k

void
_Jv_Bfree(p, v)
	struct _Jv_reent *	p
	_Jv_Bigint *	v

int
_Jv__mcmp(a, b)
	_Jv_Bigint *	a
	_Jv_Bigint *	b

_Jv_Bigint *
_Jv__mdiff(p, a, b)
	struct _Jv_reent *	p
	_Jv_Bigint *	a
	_Jv_Bigint *	b

double
_Jv_b2d(a, e)
	_Jv_Bigint *	a
	int *	e

_Jv_Bigint *
_Jv_d2b(p, d, e, bits)
	struct _Jv_reent *	p
	double	d
	int *	e
	int *	bits

void
_Jv_dtoa(d, mode, ndigits, decpt, sign, rve, buf, float_type)
	double	d
	int	mode
	int	ndigits
	int *	decpt
	int *	sign
	char **	rve
	char *	buf
	int	float_type

char *
_Jv_dtoa_r(ptr, d, mode, ndigits, decpt, sign, rve, float_type)
	struct _Jv_reent *	ptr
	double	d
	int	mode
	int	ndigits
	int *	decpt
	int *	sign
	char **	rve
	int	float_type

int
_Jv_hi0bits(arg0)
	unsigned long	arg0

_Jv_Bigint *
_Jv_i2b(arg0, arg1)
	struct _Jv_reent *	arg0
	int	arg1

int
_Jv_lo0bits(arg0)
	unsigned long *	arg0

_Jv_Bigint *
_Jv_lshift(p, b, k)
	struct _Jv_reent *	p
	_Jv_Bigint *	b
	int	k

_Jv_Bigint *
_Jv_mult(arg0, arg1, arg2)
	struct _Jv_reent *	arg0
	_Jv_Bigint *	arg1
	_Jv_Bigint *	arg2

_Jv_Bigint *
_Jv_multadd(p, arg1, arg2, arg3)
	struct _Jv_reent *	p
	_Jv_Bigint *	arg1
	int	arg2
	int	arg3

_Jv_Bigint *
_Jv_pow5mult(arg0, arg1, k)
	struct _Jv_reent *	arg0
	_Jv_Bigint *	arg1
	int	k

double
_Jv_ratio(a, b)
	_Jv_Bigint *	a
	_Jv_Bigint *	b

_Jv_Bigint *
_Jv_s2b(arg0, arg1, arg2, arg3, arg4)
	struct _Jv_reent *	arg0
	const char *	arg1
	int	arg2
	int	arg3
	unsigned long	arg4

double
_Jv_strtod_r(ptr, s00, se)
	struct _Jv_reent *	ptr
	const char *	s00
	char **	se

double
_Jv_ulp(x)
	double	x

MODULE = JavaScript::Transpile		PACKAGE = JavaScript::Transpile::Fdlibm::_Jv_reent		

_Jv_reent *
_to_ptr(THIS)
	_Jv_reent THIS = NO_INIT
    PROTOTYPE: $
    CODE:
	if (sv_derived_from(ST(0), "_Jv_reent")) {
	    STRLEN len;
	    char *s = SvPV((SV*)SvRV(ST(0)), len);
	    if (len != sizeof(THIS))
		croak("Size %d of packed data != expected %d",
			len, sizeof(THIS));
	    RETVAL = (_Jv_reent *)s;
	}
	else
	    croak("THIS is not of type _Jv_reent");
    OUTPUT:
	RETVAL

_Jv_reent
new(CLASS)
	char *CLASS = NO_INIT
    PROTOTYPE: $
    CODE:
	Zero((void*)&RETVAL, sizeof(RETVAL), char);
    OUTPUT:
	RETVAL

MODULE = JavaScript::Transpile		PACKAGE = JavaScript::Transpile::Fdlibm::_Jv_reentPtr		

int
_errno(THIS, __value = NO_INIT)
	_Jv_reent * THIS
	int __value
    PROTOTYPE: $;$
    CODE:
	if (items > 1)
	    THIS->_errno = __value;
	RETVAL = THIS->_errno;
    OUTPUT:
	RETVAL

struct _Jv_Bigint *
_result(THIS, __value = NO_INIT)
	_Jv_reent * THIS
	struct _Jv_Bigint * __value
    PROTOTYPE: $;$
    CODE:
	if (items > 1)
	    THIS->_result = __value;
	RETVAL = THIS->_result;
    OUTPUT:
	RETVAL

int
_result_k(THIS, __value = NO_INIT)
	_Jv_reent * THIS
	int __value
    PROTOTYPE: $;$
    CODE:
	if (items > 1)
	    THIS->_result_k = __value;
	RETVAL = THIS->_result_k;
    OUTPUT:
	RETVAL

struct _Jv_Bigint *
_p5s(THIS, __value = NO_INIT)
	_Jv_reent * THIS
	struct _Jv_Bigint * __value
    PROTOTYPE: $;$
    CODE:
	if (items > 1)
	    THIS->_p5s = __value;
	RETVAL = THIS->_p5s;
    OUTPUT:
	RETVAL

struct _Jv_Bigint **
_freelist(THIS, __value = NO_INIT)
	_Jv_reent * THIS
	struct _Jv_Bigint ** __value
    PROTOTYPE: $;$
    CODE:
	if (items > 1)
	    THIS->_freelist = __value;
	RETVAL = THIS->_freelist;
    OUTPUT:
	RETVAL

int
_max_k(THIS, __value = NO_INIT)
	_Jv_reent * THIS
	int __value
    PROTOTYPE: $;$
    CODE:
	if (items > 1)
	    THIS->_max_k = __value;
	RETVAL = THIS->_max_k;
    OUTPUT:
	RETVAL


MODULE = JavaScript::Transpile		PACKAGE = JavaScript::Transpile::Fdlibm::_Jv_Bigint		

_Jv_Bigint *
_to_ptr(THIS)
	_Jv_Bigint THIS = NO_INIT
    PROTOTYPE: $
    CODE:
	if (sv_derived_from(ST(0), "_Jv_Bigint")) {
	    STRLEN len;
	    char *s = SvPV((SV*)SvRV(ST(0)), len);
	    if (len != sizeof(THIS))
		croak("Size %d of packed data != expected %d",
			len, sizeof(THIS));
	    RETVAL = (_Jv_Bigint *)s;
	}
	else
	    croak("THIS is not of type _Jv_Bigint");
    OUTPUT:
	RETVAL

_Jv_Bigint
new(CLASS)
	char *CLASS = NO_INIT
    PROTOTYPE: $
    CODE:
	Zero((void*)&RETVAL, sizeof(RETVAL), char);
    OUTPUT:
	RETVAL

MODULE = JavaScript::Transpile		PACKAGE = JavaScript::Transpile::Fdlibm::_Jv_BigintPtr		

struct _Jv_Bigint *
_next(THIS, __value = NO_INIT)
	_Jv_Bigint * THIS
	struct _Jv_Bigint * __value
    PROTOTYPE: $;$
    CODE:
	if (items > 1)
	    THIS->_next = __value;
	RETVAL = THIS->_next;
    OUTPUT:
	RETVAL

int
_k(THIS, __value = NO_INIT)
	_Jv_Bigint * THIS
	int __value
    PROTOTYPE: $;$
    CODE:
	if (items > 1)
	    THIS->_k = __value;
	RETVAL = THIS->_k;
    OUTPUT:
	RETVAL

int
_maxwds(THIS, __value = NO_INIT)
	_Jv_Bigint * THIS
	int __value
    PROTOTYPE: $;$
    CODE:
	if (items > 1)
	    THIS->_maxwds = __value;
	RETVAL = THIS->_maxwds;
    OUTPUT:
	RETVAL

int
_sign(THIS, __value = NO_INIT)
	_Jv_Bigint * THIS
	int __value
    PROTOTYPE: $;$
    CODE:
	if (items > 1)
	    THIS->_sign = __value;
	RETVAL = THIS->_sign;
    OUTPUT:
	RETVAL

int
_wds(THIS, __value = NO_INIT)
	_Jv_Bigint * THIS
	int __value
    PROTOTYPE: $;$
    CODE:
	if (items > 1)
	    THIS->_wds = __value;
	RETVAL = THIS->_wds;
    OUTPUT:
	RETVAL

unsigned long
_x(THIS, __value = NO_INIT)
	_Jv_Bigint * THIS
	unsigned long __value
    PROTOTYPE: $;$
    CODE:
	if (items > 1)
	    THIS->_x[0] = __value;
	RETVAL = THIS->_x[0];
    OUTPUT:
	RETVAL

