# @author Raymond Byczko
# @file test_gitshapostconfig04.pl
# @location perl-self/test/test_gitshapostconfig/
# @purpose To provide a test for the Gitshapostconfig perl class.
# Specifically it will test get_excluded_npr.
# @associated_files sampleconfig04.cfg
# @start_date 2017-02-03 February 03, 2017
# @usage Invoke from the current directory:
#	perl -I../../lib ./test_gitshapostconfig04.pl
#
# @change_history 2017-02-07 February 7, 2017, RByczko, Added to status
# and done section.
# @status When running this script, under the output of 'exclusion
# considerations', the following is observed and is expected.
#	a) not_this_file01.html is excluded
#	b) not_this_file02.html is excluded
#	c) not_this_file03.html is excluded
#	d) not_this_file04.hmtl is excluded
#	e) not_this_file05.html is not excluded.  Initial unexpected, but
#		expected due to its directory not existing.
#	c) includedfile.hmtl is not excluded
# This outcome is per consideration of sampleconfig04.cfg
# via the two lines it contains as follows:
#
# config.excluded=not_this_file01.html
# config.excluded=not_this_file02.html
# config.excluded=./not_this_file03.html
# config.excluded=../test_gitshapostconfig/not_this_file04.html
# config.excluded=../directorydoesnotexist/not_this_file05.html
#
# Thus this test is a success.
# @status_end
# @todo Getting a Log4perl artifact.  "Seems like no initialization
# happened.  Forgot to call init?".  Need to resolve this.
# @todo_end
# @done Called Log4perl fragment with init and get_logger etc.
# No longer getting the above Log4perl artifact. @done_end

use strict;
require Gitshapostconfig;


use Log::Log4perl qw(get_logger);
Log::Log4perl->init("./gitshapost.conf");
my $logger = get_logger("main");


print 'test_gitshapostconfig04.pl:start'."\n";
my $nameObj = 'name:test_gitshapostconfig04';
my $objGS = new Gitshapostconfig($nameObj);

print 'Here is the string of objGS (pre read):'."\n";
print $objGS;
print "\n";

my $aConfigFile = './sampleconfig04.cfg';
my $ret_read = $objGS->read($aConfigFile);
my $ref_npr = $objGS->get_excluded_npr();
my @array_npr = @$ref_npr;
print "... lets check out excluded npr element"."\n";
print "... ... npr elements (start)"."\n";
foreach my $npr_element (@array_npr) {
	print "... ... ... npr_element:".$npr_element."\n";
}
print "... ... npr elements (end)"."\n";

print 'exclusion considerations'."\n";
my $candidate1='not_this_file01.html';
if ($objGS->is_excluded($candidate1) == 1) {
	print '... '.$candidate1.' is excluded'."\n";
}
else
{
	print '... '.$candidate1.' is not excluded'."\n";
}
my $candidate2='not_this_file02.html';
if ($objGS->is_excluded($candidate2) == 1) {
	print '... '.$candidate2.' is excluded'."\n";
}
else
{
	print '... '.$candidate2.' is not excluded'."\n";
}

my $candidate3='not_this_file03.html';
if ($objGS->is_excluded($candidate3) == 1) {
	print '... '.$candidate3.' is excluded'."\n";
}
else
{
	print '... '.$candidate3.' is not excluded'."\n";
}

my $candidate4='not_this_file04.html';
if ($objGS->is_excluded($candidate4) == 1) {
	print '... '.$candidate4.' is excluded'."\n";
}
else
{
	print '... '.$candidate4.' is not excluded'."\n";
}

my $candidate5='not_this_file05.html';
if ($objGS->is_excluded($candidate5)==1) {
	print '... '.$candidate5.' is excluded'."\n";
}
else
{
	print '... '.$candidate5.' is not excluded'."\n";
}

my $candidate6='includedfile.html';
if ($objGS->is_excluded($candidate6)==1) {
	print '... '.$candidate6.' is excluded'."\n";
}
else
{
	print '... '.$candidate6.' is not excluded'."\n";
}
print 'end exclusion considerations'."\n";
print "\n";

print 'Here is the string of objGS (post read):'."\n";
print $objGS;
print "\n";
print 'test_gitshapostconfig04.pl:end'."\n";
