use strict;
use warnings FATAL => 'all';

package JavaScript::Transpile::Target::Perl5::Engine::Object;
use namespace::sweep;
use Moose;

# ABSTRACT: JavaScript Object in Perl5

# VERSION

=head1 DESCRIPTION

This module provides JavaScript Object definition in a Perl5 environment.

=cut

with 'JavaScript::Transpile::Target::Perl5::Engine::Roles::NamedDataProperty';
with 'JavaScript::Transpile::Target::Perl5::Engine::Roles::NamedAccessorProperty';
#with 'JavaScript::Transpile::Target::Perl5::Engine::Roles::InternalProperty';

=head1 SEE ALSO

L<Moose>

=cut

1;
