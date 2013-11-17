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
use Encode qw/encode decode from_to/;

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
    return [ unpack('v*', encode("UTF-16LE", $_[0])) ];
}

sub arrayOfUnsignedShortToUtf8 {   # Note: this is NOT symmetric
    my $rc = '';
    map {$rc .= chr($_)} @{$_[0]};
    return $rc;
}

use constant trueAsString      => utf8ToArrayOfUnsignedShort('true');
use constant falseAsString     => utf8ToArrayOfUnsignedShort('false');
use constant undefinedAsString => utf8ToArrayOfUnsignedShort('undefined');
use constant nullAsString      => utf8ToArrayOfUnsignedShort('null');
use constant referenceAsString => utf8ToArrayOfUnsignedShort('Reference');
use constant ZeroStringValue   => utf8ToArrayOfUnsignedShort('0');
use constant xStringValue      => utf8ToArrayOfUnsignedShort('x');
use constant XStringValue      => utf8ToArrayOfUnsignedShort('X');

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
    from 'String',    via { my $s = arrayOfUnsignedShortToUtf8($_);
                            if ($s eq 'Infinity')  {
				return Math::BigInt->binf();
			    } elsif (length($s) >= 2 &&
				     substr($s, 0, 1) eq '0' &&
				     (substr($s, 1, 1) ne 'x' && substr($s, 0, 1) ne 'X')) {
				return Math::BigInt->from_oct("$_");
			    } else {
				return Math::BigInt->new("$_");
			    }
};

# String coercions
coerce 'String',
    from 'Boolean',   via { $_ ? trueAsString : falseAsString };
    from 'Null',      via { nullAsString };
    from 'Number',    via { utf8ToArrayOfUnsignedShort("$_") };
    from 'Reference', via { utf8ToArrayOfUnsignedShort(ref($_)) };
    from 'Undefined', via { undefinedAsString };

=head1 SEE ALSO

L<MooseX::Types>

=cut

1;
