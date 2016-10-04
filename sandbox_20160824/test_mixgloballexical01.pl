# @conclusion 
use strict;
my $bar = 22;
$::bar;
$::bar = 1;
print 'variables outside brackets (before)'."\n";
print '... global ::bar='.$::bar."\n";
print '... my $bar='.$bar."\n";
{
	local $::bar = 2;
	print 'variables inside brackets'."\n";
	print '... localized bar='.$::bar."\n";
	print '... my $bar='.$bar."\n";
}
print 'variables outside brackets (after)'."\n";
print '... global ::bar='.$::bar."\n";
print '... my $bar='.$bar."\n";
