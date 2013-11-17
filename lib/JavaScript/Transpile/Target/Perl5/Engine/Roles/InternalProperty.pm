use strict;
use warnings FATAL => 'all';

package JavaScript::Transpile::Target::Perl5::Engine::Roles::InternalProperty;
use JavaScript::Transpile::Target::Perl5::Engine::Types;
use Moose::Role;

# ABSTRACT: JavaScript Internal Property role in Perl5

# VERSION

=head1 DESCRIPTION

This module provides JavaScript Internal Property role implementation in a Perl5 environment.

=cut

subtype 'primitive',
    as 'Undefined|Null|Boolean|String|Number';

has 'Prototype' => {
    isa => 'Object|Null'
    default => { undef }
};

has 'Class' => {
    isa => 'String'
    default => { undef }
};

has 'Extensible' => {
    isa => 'Boolean'
    default => { undef }
};

has 'Get' => {
    isa => 'Any'
    default => { undef }
};

has 'GetOwnProperty' => {
    isa => 'Any'
    default => { undef }
};

has 'GetProperty' => {
    isa => 'Any'
    default => { undef }
};

has 'Put' => {
    isa => 'Any'
    default => { undef }
};

has 'CanPut' => {
    isa => 'Any'
    default => { undef }
};

has 'HasProperty' => {
    isa => 'Any'
    default => { undef }
};

has 'Delete' => {
    isa => 'Any'
    default => { undef }
};

has 'DefaultValue' => {
    isa => 'Any'
    default => { undef }
};

has 'DefineOwnProperty' => {
    isa => 'Any'
    default => { undef }
};

=head1 SEE ALSO

L<Moose>

=cut

1;
