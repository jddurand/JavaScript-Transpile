use strict;
use warnings FATAL => 'all';

package JavaScript::Transpile::Target::Perl5::Engine::Constants;
use Unknown::Values;

# ABSTRACT: JavaScript constants in Perl5

# VERSION

use Exporter 'import';
our @EXPORT_OK = qw/undefined true false/;
our %EXPORT_TAGS = ('all' => [ @EXPORT_OK ]);

use constant {
    undefined => unknown,
    true      => 1,
    false     => 0,
    null      => undef,
};

1;
