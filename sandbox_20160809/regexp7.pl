# @file regexp7.pl
# @author Raymond Byczko
# @company self
# @start_date 2016-08-09 August 9, 2016
# @purpose Lets test the anchor character $ (near the end).
# @note
# @note Works as expected. 
use strict;
print 'START: regexp7.pl'."\n";
my $fishing = 'Early morning I caught a bluefish';
if ($fishing =~ /bluefish$/)
{
	print '... bluefish (end) was found (EXPECTED)'."\n";
}
else
{
	print '... bluefish (end) was not found (NOT EXPECTED)'."\n";
}
if ($fishing =~ /blue$/)
{
	print '... blue (end) was found (NOT EXPECTED)'."\n";
}
else
{
	print '... blue (end) was not found (EXPECTED)'."\n";
}

print 'END: regexp7.pl'."\n";
