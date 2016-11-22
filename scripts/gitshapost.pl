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
# @change_history 2016-11-14, November 14, 2016, Implement single file mode.
# Using test code file: test_gitshapost03.pl
# @change_history 2016-11-21, November 21, 2016.  Added env.  Added gitsearch.
# Got the 'use lib' working with GITSEARCH_LIB.
# The state of this file is still draft quality.


use strict;
use Modern::Perl;
use Getopt::Long;


use Env qw(GITSEARCH_HOME GITSEARCH_LIB GITREPO_HOME GITBIN_LOCATION);
print 'GITSEARCH_LIB:'.$GITSEARCH_LIB."\n";

use lib (split ' ',$GITSEARCH_LIB);


# use GD;
require Gitshapost;
# use Gitshapost;
require Gitshapostconfig;
use Log::Log4perl qw(get_logger);


Log::Log4perl->init($GITSEARCH_HOME."/gitshapost.conf");

### gitsearch ### 
use gitsearch;
# require gitsearch;
# @todo The values in the following three set* calls should be retrieved
# from a config file or from command line arguments.
# (These calls are related to gitsearch)
setgitlocation('/usr/bin/git');
setverbosity(1);
setlengthgithash(40);
### gitsearch ###


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
	my $nameGitsha = 'name:gitshapost::Gitshapost';
	my $objGS = new Gitshapost($nameGitsha);
	# Take care of the config file and config object.
	my $nameConfig = 'name:gitshapost::Gitshapostconfig';
	my $objConfig = new Gitshapostconfig($nameConfig);
	my $ret_read = $objConfig->read($config_file);

	# Associate config object with Gitshapost object.
	$objGS->set_config($objConfig);

	# Process the file (retrieving details from across the web)
	# (Looking at a deployed file.)
	my $ret_pf = $objGS->process_file($file_input);

	# Do some XML processing
	my $hashGitDetailsRemote = $objGS->process_xml($ret_pf);
	
	# See ~/git/git-php-rewrite/document_root/php-bin/gitshaxml.php
	# gitshaxml.php is used for config.utility_page.
	print 'hashGit...error_code='.$hashGitDetailsRemote->{'errorcode'}."\n";

	if ($hashGitDetailsRemote->{'errorcode'} ne 0)
	{
		# Failure.
		my $er_msg = $hashGitDetailsRemote->{'error_message'};
		print 'failure: error_message='.$er_msg."\n";
		exit(1); # failure
	}

	# Lets check out the local repository.
	my $gitshavalue = $hashGitDetailsRemote->{'gitshavalue'};
	# @todo RByczko 2016-11-16 This is not the relative part.  It includes full directory on server.
	my $infoabout = $hashGitDetailsRemote->{'infoabout'};
	my $remote_base = $objConfig->{'remote_base'};
	print 'remote_base='.$remote_base."\n";

	my $rel_filename = 'there';
	$rel_filename = $objGS->relative_part($infoabout, $remote_base);
	my $trim_rel_filename = $rel_filename;
	$trim_rel_filename =~ s{^/+}{};
	print 'rel_filename='.$rel_filename."\n";
	print 'trim_rel_filename='.$trim_rel_filename."\n";
	my $ret_gf = git_find($GITREPO_HOME, $trim_rel_filename, $gitshavalue);
	if ($ret_gf->{found})
	{
		print 'File found'."\n";
		print '... .commitHash='.$ret_gf->{commitHash}."\n";
		print '...gitHashValue='.$ret_gf->{gitHashValue}."\n";
		print '... GIThashFile='.$ret_gf->{GIThashFile}."\n";
		print '... ... GITFile='.$ret_gf->{GITFile}."\n";

	}
	else
	{
		print 'File not found'."\n";
	}
}

	
exit(0); # success
