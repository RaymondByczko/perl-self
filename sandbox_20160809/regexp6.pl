# @file regexp6.pl
# @author Raymond Byczko
# @company self
# @start_date 2016-08-09 August 9, 2016
# @purpose Lets test the anchor character ^ (near beginnning).
# @note
# @note Works as expected . 
use strict;
print 'START: regexp6.pl'."\n";
my $fishing = 'Early morning I caught a bluefish';
if ($fishing =~ /^Early/)
{
	print '... Early (beginning) was found (EXPECTED)'."\n";
}
else
{
	print '... Early (beginning) was not found (NOT EXPECTED)'."\n";
}
if ($fishing =~ /^Late/)
{
	print '... Late (beginning) was found (NOT EXPECTED)'."\n";
}
else
{
	print '... Late (beginning) was not found (EXPECTED)'."\n";
}

print 'END: regexp6.pl'."\n";
