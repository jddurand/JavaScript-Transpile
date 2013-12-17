use strict;
use warnings FATAL => 'all';

package JavaScript::Transpile::Target::Perl5::Engine::Constants;
use JavaScript::Transpile::Target::Perl5::Engine::Undefined;
use JavaScript::Transpile::Target::Perl5::Engine::Null;

# ABSTRACT: JavaScript constants in Perl5

# VERSION

use Exporter 'import';
our @EXPORT_OK = qw/undefined true false null/;
our %EXPORT_TAGS = ('all' => [ @EXPORT_OK ]);

use constant {
    undefined => JavaScript::Transpile::Target::Perl5::Engine::Undefined->instance,
    true      => 1,
    false     => 0,
    null      => JavaScript::Transpile::Target::Perl5::Engine::Null->instance,
};

1;
