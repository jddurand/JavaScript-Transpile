#define PERL_NO_GET_CONTEXT
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"

#include "fdlibm.h"

#include "const-c.inc"

MODULE = JavaScript::Transpile::Fdlib		PACKAGE = JavaScript::Transpile::Fdlib		

PROTOTYPES: ENABLE

INCLUDE: const-xs.inc

double
__fdlibm_ieee754_acos(arg0)
	double	arg0

double
__fdlibm_ieee754_acosh(arg0)
	double	arg0

double
__fdlibm_ieee754_asin(arg0)
	double	arg0

double
__fdlibm_ieee754_atan2(arg0, arg1)
	double	arg0
	double	arg1

double
__fdlibm_ieee754_atanh(arg0)
	double	arg0

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
__fdlibm_ieee754_gamma(arg0)
	double	arg0

double
__fdlibm_ieee754_gamma_r(arg0, arg1)
	double	arg0
	int *	arg1

double
__fdlibm_ieee754_hypot(arg0, arg1)
	double	arg0
	double	arg1

double
__fdlibm_ieee754_j0(arg0)
	double	arg0

double
__fdlibm_ieee754_j1(arg0)
	double	arg0

double
__fdlibm_ieee754_jn(arg0, arg1)
	int	arg0
	double	arg1

double
__fdlibm_ieee754_lgamma(arg0)
	double	arg0

double
__fdlibm_ieee754_lgamma_r(arg0, arg1)
	double	arg0
	int *	arg1

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
__fdlibm_ieee754_scalb(arg0, arg1)
	double	arg0
	double	arg1

double
__fdlibm_ieee754_sinh(arg0)
	double	arg0

double
__fdlibm_ieee754_sqrt(arg0)
	double	arg0

double
__fdlibm_ieee754_y0(arg0)
	double	arg0

double
__fdlibm_ieee754_y1(arg0)
	double	arg0

double
__fdlibm_ieee754_yn(arg0, arg1)
	int	arg0
	double	arg1

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
__fdlibm_kernel_standard(arg0, arg1, arg2)
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
fdlibm_acosh(arg0)
	double	arg0

double
fdlibm_asin(arg0)
	double	arg0

double
fdlibm_asinh(arg0)
	double	arg0

double
fdlibm_atan(arg0)
	double	arg0

double
fdlibm_atan2(arg0, arg1)
	double	arg0
	double	arg1

double
fdlibm_atanh(arg0)
	double	arg0

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
fdlibm_erf(arg0)
	double	arg0

double
fdlibm_erfc(arg0)
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
fdlibm_frexp(arg0, arg1)
	double	arg0
	int *	arg1

double
fdlibm_gamma(arg0)
	double	arg0

double
fdlibm_gamma_r(arg0, arg1)
	double	arg0
	int *	arg1

double
fdlibm_hypot(arg0, arg1)
	double	arg0
	double	arg1

int
fdlibm_ilogb(arg0)
	double	arg0

int
fdlibm_isnan(arg0)
	double	arg0

double
fdlibm_j0(arg0)
	double	arg0

double
fdlibm_j1(arg0)
	double	arg0

double
fdlibm_jn(arg0, arg1)
	int	arg0
	double	arg1

double
fdlibm_ldexp(arg0, arg1)
	double	arg0
	int	arg1

double
fdlibm_lgamma(arg0)
	double	arg0

double
fdlibm_lgamma_r(arg0, arg1)
	double	arg0
	int *	arg1

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
fdlibm_logb(arg0)
	double	arg0

int
fdlibm_matherr(arg0)
	struct fdlibm_exception *	arg0

double
fdlibm_modf(arg0, arg1)
	double	arg0
	double *	arg1

double
fdlibm_nextafter(arg0, arg1)
	double	arg0
	double	arg1

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
fdlibm_scalb(arg0, arg1)
	double	arg0
	double	arg1

double
fdlibm_scalbn(arg0, arg1)
	double	arg0
	int	arg1

double
fdlibm_significand(arg0)
	double	arg0

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

double
fdlibm_y0(arg0)
	double	arg0

double
fdlibm_y1(arg0)
	double	arg0

double
fdlibm_yn(arg0, arg1)
	int	arg0
	double	arg1
