use strict;
use warnings FATAL => 'all';

package JavaScript::Transpile::Target::Perl5::Engine::Types;

# ABSTRACT: JavaScript Types in Perl5

# VERSION

use Unknown::Values;
use Math::BigInt;
use Moose::Util::TypeConstraints;
Math::BigInt->config(
    {
	trap_inf => 0,         # No croak in inf
	trap_nan => 0,         # No croak on NaN
	round_mode => 'even'   # Rounds to the nearest value, except for 5 which is equidistant, in which case it rounds to the nearest even digit.
    });

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

# Number is IEEE-754
coerce 'Number',
    from 'Boolean',   via { Math::BigInt->new($_ ? '1' : '0') };
    from 'Null',      via { Math::BigInt->new(undef) };  # 0
    from 'Reference', via { Math::BigInt->new("$_") };
    from 'Undefined', via { Math::BigInt->new(unknown) };  # NaN
    from 'String',    via { ($_ eq 'Infinity') ? Math::BigInt->binf() : Math::BigInt->new("$_") };

# String coercions
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
