#!./perl

# $Id: lock.t,v 2.02 2002/05/28 20:22:31 ams Exp $
#
#  @COPYRIGHT@
#
# $Log: lock.t,v $
# Revision 2.02  2002/05/28 20:22:31  ams
# 1. Rework file header handling. (Nicholas Clark)
# 2. Add integer.t and safer integer storing code. (Nicholas Clark)
#
# Revision 2.00  2002/05/18 16:00:59  ams
# Import Storable 2.00 from perl-current.
#
# Revision 1.0.1.4  2001/01/03 09:41:00  ram
# patch7: use new CAN_FLOCK routine to determine whether to run tests
#
# Revision 1.0.1.3  2000/10/26 17:11:27  ram
# patch5: just check $^O, there's no need for the whole Config
#
# Revision 1.0.1.2  2000/10/23 18:03:07  ram
# patch4: protected calls to flock() for dos platform
#
# Revision 1.0.1.1  2000/09/28 21:44:06  ram
# patch2: created.
#
#

sub BEGIN {
    if ($ENV{PERL_CORE}){
	chdir('t') if -d 't';
	@INC = ('.', '../lib', '../ext/Storable/t');
    } else {
	unshift @INC, 't';
    }
    require Config; import Config;
    if ($ENV{PERL_CORE} and $Config{'extensions'} !~ /\bStorable\b/) {
        print "1..0 # Skip: Storable was not built\n";
        exit 0;
    }

    require 'st-dump.pl';
}

sub ok;

use Storable qw(lock_store lock_retrieve);

unless (&Storable::CAN_FLOCK) {
    print "1..0 # Skip: fcntl/flock emulation broken on this platform\n";
	exit 0;
}

print "1..5\n";

@a = ('first', undef, 3, -4, -3.14159, 456, 4.5);

#
# We're just ensuring things work, we're not validating locking.
#

ok 1, defined lock_store(\@a, 'store');
ok 2, $dumped = &dump(\@a);

$root = lock_retrieve('store');
ok 3, ref $root eq 'ARRAY';
ok 4, @a == @$root;
ok 5, &dump($root) eq $dumped; 

unlink 't/store';

