use strict;
use warnings FATAL => 'all';

package JavaScript::Transpile::Target::Perl5::Engine::InternalProperty;
use namespace::sweep;
use Moose;
use JavaScript::Transpile::Target::Perl5::Engine::Types;
use JavaScript::Transpile::Target::Perl5::Engine::Constants qw/:all/;

# ABSTRACT: JavaScript Internal Property in Perl5

# VERSION

=head1 DESCRIPTION

This module provides JavaScript Internal Property definition in a Perl5 environment.

=cut

has 'Prototype' => {
    isa => 'Object|Null'
    builder => '_build_Prototype',
};

has 'Class' => {
    isa => 'String'
    builder => '_build_Class',
};

has 'Extensible' => {
    isa => 'Boolean'
    builder => '_build_Extensible',
};

has 'Get' => {
    isa => 'Any'
    builder => '_build_Get',
};

has 'GetOwnProperty' => {
    isa => 'Any'
    builder => '_build_GetOwnProperty',
};

has 'GetProperty' => {
    isa => 'Any'
    builder => '_build_GetProperty',
};

has 'Put' => {
    isa => 'Any'
    builder => '_build_Put',
};

has 'CanPut' => {
    isa => 'Any'
    builder => '_build_CanPut',
};

has 'HasProperty' => {
    isa => 'Any'
    builder => '_build_HasProperty',
};

has 'Delete' => {
    isa => 'Any'
    builder => '_build_Delete',
};

has 'DefaultValue' => {
    isa => 'Any'
    builder => '_build_DefaultValue',
};

has 'DefineOwnProperty' => {
    isa => 'Any'
    builder => '_build_DefineOwnProperty',
};

=head1 SEE ALSO

L<Moose>

=cut

1;
