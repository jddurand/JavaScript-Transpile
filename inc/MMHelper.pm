package MMHelper;

use strict;
use warnings;

use Config;

our $FDLIBMDIR = 'fdlibm53';

sub ccflags_dyn {
    my $is_dev = shift;

    my $ccflags = q<( $Config::Config{ccflags} || '' ) . ' -DHAVE_CONFIG_H -Ifdlibm53 '>;

    return $ccflags;
}

sub ccflags_static {
    my $is_dev = shift;

    return eval(ccflags_dyn($is_dev));
}

sub mm_args {
    my ( @object, %xs );

    for my $xs ( glob "$FDLIBMDIR/*.xs" ) {
        ( my $c = $xs ) =~ s/\.xs$/.c/i;
        ( my $o = $xs ) =~ s/\.xs$/\$(OBJ_EXT)/i;

        $xs{$xs} = $c;
        push @object, $o;
    }

    for my $c ( glob "$FDLIBMDIR/*.c" ) {
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
use Config::AutoConf;
use File::Spec;
use File::Temp;
use ExtUtils::CBuilder;

sub post_initialize {
    my $FDLIBMDIR = 'fdlibm53';
    #
    # Check if we have a running C compiler and if this is GCC
    # C.f. http://nadeausoftware.com/articles/2012/10/c_c_tip_how_detect_compiler_name_and_version_using_compiler_predefined_macros
    #
    my $gcc = 0;
    {
	my $ac = Config::AutoConf->new();
	if ($ac->check_cc()) {
	    $ac->msg_checking('if compiler is gcc');

	    my $prologue = "#include <stddef.h>\n#include <stdio.h>";
	    my $yes = 'yes, very probably';
	    my $no = 'no';
	    my $program = <<PROGRAM;
#if (defined(__GNUC__) || defined(__GNUG__)) && !(defined(__clang__) || defined(__INTEL_COMPILER))
  printf("$yes");
#else
  printf("$no");
#endif
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
	    if ($output eq $yes) {
		$gcc = 1;
	    }
	    unlink($c) || warn "Cannot unlink $c, $!";
	}
    }
    #
    # config.h
    # --------
    {
	my $ac = Config::AutoConf->new();
	#
	# Check headers
	#
	$ac->check_header('sys/types.h');
	$ac->check_header('sys/config.h');
        if ($gcc) {
          $ac->msg_notice('gcc detected, so let ieeefp.h do all platform configuration');
          #
          # We let ieeefp.h do all the work
          #
        } else {
          #
          # Check if double is 32 bits (bad luck...)
          #
          if ($ac->check_sizeof_type('double') == 4) {
	    $ac->define_var('_DOUBLE_IS_32BITS', 1);
	    $ac->msg_warn('Double is 32 bits - the build will very likely fail');
          }
          #
          # Check Endian-ness
          #
          my $is_little_endian = (unpack("h*", pack("s", 1)) =~ /^1/);   # C.f. perlport
          if ($is_little_endian) {
            $ac->msg_notice('little-endian platform detected');
	    $ac->define_var('__IEEE_LITTLE_ENDIAN', 1);
          } else {
            $ac->msg_notice('big-endian platform detected');
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
	  unlink($c) || warn "Cannot unlink $c, $!";
        }
        my $output = File::Spec->catfile($FDLIBMDIR, 'config.h');
        $ac->msg_notice("creating $output");
        $ac->write_config_h($output);
      }
    #
    # config-int.h
    #
    {
      my $configint_h = File::Spec->catfile($FDLIBMDIR, 'config-int.h');
      my $ac = Config::AutoConf->new();
      #
      # Check headers
      #
      $ac->msg_notice('verifying stdint-types');
      my $ac_stdint_h = '';
      if ($ac->check_header('stdint.h')) {
        $ac_stdint_h = 'stdint.h';
      }
      my $ac_cv_header_stdint = 'no-file';
      foreach (qw<inttypes.h sys/inttypes.h sys/int_types.h stdint.h>) {
        #
        # We do not want to result to be cached
        #
        my $tmpac = Config::AutoConf->new();
        if ($tmpac->check_type('uint32_t', undef, undef, "#include <$_>")) {
          $ac_cv_header_stdint = $_;
          last;
        }
      }
      my $ac_cv_header_stdint_u = 'no-file';
      foreach (qw<sys/types.h inttypes.h sys/inttypes.h sys/int_types.h>) {
        #
        # We do not want to result to be cached
        #
        my $tmpac = Config::AutoConf->new();
        if ($tmpac->check_type('u_int32_t', undef, undef, "#include <$_>")) {
          $ac_cv_header_stdint_u = $_;
          last;
        }
      }
      if ($ac_cv_header_stdint ne 'no-file') {
        if ($ac_cv_header_stdint ne $ac_stdint_h) {
          $ac->msg_notice("found in $ac_cv_header_stdint");
          open(CONFIG, '>', $configint_h) || die "Cannot open $configint_h, $!";
          print CONFIG <<CONFIG;
#ifndef CONFIG_INT_H
#define CONFIG_INT_H

#include <$ac_cv_header_stdint>

#endif /* CONFIG_INT_H */
CONFIG
          close(CONFIG) || warn "Cannot close $configint_h, $!";
          $ac->msg_notice("creating $configint_h - (just to include $ac_cv_header_stdint)");
        } else {
          $ac->msg_notice("found in $ac_stdint_h");
        }
      } elsif ($ac_cv_header_stdint_u ne 'no-file') {
          $ac->msg_notice("found u_types in $ac_cv_header_stdint_u");
          if ($ac_cv_header_stdint eq 'stdint.h') {
            $ac->msg_notice("creating $configint_h - includes $ac_cv_header_stdint, expect problems!");
          } else {
            $ac->msg_notice("creating $configint_h - (include inet-types in $ac_cv_header_stdint_u and re-typedef");
          }
          open(CONFIG, '>', $configint_h) || die "Cannot open $configint_h, $!";
          print CONFIG <<CONFIG;
#ifndef CONFIG_INT_H
#define CONFIG_INT_H

#include <stddef.h>
#include <$ac_cv_header_stdint_u>

/* int8_t int16_t int32_t defined by inet code */
typedef u_int8_t uint8_t;
typedef u_int16_t uint16_t;
typedef u_int32_t uint32_t;

/* it's a networkable system, but without any stdint.h */
/* hence it's an older 32-bit system... (a wild guess that seems to work) */
typedef u_int32_t uintptr_t;
typedef   int32_t  intptr_t;
CONFIG
          close(CONFIG) || warn "Cannot close $configint_h, $!";
        } else {
          $ac->msg_notice("not found, need to guess the types now...");
          my $sizeof_long = $ac->check_sizeof_type('long', undef, undef, undef);
          my $sizeof_voidp = $ac->check_sizeof_type('void*', undef, undef, undef);
          $ac->msg_notice("creating $configint_h - using detected values for sizeof long and sizeof void*");
          open(CONFIG, '>', $configint_h) || die "Cannot open $configint_h, $!";
          print CONFIG <<CONFIG;
#ifndef CONFIG_INT_H
#define CONFIG_INT_H

/* ISO C 9X: 7.18 Integer types <stdint.h> */

#define __int8_t_defined
typedef   signed char    int8_t;
typedef unsigned char   uint8_t;
typedef   signed short  int16_t;
typedef unsigned short uint16_t;
CONFIG
          if ($sizeof_long == 64) {
          print CONFIG <<CONFIG;

typedef   signed int    int32_t;
typedef unsigned int   uint32_t;
typedef   signed long   int64_t;
typedef unsigned long  uint64_t;
#define  int64_t  int64_t
#define uint64_t uint64_t
CONFIG

          } else {
          print CONFIG <<CONFIG;

typedef   signed long   int32_t;
typedef unsigned long  uint32_t;
CONFIG

        }
          if ($sizeof_long != $sizeof_voidp) {
          print CONFIG <<CONFIG;

typedef   signed int   intptr_t;
typedef unsigned int  uintptr_t;
CONFIG
          } else {
          print CONFIG <<CONFIG;

typedef   signed long   intptr_t;
typedef unsigned long  uintptr_t;
CONFIG
          }
        }
    }
}

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
