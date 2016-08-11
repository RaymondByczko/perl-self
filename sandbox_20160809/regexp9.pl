# @file regexp9.pl
# @author Raymond Byczko
# @company self
# @start_date 2016-08-09 August 9, 2016
# @purpose Lets test character classes.
# @note The regexp /^[^1-3][0-9][0-9]/ should
# detect 400, 500 etc but not 1xx, nor 2xx, nor 3xx.
# @note Works as expected . 
print 'START: regexp9.pl'."\n";
my $numberLine1 = '400: This is four hundred';
if ($numberLine1 =~ /^[^1-3][0-9][0-9]/)
{
	print "... detected 400 ok (EXPECTED)"."\n";
}
else
{
	print "... did not detect 400 (NOT EXPECTED)"."\n";
}
my $numberLine2 = '100: This is one hundred';
if ($numberLine2 =~ /^[^1-3][0-9][0-9]/)
{
	print "... detected 100 (NOT EXPECTED)"."\n";
}
else
{
	print "... did not detect 100 (EXPECTED)"."\n";
}

my $numberLine3 = '59: This is fifty nine';
if ($numberLine3 =~ /^[^1-3][0-9][0-9]/)
{
	print "... detected 59 (NOT EXPECTED)"."\n";
}
else
{
	print "... did not detect 59 (EXPECTED)"."\n";
}

my $numberLine4 = '690: This is six hundred and ninety.';
if ($numberLine4 =~ /^[^1-3][0-9][0-9]/)
{
	print "... detected 690 (EXPECTED)"."\n";
}
else
{
	print "... did not detect 690 (NOT EXPECTED)"."\n";
}

print 'END: regexp9.pl'."\n";
