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
constant_6 (pTHX_ const char *name, IV *iv_return) {
  /* When generated this function returned values for the list of names given
     here.  However, subsequent manual editing may have added or removed some.
     DOMAIN _IEEE_ _SVID_ */
  /* Offset 4 gives the best switch position.  */
  switch (name[4]) {
  case 'D':
    if (memEQ(name, "_SVID_", 6)) {
    /*                   ^       */
#ifdef _SVID_
      *iv_return = _SVID_;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'E':
    if (memEQ(name, "_IEEE_", 6)) {
    /*                   ^       */
#ifdef _IEEE_
      *iv_return = _IEEE_;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'I':
    if (memEQ(name, "DOMAIN", 6)) {
    /*                   ^       */
#ifdef DOMAIN
      *iv_return = DOMAIN;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  }
  return PERL_constant_NOTFOUND;
}

static int
constant_7 (pTHX_ const char *name, IV *iv_return) {
  /* When generated this function returned values for the list of names given
     here.  However, subsequent manual editing may have added or removed some.
     X_TLOSS _POSIX_ _XOPEN_ */
  /* Offset 3 gives the best switch position.  */
  switch (name[3]) {
  case 'L':
    if (memEQ(name, "X_TLOSS", 7)) {
    /*                  ^         */
#ifdef X_TLOSS
      *iv_return = X_TLOSS;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'P':
    if (memEQ(name, "_XOPEN_", 7)) {
    /*                  ^         */
#ifdef _XOPEN_
      *iv_return = _XOPEN_;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'S':
    if (memEQ(name, "_POSIX_", 7)) {
    /*                  ^         */
#ifdef _POSIX_
      *iv_return = _POSIX_;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  }
  return PERL_constant_NOTFOUND;
}

static int
constant (pTHX_ const char *name, STRLEN len, IV *iv_return) {
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

my $types = {map {($_, 1)} qw(IV)};
my @names = (qw(DOMAIN HUGE MAXFLOAT OVERFLOW PLOSS SING TLOSS UNDERFLOW
	       X_TLOSS _IEEE_ _LIB_VERSION _LIB_VERSION_TYPE _POSIX_ _SVID_
	       _XOPEN_));

print constant_types(), "\n"; # macro defs
foreach (C_constant ("JavaScript::Transpile::Fdlib", 'constant', 'IV', $types, undef, 3, @names) ) {
    print $_, "\n"; # C constant subs
}
print "\n#### XS Section:\n";
print XS_constant ("JavaScript::Transpile::Fdlib", $types);
__END__
   */

  switch (len) {
  case 4:
    /* Names all of length 4.  */
    /* HUGE SING */
    /* Offset 3 gives the best switch position.  */
    switch (name[3]) {
    case 'E':
      if (memEQ(name, "HUG", 3)) {
      /*                  E     */
#ifdef HUGE
        *iv_return = HUGE;
        return PERL_constant_ISIV;
#else
        return PERL_constant_NOTDEF;
#endif
      }
      break;
    case 'G':
      if (memEQ(name, "SIN", 3)) {
      /*                  G     */
#ifdef SING
        *iv_return = SING;
        return PERL_constant_ISIV;
#else
        return PERL_constant_NOTDEF;
#endif
      }
      break;
    }
    break;
  case 5:
    /* Names all of length 5.  */
    /* PLOSS TLOSS */
    /* Offset 0 gives the best switch position.  */
    switch (*name++) {
    case 'P':
      if (memEQ(name, "LOSS", 4)) {
      /*                P          */
#ifdef PLOSS
        *iv_return = PLOSS;
        return PERL_constant_ISIV;
#else
        return PERL_constant_NOTDEF;
#endif
      }
      break;
    case 'T':
      if (memEQ(name, "LOSS", 4)) {
      /*                T          */
#ifdef TLOSS
        *iv_return = TLOSS;
        return PERL_constant_ISIV;
#else
        return PERL_constant_NOTDEF;
#endif
      }
      break;
    }
    break;
  case 6:
    return constant_6 (aTHX_ name, iv_return);
    break;
  case 7:
    return constant_7 (aTHX_ name, iv_return);
    break;
  case 8:
    /* Names all of length 8.  */
    /* MAXFLOAT OVERFLOW */
    /* Offset 0 gives the best switch position.  */
    switch (*name++) {
    case 'M':
      if (memEQ(name, "AXFLOAT", 7)) {
      /*                M             */
#ifdef MAXFLOAT
        *iv_return = MAXFLOAT;
        return PERL_constant_ISIV;
#else
        return PERL_constant_NOTDEF;
#endif
      }
      break;
    case 'O':
      if (memEQ(name, "VERFLOW", 7)) {
      /*                O             */
#ifdef OVERFLOW
        *iv_return = OVERFLOW;
        return PERL_constant_ISIV;
#else
        return PERL_constant_NOTDEF;
#endif
      }
      break;
    }
    break;
  case 9:
    if (memEQ(name, "UNDERFLOW", 9)) {
#ifdef UNDERFLOW
      *iv_return = UNDERFLOW;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 12:
    if (memEQ(name, "_LIB_VERSION", 12)) {
#ifdef _LIB_VERSION
      *iv_return = _LIB_VERSION;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 17:
    if (memEQ(name, "_LIB_VERSION_TYPE", 17)) {
#ifdef _LIB_VERSION_TYPE
      *iv_return = _LIB_VERSION_TYPE;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  }
  return PERL_constant_NOTFOUND;
}

