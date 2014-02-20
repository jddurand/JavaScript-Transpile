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

role JavaScript::Role::this {
  #
  # "this" method, that returns the variable $JavaScript::Transpile::Target::Perl5::Engine::this
  # which should be localized anytime needed.
  #
  method this {
      #
      # If localized this is defined, it has priority, otherwise current object is used
      #
      return $JavaScript::Transpile::Target::Perl5::Engine::this || $self;
  }
}

#
# A bit painful, but necessary because type constraints in Moose is not a type system
# This role is special in the sense that it is a runtime substitute for methods
# that are polymorphic with no explicit type constraint
#
role JavaScript::Role::IsType {
    use Moose::Util::TypeConstraints;
    our %CONSTRAINT = (
                      OBJECT_TYPE    => find_type_constraint('JavaScript::Type::Object'),
                      BOOLEAN_TYPE   => find_type_constraint('JavaScript::Type::Boolean'),
                      UNDEFINED_TYPE => find_type_constraint('JavaScript::Type::Undefined'),
                      NULL_TYPE      => find_type_constraint('JavaScript::Type::Null'),
                      STRING_TYPE    => find_type_constraint('JavaScript::Type::String'),
                      NUMBER_TYPE    => find_type_constraint('JavaScript::Type::Number')
                     );

    #
    # Not declared as methods: we do not want signatures to be redone
    # Per def our caller already did it
    #
    method _isObjectByType($input, $wantedType) {
      return $CONSTRAINT{$wantedType}->check($input || $self);
    }

    method _isObject($input)    { return $self->_isObjectByType($input, 'OBJECT_TYPE')    }
    method _isBoolean($input)   { return $self->_isObjectByType($input, 'BOOLEAN_TYPE')   }
    method _isUndefined($input) { return $self->_isObjectByType($input, 'UNDEFINED_TYPE') }
    method _isNull($input)      { return $self->_isObjectByType($input, 'NULL_TYPE')      }
    method _isNumber($input)    { return $self->_isObjectByType($input, 'NUMBER_TYPE')    }
    method _isString($input)    { return $self->_isObjectByType($input, 'STRING_TYPE')    }
}
#
# A number factory must be the same the whole lifetime of package evaluation.
# That's why it is considered as a constant, that can be localized in the top
# package JavaScript::Transpile
#
role JavaScript::Role::TypeConversionAndTesting with (JavaScript::Role::IsType) {
    use JavaScript::Transpile::Target::Perl5::Engine::PrimitiveTypes;
    use JavaScript::Transpile::Target::Perl5::Engine::Constants qw/:all/;
    use JavaScript::Transpile::Target::Perl5::Engine::Number::Factory;

    has '_numberFactory' => (is => 'ro', default => sub { JavaScript::Transpile::Target::Perl5::Engine::Number::Factory->create($JavaScript::Transpile::numberFactory || 'Native') } );

    #
    # 9.1 ToPrimitive
    #
    method toPrimitive($input, $preferredType) {
	if (! $self->_isObject($input)) {
	    return $input;
	} else {
	    #
	    # $input->defaultValue() will handle $preferredType being undef
	    #
	    return $input->defaultValue($preferredType);
	}
    }
    #
    # 9.2 ToBoolean
    #
    method toBoolean($input) {
      if ($self->_isUndefined($input)) {
        return false;
      }
      elsif ($self->_isNull($input)) {
        return false;
      }
      elsif ($self->_isBoolean($input)) {
        return $input;
      }
      elsif ($self->_isNumber($input)) {
        if ($self->_numberFactory->is_zero($input) || $self->_numberFactory->is_nan($input)) {
          return false;
        } else {
          return true;
        }
      }
      elsif ($self->_isString($input)) {
        if ($input->is_empty) {
          return false;
        } else {
          return true;
        }
      }
      else {
        return true;
      }
    }
    #
    # 9.3 ToNumber: static method with type checking done by hand
    #
    method toNumber($input) {
      if ($self->_isUndefined($input)) {
	    return $self->_numberFactory->nan;
	}
	elsif ($self->_isNull($input)) {
	    return $self->_numberFactory->pos_zero;
	}
	elsif ($self->_isBoolean($input)) {
	    if ($input == true) {
		return 1;
	    } else {
		return $self->_numberFactory->pos_zero;
	    }
	}
	elsif ($self->_isNumber($input)) {
	    return $input;
	}
	elsif ($self->_isString($input)) {
	    # TO DO
	}
        else {
	    my $primValue = $self->toPrimitive($input, 'Number');
	    return $self->toNumber($primValue);
	}
    }
}

role JavaScript::Role::EnvironmentRecord {
    use JavaScript::Transpile::Target::Perl5::Engine::PrimitiveTypes;
    use JavaScript::Transpile::Target::Perl5::Engine::Constants qw/:all/;

    has 'value'     => (isa => 'JavaScript::Type::Any',     is => 'rw', predicate => 'has_value');
    has 'mutable'   => (isa => 'JavaScript::Type::Boolean', is => 'rw', default => true);
    has 'deletable' => (isa => 'JavaScript::Type::Boolean', is => 'rw', default => true);
}

role JavaScript::Role::DeclarativeEnvironmentRecord {
    use JavaScript::Transpile::Target::Perl5::Engine::PrimitiveTypes;
    use JavaScript::Transpile::Target::Perl5::Engine::Constants qw/:all/;
    use aliased 'JavaScript::Transpile::Target::Perl5::Engine::Exception';

    has '_declarativeEnvironmentRecordHash' =>
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
    method SetMutableBinding($envRec: Str $N, JavaScript::Type::Any $V, JavaScript::Type::Boolean $S) {
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

    has '_propertyDescriptorHash' =>
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
    method ToPropertyDescriptor(ClassName $class: JavaScript::Type::Any $obj) {

	if (! $obj->DOES('JavaScript::Type::Object')) {
	    Exception->throw({type => 'TypeError', message => "\$obj is not an Object but a " . $obj->blessed});
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
