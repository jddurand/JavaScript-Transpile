use strict;
use warnings FATAL => 'all';

package JavaScript::Transpile::Target::Perl5::Engine::PropertyDescriptor;
use JavaScript::Transpile::Target::Perl5::Engine::Types;
use JavaScript::Transpile::Target::Perl5::Engine::Constants qw/:all/;
use namespace::sweep;
use Moose;
use Carp qw/croak/;
use Scalar::Util qw/blessed/;

# ABSTRACT: JavaScript Property Descriptor type in Perl5

# VERSION

=head1 DESCRIPTION

This module provides JavaScript Property Descriptor type in a Perl5 environment.

=cut

has 'Desc' => (
               is => 'ro',
               isa => 'HashRef|Undefined',
               builder => '_build_desc'
              );

around BUILDARGS => sub {
  my $orig  = shift;
  my $class = shift;

  if ( @_ == 1 && ref($_[0]) eq 'HASH') {
    return $class->$orig( Desc => $_[0] );
  } else {
    return $class->$orig(@_);
  }
};

sub _build_desc {
  return undefined;
}

sub IsAccessorDescriptor {
  my ($self) = @_;

  my $Desc = $self->Desc();

  if ($Desc == undefined) {
    return false;
  }

  if (! exists($Desc->{Get}) && ! exists($Desc->{Set})) {
    return false;
  }
  return true;
}

sub IsDataDescriptor {
  my ($self) = @_;

  my $Desc = $self->Desc;

  if ($Desc == undefined) {
    return false;
  }
  if (! exists($Desc->{Value}) && ! exists($Desc->{Writable})) {
    return false;
  }
  return true;
}

sub IsGenericDescriptor {
  my ($self) = @_;

  my $Desc = $self->Desc;

  if ($Desc == undefined) {
    return false;
  }
  if ($self->IsAccessorDescriptor == false &&
      $self->IsDataDescriptor == false) {
    return true;
  }
  return false;
}

sub FromPropertyDescriptor {
  my ($self) = @_;

  my $Desc = $self->Desc;

  if ($Desc == undefined) {
    return undefined;
  }

  my $obj = Object->new();

  if ($self->IsDataDescriptor == true) {
    $obj->DefineOwnProperty('value',
                            {
                             Value => $Desc->{Value},
                             Writable => true,
                             Enumerable => true,
                             Configurable => true
                            },
                            false);
    $obj->DefineOwnProperty('writable',
                            {
                             Value => $Desc->{Writable},
                             Writable => true,
                             Enumerable => true,
                             Configurable => true
                            },
                            false);
  } else {
    $obj->DefineOwnProperty('get',
                            {
                             Value => $Desc->{Get},
                             Writable => true,
                             Enumerable => true,
                             Configurable => true
                            },
                            false);
    $obj->DefineOwnProperty('set',
                            {
                             Value => $Desc->{Set},
                             Writable => true,
                             Enumerable => true,
                             Configurable => true
                            },
                            false);
  }

  $obj->DefineOwnProperty('enumerable',
                          {
                           Value => $Desc->{Enumerable},
                           Writable => true,
                           Enumerable => true,
                           Configurable => true
                          },
                          false);
  $obj->DefineOwnProperty('configurable',
                          {
                           Value => $Desc->{Configurable},
                           Writable => true,
                           Enumerable => true,
                           Configurable => true
                          },
                          false);

  return $obj;
}

sub ToPropertyDescriptor {
  my ($self, $obj) = @_;

  my $objBlessed = blessed($obj) || '';

  if ($objBlessed ne 'Object') {
    croak "TypeError: \$obj is of type '$objBlessed', should be 'Object'";
  }

  my $desc = __PACKAGE__->new();

  my $Desc = $desc->desc;

  if ($obj->HasProperty('enumerable') == true) {
    my $enum = $obj->Get('enumerable');
    $Desc->{Enumerable} = ToBoolean($enum);
  }

  if ($obj->HasProperty('configurable') == true) {
    my $conf = $obj->Get('configurable');
    $Desc->{Configurable} = ToBoolean($conf);
  }

  if ($obj->HasProperty('value') == true) {
    my $value = $obj->Get('value');
    $Desc->{Value} = $value;
  }

  if ($obj->HasProperty('writable') == true) {
    my $writable = $obj->Get('writable');
    $Desc->{Writable} = ToBoolean($writable);
  }

  if ($obj->HasProperty('get') == true) {
    my $getter = $obj->Get('get');
    if (IsCallable($getter) == false && $getter != undefined) {
      croak "TypeError: getter $getter is not callable and is not undefined";
    }
    $Desc->{Get} = $getter;
  }

  if ($obj->HasProperty('set') == true) {
    my $setter = $obj->Get('set');
    if (IsCallable($setter) == false && $setter != undefined) {
      croak "TypeError: setter $setter is not callable and is not undefined";
    }
    $Desc->{Set} = $setter;
  }

  if (exists($Desc->{Get}) || exists($Desc->{Set})) {
    if (exists($Desc->{Value}) || exists($Desc->{Writable})) {
      croak 'TypeError: getter and/or setter property present, value and/or writable property as well';
    }
  }

  return $desc;

}

__PACKAGE__->meta()->make_immutable();

1;
