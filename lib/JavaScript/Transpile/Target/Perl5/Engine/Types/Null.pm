use strict;
use warnings FATAL => 'all';

package JavaScript::Transpile::Target::Perl5::Engine::Types::Null;
use MooseX::Singleton;

# ABSTRACT: JavaScript Null role in Perl5

# VERSION

=head2 NOTE

Implemented as a singleton so that there is no clash with the undef/defined native keyword in Perl, used to detect an optional argument in particular.

=cut

1;
