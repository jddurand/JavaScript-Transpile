use strict;
use warnings FATAL => 'all';

package JavaScript::Transpile::Target::Perl5::Engine::Types;
use Moose::Util::TypeConstraints;
use JavaScript::Transpile::Target::Perl5::Engine::PrimitiveTypes;

class_type 'JavaScript::Type::Object', {class => 'JavaScript::Transpile::Target::Perl5::Engine::Types::Object' };

subtype    'JavaScript::Type::Any', as 'JavaScript::Type::Primitive|JavaScript::Type::Object';

# ABSTRACT: JavaScript Types in Perl5

# VERSION

#
# I do it like this for a single reason: having a class that does MooseX::Prototype::Trait::Object
# will generate a warning about new not being inlined
#
#my $ObjectInstance = ObjectClass->new(Class => 'Object');
#my $ObjectClass = create_class_from_prototype($ObjectInstance, 'JavaScript::Type::Object');
#my $ObjectPrototype = $ObjectClass->new();
#print "\$ObjectPrototype is $ObjectPrototype\n";
#$ObjectPrototype->Prototype($ObjectPrototype);
#print STDERR $ObjectPrototype->dump();

1;
