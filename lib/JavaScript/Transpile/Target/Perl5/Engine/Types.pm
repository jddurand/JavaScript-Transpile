use strict;
use warnings FATAL => 'all';

package JavaScript::Transpile::Target::Perl5::Engine::Types;
use JavaScript::Transpile::Target::Perl5::Engine::Constants qw/:all/;
use JavaScript::Transpile::Target::Perl5::Engine::Undefined;
use JavaScript::Transpile::Target::Perl5::Engine::Object;

# ABSTRACT: JavaScript Types in Perl5

# VERSION

use namespace::sweep;
#use JavaScript::Transpile::Fdlibm;
use Encode qw/encode/;
use Moose::Util::TypeConstraints;

=head1 DESCRIPTION

This module provides JavaScript types in a Perl5 environment.

=cut

#
# JavaScript built-in types are: Undefined, Null, Boolean, Number, String and Object.
#
# Mapping with Moose built-in types is:
#         Any
#             Item
#                 Bool                               <=> Boolean
#                 Maybe[`a]
#                 Undef                              <=> Null
#                 Defined
#                     Value
#                         Str                        <=> String
#                             Num                    <=> Number <= DecimalLiteral
#                                 Int                           <= HexIntegerLiteral, OctalIntegerLiteral
#                             ClassName
#                             RoleName
#                     Ref
#                         ScalarRef[`a]
#                         ArrayRef[`a]
#                         HashRef[`a]
#                         CodeRef
#                         RegexpRef
#                         GlobRef
#                         FileHandle
#                         Object
#
#
# The Undefined type is a new type. Object is already a built-in type in Moose.
#
class_type 'JavaScript::Type::Undefined', {class => 'JavaScript::Transpile::Target::Perl5::Engine::Undefined' };
subtype 'JavaScript::Type::Boolean',   as 'Bool';
subtype 'JavaScript::Type::Null',      as 'Undef';
# No need of PositiveInt : we know what we are doing
subtype 'JavaScript::Type::String',    as 'ArrayRef[Int]';
subtype 'JavaScript::Type::Number',    as 'Num';

#
# The AST sub-divides Number to three categories:
#
# - DecimalLiteral
# - HexIntegerLiteral
# - OctalIntegerLiteral
#
subtype 'JavaScript::Type::DecimalLiteral', as 'JavaScript::Type::Number';
subtype 'JavaScript::Type::HexIntegerLiteral', as 'JavaScript::Type::Int';
subtype 'JavaScript::Type::OctalIntegerLiteral', as 'JavaScript::Type::Int';

#
# Coercions for strings only
#
coerce 'Str',    from 'JavaScript::Type::String', via { arrayOfUnsignedShortToUtf8($_) };
coerce 'JavaScript::Type::String', from 'Str',    via { utf8ToArrayOfUnsignedShort($_) };

#
# Take care: JavaScript::Type::String is a sequence of UTF-16 Code Units, NOT characters.
# This mean that internally JavaScript is using UCS-2, not UTF-16. I.e.
# no support for surrogate pairs. Nevertheless the spec says that textual
# data is supposed to be UTF-16. I.e. the input can contain surrogate pairs.
# Surrogate pairs will not be taken as they are, but as new characters,
# because of the UCS-2 internal encoding.
#
# To get the unsigned short values out of a UTF-16LE: unpack('v*', ...).
# To get the unsigned short values out of a UTF-16BE: unpack('n*', ...).
#
sub utf8ToArrayOfUnsignedShort {
    return [ unpack('v*', encode('UTF-16LE', $_[0])) ];
}

sub arrayOfUnsignedShortToUtf8 {   # Note: this is NOT symmetric
    return pack('W*', @{$_[0]});
}

#
# Non-primitive types
# -------------------
class_type 'JavaScript::Type::DataProperty', {class => 'JavaScript::Transpile::Target::Perl5::Engine::DataProperty' };
class_type 'JavaScript::Object', {class => 'JavaScript::Transpile::Target::Perl5::Engine::Object' };

=head1 SEE ALSO

L<MooseX::Types>

=cut

1;
