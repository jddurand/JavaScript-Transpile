use strict;
use warnings FATAL => 'all';

package JavaScript::Transpile::Target::Perl5::Engine::Roles::Object::Parameterized;
use MooseX::Declare;

role JavaScript::Roles::Object::Parameterized(Str :$class!) {
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
    has 'class'             => (isa => 'Str',                               is => 'rw', coerce => 1, default => $class);
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
        local $JavaScript::Transpile::Target::Perl5::Engine::this = $O;
	return $getter->call();
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
            local $JavaScript::Transpile::Target::Perl5::Engine::this = $O;
	    $setter->call($V);
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
	# TO DO
	$hint //= ($O->class eq 'Date') ? 'String' : 'Number';
	if ($hint eq 'String') {
	    my $toString = $O->get('toString');
	    if (isCallable($toString) == true) {
                local $JavaScript::Transpile::Target::Perl5::Engine::this = $O;
		my $str = $toString->call();
		if ($str->isa('JavaScript::Type::Primitive')) {
		    return $str;
		}
	    }
	    my $valueOf = $O->get('valueOf');
	    if (isCallable($valueOf) == true) {
                local $JavaScript::Transpile::Target::Perl5::Engine::this = $O;
		my $val = $valueOf->call();
		if ($val->isa('JavaScript::Type::Primitive')) {
		    return $val;
		}
	    }
	    Exception->throw({type => 'TypeError', message => '[[defaultValue]] cannot be computed'});
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
    
}

1;
