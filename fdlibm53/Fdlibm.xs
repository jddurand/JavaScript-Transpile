#define PERL_NO_GET_CONTEXT
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"

#include "fdlibm.h"

#include "const-c.inc"

MODULE = JavaScript::Transpile		PACKAGE = JavaScript::Transpile::Fdlibm

PROTOTYPES: ENABLE

INCLUDE: const-xs.inc

double
__fdlibm_ieee754_acos(arg0)
	double	arg0

double
__fdlibm_ieee754_asin(arg0)
	double	arg0

double
__fdlibm_ieee754_atan2(arg0, arg1)
	double	arg0
	double	arg1

double
__fdlibm_ieee754_cosh(arg0)
	double	arg0

double
__fdlibm_ieee754_exp(arg0)
	double	arg0

double
__fdlibm_ieee754_fmod(arg0, arg1)
	double	arg0
	double	arg1

double
__fdlibm_ieee754_hypot(arg0, arg1)
	double	arg0
	double	arg1

double
__fdlibm_ieee754_log(arg0)
	double	arg0

double
__fdlibm_ieee754_log10(arg0)
	double	arg0

double
__fdlibm_ieee754_pow(arg0, arg1)
	double	arg0
	double	arg1

int
__fdlibm_ieee754_rem_pio2(arg0, arg1)
	double	arg0
	double *	arg1

double
__fdlibm_ieee754_remainder(arg0, arg1)
	double	arg0
	double	arg1

double
__fdlibm_ieee754_sinh(arg0)
	double	arg0

double
__fdlibm_ieee754_sqrt(arg0)
	double	arg0

double
__fdlibm_kernel_cos(arg0, arg1)
	double	arg0
	double	arg1

int
__fdlibm_kernel_rem_pio2(arg0, arg1, arg2, arg3, arg4, arg5)
	double *	arg0
	double *	arg1
	int	arg2
	int	arg3
	int	arg4
	const int *	arg5

double
__fdlibm_kernel_sin(arg0, arg1, arg2)
	double	arg0
	double	arg1
	int	arg2

double
__fdlibm_kernel_tan(arg0, arg1, arg2)
	double	arg0
	double	arg1
	int	arg2

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
