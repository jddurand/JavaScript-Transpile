package JavaScript::Transpile::Fdlib;

use 5.010000;
use strict;
use warnings;
use Carp;

require Exporter;
use AutoLoader;

our @ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use JavaScript::Transpile::Fdlib ':all';
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
	__fdlibm_ieee754_acos
	__fdlibm_ieee754_acosh
	__fdlibm_ieee754_asin
	__fdlibm_ieee754_atan2
	__fdlibm_ieee754_atanh
	__fdlibm_ieee754_cosh
	__fdlibm_ieee754_exp
	__fdlibm_ieee754_fmod
	__fdlibm_ieee754_gamma
	__fdlibm_ieee754_gamma_r
	__fdlibm_ieee754_hypot
	__fdlibm_ieee754_j0
	__fdlibm_ieee754_j1
	__fdlibm_ieee754_jn
	__fdlibm_ieee754_lgamma
	__fdlibm_ieee754_lgamma_r
	__fdlibm_ieee754_log
	__fdlibm_ieee754_log10
	__fdlibm_ieee754_pow
	__fdlibm_ieee754_rem_pio2
	__fdlibm_ieee754_remainder
	__fdlibm_ieee754_scalb
	__fdlibm_ieee754_sinh
	__fdlibm_ieee754_sqrt
	__fdlibm_ieee754_y0
	__fdlibm_ieee754_y1
	__fdlibm_ieee754_yn
	__fdlibm_kernel_cos
	__fdlibm_kernel_rem_pio2
	__fdlibm_kernel_sin
	__fdlibm_kernel_standard
	__fdlibm_kernel_tan
	fdlibm_acos
	fdlibm_acosh
	fdlibm_asin
	fdlibm_asinh
	fdlibm_atan
	fdlibm_atan2
	fdlibm_atanh
	fdlibm_cbrt
	fdlibm_ceil
	fdlibm_copysign
	fdlibm_cos
	fdlibm_cosh
	fdlibm_erf
	fdlibm_erfc
	fdlibm_exp
	fdlibm_expm1
	fdlibm_fabs
	fdlibm_finite
	fdlibm_floor
	fdlibm_fmod
	fdlibm_frexp
	fdlibm_gamma
	fdlibm_gamma_r
	fdlibm_hypot
	fdlibm_ilogb
	fdlibm_isnan
	fdlibm_j0
	fdlibm_j1
	fdlibm_jn
	fdlibm_ldexp
	fdlibm_lgamma
	fdlibm_lgamma_r
	fdlibm_log
	fdlibm_log10
	fdlibm_log1p
	fdlibm_logb
	fdlibm_matherr
	fdlibm_modf
	fdlibm_nextafter
	fdlibm_pow
	fdlibm_remainder
	fdlibm_rint
	fdlibm_scalb
	fdlibm_scalbn
	fdlibm_significand
	fdlibm_sin
	fdlibm_sinh
	fdlibm_sqrt
	fdlibm_tan
	fdlibm_tanh
	fdlibm_y0
	fdlibm_y1
	fdlibm_yn
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

our $VERSION = '0.01';

sub AUTOLOAD {
    # This AUTOLOAD is used to 'autoload' constants from the constant()
    # XS function.

    my $constname;
    our $AUTOLOAD;
    ($constname = $AUTOLOAD) =~ s/.*:://;
    croak "&JavaScript::Transpile::Fdlib::constant not defined" if $constname eq 'constant';
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
XSLoader::load('JavaScript::Transpile::Fdlib', $VERSION);

# Preloaded methods go here.

# Autoload methods go after =cut, and are processed by the autosplit program.

1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

JavaScript::Transpile::Fdlib - Perl extension for blah blah blah

=head1 SYNOPSIS

  use JavaScript::Transpile::Fdlib;
  blah blah blah

=head1 DESCRIPTION

Stub documentation for JavaScript::Transpile::Fdlib, created by h2xs. It looks like the
author of the extension was negligent enough to leave the stub
unedited.

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

  double __fdlibm_ieee754_acos (double)
  double __fdlibm_ieee754_acosh (double)
  double __fdlibm_ieee754_asin (double)
  double __fdlibm_ieee754_atan2 (double,double)
  double __fdlibm_ieee754_atanh (double)
  double __fdlibm_ieee754_cosh (double)
  double __fdlibm_ieee754_exp (double)
  double __fdlibm_ieee754_fmod (double,double)
  double __fdlibm_ieee754_gamma (double)
  double __fdlibm_ieee754_gamma_r (double,int *)
  double __fdlibm_ieee754_hypot (double,double)
  double __fdlibm_ieee754_j0 (double)
  double __fdlibm_ieee754_j1 (double)
  double __fdlibm_ieee754_jn (int,double)
  double __fdlibm_ieee754_lgamma (double)
  double __fdlibm_ieee754_lgamma_r (double,int *)
  double __fdlibm_ieee754_log (double)
  double __fdlibm_ieee754_log10 (double)
  double __fdlibm_ieee754_pow (double,double)
  int __fdlibm_ieee754_rem_pio2 (double,double*)
  double __fdlibm_ieee754_remainder (double,double)
  double __fdlibm_ieee754_scalb (double,double)
  double __fdlibm_ieee754_sinh (double)
  double __fdlibm_ieee754_sqrt (double)
  double __fdlibm_ieee754_y0 (double)
  double __fdlibm_ieee754_y1 (double)
  double __fdlibm_ieee754_yn (int,double)
  double __fdlibm_kernel_cos (double,double)
  int __fdlibm_kernel_rem_pio2 (double*,double*,int,int,int,const int*)
  double __fdlibm_kernel_sin (double,double,int)
  double __fdlibm_kernel_standard (double,double,int)
  double __fdlibm_kernel_tan (double,double,int)
  double fdlibm_acos (double)
  double fdlibm_acosh (double)
  double fdlibm_asin (double)
  double fdlibm_asinh (double)
  double fdlibm_atan (double)
  double fdlibm_atan2 (double, double)
  double fdlibm_atanh (double)
  double fdlibm_cbrt (double)
  double fdlibm_ceil (double)
  double fdlibm_copysign (double, double)
  double fdlibm_cos (double)
  double fdlibm_cosh (double)
  double fdlibm_erf (double)
  double fdlibm_erfc (double)
  double fdlibm_exp (double)
  double fdlibm_expm1 (double)
  double fdlibm_fabs (double)
  int fdlibm_finite (double)
  double fdlibm_floor (double)
  double fdlibm_fmod (double, double)
  double fdlibm_frexp (double, int *)
  double fdlibm_gamma (double)
  double fdlibm_gamma_r (double, int *)
  double fdlibm_hypot (double, double)
  int fdlibm_ilogb (double)
  int fdlibm_isnan (double)
  double fdlibm_j0 (double)
  double fdlibm_j1 (double)
  double fdlibm_jn (int, double)
  double fdlibm_ldexp (double, int)
  double fdlibm_lgamma (double)
  double fdlibm_lgamma_r (double, int *)
  double fdlibm_log (double)
  double fdlibm_log10 (double)
  double fdlibm_log1p (double)
  double fdlibm_logb (double)
  int fdlibm_matherr (struct fdlibm_exception *)
  double fdlibm_modf (double, double *)
  double fdlibm_nextafter (double, double)
  double fdlibm_pow (double, double)
  double fdlibm_remainder (double, double)
  double fdlibm_rint (double)
  double fdlibm_scalb (double, double)
  double fdlibm_scalbn (double, int)
  double fdlibm_significand (double)
  double fdlibm_sin (double)
  double fdlibm_sinh (double)
  double fdlibm_sqrt (double)
  double fdlibm_tan (double)
  double fdlibm_tanh (double)
  double fdlibm_y0 (double)
  double fdlibm_y1 (double)
  double fdlibm_yn (int, double)



=head1 SEE ALSO

Mention other useful documentation such as the documentation of
related modules or operating system documentation (such as man pages
in UNIX), or any relevant external documentation such as RFCs or
standards.

If you have a mailing list set up for your module, mention it here.

If you have a web site set up for your module, mention it here.

=head1 AUTHOR

Jean-Damien Durand, E<lt>jdurand@E<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2013 by Jean-Damien Durand

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.18.1 or,
at your option, any later version of Perl 5 you may have available.


=cut
