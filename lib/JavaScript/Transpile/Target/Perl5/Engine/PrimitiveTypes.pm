use strict;
use warnings FATAL => 'all';

package JavaScript::Transpile::Target::Perl5::Engine::PrimitiveTypes;
# ABSTRACT: JavaScript primitive types

# VERSION

use Moose::Util::TypeConstraints;
use Encode qw/encode/;
use JavaScript::Transpile::Target::Perl5::Engine::Constants qw/:all/;

subtype    'JavaScript::Type::Boolean',   as 'Bool',  where {$_ == true || $_ == false};
class_type 'JavaScript::Type::Undefined', {class => 'JavaScript::Transpile::Target::Perl5::Engine::Types::Undefined' };
class_type 'JavaScript::Type::Null',      {class => 'JavaScript::Transpile::Target::Perl5::Engine::Types::Null' };
subtype    'JavaScript::Type::String',    as 'ArrayRef[Int]';
subtype    'JavaScript::Type::Number',    as 'Num';
subtype    'JavaScript::Type::Primitive', as 'JavaScript::Type::Boolean|JavaScript::Type::Undefined|JavaScript::Type::Null|JavaScript::Type::String|JavaScript::Type::Number';

# -------------------------
# Coercion for strings only
# -------------------------
#
# Take care: String is a sequence of UTF-16 Code Units, NOT characters.
# This mean that internally JavaScript is using UCS-2, not UTF-16. I.e.
# no support for surrogate pairs. Nevertheless the spec says that textual
# data is supposed to be UTF-16. I.e. the input can contain surrogate pairs.
# Surrogate pairs will not be taken as they are, but as new characters,
# because of the UCS-2 internal encoding.
#
# To get the unsigned short values out of a UTF-16LE: unpack('v*', ...).
# To get the unsigned short values out of a UTF-16BE: unpack('n*', ...).
#
coerce 'Str',    from 'JavaScript::Type::String', via { pack('W*', @{$_}) };
coerce 'JavaScript::Type::String', from 'Str',    via { [ unpack('v*', encode('UTF-16LE', $_)) ] };

1;
