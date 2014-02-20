use strict;
use warnings FATAL => 'all';

package JavaScript::Transpile::Target::Perl5::Engine::Number::Factory;
use MooseX::Declare;
use MooseX::AbstractFactory;

implementation_does [ qw/JavaScript::Transpile::Target::Perl5::Engine::Number::Implementation::Requires/ ];
implementation_class_via sub { 'JavaScript::Transpile::Target::Perl5::Engine::Number::' . shift };

role JavaScript::Transpile::Target::Perl5::Engine::Number::Implementation::Requires {
  #
  # Class methods
  #
  requires 'pos_zero';
  requires 'neg_zero';
  requires 'pos_inf';
  requires 'neg_inf';
  requires 'nan';
  #
  # Object methods
  #
  requires 'is_zero';
  requires 'is_nan';
  requires 'is_inf';
  requires 'is_pos';
  requires 'is_neg';
  requires 'host_pos_zero';
  requires 'host_mul';
  requires 'host_round';
  requires 'host_pos_inf';
  requires 'host_pow';
  requires 'host_int';
  requires 'host_hex';
  requires 'host_neg';
  requires 'host_add';
  requires 'host_sub';
  requires 'host_inc_length';
  requires 'host_new_from_length';
  requires 'host_class';
  requires 'host_value';
  requires 'host_abs';
}

class JavaScript::Transpile::Target::Perl5::Engine::Number::Native {
  use parent 'MarpaX::Languages::ECMAScript::AST::Grammar::ECMAScript_262_5::StringNumericLiteral::NativeNumberSemantics';
}

class JavaScript::Transpile::Target::Perl5::Engine::Number::BigFloat {
  use Math::BigFloat;
  use constant {
    ACCURACY => 20,          # Number of significant digits
    ROUND_MODE => 'even'     # Round mode
  };
  has 'bigfloat' => (isa => 'Math::BigFloat', is => 'rw', default => sub {Math::BigFloat->new('0')});
  has 'length'   => (isa => 'Num', is => 'rw', default => 0);

  #
  # Class methods
  #
  method pos_zero { return Math::BigFloat->bzero();   }
  method neg_zero { return Math::BigFloat->bzero();   }   # No -0 with Math::BigFloat
  method pos_inf  { return Math::BigFloat->binf();    }
  method neg_inf  { return Math::BigFloat->binf('-'); }
  method nan      { return Math::BigFloat->bnan()     }
  method is_pos   { return Math::BigFloat->is_pos()   }
  method is_neg   { return Math::BigFloat->is_neg()   }
  #
  # Object methods. Take care $value is the host value, a Math::BigFloat here.
  #
  method is_zero($value)      { return $value->is_zero(); }
  method is_nan($value)       { return $value->is_nan()   }
  method is_inf($value)       { return $value->is_inf()   }
  method host_pos_zero        { $self->bigfloat->bzero();                                                return $self; }
  method host_mul($y)         { $self->bigfloat->bmul($y->bigfloat);                                     return $self; }
  method host_round           { $self->bigfloat->round(ACCURACY, undef, ROUND_MODE);                     return $self; }
  method host_pos_inf         { $self->bigfloat->binf();                                                 return $self; }
  method host_pow($y)         { $self->bigfloat->bpow($y->bigfloat);                                     return $self, }
  method host_int($y)         { $self->bigfloat(Math::BigFloat->new("$y")); $self->length(length("$y")); return $self; }
  method host_hex($y)         { $self->bigfloat(Math::BigFloat->new(hex("$y")));                         return $self; }
  method host_neg             { $self->bigfloat->bneg();                                                 return $self; }
  method host_add($y)         { $self->bigfloat->badd($y->bigfloat);                                     return $self; }
  method host_sub($y)         { $self->bigfloat->bsub($y->bigfloat);                                     return $self; }
  method host_inc_length      { $self->length($self->length + 1);                                        return $self; }
  method host_new_from_length { return $self->host_class->new->host_int(sprintf('%s', $self->length)) }
  method host_class           { return $self->blessed; }
  method host_value           { return $self->bigfloat; }
  method host_abs             { $self->bigfloat->babs();                                                 return $self; }
}

1;
