package MMHelper;

use strict;
use warnings;

use Config;
use Cwd qw( abs_path );
use File::Basename qw( dirname );
use Config::AutoConf;

sub ccflags_dyn {
    my $is_dev = shift;

    my $ccflags = q<( $Config::Config{ccflags} || '' ) . ' -I. -D_IEEE_LIBM'>;
    my $is_little_endian = unpack("h*", pack("s", 1)) =~ /^1/;   # C.f. perlport
    if ($is_little_endian) {
	$ccflags .= ' -D__LITTLE_ENDIAN'
    }
    return $ccflags;
}

sub ccflags_static {
    my $is_dev = shift;

    return eval(ccflags_dyn($is_dev));
}

sub mm_args {
    my ( @object, %xs );

    for my $xs ( glob "fdlibm53/*.xs" ) {
        ( my $c = $xs ) =~ s/\.xs$/.c/i;
        ( my $o = $xs ) =~ s/\.xs$/\$(OBJ_EXT)/i;

        $xs{$xs} = $c;
        push @object, $o;
    }

    for my $c ( glob "fdlibm53/*.c" ) {
        ( my $o = $c ) =~ s/\.c$/\$(OBJ_EXT)/i;
        push @object, $o;
    }

    return (
        clean   => { FILES => join( q{ }, @object ) },
        OBJECT => join( q{ }, @object ),
        XS     => \%xs,
    );
}

sub my_package_subs {
    return <<'EOP';
{
package MY;

use Config;

sub const_cccmd {
    my $ret = shift->SUPER::const_cccmd(@_);
    return q{} unless $ret;

    if ($Config{cc} =~ /^cl\b/i) {
        $ret .= ' /Fo$@';
    }
    else {
        $ret .= ' -o $@';
    }

    return $ret;
}

sub postamble {
#    return <<'EOF';
#$(OBJECT) : mop.h
#EOF
    return <<'EOF';
EOF
}
}
EOP
}

1;
