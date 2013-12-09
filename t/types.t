#!perl
use strict;
use warnings FATAL => 'all';
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
#use JavaScript::Transpile::Target::Perl5::Engine;
use JavaScript::Transpile::Target::Perl5::Engine::PropertyDescriptor qw//;

my $x = JavaScript::Transpile::Target::Perl5::Engine::PropertyDescriptor->new({test => 1});
$x->IsAccessorDescriptor();
use Data::Dumper;
print STDERR Dumper($x->Desc);


