#!perl
use strict;
use warnings FATAL => 'all';
use Test::More tests;

BEGIN {
    use_ok( 'JavaScript::Transpile::Fdlibm', qw/:all/ ) || print "Bail out!\n";
}

my $const;

$const = FDLIBM_DOMAIN;
ok(defined($const), "FDLIBM_DOMAIN = $const");

done_testing();
