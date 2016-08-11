# @file regexp4.pl
# @author Raymond Byczko
# @company self
# @start_date 2016-08-09 August 9, 2016
# @purpose Lets test metacharacters.
# @note Just testing the metacharacter {.
# @note Works as expected.
use strict;
print 'START: regexp4.pl'."\n";
my $containsMeta = '{ALeftCurlyBracePlease';
if ($containsMeta =~ /\{ALeftCurly/)
{
	print '... {ALeftCurly was found (EXPECTED)'."\n";
}
else
{
	print '... {ALeftCurly was not found (NOT EXPECTED)'."\n";
}
if ($containsMeta =~ /\{NotToBeFound/)
{
	print '... {NotToBeFound was found (NOT EXPECTED)'."\n";
}
else
{
	print '... {NotToBeFound was not found (EXPECTED)'."\n";
}

print 'END: regexp4.pl'."\n";
