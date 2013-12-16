use strict;
use warnings FATAL => 'all';

package JavaScript::Transpile::Target::Perl5::Engine::Declare;

# ABSTRACT: JavaScript declarations in Perl

# VERSION

use MooseX::Declare;

class ObjectTemplate {
    use Log::Any qw/$log/;
    use Moose::Util::TypeConstraints;
    use Encode qw/encode/;
    use JavaScript::Transpile::Target::Perl5::Engine::Constants qw/:all/;

    # --------------------------------------------------------
    # Primitives
    # Note: no need of PositiveInt : we know what we are doing
    # --------------------------------------------------------
    subtype    'Boolean',   as 'Bool',  where {$_ == true || $_ == false};
    class_type 'Undefined', {class => 'JavaScript::Transpile::Target::Perl5::Engine::Undefined' };
    subtype    'Null',      as 'Undef', where {$_ == undef};
    subtype    'String',    as 'ArrayRef[Int]';
    subtype    'Number',    as 'Num';

    # -------------------------
    # Coercion for strings only
    # -------------------------
    #
    # Take care: String is a sequence of UTF-16 Code Units, NOT characters.
    # This mean that internally JavaScript is using UCS-2, not UTF-16. I.e.
    # no support for surrogate pairs. Nevertheless the spec says that textual
    # data is supposed to be UTF-16. I.e. the input can contain surrogate pairs.
    # Surrogate pairs will not be taken as they are, but as new characters,
    # because of the UCS-2 internal encoding.
    #
    # To get the unsigned short values out of a UTF-16LE: unpack('v*', ...).
    # To get the unsigned short values out of a UTF-16BE: unpack('n*', ...).
    #
    coerce 'Str',    from 'String', via { pack('W*', @{$_}) };
    coerce 'String', from 'Str',    via { unpack('v*', encode('UTF-16LE', $_)) };

    # -------------------------------------
    # Internal types used only as shortcuts
    # -------------------------------------
    class_type 'DataProperty',       {class => 'JavaScript::Transpile::Target::Perl5::Engine::DataProperty' };
    class_type 'AccessorProperty',   {class => 'JavaScript::Transpile::Target::Perl5::Engine::AccessorProperty' };
    class_type 'PropertyDescriptor', {class => 'JavaScript::Transpile::Target::Perl5::Engine::PropertyDescriptor' };

    our %CLASSES = map {$_ => 1} qw/Arguments Array Boolean Date Error Function JSON Math Number Object RegExp String/;
    subtype 'allowedObjectClass', as 'Str', where {exists($CLASSES{$_})};

    has 'Class'             => (isa => 'allowedObjectClass',           is => 'rw');
    has 'Prototype'         => (isa => 'Object|Null',                  is => 'rw', lazy => 1, builder => '_build_Prototype');
    has 'Extensible'        => (isa => 'Boolean',                      is => 'rw', default => false);
    has 'Get'               => (isa => 'PropertyDescriptor|Undefined', is => 'rw', default => sub { undefined });   
    has 'GetOwnProperty'    => (isa => 'PropertyDescriptor|Undefined', is => 'rw', default => sub { undefined });   
    has 'GetProperty'       => (isa => 'PropertyDescriptor|Undefined', is => 'rw', default => sub { undefined });   
    has 'Put'               => (isa => 'Boolean|Undefined',            is => 'rw', default => sub { undefined });
    has 'CanPut'            => (isa => 'Boolean|Undefined',            is => 'rw', default => sub { undefined });   
    has 'HasProperty'       => (isa => 'Boolean|Undefined',            is => 'rw', default => sub { undefined });
    has 'Delete'            => (isa => 'Boolean|Undefined',            is => 'rw', default => sub { undefined });   
    has 'DefaultValue'      => (isa => 'Boolean|Undefined',            is => 'rw', default => sub { undefined });
    has 'DefineOwnProperty' => (isa => 'Boolean|Undefined',            is => 'rw', default => sub { undefined });
        
    around Class {
	return $self->$orig() unless @_;
    
	my $class = shift;
	#
	# if [[Extensible]] is false the value of the [[Class]] internal properties of the object may not be modified
	#
	if ($self->Extensible == false && $class ne $self->Class) {
	    #
	    # We trigger if it really changes
	    #
	    $self->logger->info('The value of the [[Class]] internal property may not be modified');
	    return $self->$orig();
	}
    
	return $self->$orig($class);
    };

    sub _build_Prototype {
	my ($self) = @_;
	my $prototype = create_class_from_prototype($self)->new();
	$prototype->create_class($self->Class);
	return $prototype;
    }

    around Prototype {
	return $self->$orig() unless @_;
    
	my $prototype = shift;
	#
	# if [[Extensible]] is false the value of the [[Prototype]] internal property of the object may not be modified
	#
	if ($self->Extensible == false && $prototype ne $self->Prototype) {
	    #
	    # We trigger if it really changes
	    #
	    JavaScript::Transpile::Target::Perl5::Engine::Exception->throw({type => 'GenericError', message => 'The value of the [[Prototype]] internal property may not be modified'});
	}
	
	if ($prototype->DOES('Object')) {
	    #
	    # Recursively accessing the [[Prototype]] internal property must eventually lead to a null value
	    #
	    my $blessed = $prototype->blessed;
	    if (grep {$_ eq $blessed} $self->meta->class_precedence_list()) {
		JavaScript::Transpile::Target::Perl5::Engine::Exception->throw({type => 'GenericError', message => 'Recursive access to [[Prototype]] internal property would be possible'});
	    }
	}
	
	return $self->$orig($prototype);
    };
    
    around Extensible {
	return $self->$orig() unless @_;
	
	my $extensible = shift;
	#
	# If the [[Extensible]] internal property of that host object has been observed
	# by ECMAScript code to be false then it must not subsequently become true.
	#
	if ($self->$orig() == false && $extensible == true) {
	    JavaScript::Transpile::Target::Perl5::Engine::Exception->throw({type => 'GenericError', message => '[[Extensible]] internal property has been observed to be false so it must not subsequently become true'});
	}
	
	return $self->$orig($extensible);
    };
    
}

use MooseX::Prototype qw/create_class_from_prototype/;

create_class_from_prototype(ObjectTemplate->new(Class => 'Object'), 'JavaScript::Type::Object');

=head1 SEE ALSO

    L<MooseX::Types>

    =cut

1;
