use strict;
use warnings FATAL => 'all';

package JavaScript::Transpile;

# ABSTRACT: Transpilation of JavaScript

use Carp qw/croak/;
use MarpaX::Languages::ECMAScript::AST qw//;
use Digest::MD4 qw/md4_hex/;
use CHI;
use File::HomeDir;
use Text::Xslate qw//;
use Scalar::Util qw/blessed/;
use Module::Util qw/find_installed/;
use File::Spec;
use File::Basename qw/dirname/;
use Data::Structure::Util qw/unbless/;

our $distname = __PACKAGE__;
$distname =~ s/::/-/g;

our $cache = CHI->new(driver => 'File',
                      root_dir => File::HomeDir->my_dist_data($distname, { create => 1 } ),
                      label => __PACKAGE__,
                      namespace => 'cache',
		      max_key_length => 32);

# VERSION

=head1 DESCRIPTION

This module translates JavaScript (aka ECMAScript) source into another language.

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
    # Parse ECMAScript
    #
    my $ecmaSourceCode = 'var i = 0;';
    print JavaScript::Transpile->new()->transpile($ecmaSourceCode, target => 'perl5');

=head1 SUBROUTINES/METHODS

=head2 new($class, %options)

Instantiate a new object. Takes as parameter an optional hash of options that can be:

=over

=item cache

Produced transpilations can be cached: very often the same ECMAScript is used again and again, so there is no need to always transpile it at each call. The cache key is the buffer MD4 checksum, eventual collisions being handled. The cache location is the my_dist_data directory provided by File::HomeDir package. Default is a true value.

=item astCache

JavaScript::Transpile is using the ASTs produced by MarpaX::Languages::ECMAScript::AST, that have also a cache option. astCache correspond to the MarpaX::Languages::ECMAScript::AST cache option.

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

  my $cache       = $opts{cache} // 1;
  my $indent      = $opts{indent} // '  ';
  my $newline     = $opts{newline} // "\n";
  my $space       = $opts{space} // " ";

  my $self  = {
      _cache       => $cache,
      _indent      => $indent,
      _newline     => $newline,
      _space       => $space,
  };

  bless($self, $class);

  return $self;
}

# ----------------------------------------------------------------------------------------

=head2 parse($self, $source, %options)

Transpile an the ECMAScript source, pointed by $source, with the following options:

=over

=item grammarName

ECMAScript grammar version. Default is the one supplied with MarpaX::Languages::ECMAScript::AST.

=item target

Source language target. Default is 'perl5'.

=over

=cut

sub _blessed {
  my ($self, $ref) = @_;

  my $rc = blessed($ref) || '';
  $rc =~ s/.*:://;
  return $rc;
}

sub _lhs2lexeme {
  my ($self, $ref) = @_;
  my $rc = $ref->[0]->[2];
  #
  # C.f. "A little hack" section in the template
  #
  $ref->[0]->[2] = '';
  return $rc;
}

sub _lexeme {
  my ($self, $ref) = @_;

  return $ref->[2];
}

sub _curIndent {
  my ($self) = @_;

  return $self->{_indent} x $self->{_curIndent};
}

sub _incIndent {
  my ($self) = @_;

  return $self->{_indent} x ++$self->{_curIndent};
}

sub _decIndent {
  my ($self) = @_;

  return $self->{_indent} x --$self->{_curIndent};
}

sub _newline {
  my ($self) = @_;

  return $self->{_newline};
}

sub _space {
  my ($self) = @_;

  return $self->{_space};
}

sub _render {
    my ($self, $tx, $target, $ast) = @_;

    #
    # This will fail if we hit perl deep recursion limit, i.e.
    # the source would have 100 successive '{'. Is that
    # a reasonnable source code -;
    # C.f. $target.tx that is recursively call $self->_render().
    #
    # In addition Text::Xslate wants an array reference, bit a blessed array
    #
    return $tx->render("$target.tx", {self => $self, target => $target, type => $self->_blessed($ast), arrayp => unbless($ast)});
}

sub _ast {
    my ($self, $source) = @_;

    return MarpaX::Languages::ECMAScript::AST->new(cache => $self->{_astCache}, grammarName => $self->{_grammarName})->parse($source);
}

sub parse {
  my ($self, $source, %options) = @_;

  my $target = $options{target} || 'perl5';

  my $file_system_path = find_installed(__PACKAGE__);
  my $tx = Text::Xslate->new(type => 'text',
			     path => File::Spec->catdir(dirname($file_system_path), 'Transpile', 'Xslate'),
			     function => {
				 _blessed => \&_blessed,
				 _lhs2lexeme => \&_lhs2lexeme,
				 _lexeme => \&_lexeme,
				 _indIndent => \&_incIndent,
				 _decIndent => \&_decIndent,
				 _newline => \&_newline,
				 _space => \&_space,
				 _render => \&_render,
			     },
      );

  #
  # If cache is enabled, compute the MD4 and check availability
  #
  if ($self->{_cache}) {
      my $md4 = md4_hex($source);
      my $hashp = $cache->get($md4) || {};
      my $transpile = $hashp->{$source} || undef;
      if (defined($transpile)) {
	  return $transpile;
      }
      $hashp->{$source} = $self->_render($tx, $target, $self->_ast($source));
      $cache->set($md4, $hashp);
      return $hashp->{$source};
  } else {
      return $self->_render($tx, $target, $self->_ast($source));
  }
}

=head1 SEE ALSO

L<Log::Any>, L<MarpaX::Languages::ECMAScript::AST>, L<Digest::MD4>, L<CHI::Driver::File>

=cut

1;
