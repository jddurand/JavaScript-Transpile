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
