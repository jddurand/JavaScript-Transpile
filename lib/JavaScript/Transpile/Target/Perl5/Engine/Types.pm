use strict;
use warnings FATAL => 'all';

package JavaScript::Transpile::Target::Perl5::Engine::Types;

use Log::Any qw/$log/;
use MooseX::Types;

# ABSTRACT: JavaScript Types in Perl5

# VERSION

=head1 DESCRIPTION

This module provides JavaScript types in a Perl5 environment.

=cut

use MooseX::Types -declare => [
    qw/
        Undefined
        Null
        Boolean
        String
        Number
        Reference
        /
];
use MooseX::Types::Moose qw/Undef Defined Bool Str Num Ref/;

#
# Note: for Object, we use Moose's Object directly

subtype Undefined, as Undef;                 # JavaScript Undefined is really undef in perl
subtype Null,      as Defined;               # JavaScript Null      is a defined value albeit null
subtype Boolean,   as Bool;                  # JavaScript Boolean   maps to Bool
subtype String,    as Str;                   # JavaScript String    maps to Str
subtype Number,    as Num;                   # JavaScript Number    maps to Num
subtype Reference, as Ref;                   # JavaScript Reference maps to Ref

=head1 SEE ALSO

L<MooseX::Types>

=cut

1;
