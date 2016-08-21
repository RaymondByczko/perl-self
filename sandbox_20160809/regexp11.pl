# @file regexp11.pl
# @author Raymond Byczko
# @company self
# @start_date 2016-08-11 August 11, 2016
# @purpose Lets test character class abbreviations, namely backslash d.
# @note Also experiment with grouping metacharacters '()' and special variables $1, $2 etc
# @note Works as expected but with some flaw/success in 6th part.
# @change_history RByczko, 2016-08-20, Adjusted 6th regexp trying different techniques.

use strict;
print 'START: regexp11.pl'."\n";

print 'doing 1st regexp...'."\n";
my $numberLine1 = 'This line contains a time in hours minutes second format 23:33:10. Try a good regexp.';
my $hour1;
my $minute1;
my $second1;
($hour1,$minute1,$second1) = ($numberLine1 =~ /(\d\d):(\d\d):(\d\d)/);

print '... hour1='.$hour1.' (EXPECTED 23)'."\n";
print '... minute1='.$minute1.' (EXPECTED 33)'."\n";
print '... second1='.$second1.' (EXPECTED 10)'."\n";

print 'doing 2th regexp...'."\n";
my $numberLine2 = 'This line contains a time in hours minutes but no seconds format 11:22. Try a miss regexp.';
my $hour2;
my $minute2;
my $second2;
($hour2,$minute2,$second2) = ($numberLine2 =~ /(\d\d):(\d\d):(\d\d)/);

print '... hour2='.$hour2.' (EXPECTED nothing)'."\n";
print '... minute2='.$minute2.' (EXPECTED nothing)'."\n";
print '... second2='.$second2.' (EXPECTED nothing)'."\n";


print 'doing 3th regexp...'."\n";
my $numberLine3 = '@author Raymond Byczko';
if ($numberLine3 =~ /(\@author)\s(.*)/)
{
	print "... author comment line detected (EXPECTED)"."\n";
	my $authorSymbol = $1;
	my $authorName = $2;
	print '... Author symbol found: '.$authorSymbol."\n";
	print '... Author name found: '.$authorName."\n"; 

}
else
{
	print "... author comment line not detected (NOT EXPECTED)"."\n";
}

print 'doing 4th regexp...'."\n";
my $numberLine4 = ' @comment This is some comment @endcomment MORE AFTER COMMENT';
if ($numberLine4 =~ /(\@comment)\s*(.*)(\@endcomment)/)
{
	print "... comment comment line detected (EXPECTED)"."\n";
	my $commentSymbol = $1;
	my $commentContents = $2;
	print '... Comment symbol found: '.$commentSymbol."\n";
	print '... Comment contents found: '.$commentContents."\n"; 
}
else
{
	print "... comment comment not detected (NOT EXPECTED)"."\n";
}

# The following example can be an example of how a comment can
# be extracted from multi-line comment fields that are delimited
# by @comment and @endcomment.

my $numberLine5a = ' @comment This is some multi-line comment'."\n";
my $numberLine5b = 'that has this second line'."\n";
my $numberLine5c = 'and ends on this third line@endcomment'."\n";
$/ = ""; # paragraph mode.
chomp($numberLine5a);
chomp($numberLine5b);
chomp($numberLine5c);

my $numberLine5Combined = $numberLine5a.' '.$numberLine5b.' '.$numberLine5c;

print 'doing 5th regexp...'."\n";
if ($numberLine5Combined =~ /(\@comment)\s*(.*)(\@endcomment)/)
{
	print "... comment comment line detected (EXPECTED)"."\n";
	my $commentSymbol = $1;
	my $commentContents = $2;
	my $commentEndSymbol = $3;
	print '... Comment symbol found: '.$commentSymbol."\n";
	print '... Comment contents found: '.$commentContents."\n"; 
	print '... Comment end symbol found: '.$commentEndSymbol."\n";
}
else
{
	print "... comment comment not detected (NOT EXPECTED)"."\n";
}

print 'doing 6th regexp...'."\n";
my $numberLine6a = 'This is a non comment line, 6a'."\n";
my $numberLine6b = 'This is a non comment line, 6b'."\n";
my $numberLine6c = ' @comment This is some multi-line comment 6c'."\n";
my $numberLine6d = 'that has this second line 6d'."\n";
my $numberLine6e = 'and ends on this third line 6e@endcomment'."\n";
my $numberLine6f = 'This is a non comment line, 6f'."\n";
my $numberLine6g = 'This is a non comment line, 6g'."\n";
my $numberLine6h = '@comment This is a single liner 6h @endcomment'."\n";
my $numberLine6i = '@comment This is a single liner 6i@endcomment'."\n";

my @numberLineArray6 = (\$numberLine6a, \$numberLine6b, \$numberLine6c, \$numberLine6d, \$numberLine6e, \$numberLine6f, \$numberLine6g, \$numberLine6h, \$numberLine6i);
foreach my $line6ref (@numberLineArray6) {
	if ($$line6ref =~ /(\@comment)\s(.*)(\@endcomment)/)
	{
		# sl seems to be picked up well.
		# singleline comment - process and continue
		# @comment and @endcomment on same line.
		print '... found singleline (sl):'.$$line6ref."\n";
		print '... ... the comment is (sl):'.$2.'END'."\n";
	}
	if ($$line6ref =~ /(\@comment)\s(.*)(\@endcomment){0}/)
	{
		# ml1 does not work well.  Its picking up @endcomment for some reason.
		# start of multi line comment - process and continue
		# @comment on line but no @endcomment.
		print '... found multiline (ml1):'.$$line6ref."\n";
	}
	if ($$line6ref =~ /\@comment/)
	{
		if ($$line6ref !~ /\@endcomment/)
		{
			# ml2 seems to work well.
			# start of multi line comment - process and continue
			# @comment on line but no @endcomment.
			print '... found multiline (ml2):'.$$line6ref."\n";
		}
	}
	if ($$line6ref =~ /(\@comment){0}\s(.*)(\@endcomment){0}/)
	{
		# nc is working very poorly.  Picking up lots of lines it was not
		# intended to.
		# no comment labels - process and continue
		print '... found no comments (nc):'.$$line6ref."\n";
	}
	if ($$line6ref !~ /\@comment/)
	{
		if ($$line6ref !~ /\@endcomment/)
		{
			# 2if seems to work well.
			# no comment labels - process and continue
			print '... found no comments (2if):'.$$line6ref."\n";
		}
	}

}
print 'END: regexp11.pl'."\n";
