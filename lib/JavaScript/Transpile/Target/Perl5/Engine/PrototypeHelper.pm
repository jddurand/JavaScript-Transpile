use strict;
use warnings FATAL => 'all';

package JavaScript::Transpile::Target::Perl5::Engine::PrototypeHelper;
use Class::Prototyped ':OVERLOAD';

sub BEGIN {
    Class::Prototyped->newPackage(
	'JavaScript::Transpile::Target::Perl5::Type::Undefined',
        '""'  => sub { 'Undefined' }
	);
}

our %ATTRIBUTES =
    (
     NamedDataProperty =>
     {
	 Value         => JavaScript::Transpile::Target::Perl5::Type::Undefined->reflect->object,
	 Writable      => 0,
	 Enumerable    => 0,
	 Configuration => 0
     }
    );

sub createNamedDataProperty {
    return Class::Prototyped->new($ATTRIBUTES{NamedDataProperty}, @_);
}
