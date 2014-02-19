use strict;
use warnings FATAL => 'all';

package JavaScript::Transpile::Target::Perl5::Engine::Number::Factory;
use MooseX::Declare;
use MooseX::AbstractFactory;

implementation_does [ qw/JavaScript::Transpile::Target::Perl5::Engine::Number::Implementation::Requires/ ];
implementation_class_via sub { 'JavaScript::Transpile::Target::Perl5::Engine::Number::' . shift };

role JavaScript::Transpile::Target::Perl5::Engine::Number::Implementation::Requires {
  requires 'pos_zero';
  requires 'neg_zero';
  requires 'is_zero';
  requires 'pos_inf';
  requires 'neg_inf';
  requires 'nan';
  requires 'is_nan';
}

class JavaScript::Transpile::Target::Perl5::Engine::Number::Native {
  use parent 'MarpaX::Languages::ECMAScript::AST::Grammar::ECMAScript_262_5::StringNumericLiteral::NativeNumberSemantics';
}

class JavaScript::Transpile::Target::Perl5::Engine::Number::BigFloat {
  use Math::BigFloat;

  sub pos_zero { return Math::BigFloat->bzero();   }
  sub neg_zero { return Math::BigFloat->bzero();   }   # No -0 with Math::BigFloat
  sub is_zero  { return Math::BigFloat->is_zero(); }
  sub pos_inf  { return Math::BigFloat->binf();    }
  sub neg_inf  { return Math::BigFloat->binf('-'); }
  sub nan      { return Math::BigFloat->bnan()     }
  sub is_nan   { return Math::BigFloat->is_nan()   }
}

1;
