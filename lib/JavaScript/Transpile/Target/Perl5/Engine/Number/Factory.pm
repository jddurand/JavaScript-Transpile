use strict;
use warnings FATAL => 'all';

package JavaScript::Transpile::Target::Perl5::Engine::Number::Factory;
use MooseX::Declare;
use MooseX::AbstractFactory;

implementation_does [ qw/JavaScript::Transpile::Target::Perl5::Engine::Number::Implementation::Requires/ ];
implementation_class_via sub { 'JavaScript::Transpile::Target::Perl5::Engine::Number::' . shift };

role JavaScript::Transpile::Target::Perl5::Engine::Number::Implementation::Requires {
  requires 'new';
  requires 'new_from_sign';
  requires 'new_from_cmp';
  requires 'new_from_length';
  requires 'clone_init';
  requires 'clone';
  requires 'decimalOn';
  requires 'mul';
  requires 'div';
  requires 'mod';
  requires 'nan';
  requires 'pos_one';
  requires 'neg_one';
  requires 'pos_zero';
  requires 'neg_zero';
  requires 'pos_inf';
  requires 'neg_inf';
  requires 'pow';
  requires 'int';
  requires 'hex';
  requires 'neg';
  requires 'abs';
  requires 'add';
  requires 'and';
  requires 'or';
  requires 'xor';
  requires 'not';
  requires 'sqrt';
  requires 'sub';
  requires 'inc';
  requires 'dec';
  requires 'inc_length';
  requires 'sign';
  requires 'cmp';
  requires 'host_number';
  requires 'host_value';
  requires 'is_zero';
  requires 'is_pos_one';
  requires 'is_neg_one';
  requires 'is_pos';
  requires 'is_neg';
  requires 'is_inf';
  requires 'is_nan';
  requires 'left_shift';
  requires 'right_shift';
}

class JavaScript::Transpile::Target::Perl5::Engine::Number::Native {
  use parent 'MarpaX::Languages::ECMAScript::AST::Grammar::ECMAScript_262_5::StringNumericLiteral::NativeNumberSemantics';
}

class JavaScript::Transpile::Target::Perl5::Engine::Number::BigFloat is mutable {   # Because we redefine our constructor
  use Math::BigFloat;
  use parent 'MarpaX::Languages::ECMAScript::AST::Grammar::ECMAScript_262_5::StringNumericLiteral::NativeNumberSemantics';
  use constant {
    ACCURACY => 20,          # Number of significant digits
    ROUND_MODE => 'even'     # Round mode
  };

  sub new {
    my ($class, %opts) = @_;
    my $self = {_number => $opts{number}    // Math::BigFloat->new('0'),
                _length => $opts{length}    // 0,
                _decimal => $opts{decimal } // 0};
    bless($self, $class);
    return $self;
  }

  sub clone {
    my ($self) = @_;
    return (ref $self)->new(number => $self->{_number}->copy,
                            length => $self->{_length},
                            decimal => $self->{_decimal});
  }

  sub mul             { $_[0]->{_number}->bmul($_[1]->{_number});                                            return $_[0]; }
  sub div             { $_[0]->{_number}->bdiv($_[1]->{_number});                                            return $_[0]; }
  sub mod             { $_[0]->{_number}->bmod($_[1]->{_number});                                            return $_[0]; }
  sub nan             { $_[0]->{_number}->bnan();                                                            return $_[0]; }
  sub pos_one         { $_[0]->{_number}->bone();                                                            return $_[0]; }
  sub neg_one         { $_[0]->{_number}->bone('-');                                                         return $_[0]; }
  sub pos_zero        { $_[0]->{_number}->bzero();                                                           return $_[0]; }
  sub neg_zero        { $_[0]->{_number}->bzero();                                                           return $_[0]; } # No -0 with Math::BigFloat
  sub pos_inf         { $_[0]->{_number}->binf();                                                            return $_[0]; }
  sub neg_inf         { $_[0]->{_number}->binf('-');                                                         return $_[0]; }
  sub pow             { $_[0]->{_number}->bpow($_[1]->{_number});                                            return $_[0]; }
  sub and             { $_[0]->{_number}->band($_[1]->{_number});                                            return $_[0]; }
  sub or              { $_[0]->{_number}->bior($_[1]->{_number});                                            return $_[0]; }
  sub xor             { $_[0]->{_number}->bxor($_[1]->{_number});                                            return $_[0]; }
  sub not             { $_[0]->{_number}->bnot($_[1]->{_number});                                            return $_[0]; }
  sub int             { $_[0]->{_number} = Math::BigFloat->new("$_[1]"); $_[0]->{_length} = length("$_[1]"); return $_[0]; }
  sub hex             { $_[0]->{_number} = Math::BigFloat->new(hex("$_[1]"));                                return $_[0]; }
  sub neg             { $_[0]->{_number}->bneg();                                                            return $_[0]; }
  sub abs             { $_[0]->{_number}->babs();                                                            return $_[0]; }
  sub add             { $_[0]->{_number}->badd($_[1]->{_number});                                            return $_[0]; }
  sub sub             { $_[0]->{_number}->bsub($_[1]->{_number});                                            return $_[0]; }
  sub inc             { $_[0]->{_number}->binc();                                                            return $_[0]; }
  sub dec             { $_[0]->{_number}->bdec();                                                            return $_[0]; }
  sub sqrt            { $_[0]->{_number}->bsqrt();                                                           return $_[0]; }
  sub host_value      { $_[0]->{_number}->round(ACCURACY, undef, ROUND_MODE);                     return $_[0]->{_number}; }
  sub left_shift      { $_[0]->{_number}->blsft($_[1]->{_number}, 2);                                        return $_[0]; }
  sub right_shift     { $_[0]->{_number}->brsft($_[1]->{_number}, 2);                                        return $_[0]; }

  __PACKAGE__->meta->make_immutable(inline_constructor => 0);
}

1;
