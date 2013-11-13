use strict;
use warnings FATAL => 'all';

package JavaScript::Transpile::Target::Perl5::Engine;

use Log::Any qw/$log/;
use MooseX::Prototype;

# ABSTRACT: JavaScript Engine in Perl5

# VERSION

=head1 DESCRIPTION

This module provides a JavaScript engine in a Perl5 environment.

=head1 SYNOPSIS

    use strict;
    use warnings FATAL => 'all';
    use JavaScript::Transpile::Target::Perl5::Engine;
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
    #
    # Parse ECMAScript and use the higher-level JavaScript::Transpile module
    #
    my $engine = JavaScript::Transpile::Target::Perl5::Engine->new();

=head1 SUBROUTINES/METHODS

=head2 new($class, %options)

Instantiate a new object. Takes as parameter an optional hash of options that can be:

=over

=back

=cut

# ----------------------------------------------------------------------------------------
sub new {
  my ($class, %opts) = @_;

  my $self  = {
  };

  bless($self, $class);

  return $self;
}

=head1 SEE ALSO

L<JavaScript::Transpile>, L<MooseX::Prototype>

=cut

1;
