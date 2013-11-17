use strict;
use warnings FATAL => 'all';

package JavaScript::Transpile::Target::Perl5::Engine::Roles::NamedDataProperty;
use JavaScript::Transpile::Target::Perl5::Engine::Types;
use Moose::Role;

# ABSTRACT: JavaScript Named Data Property role in Perl5

# VERSION

=head1 DESCRIPTION

This module provides JavaScript Named Data Property role implementation in a Perl5 environment.

=cut

has 'Value' => {
    isa => 'Any'
    default => { undef }
};

has 'Writable' => {
    isa => 'Boolean'
    default => { false }
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
