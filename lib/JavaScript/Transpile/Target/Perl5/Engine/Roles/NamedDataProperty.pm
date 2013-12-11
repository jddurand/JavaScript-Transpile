use strict;
use warnings FATAL => 'all';

package JavaScript::Transpile::Target::Perl5::Engine::Roles::NamedDataProperty;
use namespace::sweep;
use Moose::Role;
use JavaScript::Transpile::Target::Perl5::Engine::DataProperty;

# ABSTRACT: JavaScript Named Data Property role in Perl5

# VERSION

=head1 DESCRIPTION

This module provides JavaScript Named Data Property role implementation in a Perl5 environment.

=cut

has '_namedDataProperty' => (
    isa => 'HashRef',
    is => 'ro',
    builder => '_build__namedDataProperty',
    writer => '_set__namedDataProperty'
);

sub _build__namedDataProperty {
    return {jdd =>JavaScript::Transpile::Target::Perl5::Engine::DataProperty->new() };
}

1;
