use strict;
use warnings FATAL => 'all';

package JavaScript::Transpile::Target::Perl5::Engine::Types;

use Log::Any qw/$log/;
use Unknown::Values;
use Moose;
use Moose::Util::TypeConstraints;

# ABSTRACT: JavaScript Types in Perl5

# VERSION

=head1 DESCRIPTION

This module provides JavaScript primitive types in a Perl5 environment.

=cut

#
# Types definitions
# -----------------
#
class_type 'Undefined', {class => ref(unknown) };
subtype 'Null',      as 'Undef';
subtype 'Boolean',   as 'Bool';
subtype 'String',    as 'ArrayRef[GreaterOrEqualThanZeroInt]';
subtype 'Number',    as 'Num';
#
# Moose already provides the Object type
#
# subtype 'Object',    as 'Object';

#
# Types coercions
# ---------------
#         Any
#             Item
#                 Bool                               <=> Boolean
#                 Maybe[`a]
#                 Undef                              <=> Null
#                 Defined
#                     Value
#                         Str                        <=> String
#                             Num                    <=> Number
#                                 Int
#                             ClassName
#                             RoleName
#                     Ref                            <=> Reference
#                         ScalarRef[`a]
#                         ArrayRef[`a]
#                         HashRef[`a]
#                         CodeRef
#                         RegexpRef
#                         GlobRef
#                         FileHandle
#                         Object                     <=> Undefined

use constant trueAsString      => [ unpack('S*', 'true') ];
use constant falseAsString     => [ unpack('S*', 'false') ];
use constant undefinedAsString => [ unpack('S*', 'undefined') ];
use constant nullAsString      => [ unpack('S*', 'null') ];
use constant referenceAsString => [ unpack('S*', 'Reference') ];

# Undefined is mapped to single value unknown
coerce 'Undefined', from 'Any', via { unknown };

# Null is mapped to single value undef
coerce 'Null', from 'Any', via { undef };

# Boolean is mapped to two values 1 and 0
coerce 'Boolean', from 'Any', via { $_ ? 1 : 0 };

coerce 'String',
    from 'Boolean',   via { $_ ? trueAsString : falseAsString };
    from 'Null',      via { nullAsString };
    from 'Number',    via { [ unpack('S*', "$_") ] };
    from 'Reference', via { [ unpack('S*', ref($_)) ] };
    from 'Undefined', via { undefinedAsString };

=head1 SEE ALSO

L<MooseX::Types>

=cut

1;
