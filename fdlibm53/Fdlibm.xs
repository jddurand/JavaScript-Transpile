#define PERL_NO_GET_CONTEXT
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"

#include <fdlibm.h>

#include "const-c.inc"

MODULE = JavaScript::Transpile::Fdlib		PACKAGE = JavaScript::Transpile::Fdlib		

INCLUDE: const-xs.inc

double
__ieee754_acos(arg0)
	double	arg0

double
__ieee754_acosh(arg0)
	double	arg0

double
__ieee754_asin(arg0)
	double	arg0

double
__ieee754_atan2(arg0, arg1)
	double	arg0
	double	arg1

double
__ieee754_atanh(arg0)
	double	arg0

double
__ieee754_cosh(arg0)
	double	arg0

double
__ieee754_exp(arg0)
	double	arg0

double
__ieee754_fmod(arg0, arg1)
	double	arg0
	double	arg1

double
__ieee754_gamma(arg0)
	double	arg0

double
__ieee754_gamma_r(arg0, arg1)
	double	arg0
	int *	arg1

double
__ieee754_hypot(arg0, arg1)
	double	arg0
	double	arg1

double
__ieee754_j0(arg0)
	double	arg0

double
__ieee754_j1(arg0)
	double	arg0

double
__ieee754_jn(arg0, arg1)
	int	arg0
	double	arg1

double
__ieee754_lgamma(arg0)
	double	arg0

double
__ieee754_lgamma_r(arg0, arg1)
	double	arg0
	int *	arg1

double
__ieee754_log(arg0)
	double	arg0

double
__ieee754_log10(arg0)
	double	arg0

double
__ieee754_pow(arg0, arg1)
	double	arg0
	double	arg1

int
__ieee754_rem_pio2(arg0, arg1)
	double	arg0
	double *	arg1

double
__ieee754_remainder(arg0, arg1)
	double	arg0
	double	arg1

double
__ieee754_scalb(arg0, arg1)
	double	arg0
	double	arg1

double
__ieee754_sinh(arg0)
	double	arg0

double
__ieee754_sqrt(arg0)
	double	arg0

double
__ieee754_y0(arg0)
	double	arg0

double
__ieee754_y1(arg0)
	double	arg0

double
__ieee754_yn(arg0, arg1)
	int	arg0
	double	arg1

double
__kernel_cos(arg0, arg1)
	double	arg0
	double	arg1

int
__kernel_rem_pio2(arg0, arg1, arg2, arg3, arg4, arg5)
	double *	arg0
	double *	arg1
	int	arg2
	int	arg3
	int	arg4
	const int *	arg5

double
__kernel_sin(arg0, arg1, arg2)
	double	arg0
	double	arg1
	int	arg2

double
__kernel_standard(arg0, arg1, arg2)
	double	arg0
	double	arg1
	int	arg2

double
__kernel_tan(arg0, arg1, arg2)
	double	arg0
	double	arg1
	int	arg2

double
acos(arg0)
	double	arg0

double
acosh(arg0)
	double	arg0

double
asin(arg0)
	double	arg0

double
asinh(arg0)
	double	arg0

double
atan(arg0)
	double	arg0

double
atan2(arg0, arg1)
	double	arg0
	double	arg1

double
atanh(arg0)
	double	arg0

double
cbrt(arg0)
	double	arg0

double
ceil(arg0)
	double	arg0

double
copysign(arg0, arg1)
	double	arg0
	double	arg1

double
cos(arg0)
	double	arg0

double
cosh(arg0)
	double	arg0

double
erf(arg0)
	double	arg0

double
erfc(arg0)
	double	arg0

double
exp(arg0)
	double	arg0

double
expm1(arg0)
	double	arg0

double
fabs(arg0)
	double	arg0

int
finite(arg0)
	double	arg0

double
floor(arg0)
	double	arg0

double
fmod(arg0, arg1)
	double	arg0
	double	arg1

double
frexp(arg0, arg1)
	double	arg0
	int *	arg1

double
gamma(arg0)
	double	arg0

double
gamma_r(arg0, arg1)
	double	arg0
	int *	arg1

double
hypot(arg0, arg1)
	double	arg0
	double	arg1

int
ilogb(arg0)
	double	arg0

int
isnan(arg0)
	double	arg0

double
j0(arg0)
	double	arg0

double
j1(arg0)
	double	arg0

double
jn(arg0, arg1)
	int	arg0
	double	arg1

double
ldexp(arg0, arg1)
	double	arg0
	int	arg1

double
lgamma(arg0)
	double	arg0

double
lgamma_r(arg0, arg1)
	double	arg0
	int *	arg1

double
log(arg0)
	double	arg0

double
log10(arg0)
	double	arg0

double
log1p(arg0)
	double	arg0

double
logb(arg0)
	double	arg0

int
matherr(arg0)
	struct exception *	arg0

double
modf(arg0, arg1)
	double	arg0
	double *	arg1

double
nextafter(arg0, arg1)
	double	arg0
	double	arg1

double
pow(arg0, arg1)
	double	arg0
	double	arg1

double
remainder(arg0, arg1)
	double	arg0
	double	arg1

double
rint(arg0)
	double	arg0

double
scalb(arg0, arg1)
	double	arg0
	double	arg1

double
scalbn(arg0, arg1)
	double	arg0
	int	arg1

double
significand(arg0)
	double	arg0

double
sin(arg0)
	double	arg0

double
sinh(arg0)
	double	arg0

double
sqrt(arg0)
	double	arg0

double
tan(arg0)
	double	arg0

double
tanh(arg0)
	double	arg0

double
y0(arg0)
	double	arg0

double
y1(arg0)
	double	arg0

double
yn(arg0, arg1)
	int	arg0
	double	arg1
