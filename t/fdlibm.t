#!perl
use strict;
use warnings FATAL => 'all';
use Test::More;

BEGIN {
    use_ok( 'JavaScript::Transpile::Fdlibm', qw/:all/ ) || print "Bail out!\n";
}

my $const;

foreach (qw/FDLIBM_DOMAIN
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
            _FDLIBM_XOPEN_/) {
    $const = eval $_;
    ok(defined($const), "$_ = $const");
}

my $nan = fdlibm_acos(-2);

is(fdlibm_acos(1), 0, "acos(1) = 0");
is(fdlibm_isnan(fdlibm_acos(-2)), 1, "acos(-2) nan");
is(fdlibm_isnan(fdlibm_acos(2)), 1, "acos(2) nan");
is(fdlibm_isnan(fdlibm_acos($nan)), 1, "acos(nan) nan");

is(fdlibm_asin(0), 0, "asin(0) = 0");
is(fdlibm_isnan(fdlibm_asin(-2)), 1, "asin(-2) nan");
is(fdlibm_isnan(fdlibm_asin(2)), 1, "asin(2) nan");
is(fdlibm_isnan(fdlibm_asin($nan)), 1, "asin(nan) nan");

is(fdlibm_atan(0), 0, "atan(0) = 0");

is(fdlibm_isnan(fdlibm_atan2(0, $nan)), 1, "atan2(0, nan) nan");
is(fdlibm_isnan(fdlibm_atan2($nan, 0)), 1, "atan2(nan, 0) nan");
is(fdlibm_atan2(+0.0, 0), 0, "atan2(+0.0, 0) 0");
is(fdlibm_atan2(-0.0, 0), 0, "atan2(-+0.0, 0) 0");

done_testing();
