use strict;
use warnings FATAL => 'all';

package JavaScript::Transpile::Target::Perl5::Engine::Object;
use MooseX::Declare;

class JavaScript::Type::Object is dirty {
    use JavaScript::Transpile::Target::Perl5::Engine::PrimitiveTypes;
    use Moose::Util::TypeConstraints;
    use MooseX::Prototype;

    with 'MooseX::Prototype::Trait::Object::RW';

    our %CLASSES = map {$_ => 1} qw/Arguments Array Boolean Date Error Function JSON Math Number Object RegExp String/;
    subtype 'allowedObjectClass', as 'Str', where {exists($CLASSES{$_})};

    has 'Class' => (isa => 'allowedObjectClass',
		    is => 'rw');
}

1;
