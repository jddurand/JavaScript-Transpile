use strict;
use warnings FATAL => 'all';

package JavaScript::Transpile::Target::Perl5::Engine::Declare;

# ABSTRACT: JavaScript declarations in Perl

# VERSION

#
# Yes, JavaScript uses the prototype model. One might think that I should
# have used MooseX::Prototype, but if you look closely to the spec you
# will see that in fact classes are never modified. New "attributes" are
# in reality added in a PropertyDescriptor. Therefore it is perfectly
# sensible to use immutable classes to simulate JavaScript.
#

use MooseX::Declare;
use JavaScript::Transpile::Target::Perl5::Engine::PrimitiveTypes;
use JavaScript::Transpile::Target::Perl5::Engine::Constants qw/:all/;

class JavaScript::Type::PropertyDescriptor {
    use JavaScript::Transpile::Target::Perl5::Engine::PrimitiveTypes;
    use JavaScript::Transpile::Target::Perl5::Engine::Constants qw/:all/;
    use aliased 'JavaScript::Transpile::Target::Perl5::Engine::Exception';

    has '_property' => ( is => 'rw', traits => ['Hash'], isa => 'HashRef', default => sub { {enumerable => false, configurable => false} },
			 handles => {
			     accessor => 'accessor',
			     exists   => 'exists',
			 }
	);
    #
    # 8.10.1 IsAccessorDescriptor ( Desc )
    #
    method isAccessorDescriptor(ClassName $class: JavaScript::Type::PropertyDescriptor|JavaScript::Type::Undefined $desc) {
	if ($desc == undefined) {
	    return false;
	}
	if (! $desc->hash->exists('get') && ! $desc->hash->exists('set')) {
	    return false;
	}
	return true;
    }
    #
    # 8.10.2 IsDataDescriptor ( Desc )
    #
    method isDataDescriptor(ClassName $class: JavaScript::Type::PropertyDescriptor|JavaScript::Type::Undefined $desc) {
	if ($desc == undefined) {
	    return false;
	}
	if (! $desc->hash->exists('value') && ! $desc->hash->exists('writable')) {
	    return false;
	}
	return true;
    }
    #
    # 8.10.3 IsGenericDescriptor ( Desc )
    #
    method isGenericDescriptor(ClassName $class: JavaScript::Type::PropertyDescriptor|JavaScript::Type::Undefined $desc) {
	if ($desc == undefined) {
	    return false;
	}
	if ($class->IsAccessorDescriptor($desc) == false &&
	    $class->IsDataDescriptor($desc) == false) {
	    return true;
	}
	return false;
    }
    #
    # 8.10.4 FromPropertyDescriptor ( Desc )
    #
    method fromPropertyDescriptor(ClassName $class: JavaScript::Type::PropertyDescriptor|JavaScript::Type::Undefined $desc) {
	if ($desc == undefined) {
	    return undefined;
	}

	my $obj = JavaScript::Type::PropertyDescriptor->new();

	if ($class->IsDataDescriptor($desc) == true) {
	    $obj->defineOwnProperty('value',
				    {
					value => $desc->hash->get('value'),
					writable => true,
					enumerable => true,
					configurable => true
				    },
				    false);
	    $obj->defineOwnProperty('writable',
				    {
					value => $desc->hash->get('writable'),
					writable => true,
					enumerable => true,
					configurable => true
				    },
				    false);
	} else {
	    $obj->defineOwnProperty('get',
				    {
					value => $desc->hash->get('get'),
					writable => true,
					enumerable => true,
					configurable => true
				    },
				    false);
	    $obj->defineOwnProperty('set',
				    {
					value => $desc->hash->get('set'),
					writable => true,
					enumerable => true,
					configurable => true
				    },
				    false);
	}

	$obj->defineOwnProperty('enumerable',
				{
				    value => $desc->hash->get('enumerable'),
				    writable => true,
				    enumerable => true,
				    configurable => true
				},
				false);
	$obj->defineOwnProperty('configurable',
				{
				    value => $desc->hash->get('configurable'),
				    writable => true,
				    enumerable => true,
				    configurable => true
				},
				false);

	return $obj;
    }
    #
    # 8.10.5 ToPropertyDescriptor ( Obj )
    #
    method ToPropertyDescriptor(ClassName $class: $obj) {
	my $objBlessed = blessed($obj) || '';

	if ($objBlessed ne 'JavaScript::Type::Object') {
	    Exception->throw({type => 'TypeError', message => "\$obj does not have an object role"});
	}

	my $desc = JavaScript::Type::PropertyDescriptor->new();

	if ($obj->hasProperty('enumerable') == true) {
	    my $enum = $obj->get('enumerable');
	    $desc->hash->accessor('enumerable', $class->ToBoolean($enum));
	}

	if ($obj->hasProperty('configurable') == true) {
	    my $conf = $obj->get('configurable');
	    $desc->hash->accessor('configurable', $class->ToBoolean($conf));
	}

	if ($obj->hasProperty('value') == true) {
	    my $value = $obj->get('value');
	    $desc->hash->accessor('value', $value);
	}

	if ($obj->hasProperty('writable') == true) {
	    my $writable = $obj->get('writable');
	    $desc->property('writable', $class->ToBoolean($writable));
	}

	if ($obj->hasProperty('get') == true) {
	    my $getter = $obj->get('get');
	    if ($class->isCallable($getter) == false && $getter != undefined) {
		Exception->throw({type => 'TypeError', message => "getter $getter is not callable and is not undefined"});
	    }
	    $desc->hash->accessor('get', $getter);
	}

	if ($obj->hasProperty('set') == true) {
	    my $setter = $obj->get('set');
	    if ($class->isCallable($setter) == false && $setter != undefined) {
		Exception->throw({type => 'TypeError', message => "setter $setter is not callable and is not undefined"});
	    }
	    $desc->hash->accessor('set', $setter);
	}

	if ($desc->exists('get') || $desc->exists('set')) {
	    if ($desc->exists('value') || $desc->exists('writable')) {
		Exception->throw({type => 'TypeError', message => 'getter and/or setter property present, value and/or writable property as well'});
	    }
	}

	return $desc;
    }
}

class JavaScript::Type::Object is mutable {   # See below, I cannot blame MooseX::Declare for that
    use JavaScript::Transpile::Target::Perl5::Engine::PrimitiveTypes;
    use JavaScript::Transpile::Target::Perl5::Engine::Constants qw/:all/;
    use aliased 'JavaScript::Transpile::Target::Perl5::Engine::Exception';
    use Moose::Util::TypeConstraints;
    use Scalar::Util qw/blessed/;

    our %CLASSES = map {$_ => 1} qw/Arguments Array Boolean Date Error Function JSON Math Number Object RegExp String/;

    has '_properties'       => (traits => ['Hash'], is => 'ro', isa => 'HashRef[JavaScript::Type::PropertyDescriptor]', default => sub { {} },
				handles => {
				    descriptor         => 'accessor',
				    exists_descriptor  => 'exists',
				    descriptors        => 'keys',
				    count_descriptors  => 'count',
				    delete_descriptor  => 'delete',
				},
	);
    has 'class'             => (isa => 'Str',                               is => 'rw', coerce => 1, default => 'Object');
    has 'extensible'        => (isa => 'JavaScript::Type::Boolean',         is => 'rw', default => false);
    #
    # Take care: the root of all objects, i.e. $Object, is created with an explicit null
    #
    has 'prototype'         => (isa => 'JavaScript::Type::Object|JavaScript::Type::Null', is => 'rw', weak_ref => 1, default => null);

    #
    # JavaScript prototyping is as simple as that.
    # Another way would be like MooseX::Prototype with shallow copies.
    # But this mean creating mutable classes all the time.
    #
    around new(ClassName|JavaScript::Type::Object $class: @params) {
	my $blessed = blessed($class) || '';
	if ($blessed) {
	    return $blessed->$orig(@params, prototype => $class);
	}
	$class->$orig(@params);
    };
	
    #
    # 8.12.1 [[GetOwnProperty]] (P)
    #
    method getOwnProperty(Str $p) {
	print STDERR "$self->getOwnProperty($p)\n";
	if (! $self->exists_descriptor($p)) {
	    return undefined;
	}
	my $d = JavaScript::Type::PropertyDescriptor->new();
	my $x = $self->_properties->descriptor($p);
	if (JavaScript::Type::PropertyDescriptor->isDataproperty($x)) {
	    $d->accessor('value', $x->accessor('value'));
	    $d->accessor('writable', $x->accessor('writable'));
	} else {
	    $d->accessor('get', $x->accessor('get'));
	    $d->accessor('set', $x->accessor('set'));
	}
	$d->accessor('enumerable', $x->accessor('enumerable'));
	$d->accessor('configurable', $x->accessor('configurable'));
    }
    #
    # 8.12.2 [[GetProperty]] (P)
    #
    method getProperty(Str $p) {
	my $prop = $self->getOwnProperty($p);
	if ($prop != undefined) {
	    return $prop;
	}
	my $proto = $self->prototype;
	if (! defined($proto)) {
	    return undefined;
	}
	return $proto->SUPER($p);
    }
    #
    # 8.12.3 [[Get]] (P)
    #
    method get(Str $p) {
	my $desc = $self->getProperty($p);
	if ($desc == undefined) {
	    return undefined;
	}
	if ($desc->isDataDescriptor == true) {
	    return $desc->value;
	}
	my $getter = $desc->get;
	if ($getter == undefined) {
	    return undefined;
	}
	return $getter->call($self);
    }
    #
    # 8.12.6 [[HasProperty]] (P)
    #
    method hasProperty(Str $p) {
	my $desc = $self->getProperty($p);
	if ($desc == undefined) {
	    return undefined;
	}
	return true;
    }

    around class {
	return $self->$orig() unless  $#_ >= 2;

	my $class = pop;

	if (!exists($CLASSES{$class})) {
	    Exception->throw({type => 'TypeError', message => "The value of the [[Class]] internal property cannot but $class, but one of: " . join(' ', sort keys %CLASSES)});
	}
	#
	# if [[Extensible]] is false the value of the [[Class]] internal properties of the object may not be modified
	#
	if ($self->extensible == false) {
	    #
	    # We trigger if it really changes
	    #
	    Exception->throw({type => 'TypeError', message => "The value of the [[Class]] internal property may not be modified"});
	}
    
	return $self->$orig($class);
    }

      #
      # Private method that will search for a prototype
      #
      method _findPrototype(JavaScript::Type::Object $obj, ArrayRef $listp?) {
        my $prototype = $self->prototype;
        if (defined($prototype)) {
          if (defined($listp)) {
            push(@{$listp}, $prototype);
          }
          if ($prototype == $obj) {
            return true;
          } else {
            return $prototype->super($obj, $listp);
          }
        } else {
          return 0;
        }
      }

    around prototype {
	return $self->$orig() unless  $#_ >= 2;

	my $prototype = pop;

      #
      # if [[Extensible]] is false the value of the [[Prototype]] internal property of the object may not be modified
      #
      if ($self->extensible == false) {
	  #
	  # We trigger if it really changes
	  #
	  Exception->throw({type => 'GenericError', message => 'The value of the [[Prototype]] internal property may not be modified'});
      }
      my @list = ();
      $self->_findPrototype($prototype, \@list);
      print STDERR "Prototype chain: " . join(', ', reverse(@list)) . "\n";
      if ($prototype != null && $self->_findPrototype($prototype)) {
	  #
	  # Recursively accessing the [[Prototype]] internal property must eventually lead to a null value
	  #
	  Exception->throw({type => 'GenericError', message => 'Recursive access to [[Prototype]] internal property would be possible'});
      }
	
      return $self->$orig($prototype);
    }
    
    around extensible {
	return $self->$orig() unless  $#_ >= 2;

	my $extensible = pop;
	
	#
	# If the [[Extensible]] internal property of that host object has been observed
	# by ECMAScript code to be false then it must not subsequently become true.
	#
	if ($self->$orig() == false && $extensible == true) {
	    Exception->throw({type => 'GenericError', message => '[[Extensible]] internal property has been observed to be false so it must not subsequently become true'});
	}
	
	return $self->$orig($extensible);
    }
    
    __PACKAGE__->meta->make_immutable( inline_constructor => 0 );
}

1;
