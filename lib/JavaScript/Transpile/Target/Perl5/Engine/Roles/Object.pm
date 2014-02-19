use strict;
use warnings FATAL => 'all';

package JavaScript::Transpile::Target::Perl5::Engine::Roles::Object;
use JavaScript::Transpile::Target::Perl5::Engine::Roles::Object::Parameterized;
use MooseX::Declare;

role JavaScript::Roles::Object {
  with 'JavaScript::Roles::Object::Parameterized' => {className => 'Object'};
}

1;
