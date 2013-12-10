#!perl
use strict;
use warnings FATAL => 'all';
use Test::More tests => 2;
    use Log::Log4perl qw/:easy/;
    use Log::Any::Adapter;
    use Log::Any qw/$log/;
    #
    # Init log
    #
    our $defaultLog4perlConf = '
    log4perl.rootLogger              = TRACE, Screen
    log4perl.appender.Screen         = Log::Log4perl::Appender::Screen
    log4perl.appender.Screen.stderr  = 0
    log4perl.appender.Screen.layout  = PatternLayout
    log4perl.appender.Screen.layout.ConversionPattern = %d %-5p %6P %m{chomp}%n
    ';
    Log::Log4perl::init(\$defaultLog4perlConf);
    Log::Any::Adapter->set('Log4perl');

BEGIN {
    use_ok( 'JavaScript::Transpile' ) || print "Bail out!\n";
}

my $ecmaSourceCode = do {local $/; <DATA>};
my $perl5 = JavaScript::Transpile->new()->transpile($ecmaSourceCode);
ok($perl5);
print "==>\n$perl5\n";
__DATA__
var i;
