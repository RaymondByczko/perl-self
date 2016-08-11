# @file regexp8.pl
# @author Raymond Byczko
# @company self
# @start_date 2016-08-09 August 9, 2016
# @purpose Lets test the anchor characters ^ and $.
# @note
# @note Works as expected . 
use strict;
print 'START: regexp8.pl'."\n";
my $fishing = 'Mako Shark';
if ($fishing =~ /^Mako Shark$/)
{
	print "... 'Mako Shark' was found (EXPECTED)"."\n";
}
else
{
	print "... 'Mako Shark' was not found (NOT EXPECTED)"."\n";
}
if ($fishing =~ /^Makko Shark$/)
{
	print "... 'Makko Shark' was found (NOT EXPECTED)"."\n";
}
else
{
	print "... 'Makko Shark' was not found (EXPECTED)"."\n";
}

print 'END: regexp8.pl'."\n";
