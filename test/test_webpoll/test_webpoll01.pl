use strict;
require Webpoll;

my $pollThisSite = 'http://www.nytimes.com';
my $objWP = new Webpoll($pollThisSite);

my $num_iterations = 3;
my $delay = 15; #15 seconds
my $basePathName = 'nytimes';
my $suffix = 'html';
$objWP->poll($num_iterations, $delay, $basePathName, $suffix);
