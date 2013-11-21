package MMHelper;

use strict;
use warnings;

use Config;
use Cwd qw( abs_path );
use File::Basename qw( dirname );
use Config::AutoConf;
use File::Temp;
use ExtUtils::CBuilder;

sub ccflags_dyn {
    my $is_dev = shift;

    my $ac = Config::AutoConf->new();
    #
    # Check headers
    #
    $ac->check_header('sys/types.h');
    $ac->check_header('sys/config.h');
    #
    # Check if double is 32 bits (bad luck...)
    #
    if ($ac->check_sizeof_type('double') == 4) {
	$ac->define_var('_DOUBLE_IS_32BITS', 1);
	warn "Double is 32 bits - the build will very likely fail";
    }
    #
    # Check Endian-ness
    #
    my $is_little_endian = (unpack("h*", pack("s", 1)) =~ /^1/);   # C.f. perlport
    if ($is_little_endian) {
	$ac->define_var('__IEEE_LITTLE_ENDIAN', 1);
    } else {
	$ac->define_var('__IEEE_BIG_ENDIAN', 1);
    }
    #
    # Check right-shift signed-ness
    #
    $ac->msg_checking('right-shift signed-ness');
    my $prologue = "#include <stddef.h>\n#include <stdio.h>";
    my $program = <<PROGRAM;
  signed char c = 0x97;
  c >> 1;
  if ((c & 0x80) == 0x80) {
    printf("Signed shift");
  } else {
    printf("Unsigned shift");
  }
PROGRAM
    my $source = $ac->lang_build_program($prologue, $program);
    my $c = File::Temp->new(UNLINK => 0, SUFFIX => '.c');
    print $c $source;
    close($c);
    my $b = ExtUtils::CBuilder->new(quiet => 1);
    my $obj_file = $b->compile(source => $c);
    my $exe_file = $b->link_executable(objects => [ $obj_file ]);
    my $output = `$exe_file`;
    $ac->msg_result($output);
    if ($output eq 'Unsigned shift') {
	$ac->define_var('Unsigned_Shifts', 1);
    }

    $ac->write_config_h('config.h');
    my $ccflags = q<( $Config::Config{ccflags} || '' ) . ' -Ifdlibm53 '>;

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
