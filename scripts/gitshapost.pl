#!/usr/bin/perl
# @file gitshapost.pl
# @location perl-self/scripts/
# @company self
# @author Raymond Byczko
# @start_date 2016-10-14 October 14, 2016
# @purpose To offer a command line utility for checking a deployed
# website against a developer's copy of that website.  The developer's
# copy is the the local git repository the developer is using.  gitshapost.pl
# can be used to see how the web site is deployed and see if it needs
# updating.  Determining the need to update is the primary problem
# gitshapost.pl is trying to solve.
# @note This utility is inspired by a test perl script:
# @reference perl-self/test/test_webpoll/test_webpoll02.pl
# @change_history
use strict;
use Getopt::Long;
use GD;

my $file_input="";
my $all=0;
my $config_file='.gitshapost.cfg';

# This anonymous hash contains configuration settings that
# are read from one and possibly more configuration files.
my $ref_config_settings = {
	'local_base'=>'',
	'checked_website'=>'',
	'utility_location'=>'',
	'utility_get'=>'',
	'utility_page'=>''
};

GetOptions(
	"f=s"=> \$file_input,
	"a"=> \$all,
	"s=s"=> \$config_file
) or die ('Error in command line arguments'."\n");

print 'file_input='.$file_input."\n";
print 'all='.$all."\n";
print 'config_file='.$config_file."\n";
if (($file_input eq "") && ($all == 0))
{
	print 'Need to specify a single file or all'."\n";
	print 'exiting'."\n";
	exit(1); # non success
}
if (($file_input ne "") && ($all == 1))
{
	print 'Cannot specify a single file and all at the same time.'."\n";
	print 'Chose one or the other'."\n";
	print 'exiting'."\n";
	exit(2); # non success
}
if ($all == 1)
{
	# We are in all mode.
}
if ($file_input ne "")
{
	# we are in single file mode.
}
exit(0); # success
