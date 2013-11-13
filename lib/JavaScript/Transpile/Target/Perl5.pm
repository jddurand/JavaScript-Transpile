use strict;
use warnings FATAL => 'all';

package JavaScript::Transpile::Target::Perl5;

use Carp qw/croak/;
use Log::Any qw/$log/;

# ABSTRACT: Transpilation of JavaScript to Perl5

# VERSION

=head1 DESCRIPTION

This module provides helpers to transpile JavaScript (aka ECMAScript) source into perl5.

=head1 SYNOPSIS

    use strict;
    use warnings FATAL => 'all';
    use JavaScript::Transpile;
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
    my $ecmaSourceCode = 'var i = 0;';
    print JavaScript::Transpile->new()->transpile($ecmaSourceCode, target => 'perl5');

=head1 SUBROUTINES/METHODS

=head2 new($class, %options)

Instantiate a new object. Takes as parameter an optional hash of options that can be:

=over

=item indent

Indent style. Default to 2 spaces.

=item newline

Newline style. Default to "\n".

=item space

Space style. Default to " ".

=back

=cut

# ----------------------------------------------------------------------------------------
sub new {
  my ($class, %opts) = @_;

  my $indent      = $opts{indent} // '  ';
  my $newline     = $opts{newline} // "\n";
  my $space       = $opts{space} // " ";

  my $self  = {
      _indent      => $indent,
      _newline     => $newline,
      _space       => $space,
  };

  bless($self, $class);

  return $self;
}

# ----------------------------------------------------------------------------------------

=head2 g1Callback($self, $rcp, $ruleId, $value, $index, $lhs, @rhs)

G1 callback. A reference to this method is given to the transpile method of MarpaX::Languages::ECMAScript::AST.

=cut

sub g1Callback {
  my ($self, $rcp, $ruleId, $value, $index, $lhs, @rhs) = @_;

  print STDERR "G1 callback @_\n";

  return 1;

}

# ----------------------------------------------------------------------------------------

=head2 g1CallbackRef($self)

G1 callback reference.

=cut

sub g1CallbackRef {
  my ($self) = @_;

  return \&g1Callback;

}

# ----------------------------------------------------------------------------------------

=head2 lexemeCallback($self, $rcp, $ruleId, $value, $index, $lhs, @rhs)

Lexeme callback. A reference to this method is given to the transpile method of MarpaX::Languages::ECMAScript::AST.

=cut

sub lexemeCallback {
  my ($self, $rcp, $name, $ruleId, $value, $index, $lhs, @rhs) = @_;

  print STDERR "Lexeme callback $name\n";

  return 0;

}

# ----------------------------------------------------------------------------------------

=head2 lexemeCallbackRef($self)

Lexeme callback reference.

=cut

sub lexemeCallbackRef {
  my ($self) = @_;

  return \&lexemeCallback;

}

=head1 SEE ALSO

L<MarpaX::Languages::ECMAScript::AST>

=cut

1;
