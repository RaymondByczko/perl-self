# @file regexp3.pl
# @author Raymond Byczko
# @company self
# @start_date 2016-08-09 August 9, 2016
# @note Just testing the use of backslashes with alternative delimiters.
# Works as expected.
use strict;
print 'START: regexp3.pl'."\n";
my $mypath = '/usr/lib:/home/raymond/bin:/home/raymond/perl';
if ($mypath =~ m!/home/raymond/perl!)
{
	print '... /home/raymond/perl was found (EXPECTED)'."\n";
}
else
{
	print '... /home/raymond/perl was not found (NOT EXPECTED)'."\n";
}
if ($mypath =~ m!/home/raymond/nothere!)
{
	print '... /home/raymond/nothere was found (NOT EXPECTED)'."\n";
}
else
{
	print '... /home/raymond/nothere was not found (EXPECTED)'."\n";
}

print 'END: regexp3.pl'."\n";
