use strict;
use warnings FATAL => 'all';

package JavaScript::Transpile::Target::Perl5::Engine::Constants;
use JavaScript::Transpile::Target::Perl5::Engine::Types::Undefined;
use JavaScript::Transpile::Target::Perl5::Engine::Types::Null;

# ABSTRACT: JavaScript constants in Perl5

# VERSION

use Exporter 'import';
our @EXPORT_OK = qw/undefined true false null/;
our %EXPORT_TAGS = ('all' => [ @EXPORT_OK ]);

use constant {
    undefined => JavaScript::Transpile::Target::Perl5::Engine::Types::Undefined->instance,
    true      => 1,
    false     => 0,
    null      => JavaScript::Transpile::Target::Perl5::Engine::Types::Null->instance,
};

1;
