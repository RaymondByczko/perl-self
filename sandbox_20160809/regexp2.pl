# @file regexp2.pl
# @author Raymond Byczko
# @company self
# @start_date 2016-08-09 August 9, 2016
# @note Why does the single quotes in the regular expression effect
# the search such that author in quotes is not found in srcline?
# @note It seems it is searching for 'author', that is author with the
# single quotes around it.
use strict;
print 'START: regexp2.pl'."\n";
my $srcline = 'author Raymond Byczko';
if ($srcline =~ m!'author'!)
{
	print '... author was found using different delimiters (NOT EXPECTED)'."\n";
}
else
{
	print '... author was not found using different delimiters (EXPECTED)'."\n";
}

my $srcline2 = "'author' Raymond Byczko";
if ($srcline2 =~ m!'author'!)
{
	print "... 'author' was found using different delimiters (EXPECTED)"."\n";
}
else
{
	print "... 'author' was not found using different delimiters (NOT EXPECTED)"."\n";
}
print 'END: regexp2.pl'."\n";
