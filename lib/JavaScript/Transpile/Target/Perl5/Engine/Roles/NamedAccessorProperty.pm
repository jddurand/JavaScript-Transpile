use strict;
use warnings FATAL => 'all';

package JavaScript::Transpile::Target::Perl5::Engine::Roles::NamedAccessorProperty;
use namespace::sweep;
use Moose::Role;
use JavaScript::Transpile::Target::Perl5::Engine::AccessorProperty;

# ABSTRACT: JavaScript Named Accessor Property role in Perl5

# VERSION

=head1 DESCRIPTION

This module provides JavaScript Named Accessor Property role implementation in a Perl5 environment.

=cut

has '_namedAccessorProperty' => (
    isa => 'HashRef[JavaScript::Transpile::Target::Perl5::Engine::DataProperty]',
    is => 'ro',
    builder => '_build__namedAccessorProperty',
    writer => '_set__namedAccessorProperty'
);

sub _build__namedAccessorProperty {
    return {jdd => JavaScript::Transpile::Target::Perl5::Engine::DataProperty->new() };
}

1;
