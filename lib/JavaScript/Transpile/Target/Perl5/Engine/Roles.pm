use strict;
use warnings FATAL => 'all';

package JavaScript::Transpile::Target::Perl5::Engine::Roles;

use Log::Any qw/$log/;
use JavaScript::Transpile::Target::Perl5::Engine::Types;

# ABSTRACT: JavaScript Object Type in Perl5

# VERSION

=head1 DESCRIPTION

This module provides JavaScript Object type definition in a Perl5 environment.

=cut

has 'NamedDataPropery' => {
    isa => 'DataProperty'
};

=head1 SEE ALSO

L<Moose>

=cut

1;
