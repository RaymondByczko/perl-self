# @author Raymond Byczko
# @file test_webpoll02.pl
# @location perl-self/test/test_webpoll/
# @purpose To provide a test for the Webpoll perl class.
# This test will look at the remindme website.
# @start_date 2016-10-13 October 13, 2016

use strict;
require Webpoll;

print 'test_webpoll02.pl:start'."\n";
my $gitPostBase = 'http://remindme.lunarrays.com/gitshapost.php';
my $srcFileToGitCheck = 'igniter/system/core/Common.php';
my $check = $gitPostBase.'?ftc='.$srcFileToGitCheck;
my $objWP = new Webpoll($check);

my $num_iterations = 1;
my $delay = 1; #15 seconds
my $basePathName = 'remindmeCheckA';
my $suffix = 'txt';
my $ret_poll = $objWP->poll($num_iterations, $delay, $basePathName, $suffix);
my @ret_poll = @$ret_poll;
foreach my $poll_stats (@ret_poll) {
	my $ct = $poll_stats->{ct};
	my $sha = $poll_stats->{sha};
	my $length = $poll_stats->{length};
	my $post_enc = $poll_stats->{post_enc};

	print '... ct='.$ct."\n";
	print '... sha='.$sha."\n";
	print '... length='.$length."\n";
	print '... post_enc='.$post_enc."\n";
}
print 'Here is the string of objWP:'."\n";
print $objWP;
print "\n";
print 'test_webpoll02.pl:end'."\n";
