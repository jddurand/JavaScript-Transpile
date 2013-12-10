use strict;
use warnings FATAL => 'all';

package JavaScript::Transpile::Target::Perl5::Engine::Exception;
use namespace::sweep;
use Moose;
with 'Throwable';

has type => (is => 'ro');
has message => (is => 'ro');

1;
