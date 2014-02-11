use strict;
use warnings FATAL => 'all';

package JavaScript::Transpile::Target::Perl5::Engine::Number::BigFloat;
use Math::BigFloat;

our $POS_ZERO = Math::BigFloat->bzero();
our $NEG_ZERO = Math::BigFloat->bzero();   # No -0 with Math::BigInt.
our $POS_INF  = Math::BigFloat->binf();
our $NEG_INF  = Math::BigFloat->binf('-');
our $NAN      = Math::BigFloat->bnan();

1;
