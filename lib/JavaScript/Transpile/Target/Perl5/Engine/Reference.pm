use strict;
use warnings FATAL => 'all';

package JavaScript::Transpile::Target::Perl5::Engine::Roles::Reference;
use JavaScript::Transpile::Target::Perl5::Engine::Types;
use JavaScript::Transpile::Target::Perl5::Engine::Constants;
use Moose;
use MooseX::ClassAttribute;

# ABSTRACT: JavaScript Reference type in Perl5

# VERSION

=head1 DESCRIPTION

This module provides JavaScript Reference type implementation in a Perl5 environment.

=cut

has 'base' => (
    is     => 'rw',
    isa    => 'Undefined|Object|Boolean|String|Number|EnvironmentRecord',
    default => { undefined }
    );

has 'referencedName' => (
    is     => 'rw',
    isa    => 'String',
    );


has 'strictReference' => (
    is     => 'rw',
    isa    => 'Boolean',
    );


sub GetBase {
    my $self = shift;

    return $self->base;
}

sub GetReferencedName {
    my $self = shift;

    return $self->referencedName;
}

sub IsStrictReference {
    my $self = shift;

    return $self->strictReference;
}

sub HasPrimitiveBase {
    my $self = shift;

    if ($self->base->DOES('Boolean') ||
	$self->base->DOES('String') ||
	$self->base->DOES('Number')) {
	return true;
    } else {
	return false;
    }
}

sub IsPropertyReference {
    my $self = shift;

    if ($self->base->DOES('Object') ||
	$self->HasPrimitiveBase()) {
	return true,
    } else {
	return false;
    }
}

sub IsUnresolvableReference {
    my $self = shift;

    if ($self->base == undefined) {
	return true;
    } else {
	return false;
    }
}

class_has 'GetValue' => 
        ( is      => 'rw',
          isa     => 'Any',
          default => sub {
	      my ($class, $v) = @_;

	      if (ref($v) ne __PACKAGE__) {
		  return $v;
	      }

	      my $base = $v->GetBase();

	      if ($v->IsUnresolvableReference()) {
		  croak 'ReferenceError: Unresolvable reference';
	      }
	      if ($v->IsPropertyReference() == true) {
		  if ($v->HasPrimitiveBase() == false) {
		      my $get = $base->
		  }
	      }

	      if ($desc == undefined) {
		  return false;
	      }
	      if (! exists($desc->{Get} && ! $desc->{Set})) {
		  return false;
	      }
	      return true;
	  },
        );

=head1 SEE ALSO

L<Moose>

=cut

1;
