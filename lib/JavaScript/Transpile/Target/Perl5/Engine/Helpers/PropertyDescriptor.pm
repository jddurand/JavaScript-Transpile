use strict;
use warnings FATAL => 'all';

package JavaScript::Transpile::Target::Perl5::Engine::Helpers::PropertyDescriptor;
use JavaScript::Transpile::Target::Perl5::Engine::Types qw/PropertyDescriptor/;
use JavaScript::Transpile::Target::Perl5::Engine::Constants qw/:all/;
use MooseX::Method::Signatures;
use Carp qw/croak/;

method IsAccessorDescriptor($class: PropertyDescriptor $desc) {

  if ($desc == undefined) {
    return false;
  }

  if (! exists($desc->{Get}) && ! exists($desc->{Set})) {
    return false;
  }

  return true;
}

method IsDataDescriptor($class: PropertyDescriptor $desc) {

  if ($desc == undefined) {
    return false;
  }

  if (! exists($desc->{Value}) && ! exists($desc->{Writable})) {
    return false;
  }

  return true;
}

method IsGenericDescriptor($class: PropertyDescriptor $desc) {

  if ($desc == undefined) {
    return false;
  }

  if ($class->IsAccessorDescriptor($desc) == false &&
      $class->IsDataDescriptor($desc) == false) {
    return true;
  }

  return false;
}

method FromPropertyDescriptor($class: PropertyDescriptor $desc) {

  if ($desc == undefined) {
    return undefined;
  }

  my $obj = Object->new();

  if ($class->IsDataDescriptor($desc) == true) {
    $obj->DefineOwnProperty('value',
                            {
                             Value => $desc->{Value},
                             Writable => true,
                             Enumerable => true,
                             Configurable => true
                            },
                            false);
    $obj->DefineOwnProperty('writable',
                            {
                             Value => $desc->{Writable},
                             Writable => true,
                             Enumerable => true,
                             Configurable => true
                            },
                            false);
  } else {
    $obj->DefineOwnProperty('get',
                            {
                             Value => $desc->{Get},
                             Writable => true,
                             Enumerable => true,
                             Configurable => true
                            },
                            false);
    $obj->DefineOwnProperty('set',
                            {
                             Value => $desc->{Set},
                             Writable => true,
                             Enumerable => true,
                             Configurable => true
                            },
                            false);
  }

  $obj->DefineOwnProperty('enumerable',
                          {
                           Value => $desc->{Enumerable},
                           Writable => true,
                           Enumerable => true,
                           Configurable => true
                          },
                          false);
  $obj->DefineOwnProperty('configurable',
                          {
                           Value => $desc->{Configurable},
                           Writable => true,
                           Enumerable => true,
                           Configurable => true
                          },
                          false);

  return $obj;
}

method ToPropertyDescriptor($class: Object $obj) {

    my $desc = {};

    if ($obj->HasProperty('enumerable') == true) {
	my $enum = $obj->Get('enumerable');
	$desc->{Enumerable} = ToBoolean($enum);
    }

    if ($obj->HasProperty('configurable') == true) {
	my $conf = $obj->Get('configurable');
	$desc->{Configurable} = ToBoolean($conf);
    }

    if ($obj->HasProperty('value') == true) {
	my $value = $obj->Get('value');
	$desc->{Value} = $value;
    }

    if ($obj->HasProperty('writable') == true) {
	my $writable = $obj->Get('writable');
	$desc->{Writable} = ToBoolean($writable);
    }

    if ($obj->HasProperty('get') == true) {
	my $getter = $obj->Get('get');
	if ($class->IsCallable($getter) == false && $getter != undefined) {
	    croak "TypeError: getter $getter is not callable and is not undefined";
	}
	$desc->{Get} = $getter;
    }

    if ($obj->HasProperty('set') == true) {
	my $setter = $obj->Get('set');
	if ($class->IsCallable($setter) == false && $setter != undefined) {
	    croak "TypeError: setter $setter is not callable and is not undefined";
	}
	$desc->{Set} = $setter;
    }

    if (exists($desc->{Get}) || exists($desc->{Set})) {
	if (exists($desc->{Value}) || exists($desc->{Writable})) {
	    croak 'TypeError: getter and/or setter property present, value and/or writable property as well';
	}
    }

    return $desc;
}

1;
