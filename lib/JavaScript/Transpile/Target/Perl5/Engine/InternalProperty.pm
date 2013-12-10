use strict;
use warnings FATAL => 'all';

package JavaScript::Transpile::Target::Perl5::Engine::InternalProperty;
use namespace::sweep;
use Moose;
use MooseX::Prototype qw/create_class_from_prototype/;
use JavaScript::Transpile::Target::Perl5::Engine::Types;
use JavaScript::Transpile::Target::Perl5::Engine::Constants qw/:all/;
use JavaScript::Transpile::Target::Perl5::Engine::Exception;

# ABSTRACT: JavaScript Internal Property in Perl5

# VERSION

=head1 DESCRIPTION

This module provides JavaScript Internal Property definition in a Perl5 environment.

=cut

our @NOT_ALLOWED_CLASS = qw/Arguments Array Boolean Date Error Function JSON Math Number Object RegExp String/;

use MooseX::Method::Signatures;

#
# Prototype is an implementation stuff, so it is legal to use native types.
# Because of the cost of creating a class, we do it in a lazy way, and use
# an attribute instead of a method
#
has 'Prototype' => (isa => 'Str|Undef',
                    is => 'ro',
                    lazy => 1,
                    builder => '_build_Prototype');

sub _build_Prototype {
  #
  # Recursively accessing the [[Prototype]] internal property must eventually lead to a null value
  #
  return create_class_from_prototype($self)->new({name => });
}

has 'Class' => {
    isa => 'String'
    builder => '_build_Class',
    trigger => '_trigger_Class'
};

sub _build_Class { '' };

sub _trigger_Class {
  my ($self, $new, $old) = @_;

  if (grep {$new eq $_} @NOT_ALLOWED_CLASS) {
    JavaScript::Transpile::Target::Perl5::Engine::Exception->throw({type => 'GenericError', message => "Class value $new is not allowed"});
  }
}

has 'Extensible' => {
    isa => 'Boolean'
    builder => '_build_Extensible',
};

sub _build_Extensible { false };

has 'Get' => {
    isa => 'Any'
    builder => '_build_Get',
};

sub _build_Get { undefined };

has 'GetOwnProperty' => {
    isa => 'Undefined|PropertyDescriptor'
    builder => '_build_GetOwnProperty',
};

sub _build_GetOwnProperty { undefined };

has 'GetProperty' => {
    isa => 'Any'
    builder => '_build_GetProperty',
};

has 'Put' => {
    isa => 'Any'
    builder => '_build_Put',
};

has 'CanPut' => {
    isa => 'Any'
    builder => '_build_CanPut',
};

has 'HasProperty' => {
    isa => 'Any'
    builder => '_build_HasProperty',
};

has 'Delete' => {
    isa => 'Any'
    builder => '_build_Delete',
};

has 'DefaultValue' => {
    isa => 'Any'
    builder => '_build_DefaultValue',
};

has 'DefineOwnProperty' => {
    isa => 'Any'
    builder => '_build_DefineOwnProperty',
};

=head1 SEE ALSO

L<Moose>

=cut

1;
