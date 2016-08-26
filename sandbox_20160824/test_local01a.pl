# @file test_local01a.pl
# @company self
# @author Raymond Byczko
# @location perl-self/sandbox_20160824/
# @start_date 2016-08-24 August 24, 2016
# @purpose To test how local applied to an outer scope my variable
# works.
# @conclusion Compiler checker (-c) will complain cannot localize
# variable.  One solution is to see test_local01b.pl
# @see http://docstore.mik.ua/orelly/perl/advprog/ch03_01.htm
# @itsays
# One is to use the local operator, which operates on global variables only;
# it saves their values and arranges to have them restored at the end of
# the block.
# @enditsays
# @observation bar is not a global variable.
use strict;
my $bar;
my $bar = 1;
print 'variables outside brackets (before)'."\n";
print '... bar='.$bar."\n";
{
	local $bar = 2;
	print 'variables inside brackets'."\n";
	print '... bar='.$bar."\n";
}
print 'variables outside brackets (after)'."\n";
print '... bar='.$bar."\n";
