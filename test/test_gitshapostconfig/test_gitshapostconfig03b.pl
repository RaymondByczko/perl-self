# @author Raymond Byczko
# @file test_gitshapostconfig03b.pl
# @location perl-self/test/test_gitshapostconfig/
# @purpose To provide a test for the Gitshapostconfig perl class.
# Specifically it will test the exclude mechanism providing an example
# of how client code may use it. This will look at the method is_excluded
# provided by the Gitshapostconfig class.  This will provide an alternative
# to a less clear, although equally accurate method, by looking at the excluded
# hash directly in the Gitshapostconfig object.
# @associated_files sampleconfig03b.cfg
# @start_date 2017-01-14 January 14, 2017
# @usage Invoke from the current directory:
#	perl -I../../lib ./test_gitshapostconfig03b.pl
#
# @status When running this script, under the output of 'exclusion
# considerations', the following is observed and is expected.
#	a) not_this_file01.html is excluded
#	b) not_this_file02.html is excluded
#	c) includedfile.hmtl is not excluded
# This outcome is per consideration of sampleconfig03b.cfg
# via the two lines it contains as follows:
#
# 	config.excluded=not_this_file01.html
#	config.excluded=not_this_file02.html
#
# Thus this test is a success.
# @todo Getting a Log4perl artifact.  "Seems like no initialization
# happened.  Forgot to call init?".  Need to resolve this.
# @todo_end

use strict;
require Gitshapostconfig;

print 'test_gitshapostconfig03b.pl:start'."\n";
my $nameObj = 'name:test_gitshapostconfig03b';
my $objGS = new Gitshapostconfig($nameObj);

print 'Here is the string of objGS (pre read):'."\n";
print $objGS;
print "\n";

my $aConfigFile = './sampleconfig03b.cfg';
my $ret_read = $objGS->read($aConfigFile);

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

my $candidate3='includedfile.html';
if ($objGS->is_excluded($candidate3)==1) {
	print '... '.$candidate3.' is excluded'."\n";
}
else
{
	print '... '.$candidate3.' is not excluded'."\n";
}
print 'end exclusion considerations'."\n";
print "\n";

print 'Here is the string of objGS (post read):'."\n";
print $objGS;
print "\n";
print 'test_gitshapostconfig03b.pl:end'."\n";
