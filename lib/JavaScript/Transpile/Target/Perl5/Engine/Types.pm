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
        Object
        Reference
        /
];

=head1 SEE ALSO

L<MooseX::Types>

=cut

1;
