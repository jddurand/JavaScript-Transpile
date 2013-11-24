use strict;
use warnings FATAL => 'all';

package JavaScript::Transpile::Fdlibm;

# ABSTRACT: fdlibm interface from gcc with extensions taken from Java

# VERSION

use 5.010000;
use Carp;

require Exporter;
use AutoLoader;

our @ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use JavaScript::Transpile::Fdlibm ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS = ( 'all' => [ qw(
	FDLIBM_DOMAIN
	FDLIBM_HUGE
	FDLIBM_MAXFLOAT
	FDLIBM_OVERFLOW
	FDLIBM_PLOSS
	FDLIBM_SING
	FDLIBM_TLOSS
	FDLIBM_UNDERFLOW
	FDLIBM_X_TLOSS
	_FDLIBM_IEEE_
	_FDLIBM_LIB_VERSION
	_FDLIBM_POSIX_
	_FDLIBM_SVID_
	_FDLIBM_XOPEN_
	fdlibm_acos
	fdlibm_asin
	fdlibm_atan
	fdlibm_atan2
	fdlibm_cbrt
	fdlibm_ceil
	fdlibm_copysign
	fdlibm_cos
	fdlibm_cosh
	fdlibm_exp
	fdlibm_expm1
	fdlibm_fabs
	fdlibm_finite
	fdlibm_floor
	fdlibm_fmod
	fdlibm_hypot
	fdlibm_isnan
	fdlibm_log
	fdlibm_log10
	fdlibm_log1p
	fdlibm_pow
	fdlibm_remainder
	fdlibm_rint
	fdlibm_scalbn
	fdlibm_sin
	fdlibm_sinh
	fdlibm_sqrt
	fdlibm_tan
	fdlibm_tanh
        __fdlibm_ieee754_remainder
        fdlibm_dtoa
        fdlibm_dtoa_r
        fdlibm strtod_r
        fdlibm_floatToIntBits
        fdlibm_doubleToLongBits
        fdlibm_longBitsToDouble
        fdlibm_isNaN
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
	FDLIBM_DOMAIN
	FDLIBM_HUGE
	FDLIBM_MAXFLOAT
	FDLIBM_OVERFLOW
	FDLIBM_PLOSS
	FDLIBM_SING
	FDLIBM_TLOSS
	FDLIBM_UNDERFLOW
	FDLIBM_X_TLOSS
	_FDLIBM_IEEE_
	_FDLIBM_LIB_VERSION
	_FDLIBM_POSIX_
	_FDLIBM_SVID_
	_FDLIBM_XOPEN_
);

sub AUTOLOAD {
    # This AUTOLOAD is used to 'autoload' constants from the constant()
    # XS function.

    my $constname;
    our $AUTOLOAD;
    ($constname = $AUTOLOAD) =~ s/.*:://;
    croak "&JavaScript::Transpile::Fdlibm::constant not defined" if $constname eq 'constant';
    my ($error, $val) = constant($constname);
    if ($error) { croak $error; }
    {
	no strict 'refs';
	# Fixed between 5.005_53 and 5.005_61
#XXX	if ($] >= 5.00561) {
#XXX	    *$AUTOLOAD = sub () { $val };
#XXX	}
#XXX	else {
	    *$AUTOLOAD = sub { $val };
#XXX	}
    }
    goto &$AUTOLOAD;
}

require XSLoader;
XSLoader::load('JavaScript::Transpile', $VERSION);

# Preloaded methods go here.

# Autoload methods go after =cut, and are processed by the autosplit program.

=head1 NAME

JavaScript::Transpile::Fdlibm - Perl extension for fdlibm

=head1 SYNOPSIS

  use JavaScript::Transpile::Fdlibm;

=head1 DESCRIPTION

fdlibm, version 53, interface.

Blah blah blah.

=head2 EXPORT

None by default.

=head2 Exportable constants

  FDLIBM_DOMAIN
  FDLIBM_HUGE
  FDLIBM_MAXFLOAT
  FDLIBM_OVERFLOW
  FDLIBM_PLOSS
  FDLIBM_SING
  FDLIBM_TLOSS
  FDLIBM_UNDERFLOW
  FDLIBM_X_TLOSS
  _FDLIBM_IEEE_
  _FDLIBM_LIB_VERSION
  _FDLIBM_POSIX_
  _FDLIBM_SVID_
  _FDLIBM_XOPEN_

=head2 Exportable functions

  double fdlibm_acos (double)
  double fdlibm_asin (double)
  double fdlibm_atan (double)
  double fdlibm_atan2 (double, double)
  double fdlibm_cbrt (double)
  double fdlibm_ceil (double)
  double fdlibm_copysign (double, double)
  double fdlibm_cos (double)
  double fdlibm_cosh (double)
  double fdlibm_exp (double)
  double fdlibm_expm1 (double)
  double fdlibm_fabs (double)
  int fdlibm_finite (double)
  double fdlibm_floor (double)
  double fdlibm_fmod (double, double)
  double fdlibm_hypot (double, double)
  int fdlibm_isnan (double)
  double fdlibm_log (double)
  double fdlibm_log10 (double)
  double fdlibm_log1p (double)
  double fdlibm_pow (double, double)
  double fdlibm_remainder (double, double)
  double fdlibm_rint (double)
  double fdlibm_scalbn (double, int)
  double fdlibm_sin (double)
  double fdlibm_sinh (double)
  double fdlibm_sqrt (double)
  double fdlibm_tan (double)
  double fdlibm_tanh (double)
  double __fdlibm_ieee754_remainder(double, double)
  void fdlibm_dtoa(double, int, int, int *, int *, char **, char *, int)
  void fdlibm_dtoa_r(struct _Jv_reent *, double, int, int, int *, int *, char **, int)
  double fdlibm_strtod_r(struct _Jv_reent *, const char *,  char **)
  jint fdlibm_floatToIntBits (float value)
  jlong fdlibm_doubleToLongBits(double)
  double fdlibm_longBitsToDouble(jlong)
  int fdlibm_isNaN(jlong)

=head1 NOTES

jint is a 32bits integer, jlong is a 64bits integer.

L<http://gcc.gnu.org/>

=head1 SEE ALSO

L<http://www.netlib.org/fdlibm/>

L<http://gcc.gnu.org/>

=cut

1;
