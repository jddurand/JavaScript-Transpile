use strict;
use warnings FATAL => 'all';

package JavaScript::Transpile::Target::Perl5::Engine::InternalProperty;
use namespace::sweep;
use Moose::Role;
use MooseX::Prototype qw/create_class_from_prototype/;
use JavaScript::Transpile::Target::Perl5::Engine::Types;
use JavaScript::Transpile::Target::Perl5::Engine::Constants qw/:all/;
use JavaScript::Transpile::Target::Perl5::Engine::Exception;
use MooseX::Method::Signatures;
use Scalar::Util qw/refaddr/;

with 'MooseX::Role::Logger';

# ABSTRACT: JavaScript Internal Property role in Perl5

# VERSION

=head1 DESCRIPTION

This module provides JavaScript Internal Property role in a Perl5 environment.

=cut

our @NOT_ALLOWED_CLASS = qw/Arguments Array Boolean Date Error Function JSON Math Number Object RegExp String/;

#
# Note that ECMAScript does not say that an implementation must support overwriting the Class, Prototype or Extensible internal properties. It appears that I have chosen to support this, leading to few 'around' modifier methods.

#
# Because of the cost of creating a class, we do prototype in a lazy way.
#
has 'Prototype' => (isa => 'Object|Null',
                    is => 'rw',
                    lazy => 1,
                    builder => '_build_Prototype');

sub _build_Prototype {
  my ($self) = @_;
  #
  # By itself, MooseX::Prototype is building new classes everytime, so there
  # is no limit unless the user changes himself the prototype attribute, handled
  # with the around method modifier below
  #
  return create_class_from_prototype($self)->new();
}

around 'Prototype' => sub {
  my $orig = shift;
  my $self = shift;

  return $self->$orig() unless @_;

  my $prototype = shift;
  #
  # if [[Extensible]] is false the value of the [[Prototype]] internal property of the object may not be modified
  #
  if ($self->Extensible == false && $prototype ne $self->Prototype) {
    #
    # We trigger if it really changes
    #
    JavaScript::Transpile::Target::Perl5::Engine::Exception->throw({type => 'GenericError', message => 'The value of the [[Prototype]] internal property may not be modified'});
  }

  if ($prototype->DOES('Object')) {
    #
    # Recursively accessing the [[Prototype]] internal property must eventually lead to a null value
    #
    my $blessed = $prototype->blessed;
    if (grep {$_ eq $blessed} $self->meta->class_precedence_list()) {
      JavaScript::Transpile::Target::Perl5::Engine::Exception->throw({type => 'GenericError', message => 'Recursive access to [[Prototype]] internal property would be possible'});
    }
  }

  return $self->$orig($prototype);
};

has 'Class' => (isa => 'String',
		is => 'rw',
		builder => '_build_Class'
               );

#
# Built-in classes will have to sub-class _build_Class to inject one of one the
# reserved Class keywords
#
sub _build_Class {
    my ($self) = @_;

    return $self->blessed;
}

around 'Class' => sub {
  my $orig = shift;
  my $self = shift;

  return $self->$orig() unless @_;

  my $class = shift;
  #
  # if [[Extensible]] is false the value of the [[Class]] internal properties of the object may not be modified
  #
  if ($self->Extensible == false && $class ne $self->Class) {
    #
    # We trigger if it really changes
    #
    $self->logger->info('The value of the [[Class]] internal property may not be modified');
    return $self->$orig();
  }
  #
  # Class has some reserved keywords
  #
  if (grep {$class eq $_} @NOT_ALLOWED_CLASS) {
    JavaScript::Transpile::Target::Perl5::Engine::Exception->throw({type => 'GenericError', message => "Class value $class is not allowed"});
  }

  return $self->$orig($class);
};

has 'Extensible' => (
    isa => 'Boolean',
    is => 'rw',
    builder => '_build_Extensible'
);

sub _build_Extensible { false };

around 'Extensible' => sub {
  my $orig = shift;
  my $self = shift;

  return $self->$orig() unless @_;

  my $extensible = shift;
  #
  # If the [[Extensible]] internal property of that host object has been observed
  # by ECMAScript code to be false then it must not subsequently become true.
  #
  if ($self->$orig() == false && $extensible == true) {
    JavaScript::Transpile::Target::Perl5::Engine::Exception->throw({type => 'GenericError', message => '[[Extensible]] internal property has been observed to be false so it must not subsequently become true'});
  }

  return $self->$orig($extensible);
};

method Get($self: String $propertyName) {
  my $property = $self->Property;
  if ($property->DOES('Object')) {
    if ($property->DOES('NamedDataProperty')) {
	return;
    }
  }
}

sub _build_Get { undefined };

has 'GetOwnProperty' => {
    isa => 'Undefined|PropertyDescriptor',
    builder => '_build_GetOwnProperty',
};

sub _build_GetOwnProperty { undefined };

has 'GetProperty' => {
    isa => 'Any',
    builder => '_build_GetProperty',
};

has 'Put' => {
    isa => 'Any',
    builder => '_build_Put',
};

has 'CanPut' => {
    isa => 'Any',
    builder => '_build_CanPut',
};

has 'HasProperty' => {
    isa => 'Any',
    builder => '_build_HasProperty',
};

has 'Delete' => {
    isa => 'Any',
    builder => '_build_Delete',
};

has 'DefaultValue' => {
    isa => 'Any',
    builder => '_build_DefaultValue',
};

has 'DefineOwnProperty' => {
    isa => 'Any',
    builder => '_build_DefineOwnProperty',
};

=head1 SEE ALSO

L<Moose>

=cut

1;
