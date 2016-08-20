# @file regexp10.pl
# @author Raymond Byczko
# @company self
# @start_date 2016-08-10 August 10, 2016
# @purpose Lets test character class abbreviations, namely backslash d.
# @note Also experiment with grouping metacharacters '()' and special variable $1
# @note Works as expected. 
print 'START: regexp10.pl'."\n";
my $numberLine1 = 'This line contains two digits 77 here and trying to match to two.';
if ($numberLine1 =~ /\d\d/)
{
	print "... detected two digits ok (EXPECTED)"."\n";
}
else
{
	print "... did not detect two digits (NOT EXPECTED)"."\n";
}
my $numberLine2 = 'This line contains two digits 44 here and trying to match to three';
if ($numberLine2 =~ /\d\d\d/)
{
	print "... detected three digits (NOT EXPECTED)"."\n";
}
else
{
	print "... did not detect three digits (EXPECTED)"."\n";
}

my $numberLine3 = 'This line contains three digits 555 and trying to match to two';
if ($numberLine3 =~ /\d\d/)
{
	print "... detected two digits (EXPECTED)"."\n";
}
else
{
	print "... did not detect two digits (NOT EXPECTED)"."\n";
}

my $numberLine4 = 'This contains a two 11 and three 333 digit sequence and a two 22, and trying to match to three';
if ($numberLine4 =~ /(\d\d\d)/)
{
	print "... detected three digits (EXPECTED: 333).Found:".$1."\n";
}
else
{
	print "... did not detect three digits (NOT EXPECTED)"."\n";
}

print 'END: regexp10.pl'."\n";
