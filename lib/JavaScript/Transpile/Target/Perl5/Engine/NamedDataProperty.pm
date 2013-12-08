use strict;
use warnings FATAL => 'all';

package JavaScript::Transpile::Target::Perl5::Engine::NamedDataProperty;
use namespace::sweep;
use Moose;
use JavaScript::Transpile::Target::Perl5::Engine::Types;
use JavaScript::Transpile::Target::Perl5::Engine::Constants qw/:all/;

# ABSTRACT: JavaScript Named Data Property in Perl5

# VERSION

=head1 DESCRIPTION

This module provides JavaScript Named Data Property implementation in a Perl5 environment.

=cut

has 'Value' => {
    isa => 'Any',
    is => 'ro',
    builder => '_build_Value',
    writer => '_set_Value',
};

sub _build_Value { undefined };

has 'Writable' => {
    isa => 'Boolean',
    is => 'ro',
    builder => '_build_Writable',
    writer => '_set_Writable',
};

sub _build_Writable { false };

has 'Enumerable' => {
    isa => 'Boolean',
    is => 'ro',
    builder => '_build_Enumerable',
    writer => '_set_Enumerable',
};

sub _build_Enumerable { false };

has 'Configurable' => {
    isa => 'Boolean',
    is => 'ro',
    builder => '_build_Configurable',
    writer => '_set_Configurable',
};

sub _build_Configurable { false };

=head1 SEE ALSO

L<Moose>

=cut

1;
