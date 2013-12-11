use strict;
use warnings FATAL => 'all';

package JavaScript::Transpile::Target::Perl5::Engine::AccessorProperty;
use namespace::sweep;
use Moose::Role;
use MooseX::Method::Signatures;
use JavaScript::Transpile::Target::Perl5::Engine::Types;
use JavaScript::Transpile::Target::Perl5::Engine::Constants qw/:all/;

# ABSTRACT: JavaScript Accessor Property in Perl5

# VERSION

=head1 DESCRIPTION

This module provides JavaScript Accessor Property implementation in a Perl5 environment.

=cut

#
# If the value is an Object it must be a function Object.
# The function's [[Call]] internal method (8.6.2) is called with an empty arguments list
# to return the property value each time a get access of the property is performed.
#
method Get($self:) {
  if ($self->Class eq 'Function') {
    my $Call = $self->Call;
    return &$Call();
  }
  return undefined;
}

#
# If the value is an Object it must be a function Object.
# The function's [[Call]] internal method (8.6.2) is called with an arguments list
# containing the assigned value as its sole argument each time a set access of the
# property is performed. The effect of a property's [[Set]] internal method may,
# but is not required to, have an effect on the value returned by subsequent calls
# to the property's [[Get]] internal method.
#
# Take care: coercion from String to Str
#
method Set($self: Any $value) {
  if ($self->Class eq 'Function') {
    my $Call = $self->Call;
    return &$Call($value);
  }
  return undefined;
}

has 'Enumerable' => (
                     isa => 'JavaScript::Type::Boolean',
                     is => 'ro',
                     writer => '_set_Enumerable',
                     builder => '_build_Enumerable'
);

sub _build_Enumerable { false }

has 'Configurable' => (
                       isa => 'JavaScript::Type::Boolean',
                       is => 'rw',
                       writer => '_set_Configurable',
                       builder => '_build_Configurable'
);

sub _build_Configurable { false }

1;
