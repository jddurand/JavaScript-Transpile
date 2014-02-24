#!perl
package main;
use strict;
use warnings FATAL => 'all';
use Log::Log4perl qw/:easy/;
use Log::Any::Adapter;
use Log::Any qw/$log/;
#
# Init log
#
our $defaultLog4perlConf = '
    log4perl.rootLogger              = WARN, Screen
    log4perl.appender.Screen         = Log::Log4perl::Appender::Screen
    log4perl.appender.Screen.stderr  = 0
    log4perl.appender.Screen.layout  = PatternLayout
    log4perl.appender.Screen.layout.ConversionPattern = %d %-5p %6P %m{chomp}%n
    ';
Log::Log4perl::init(\$defaultLog4perlConf);
Log::Any::Adapter->set('Log4perl');
use JavaScript::Transpile::Target::Perl5::Engine;
use JavaScript::Transpile::Target::Perl5::Engine::Constants qw/:all/;
use aliased 'JavaScript::Transpile::Target::Perl5::Engine::Types::Object', 'JavaScript::Types::Object';

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

my $Object = JavaScript::Types::Object->new();
print STDERR $Object->dump();

my $Child = $Object->new();
print STDERR $Child->dump();

#my $Child2 = $Child->new();
#$Child2->prototype($Object);
#print STDERR $Child2->dump();

#print STDERR "JavaScript::Role::TypeConversionAndTesting::toNumber($Child): " . JavaScript::Role::TypeConversionAndTesting::toNumber($Child) . "\n";
use Encode qw/encode/;
my $string = [ unpack('v*', encode('UTF-16LE', '54')) ];
print STDERR "JavaScript::Role::TypeConversionAndTesting::toNumber('54'): " . JavaScript::Role::TypeConversionAndTesting::toNumber($string) . "\n";
$string = [ unpack('v*', encode('UTF-16LE', 'test')) ];
print STDERR "JavaScript::Role::TypeConversionAndTesting::toNumber('test'): " . JavaScript::Role::TypeConversionAndTesting::toNumber($string) . "\n";

use MarpaX::Languages::ECMAScript::AST::Grammar::ECMAScript_262_5::StringNumericLiteral::NativeNumberSemantics;
my $test1 = MarpaX::Languages::ECMAScript::AST::Grammar::ECMAScript_262_5::StringNumericLiteral::NativeNumberSemantics->new()->int(19);
my $test2 = MarpaX::Languages::ECMAScript::AST::Grammar::ECMAScript_262_5::StringNumericLiteral::NativeNumberSemantics->new()->int(3);
$test1->left_shift($test2);
print "19 << 3 = " . ($test1->host_value || 'undef') . " (== " . (19 << 3) . " ?\n";
my $test3 = MarpaX::Languages::ECMAScript::AST::Grammar::ECMAScript_262_5::StringNumericLiteral::NativeNumberSemantics->new()->int(111);
print "~" . $test3->host_value . " = " . $test3->not->host_value . "\n";
