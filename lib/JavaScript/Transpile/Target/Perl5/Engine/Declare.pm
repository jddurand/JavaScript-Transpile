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

class JavaScript::Type::Object is mutable {   # See below, I cannot blame MooseX::Declare for that
    use JavaScript::Transpile::Target::Perl5::Engine::PrimitiveTypes;
    use JavaScript::Transpile::Target::Perl5::Engine::Constants qw/:all/;
    use aliased 'JavaScript::Transpile::Target::Perl5::Engine::Exception';
    use Moose::Util::TypeConstraints;
    use Scalar::Util qw/blessed/;

    our %CLASSES = map {$_ => 1} qw/Arguments Array Boolean Date Error Function JSON Math Number Object RegExp String/;

    has '_propertyDescriptorHash' =>
	(traits => ['Hash'],
	 is => 'ro',
	 isa => 'HashRef[JavaScript::Role::PropertyDescriptor]',
	 default => sub { {} },
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
    has 'prototype'         => (isa => 'JavaScript::Type::Object|JavaScript::Type::Null', is => 'rw', weak_ref => 1, default => sub { return null });

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
    method getOwnProperty($O: Str $P) {
	if (! $O->exists_descriptor($P)) {
	    return undefined;
	}
	my $D = JavaScript::Role::PropertyDescriptor->new();
	my $X = $O->_propertyDescriptorHash->descriptor($P);
	if (JavaScript::Role::PropertyDescriptor->isDataproperty($X)) {
	    $D->accessor('value', $X->accessor('value'));
	    $D->accessor('writable', $X->accessor('writable'));
	} else {
	    $D->accessor('get', $X->accessor('get'));
	    $D->accessor('set', $X->accessor('set'));
	}
	$D->accessor('enumerable', $X->accessor('enumerable'));
	$D->accessor('configurable', $X->accessor('configurable'));
	return $D;
    }
    #
    # 8.12.2 [[GetProperty]] (P)
    #
    method getProperty($O: Str $P) {
	my $prop = $O->getOwnProperty($P);
	if ($prop != undefined) {
	    return $prop;
	}
	my $proto = $O->prototype;
	if ($proto == null) {
	    return undefined;
	}
	return $proto->SUPER($P);
    }
    #
    # 8.12.3 [[Get]] (P)
    #
    method get($O: Str $P) {
	my $desc = $O->getProperty($P);
	if ($desc == undefined) {
	    return undefined;
	}
	if ($desc->isDataDescriptor == true) {
	    return $desc->get('value');
	}
	my $getter = $desc->('get');
	if ($getter == undefined) {
	    return undefined;
	}
	return $getter->call($O);
    }
    #
    # 8.12.4 [[CanPut]] (P)
    #
    method canPut($O: Str $P) {
	my $desc = $O->getOwnProperty($P);
	if ($desc != undefined) {
	    if ($desc->isDataDescriptor == true) {
		if  ($desc->get('set') == undefined) {
		    return false;
		} else {
		    return true;
		}
	    } else {
		return $desc->get('writable');
	    }
	}
	my $proto = $O->prototype;
	if ($proto == null) {
	    return $O->extensible;
	}
	my $inherited = $proto->getProperty($P);
	if ($inherited == undefined) {
	    return $O->extensible;
	}
	if ($inherited->isAccessorDescriptor == true) {
	    if ($inherited->get('set') == undefined) {
		return false;
	    } else {
		return true;
	    }
	} else {
	    if ($O->extensible == false) {
		return false;
	    } else {
		return $inherited->get('writable');
	    }
	}
    }
    #
    # 8.12.5 [[Put]] ( P, V, Throw )
    #
    method put($O: Str $P, JavaScript::Type::Primitive|JavaScript::Type::Object $V, JavaScript::Type::Boolean $Throw) {
	if ($O->canPut($P) == false) {
	    if ($Throw == true) {
		Exception->throw({type => 'TypeError', message => "[[canPut]] on $P returned false"});
	    } else {
		return;
	    }
	}
	my $ownDesc = $O->getOwnProperty($P);
	if ($ownDesc->isDataDescriptor == true) {
	    my $valueDesc = JavaScript::Role::PropertyDescriptor->new({value => $V});
	    $O->defineOwnProperty($P, $valueDesc, $Throw);
	    return;
	}
	my $desc = $O->getProperty($P);
	if ($desc->isDataDescriptor == true) {
	    my $setter = $desc->get('set');
	    $setter->call($O, $V);
	} else {
	    my $newDesc = JavaScript::Role::PropertyDescriptor->new({value => $V,
								     writable => true,
								     enumerable => true,
								     configurable => true});
	    $O->defineOwnProperty($P, $newDesc, $Throw);
	}
    }
    #
    # 8.12.6 [[HasProperty]] (P)
    #
    method hasProperty($O: Str $P) {
	my $desc = $O->getProperty($P);
	if ($desc == undefined) {
	    return false;
	} else {
	    return true;
	}
    }
    #
    # 8.12.7 [[Delete]] (P, Throw)
    #
    method delete($O: Str $P, JavaScript::Type::Boolean $Throw) {
	my $desc = $O->getProperty($P);
	if ($desc == undefined) {
	    return true;
	}
	if ($desc->get('configurable') == true) {
	    $O->_propertyDescriptorHash->delete_descriptor($P);
	    return true;
	} elsif ($Throw == true) {
	    Exception->throw({type => 'TypeError', message => "[[Delete]] on $P that have configurable == false"});
	}
	return false;
    }
    #
    # 8.12.8 [[DefaultValue]] (hint)
    #
    method defaultValue($O: Str $hint?) {
	if (defined($hint) && $hint eq 'String') {
	    my $toString = $O->get('toString');
	}
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
        if ($prototype != null) {
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

role JavaScript::Role::TypeConversionAndTesting {
    use JavaScript::Transpile::Target::Perl5::Engine::PrimitiveTypes;
    use JavaScript::Transpile::Target::Perl5::Engine::Constants qw/:all/;
    #
    # 9.1 ToPrimitive
    #
    method toPrimitive(ClassName $class: JavaScript::Type::Primitive|JavaScript::Type::Object $input, Str $preferredType?) {
	if (! $input->isa('JavaScript::Type::Object')) {
	    return $input;
	} else {
	    #
	    # $preferredType will be undef is not present. JavaScript::Type::Object->defaultValue() handles this.
	    #
	    return $input->defaultValue($preferredType);
	}
    }
    #
    # 9.2 ToBoolean
    #
    method toBoolean(ClassName $class: JavaScript::Type::Primitive|JavaScript::Type::Object $input) {
	if ($input->isa('JavaScript::Type::Undefined')) {
	    return false;
	}
	elsif ($input->isa('JavaScript::Type::Null')) {
	    return false;
	}
	elsif ($input->isa('JavaScript::Type::Boolean')) {
	    return $input;
	}
	elsif ($input->isa('JavaScript::Type::Number')) {
	    # TODO return $input;
	}
    }
}

role JavaScript::Role::EnvironmentRecord {
    use JavaScript::Transpile::Target::Perl5::Engine::PrimitiveTypes;
    use JavaScript::Transpile::Target::Perl5::Engine::Constants qw/:all/;

    has 'value'     => (isa => 'JavaScript::Type::Primitive|JavaScript::Type::Object',     is => 'rw', predicate => 'has_value');
    has 'mutable'   => (isa => 'JavaScript::Type::Boolean', is => 'rw', default => true);
    has 'deletable' => (isa => 'JavaScript::Type::Boolean', is => 'rw', default => true);
}

role JavaScript::Role::DeclarativeEnvironmentRecord {
    use JavaScript::Transpile::Target::Perl5::Engine::PrimitiveTypes;
    use JavaScript::Transpile::Target::Perl5::Engine::Constants qw/:all/;
    use aliased 'JavaScript::Transpile::Target::Perl5::Engine::Exception';

    has '_declarativeEnvironmentRecord' =>
	( is => 'rw',
	  traits => ['Hash'],
	  isa => 'HashRef[JavaScript::Role::EnvironmentRecord]',
	  default => sub { {} },
	  handles => {
	      accessor => 'accessor',
	      exists   => 'exists',
	      delete  => 'delete',
	  }
	);
    #
    # 10.2.1.1.1 HasBinding(N)
    #
    method hasBinding($envRec: Str $N) {
	if ($envRec->exists($N)) {
	    return true;
	}
	return false;
    }
    #
    # 10.2.1.1.2 CreateMutableBinding (N, D)
    #
    method createMutableBinding($envRec: Str $N, JavaScript::Type::Boolean $D) {
	my $environmentRecord = JavaScript::Role::EnvironmentRecord->new({value => undefined, mutable => 1});
	if ($D == true) {
	    $environmentRecord->deletable(true);
	}
	$envRec->set($N, $environmentRecord);
    }
    #
    # 10.2.1.1.3 SetMutableBinding (N,V,S)
    #
    method SetMutableBinding($envRec: Str $N, JavaScript::Type::Primitive|JavaScript::Type::Object $V, JavaScript::Type::Boolean $S) {
	if ($envRec->get($N)->mutable == true) {
	    $envRec->get($N)->value($V);
	} else {
	    if ($S == true) {
		Exception->throw({type => 'TypeError', message => "Attempt to change the value of an immutable binding for $N"});
	    }
	}
    }
    #
    # 10.2.1.1.4 GetBindingValue(N,S)
    #
    method getBindingValue($envRec: Str $N, JavaScript::Type::Boolean $S) {
	if (! $envRec->get($N)->has_value) {
	    if ($S == false) {
		return undefined;
	    } else {
		Exception->throw({type => 'ReferenceError', message => "Attempt to get the value of an unitialized binding for $N"});
	    }
	} else {
	    return $envRec->get($N)->value;
	}
    }
    #
    # 10.2.1.1.5 DeleteBinding (N)
    #
    method deleteBinding($envRec: Str $N) {
	if (! $envRec->exists($N)) {
	    return true;
	}
	if (! $envRec->get($N)->deletable) {
	    return false;
	}
	$envRec->delete($N);
	return true;
    }
    #
    # 10.2.1.1.6 ImplicitThisValue()
    #
    method implicitThisValue {
	return undefined;
    }
    #
    # 10.2.1.1.7 CreateImmutableBinding (N)
    #
    method createImmutableBinding($envRec: Str $N) {
	$envRec->set($N, JavaScript::Role::EnvironmentRecord->new({mutable => false}));
    }
    #
    # 10.2.1.1.8 InitializeImmutableBinding (N,V)
    #
    method initializeImmutableBinding($envRec: Str $N, Any $V) {
	$envRec->get($N)->value($V);
	# Record that the immutable binding for N in envRec has been initialised: automatic with predicate has_value
    }
}

role JavaScript::Role::ObjectEnvironmentRecord {
    use JavaScript::Transpile::Target::Perl5::Engine::PrimitiveTypes;
    use JavaScript::Transpile::Target::Perl5::Engine::Constants qw/:all/;
    use aliased 'JavaScript::Transpile::Target::Perl5::Engine::Exception';

    has 'bindings'    => ( is => 'ro', isa => 'JavaScript::Type::Object', required => 1);
    has 'provideThis' => ( is => 'ro', isa => 'JavaScript::Type::Boolean', default => false);
    #
    # 10.2.1.2.1 HasBinding(N)
    #
    method hasBinding($envRec: Str $N) {
    	my $bindings = envRec->_bindings;
    	return $bindings->hasProperty($N);
    }
    #
    # 10.2.1.2.2 CreateMutableBinding (N, D)
    #
    method createMutableBinding($envRec: Str $N, JavaScript::Type::Boolean $D) {
    	my $bindings = envRec->_bindings;
    	my $configValue = ($D == true) ? true : false;
    	$bindings->defineOwnProperty($N,
    				     JavaScript::Role::PropertyDescriptor->new(
    					 {
    					     value => undefined,
    					     writable => true,
    					     enumerable => true,
    					     configurable => $configValue
    					 }
    				     ),
    				     true);
    }
    #
    # 10.2.1.2.3 SetMutableBinding (N,V,S)
    #
    method SetMutableBinding($envRec: Str $N, Any $V, JavaScript::Type::Boolean $S) {
    	my $bindings = envRec->_bindings;
    	$bindings->put($N, $V, $S);
    }
    #
    # 10.2.1.2.4 GetBindingValue(N,S)
    #
    method getBindingValue($envRec: Str $N, JavaScript::Type::Boolean $S) {
    	my $bindings = envRec->_bindings;
    	my $value = $bindings->hasProperty($N);
    	if ($value == false) {
    	    if ($S == false) {
    		return undefined;
    	    } else {
    		Exception->throw({type => 'ReferenceError', message => "Attempt to get the value of an unitialized binding for $N"});
    	    }
    	}
    	return $bindings->get($N);
    }
    #
    # 10.2.1.2.5 DeleteBinding (N)
    #
    method deleteBinding($envRec: Str $N) {
    	my $bindings = $envRec->bindings;
    	return $bindings->delete($N, false);
    }
    #
    # 10.2.1.2.6 ImplicitThisValue()
    #
    method implicitThisValue($envRec) {
    	if ($envRec->provideThis) {
    	    return $envRec->bindings;
    	} else {
    	    return undefined;
    	}
    }
}

role JavaScript::Role::PropertyDescriptor {
    use JavaScript::Transpile::Target::Perl5::Engine::PrimitiveTypes;
    use JavaScript::Transpile::Target::Perl5::Engine::Constants qw/:all/;
    use aliased 'JavaScript::Transpile::Target::Perl5::Engine::Exception';

    has '_propertyDescriptor' =>
	( is => 'rw',
	  traits => ['Hash'],
	  isa => 'HashRef',
	  default => sub { {enumerable => false, configurable => false} },
	  handles => {
	      accessor => 'accessor',
	      exists   => 'exists',
	  }
	);
    #
    # 8.10.1 IsAccessorDescriptor ( Desc )
    #
    method isAccessorDescriptor(ClassName $class: JavaScript::Role::PropertyDescriptor|JavaScript::Type::Undefined $desc) {
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
    method isDataDescriptor(ClassName $class: JavaScript::Role::PropertyDescriptor|JavaScript::Type::Undefined $desc) {
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
    method isGenericDescriptor(ClassName $class: JavaScript::Role::PropertyDescriptor|JavaScript::Type::Undefined $desc) {
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
    method fromPropertyDescriptor(ClassName $class: JavaScript::Role::PropertyDescriptor|JavaScript::Type::Undefined $desc) {
	if ($desc == undefined) {
	    return undefined;
	}

	my $obj = JavaScript::Role::PropertyDescriptor->new();

	if ($class->IsDataDescriptor($desc) == true) {
	    $obj->defineOwnProperty('value',
				    JavaScript::Role::PropertyDescriptor->new(
					{
					    value => $desc->hash->get('value'),
					    writable => true,
					    enumerable => true,
					    configurable => true
					}
				    ),
				    false);
	    $obj->defineOwnProperty('writable',
				    JavaScript::Role::PropertyDescriptor->new(
					{
					    value => $desc->hash->get('writable'),
					    writable => true,
					    enumerable => true,
					    configurable => true
					}
				    ),
				    false);
	} else {
	    $obj->defineOwnProperty('get',
				    JavaScript::Role::PropertyDescriptor->new(
					{
					    value => $desc->hash->get('get'),
					    writable => true,
					    enumerable => true,
					    configurable => true
					}
				    ),
				    false);
	    $obj->defineOwnProperty('set',
				    JavaScript::Role::PropertyDescriptor->new(
					{
					    value => $desc->hash->get('set'),
					    writable => true,
					    enumerable => true,
					    configurable => true
					}
				    ),
				    false);
	}

	$obj->defineOwnProperty('enumerable',
				JavaScript::Role::PropertyDescriptor->new(
				    {
					value => $desc->hash->get('enumerable'),
					writable => true,
					enumerable => true,
					configurable => true
				    }
				),
				false);
	$obj->defineOwnProperty('configurable',
				JavaScript::Role::PropertyDescriptor->new(
				    {
					value => $desc->hash->get('configurable'),
					writable => true,
					enumerable => true,
					configurable => true
				    }
				),
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

	my $desc = JavaScript::Role::PropertyDescriptor->new();

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

role JavaScript::Role::Reference {
    has 'class'             => (isa => 'Str',                               is => 'rw', coerce => 1, default => 'Object');
}


1;
