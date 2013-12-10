use strict;
use warnings FATAL => 'all';

package JavaScript::Transpile::Target::Perl5::Engine::Helpers::PropertyDescriptor;
use JavaScript::Transpile::Target::Perl5::Engine::Types qw/PropertyDescriptor/;
use JavaScript::Transpile::Target::Perl5::Engine::Constants qw/:all/;
use Method::Signatures;

method IsAccessorDescriptor($class: PropertyDescriptor Desc) {

  if ($Desc == undefined) {
    return false;
  }

  if (! exists($Desc->{Get}) && ! exists($Desc->{Set})) {
    return false;
  }

  return true;
}

method IsDataDescriptor($class: PropertyDescriptor Desc) {

  if ($Desc == undefined) {
    return false;
  }

  if (! exists($Desc->{Value}) && ! exists($Desc->{Writable})) {
    return false;
  }

  return true;
}

method IsGenericDescriptor($class: PropertyDescriptor Desc) {

  if ($Desc == undefined) {
    return false;
  }

  if ($class->IsAccessorDescriptor($Desc) == false &&
      $class->IsDataDescriptor($Desc) == false) {
    return true;
  }

  return false;
}

method FromPropertyDescriptor($class: PropertyDescriptor Desc) {

  if ($Desc == undefined) {
    return undefined;
  }

  my $obj = Object->new();

  if ($class->IsDataDescriptor($Desc) == true) {
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

method ToPropertyDescriptor($class: Object Obj) {

    my $Desc = {};

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

1;
