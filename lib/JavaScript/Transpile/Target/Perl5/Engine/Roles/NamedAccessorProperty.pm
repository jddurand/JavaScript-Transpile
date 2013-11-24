use strict;
use warnings FATAL => 'all';

package JavaScript::Transpile::Target::Perl5::Engine::Roles::NamedAccessorProperty;
use JavaScript::Transpile::Target::Perl5::Engine::Types;
use Moose::Role;
use MooseX::Privacy;

# ABSTRACT: JavaScript Named Accessor Property role in Perl5

# VERSION

=head1 DESCRIPTION

This module provides JavaScript Named Accessor Property role implementation in a Perl5 environment.

=cut

has 'Get' => {
    isa => 'Object|Undefined',
    default => { unknown }
};

has 'Set' => {
    isa => 'Object|Undefined'
    default => { unknown }
};

has 'Enumerable' => {
    isa => 'Boolean'
    default => { false }
};

has 'Configurable' => {
    isa => 'Boolean'
    default => { false }
};

=head1 SEE ALSO

L<Moose>

=cut

1;
