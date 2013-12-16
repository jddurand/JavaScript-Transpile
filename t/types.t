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
use JavaScript::Transpile::Target::Perl5::Engine;
use JavaScript::Transpile::Target::Perl5::Engine::Constants qw/:all/;

#my $ROOT = JavaScript::Type::Object->new();
#print STDERR $ROOT->dump();
#my $child = $ROOT->new();
#print STDERR $child->dump();
#print "Child class precedence list: " . join(' ', $child->meta->class_precedence_list) . "\n";
#my $desc = JavaScript::Type::PropertyDescriptor->ToPropertyDescriptor($child);
#print STDERR "Desc: " . $desc->dump;
#my $grandChild = $child->prototype->new();
#print STDERR $grandChild->dump();
#print "Grand child class precedence list: " . join(' ', $grandChild->meta->class_precedence_list) . "\n";
#$grandChild->prototype($ROOT);
#print STDERR $grandChild->dump();
#print "New Grand child class precedence list: " . join(' ', $grandChild->meta->class_precedence_list) . "\n";
#$grandChild->prototype;

my $Object = JavaScript::Type::Object->new();
print STDERR $Object->dump();

my $Child = $Object->new();
print STDERR $Child->dump();

my $Child2 = $Child->new();
$Child2->prototype($Object);
print STDERR $Child2->dump();

