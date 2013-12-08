use strict;
use warnings FATAL => 'all';

package JavaScript::Transpile::Target::Perl5::Engine::NamedAccessorProperty;
use namespace::sweep;
use Moose;
use JavaScript::Transpile::Target::Perl5::Engine::Types;
use JavaScript::Transpile::Target::Perl5::Engine::Constants qw/:all/;

# ABSTRACT: JavaScript Named Accessor Property in Perl5

# VERSION

=head1 DESCRIPTION

This module provides JavaScript Named Accessor Property implementation in a Perl5 environment.

=cut

has 'Get' => {
    isa => 'Object|Undefined',
    is => 'ro',
    builder => '_build_Get',
    writer => '_set_Get',
};

sub _build_Get { undefined }

has 'Set' => {
    isa => 'Object|Undefined'
    is => 'ro',
    builder => '_build_Set',
    writer => '_set_Set',
};

sub _build_Set { undefined }

has 'Enumerable' => {
    isa => 'Boolean'
    is => 'ro',
    builder => '_build_Enumerable'
    writer => '_set_Enumerable'
};

sub _build_Enumerable { false }

has 'Configurable' => {
    isa => 'Boolean'
    is => 'ro',
    builder => 'build_Configurable'
    writer => 'set_Configurable'
};

sub _build_Configurable { false }

=head1 SEE ALSO

L<Moose>

=cut

1;
