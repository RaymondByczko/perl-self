# @file test_local01b.pl
# @company self
# @author Raymond Byczko
# @location perl-self/sandbox_20160824/
# @start_date 2016-08-24 August 24, 2016
# @purpose This is a variant of test_local01a.pl  However, instead
# of testing how local can be applied to an outer scope my variable
# works, it will test how local is applied to a global variable.
# @conclusion Compiler checker (-c) does not complain.
# @see http://docstore.mik.ua/orelly/perl/advprog/ch03_01.htm
# @itsays
# One is to use the local operator, which operates on global variables only;
# it saves their values and arranges to have them restored at the end of
# the block.
# @enditsays
# @observation bar is a global variable.
# @conclusion ::bar is actually a global variable and not a lexical.
# Accordingly, local can work on it.
use strict;
$::bar;
$::bar = 1;
print 'variables outside brackets (before)'."\n";
print '... bar='.$::bar."\n";
{
	local $::bar = 2;
	print 'variables inside brackets'."\n";
	print '... bar='.$::bar."\n";
}
print 'variables outside brackets (after)'."\n";
print '... bar='.$::bar."\n";
