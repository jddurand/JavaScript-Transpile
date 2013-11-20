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
            _FDLIBM_XOPEN_
/) {
    $const = eval $_;
    ok(defined($const), "$_ = $const");
}

done_testing();
