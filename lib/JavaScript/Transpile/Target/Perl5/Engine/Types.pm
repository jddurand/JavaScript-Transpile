use strict;
use warnings FATAL => 'all';

package JavaScript::Transpile::Target::Perl5::Engine::Types;

# ABSTRACT: JavaScript Types in Perl5

# VERSION

use namespace::sweep;
use Unknown::Values;
use JavaScript::Transpile::Fdlibm;
use Moose::Util::TypeConstraints;
use Encode qw/encode/;

=head1 DESCRIPTION

This module provides JavaScript primitive types in a Perl5 environment.

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
# The Undefined type is a new type. Object is already a built-in type in Moose.
#
class_type 'Undefined', {class => ref(unknown) };
subtype 'Boolean',   as 'Bool';
subtype 'Null',      as 'Undef';
subtype 'String',    as 'ArrayRef[Int]';
subtype 'Number',    as 'Num';

#
# The AST sub-divides Number to three categories:
#
# - DecimalLiteral
# - HexIntegerLiteral
# - OctalIntegerLiteral
#
subtype 'DecimalLiteral', as 'Number';
subtype 'HexIntegerLiteral', as 'Int';
subtype 'OctalIntegerLiteral', as 'Int';

#
# Coercions:
#
coerce 'Str',    from 'String', via { arrayOfUnsignedShortToUtf8($_) };
coerce 'String', from 'Str',    via { utf8ToArrayOfUnsignedShort($_) };

coerce 'Boolean', from 'String', via { $_ eq 'true' ? 1 : 0 };
coerce 'String', from 'Boolean', via { $_ ? 'true' : 'false' };

coerce 'String',  from 'Null', via { 'null' };
coerce 'Null',  from 'String', via { undef };

coerce 'Number', from 'DecimalLiteral', via { fdlibm_strtod($_) };
coerce 'Int',    from 'HexIntegerLiteral', via { hex($_) };
coerce 'Int',    from 'OctalIntegerLiteral', via { oct($_) };

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
sub utf8ToArrayOfUnsignedShort {
    return [ unpack('v*', encode('UTF-16LE', $_[0])) ];
}

sub arrayOfUnsignedShortToUtf8 {   # Note: this is NOT symmetric
    return pack('W*', @{$_[0]});
}

=head1 SEE ALSO

L<MooseX::Types>

=cut

1;
