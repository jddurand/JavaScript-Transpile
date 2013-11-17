use strict;
use warnings FATAL => 'all';

package JavaScript::Transpile::Target::Perl5::Engine::Roles::ReferenceSpecification;
use JavaScript::Transpile::Target::Perl5::Engine::Types;
use Moose::Role;
use MooseX::Privacy;

# ABSTRACT: JavaScript Reference Specification role in Perl5

# VERSION

=head1 DESCRIPTION

This module provides JavaScript Reference Specification role implementation in a Perl5 environment.

=cut

has 'base' => (
    is     => 'rw',
    isa    => 'Undefined|Object|Boolean|String|Number|EnvironmentRecord',
    traits => [qw/Private/],
    default => { undef }
    );

has 'referencedName' => (
    is     => 'rw',
    isa    => 'String',
    traits => [qw/Private/],
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
    return
	$self->base->DOES('Boolean') ||
	$self->base->DOES('String') ||
	$self->base->DOES('Number') ||
	;
}

sub IsPropertyReference {
    my $self = shift;
    return
	$self->base->DOES('Object') ||
	$self->HasPrimitiveBase()
	;
}

sub IsUnresolvableReference {
    my $self = shift;
    return ! defined($self->base);
}

=head1 SEE ALSO

L<Moose>

=cut

1;
