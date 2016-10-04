# @author Raymond Byczko
# @file test_webpoll01.pl
# @location perl-self/test/test_webpoll/
# @purpose To provide a test for the Webpoll perl class.
# @start_date 2016-09-22 September 22, 2016

use strict;
require Webpoll;

print 'test_webpoll01.pl:start'."\n";
my $pollThisSite = 'http://www.nytimes.com';
my $objWP = new Webpoll($pollThisSite);

my $num_iterations = 2;
my $delay = 1; #15 seconds
my $basePathName = 'nytimesE';
my $suffix = 'html';
my $ret_poll = $objWP->poll($num_iterations, $delay, $basePathName, $suffix);
my @ret_poll = @$ret_poll;
foreach my $poll_stats (@ret_poll) {
	my $ct = $poll_stats->{ct};
	my $sha = $poll_stats->{sha};
	my $length = $poll_stats->{length};

	print '... ct='.$ct."\n";
	print '... sha='.$sha."\n";
	print '... length='.$length."\n";
}
print 'Here is the string of objWP:'."\n";
print $objWP;
print "\n";
print 'test_webpoll01.pl:end'."\n";
