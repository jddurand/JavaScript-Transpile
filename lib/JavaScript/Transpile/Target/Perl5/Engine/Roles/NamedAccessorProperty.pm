use strict;
use warnings FATAL => 'all';

package JavaScript::Transpile::Target::Perl5::Engine::Roles::NamedAccessorProperty;
use namespace::sweep;
use JavaScript::Transpile::Target::Perl5::Engine::Types;
use Moose::Role;

# ABSTRACT: JavaScript Named Accessor Property role in Perl5

# VERSION

=head1 DESCRIPTION

This module provides JavaScript Named Accessor Property role implementation in a Perl5 environment.

=cut

has _namedAccessorProperty => (
    isa => 'HashRef[JS_DataProperty]',
    is => 'ro',
    builder => '_build__namedAccessorProperty',
    writer => '_set__namedAccessorProperty'
);

sub _build__namedAccessorProperty {
    return {jdd => JS_DataProperty->new() };
}

1;
