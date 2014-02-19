use strict;
use warnings FATAL => 'all';

package JavaScript::Transpile;
use JavaScript::Transpile::Target::Perl5;

# ABSTRACT: Transpilation of JavaScript

use MarpaX::Languages::ECMAScript::AST qw//;
use MarpaX::Languages::ECMAScript::AST::Exceptions qw/:all/;
use Digest::MD4 qw/md4_hex/;
use CHI;
use File::HomeDir 0.93;
use File::Spec;
use version 0.77;
use Log::Any qw/$log/;

our $distname = __PACKAGE__;
$distname =~ s/::/-/g;

our $CACHE = CHI->new(driver => 'File',
                      root_dir => File::HomeDir->my_dist_data($distname, { create => 1 } ),
                      label => __PACKAGE__,
                      namespace => 'cache',
		      max_key_length => 32);

# VERSION
our $CURRENTVERSION;
{
  #
  # Because $VERSION is generated by dzil, not available in dev. tree
  #
  no strict 'vars';
  $CURRENTVERSION = $VERSION;
}

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

Produced transpilations can be cached: very often the same ECMAScript is used again and again, so there is no need to always transpile it at each call. The cache key is the buffer MD4 checksum, eventual collisions being handled. The cache location is the my_dist_data directory provided by File::HomeDir package. Default is a false value.

=item astCache

JavaScript::Transpile is using the ASTs produced by MarpaX::Languages::ECMAScript::AST, that have also a cache option. astCache correspond to the MarpaX::Languages::ECMAScript::AST cache option.

=item number

Number implementation. Possible values are 'Native' and 'BigFloat'. Default is 'Native'.

=back

=cut

# ----------------------------------------------------------------------------------------
sub new {
  my ($class, %opts) = @_;

  my $cache       = $opts{cache} // 0;
  my $astCache    = $opts{astCache}; # No pb if this is undef, we just proxy it
  my $number      = $opts{number} // 'Native';

  my $self  = {
               _cache       => $cache,
               _astCache    => $astCache,
               _number      => $number
  };

  bless($self, $class);

  return $self;
}

# ----------------------------------------------------------------------------------------

=head2 transpile($self, $source, %options)

Transpile an the ECMAScript source, pointed by $source, with the following options:

=over

=item grammarName

ECMAScript grammar version. Default is the one supplied with MarpaX::Languages::ECMAScript::AST. This later module can throw MarpaX::Languages::ECMAScript::AST::Exception::SyntaxError or MarpaX::Languages::ECMAScript::AST::Exception::InternalError Exception::Class errors.


=item target

Source language target. Default is 'perl5'.

=item indent

Indent style. Default is target specific.

=item newline

Newline style. Default is target specific.

=item space

Space style. Default is target specific.

=over

=cut

sub _getAndCheckHashFromCache {
  my ($self, $md4, $source, $transpilep, $fromCachep) = @_;

  my $rc = 0;

  my $fromCache = $CACHE->get($md4);
  if (defined($fromCache)) {
    my $clearCache = 1;
    my $store;
    if (ref($fromCache) eq 'HASH') {
      $store = $fromCache->{$source};
      if (defined($store)) {
        if (ref($store) eq 'HASH') {
          my $storeVersion = $store->{version};
          #
          # Trying to get from cache using the dev files will always clear the cache -;
          #
          if (defined($storeVersion) && defined($CURRENTVERSION)) {
            if (version::is_lax($storeVersion) && version::is_lax($CURRENTVERSION)) {
              if (version->parse($storeVersion) == version->parse($CURRENTVERSION)) {
                my $transpile = $store->{transpile};
                if (defined($transpile)) {
                  $log->tracef('cache ok, storeVersion=%s', $storeVersion);
                  $rc = 1;
                  ${$transpilep} = $transpile;
                  ${$fromCachep} = $fromCache;
                  $clearCache = 0;
                } else {
                  $log->tracef('cache ko, transpile undefined');
                }
              } else {
                $log->tracef('cache ko, storeVersion %s != %s (current version)', $storeVersion, $CURRENTVERSION);
              }
            } else {
              #
              # In case versions are really garbled, use %s instead of %d
              #
              $log->tracef('cache ko, storeVersion %s (is_lax=%s), current version %s (is_lax=%s)', $storeVersion, version::is_lax($storeVersion) || '', $CURRENTVERSION, version::is_lax($CURRENTVERSION) || '');
            }
          } else {
            $log->tracef('cache ko, storeVersion %s, current version %s', $storeVersion || 'undefined', $CURRENTVERSION || 'undefined');
          }
        } else {
          $log->tracef('cache ko, store is a %s', ref($store));
        }
      } else {
        $log->tracef('cache ko, no entry for given source code');
      }
    } else {
      $log->tracef('cache ko, $fromCache is a %s', ref($fromCache));
    }
    if ($clearCache) {
      if (ref($fromCache) eq 'HASH') {
        #
        # Invalid data
        #
        if (defined($store)) {
          delete($fromCache->{$source});
          $CACHE->set($md4, $fromCache);
          $log->tracef('cache cleaned');
        }
      } else {
        #
        # Invalid cache
        #
        $CACHE->remove($md4);
        $log->tracef('cache removed');
      }
    }
  } else {
    $log->tracef('cache ko, no cache for md4 %s', $md4);
  }

  return $rc;
}

sub _ast {
    my ($self, %options) = @_;

    if (exists($options{cache})) {
	delete($options{cache});
    }
    if (exists($options{grammarName})) {
	delete($options{grammarName});
    }

    return MarpaX::Languages::ECMAScript::AST->new(cache => $self->{_astCache}, grammarName => $self->{_grammarName}, %options);
}

sub _render {
    my ($self, $ast, $source) = @_;

    return $ast->template->transpile($ast->parse($source));
}

sub transpile {
    my ($self, $source, %options) = @_;

    my $target = $options{target} || 'perl5';
    if ($target eq 'perl5') {
	my $callback = JavaScript::Transpile::Target::Perl5->new(%options);
	$options{Template} = {
                              g1Callback => $callback->g1CallbackRef,
                              g1CallbackArgs => [ $callback ],
                              lexemeCallback => $callback->lexemeCallbackRef,
                              lexemeCallbackArgs => [ $callback ]
                             };
    }

    my $rc;
    #
    # If cache is enabled, compute the MD4 and check availability
    #
    my $transpile;
    if ($self->{_cache}) {
	my $md4 = md4_hex($source);
	my $fromCache = {};
	if (! $self->_getAndCheckHashFromCache($md4, $source, \$transpile, \$fromCache)) {
	    $transpile = $self->_render($self->_ast(%options), $source);
	    if (defined($CURRENTVERSION)) {
		$fromCache->{$source} = {transpile => $transpile, version => $CURRENTVERSION};
		$CACHE->set($md4, $fromCache);
	    }
	}
    } else {
	$transpile = $self->_render($self->_ast(%options), $source);
    }

    return $transpile;
}

# ----------------------------------------------------------------------------------------

=head1 SEE ALSO

L<Log::Any>, L<MarpaX::Languages::ECMAScript::AST>, L<Digest::MD4>, L<CHI::Driver::File>

=cut

1;
