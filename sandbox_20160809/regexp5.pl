# @file regexp5.pl
# @author Raymond Byczko
# @company self
# @start_date 2016-08-09 August 9, 2016
# @purpose Lets test metacharacters.
# @note Just testing the metacharacter $.
# @note Works as expected. 
use strict;
print 'START: regexp5.pl'."\n";
my $containsMeta = '$ADollarPlease';
if ($containsMeta =~ /\$ADollar/)
{
	print '... $ADollar was found (EXPECTED)'."\n";
}
else
{
	print '... $ADollar was not found (NOT EXPECTED)'."\n";
}
if ($containsMeta =~ /\$NotToBeFound/)
{
	print '... $NotToBeFound was found (NOT EXPECTED)'."\n";
}
else
{
	print '... $NotToBeFound was not found (EXPECTED)'."\n";
}

print 'END: regexp5.pl'."\n";
