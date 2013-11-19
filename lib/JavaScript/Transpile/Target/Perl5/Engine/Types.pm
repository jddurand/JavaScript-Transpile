use strict;
use warnings FATAL => 'all';

package JavaScript::Transpile::Target::Perl5::Engine::Types;

# ABSTRACT: JavaScript Types in Perl5

# VERSION

use Unknown::Values;
use bignum;
use Moose::Util::TypeConstraints;
use Encode qw/encode/;

Math::BigInt->round_mode('even');  # Just to be sure

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
subtype 'IntGeZero', as 'Int', where { $_ >= 0 };
subtype 'String',    as 'ArrayRef[IntGeZero]';
subtype 'Number',    as 'Object', traits => [qw/Num/];
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
#                             Num
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
#                         Object                     <=> Undefined, Number

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
    return pack('W*', @{$_[0]});
}

use constant trueAsString      => utf8ToArrayOfUnsignedShort('true');
use constant falseAsString     => utf8ToArrayOfUnsignedShort('false');
use constant undefinedAsString => utf8ToArrayOfUnsignedShort('undefined');
use constant nullAsString      => utf8ToArrayOfUnsignedShort('null');
use constant referenceAsString => utf8ToArrayOfUnsignedShort('Reference');
use constant ZeroStringValue   => utf8ToArrayOfUnsignedShort('0');
use constant xStringValue      => utf8ToArrayOfUnsignedShort('x');
use constant XStringValue      => utf8ToArrayOfUnsignedShort('X');
use constant NaNStringValue    => utf8ToArrayOfUnsignedShort('NaN');
use constant InfPStringValue   => utf8ToArrayOfUnsignedShort('+Infinity');
use constant InfMStringValue   => utf8ToArrayOfUnsignedShort('-Infinity');
use constant ZeroPStringValue  => utf8ToArrayOfUnsignedShort('+0');
use constant ZeroMStringValue  => utf8ToArrayOfUnsignedShort('-0');

# Undefined is mapped to single value unknown
coerce 'Undefined', from 'Any', via { unknown };

# Null is mapped to single value undef
coerce 'Null', from 'Any', via { undef };

# Boolean is mapped to two values 1 and 0
coerce 'Boolean', from 'Any', via { $_ ? 1 : 0 };

# Number is IEEE-754
# In ECMAScript-262-5, Number special values are:
# NaN
# +Infinity
#  Infinity
# -Infinity
# +0
#  0
# -0
coerce 'Number',
    from 'Boolean',   via { $_ ? 1 : 0 };
    from 'Null',      via { 0 };
    from 'Reference', via { int($_) };
    from 'Undefined', via { NaN() };
    from 'String',    via { my $s = arrayOfUnsignedShortToUtf8($_);
                            if (! $s || $s eq 'NaN') {
                              return NaN();
                            } elsif ($s eq '+Infinity' || $s eq 'Infinity')  {
                              return +inf();
                            } elsif ($s eq '-Infinity')  {
                              return -inf();
                            } elsif ($s eq '+0' || $s eq '0')  {
                              return +0.0;
                            } elsif ($s eq '-0')  {
                              return -0.0;
			    } elsif (substr($s, 0, 1) eq '0') {
                              return oct($s);      # See perldoc, in fact oct() behaves like hex() if 0x or 0X
			    } else {
                              return 0+$s;         # perl to do the magic
			    }
};

# String coercions
coerce 'String',
  from 'Boolean',   via { $_ ? trueAsString : falseAsString };
  from 'Null',      via { nullAsString };
  from 'Number',    via {                          # Numbers are objects, c.f. Math::BigInt or Math::BigFloat
    if ($_->is_nan()) {
      return NaNStringValue;
    } elsif ($_->is_inf()) {
      return InfPStringValue;
    } elsif ($_->is_inf('-')) {
      return InfMStringValue;
    } elsif ($_->is_zero()) {
      #
      # For the principle, I believe is_pos() always returns true
      #
      if ($_->is_pos()) {
        return ZeroPStringValue;
      } else {
        return ZeroMStringValue;
      }
    } else {
      return utf8ToArrayOfUnsignedShort("$_")
    }
  };
    from 'Reference', via { utf8ToArrayOfUnsignedShort(ref($_)) };
    from 'Undefined', via { undefinedAsString };

=head1 SEE ALSO

L<MooseX::Types>

=cut

1;
