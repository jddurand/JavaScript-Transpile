#define PERL_constant_NOTFOUND	1
#define PERL_constant_NOTDEF	2
#define PERL_constant_ISIV	3
#define PERL_constant_ISNO	4
#define PERL_constant_ISNV	5
#define PERL_constant_ISPV	6
#define PERL_constant_ISPVN	7
#define PERL_constant_ISSV	8
#define PERL_constant_ISUNDEF	9
#define PERL_constant_ISUV	10
#define PERL_constant_ISYES	11

#ifndef NVTYPE
typedef double NV; /* 5.6 and later define NVTYPE, and typedef NV to it.  */
#endif
#ifndef aTHX_
#define aTHX_ /* 5.6 or later define this for threading support.  */
#endif
#ifndef pTHX_
#define pTHX_ /* 5.6 or later define this for threading support.  */
#endif

static int
constant_13 (pTHX_ const char *name, NV *nv_return) {
  /* When generated this function returned values for the list of names given
     here.  However, subsequent manual editing may have added or removed some.
     FDLIBM_DOMAIN _FDLIBM_IEEE_ _FDLIBM_SVID_ */
  /* Offset 11 gives the best switch position.  */
  switch (name[11]) {
  case 'D':
    if (memEQ(name, "_FDLIBM_SVID_", 13)) {
    /*                          ^        */
#ifdef _FDLIBM_SVID_
      *nv_return = _FDLIBM_SVID_;
      return PERL_constant_ISNV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'E':
    if (memEQ(name, "_FDLIBM_IEEE_", 13)) {
    /*                          ^        */
#ifdef _FDLIBM_IEEE_
      *nv_return = _FDLIBM_IEEE_;
      return PERL_constant_ISNV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'I':
    if (memEQ(name, "FDLIBM_DOMAIN", 13)) {
    /*                          ^        */
#ifdef FDLIBM_DOMAIN
      *nv_return = FDLIBM_DOMAIN;
      return PERL_constant_ISNV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  }
  return PERL_constant_NOTFOUND;
}

static int
constant_14 (pTHX_ const char *name, NV *nv_return) {
  /* When generated this function returned values for the list of names given
     here.  However, subsequent manual editing may have added or removed some.
     FDLIBM_X_TLOSS _FDLIBM_POSIX_ _FDLIBM_XOPEN_ */
  /* Offset 10 gives the best switch position.  */
  switch (name[10]) {
  case 'L':
    if (memEQ(name, "FDLIBM_X_TLOSS", 14)) {
    /*                         ^          */
#ifdef FDLIBM_X_TLOSS
      *nv_return = FDLIBM_X_TLOSS;
      return PERL_constant_ISNV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'P':
    if (memEQ(name, "_FDLIBM_XOPEN_", 14)) {
    /*                         ^          */
#ifdef _FDLIBM_XOPEN_
      *nv_return = _FDLIBM_XOPEN_;
      return PERL_constant_ISNV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'S':
    if (memEQ(name, "_FDLIBM_POSIX_", 14)) {
    /*                         ^          */
#ifdef _FDLIBM_POSIX_
      *nv_return = _FDLIBM_POSIX_;
      return PERL_constant_ISNV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  }
  return PERL_constant_NOTFOUND;
}

static int
constant (pTHX_ const char *name, STRLEN len, NV *nv_return) {
  /* Initially switch on the length of the name.  */
  /* When generated this function returned values for the list of names given
     in this section of perl code.  Rather than manually editing these functions
     to add or remove constants, which would result in this comment and section
     of code becoming inaccurate, we recommend that you edit this section of
     code, and use it to regenerate a new set of constant functions which you
     then use to replace the originals.

     Regenerate these constant functions by feeding this entire source file to
     perl -x

#!/usr/bin/perl -w
use ExtUtils::Constant qw (constant_types C_constant XS_constant);

my $types = {map {($_, 1)} qw(NV)};
my @names = (qw(FDLIBM_DOMAIN FDLIBM_HUGE FDLIBM_MAXFLOAT FDLIBM_OVERFLOW
	       FDLIBM_PLOSS FDLIBM_SING FDLIBM_TLOSS FDLIBM_UNDERFLOW
	       FDLIBM_X_TLOSS _FDLIBM_IEEE_ _FDLIBM_LIB_VERSION _FDLIBM_POSIX_
	       _FDLIBM_SVID_ _FDLIBM_XOPEN_));

print constant_types(), "\n"; # macro defs
foreach (C_constant ("JavaScript::Transpile::Fdlib", 'constant', 'NV', $types, undef, 3, @names) ) {
    print $_, "\n"; # C constant subs
}
print "\n#### XS Section:\n";
print XS_constant ("JavaScript::Transpile::Fdlib", $types);
__END__
   */

  switch (len) {
  case 11:
    /* Names all of length 11.  */
    /* FDLIBM_HUGE FDLIBM_SING */
    /* Offset 10 gives the best switch position.  */
    switch (name[10]) {
    case 'E':
      if (memEQ(name, "FDLIBM_HUG", 10)) {
      /*                         E      */
#ifdef FDLIBM_HUGE
        *nv_return = FDLIBM_HUGE;
        return PERL_constant_ISNV;
#else
        return PERL_constant_NOTDEF;
#endif
      }
      break;
    case 'G':
      if (memEQ(name, "FDLIBM_SIN", 10)) {
      /*                         G      */
#ifdef FDLIBM_SING
        *nv_return = FDLIBM_SING;
        return PERL_constant_ISNV;
#else
        return PERL_constant_NOTDEF;
#endif
      }
      break;
    }
    break;
  case 12:
    /* Names all of length 12.  */
    /* FDLIBM_PLOSS FDLIBM_TLOSS */
    /* Offset 7 gives the best switch position.  */
    switch (name[7]) {
    case 'P':
      if (memEQ(name, "FDLIBM_PLOSS", 12)) {
      /*                      ^           */
#ifdef FDLIBM_PLOSS
        *nv_return = FDLIBM_PLOSS;
        return PERL_constant_ISNV;
#else
        return PERL_constant_NOTDEF;
#endif
      }
      break;
    case 'T':
      if (memEQ(name, "FDLIBM_TLOSS", 12)) {
      /*                      ^           */
#ifdef FDLIBM_TLOSS
        *nv_return = FDLIBM_TLOSS;
        return PERL_constant_ISNV;
#else
        return PERL_constant_NOTDEF;
#endif
      }
      break;
    }
    break;
  case 13:
    return constant_13 (aTHX_ name, nv_return);
    break;
  case 14:
    return constant_14 (aTHX_ name, nv_return);
    break;
  case 15:
    /* Names all of length 15.  */
    /* FDLIBM_MAXFLOAT FDLIBM_OVERFLOW */
    /* Offset 7 gives the best switch position.  */
    switch (name[7]) {
    case 'M':
      if (memEQ(name, "FDLIBM_MAXFLOAT", 15)) {
      /*                      ^              */
#ifdef FDLIBM_MAXFLOAT
        *nv_return = FDLIBM_MAXFLOAT;
        return PERL_constant_ISNV;
#else
        return PERL_constant_NOTDEF;
#endif
      }
      break;
    case 'O':
      if (memEQ(name, "FDLIBM_OVERFLOW", 15)) {
      /*                      ^              */
#ifdef FDLIBM_OVERFLOW
        *nv_return = FDLIBM_OVERFLOW;
        return PERL_constant_ISNV;
#else
        return PERL_constant_NOTDEF;
#endif
      }
      break;
    }
    break;
  case 16:
    if (memEQ(name, "FDLIBM_UNDERFLOW", 16)) {
#ifdef FDLIBM_UNDERFLOW
      *nv_return = FDLIBM_UNDERFLOW;
      return PERL_constant_ISNV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 19:
    if (memEQ(name, "_FDLIBM_LIB_VERSION", 19)) {
#ifdef _FDLIBM_LIB_VERSION
      *nv_return = _FDLIBM_LIB_VERSION;
      return PERL_constant_ISNV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  }
  return PERL_constant_NOTFOUND;
}

