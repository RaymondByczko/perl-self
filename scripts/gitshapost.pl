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
# @change_history 2016-11-22, November 22, 2016.  Added GITBIN_LOCATION
# env variable. Added Log4Perl.  Added BEGIN package constructor.
# @change_history 2016-11-23, November 23, 2016.
# Adjusted processing of return value for Gitshapost::process_file.
# This is to reflect the change in its return type from a scalar to
# a reference to a hash.
# @change_history 2016-11-26, November 26, 2016.  Added normalize_config_file.
# @change_history 2016-12-25, December 25, 2016.  Migrated print to logger calls.
# @change_history 2017-01-14, January 14, 2017.  Added excluded file functionality
# to single file mode.
# @change_history 2017-01-15, January 15, 2017.  Added no_path_resolution functionality
# for exclusion of files.  See Diary #7, p. 167 to 172. 
# @change_history 2017-01-18, January 18, 2017.  Implement 'all' mode.
# @todo Need to finish 'all' mode. @todo_end
# @change_history 2017-02-03, February 3, 2017.  Added to 'all' mode.  In progress.
# @change_history 2017-02-07, February 7, 2017.  Refactor single file mode with sub:
# remote_repo_compare.  Eventually this will be applied to all file mode.
# @change_history 2017-02-07, February 7, 2017.  Partial refactor of all file mode
# with sub: candidates_for_processing.
# @change_history 2017-02-09, February 9, 2017.  Change signature of sub:
# candidates_for_processing.  Document candidates_for_processing.
# @change_history 2017-02-09, February 9, 2017. Add sub candidates_for_processing_1
# This sub produces a reference to an array of candidates to be processed
# for single file mode (-f).
# @change_history 2017-02-09, February 9, 2017. Added remote_repo_compare_single.
# It is wrapped now by a remote_repo_compare.
# @change_history 2017-02-09, February 9, 2017. Adjusted all mode with call to sub
# remote_repo_compare.  Added logger info on excluded files and candidates for
# processing.  All of this is to refactor single file and all mode into something
# more unified and more DRY. @todo need to remove logically removed code (0==1).

use strict;
use Modern::Perl;
use Getopt::Long;
use Cwd;
use File::Basename;


use Env qw(GITSEARCH_HOME GITSEARCH_LIB GITREPO_HOME GITBIN_LOCATION);
BEGIN {
	# print 'BEGIN-gitshapost.pl';
	die 'GITSEARCH_HOME not defined. Do a: source gitshapostenv'."\n" unless defined($GITSEARCH_HOME); 
	die 'GITSEARCH_LIB not defined. Do a: source gitshapostenv'."\n" unless defined($GITSEARCH_LIB); 
	die 'GITREPO_HOME not defined. Do a: source gitshapostenv'."\n" unless defined($GITREPO_HOME); 
	die 'GITBIN_LOCATION not defined. Do a: source gitshapostenv'."\n" unless defined($GITBIN_LOCATION); 
	print 'BEGIN-gitshapost.pl-success';
}
print 'GITSEARCH_LIB:'.$GITSEARCH_LIB."\n";

use lib (split ' ',$GITSEARCH_LIB);


# use GD;
require Gitshapost;
# use Gitshapost;
require Gitshapostconfig;
require Gitshautility;
use Log::Log4perl qw(get_logger);


Log::Log4perl->init($GITSEARCH_HOME."/gitshapost.conf");
my $logger = get_logger("main");


$logger->info('gitshapost.pl-start');

### gitsearch ### 
use gitsearch;
# require gitsearch;
# @todo The values in the following three set* calls should be retrieved
# from a config file or from command line arguments.
# (These calls are related to gitsearch)
setgitlocation($GITBIN_LOCATION);
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


# normalize_config_file.  Insure that config_file is correct, in that
# the one utilized should be in same directory as where the file for -f
# is located.
#
# Config files should be in the directory of the files to which it
# applies.  gitshapost.pl however, can be called, lets say, from
# a parent directory of a subdirectory, the later of which contains
# the file we are interested in (utilized for example in
# single file mode).  And so when gitshapost.pl is invoked, it is utilizing
# the config file in that parent directory.  This is conceptually
# incorrect, unless we have directory inheritance.  What we want is
# the config file located in the subdirectory.  We want the config
# file immediately local to the relevant file. 
sub normalize_config_file {
	my ($config_file, $current_dir, $file_input) = @_;
	$logger->info('normalize_config_file-start');
	$logger->info('... config_file='.$config_file);
	$logger->info('... current_dir='.$current_dir);
	$logger->info('... file_input='.$file_input);
	my $abs_fipath = Cwd::realpath($file_input);
	$logger->info('... abs_fipath='.$abs_fipath);
	my ($fi_name, $fi_path, $fi_suffix) = fileparse($abs_fipath);
	$logger->info('... fi_name='.$fi_name);
	$logger->info('... fi_path='.$fi_path);
	$logger->info('... fi_suffix='.$fi_suffix);
	my $ncf = '';
	if ($fi_path eq $current_dir)
	{
		$logger->info('... path of file_input and current directory are equal');
		$ncf = $fi_path.$config_file;
	}
	else
	{
		$logger->info('... path of file_input and current directory are not equal');
		$ncf = $fi_path.$config_file;
	}
	$logger->info('... ncf='.$ncf);
	$logger->info('normalize_config_file-end');
	return $ncf;
}


if (($file_input eq "") && ($all == 0))
{
	$logger->info('... gitshapost.pl-need single file or all-exiting');
	print 'Need to specify a single file or all'."\n";
	print 'exiting'."\n";
	exit(1); # non success
}
if (($file_input ne "") && ($all == 1))
{
	$logger->info('... gitshapost.pl-cannot specify single file and all-exiting');
	print 'Cannot specify a single file and all at the same time.'."\n";
	print 'Chose one or the other'."\n";
	print 'exiting'."\n";
	exit(2); # non success
}
if ($all == 1)
{
	$logger->info('... gitshapost.pl-start of all mode');
	# We are in all mode.

	print "all mode (start)..."."\n";

	# Step 1 - Establish gitshapost object
	my $nameGitsha = 'name:gitshapost::Gitshapost';
	my $objGS = new Gitshapost($nameGitsha);
	# Step 2 - Take care of the config file and config object.
	my $nameConfig = 'name:gitshapost::Gitshapostconfig';
	my $objConfig = new Gitshapostconfig($nameConfig);
	# Step 3 - Normalize config file.
	my $current_dir = cwd();
	$current_dir .= '/';
	# my $ncf = normalize_config_file($config_file, $current_dir, $file_input);
	# my $ncf = normalize_config_file($config_file, $current_dir, $current_dir);
	# @todo temp fix - resolve
	my $ncf = $current_dir.$config_file;
	my $ret_read = $objConfig->read($ncf);
	$logger->info('... ... ret_read (from $objConfig->read):'.$ret_read);

	# @todo temp debugging
	print $objConfig;

	### print 'exit for testing'."\n";
	# Step 4 - Establish possible candidates in current directory.
	my $explore_dir = cwd();

	# Associate config object with Gitshapost object.
	$objGS->set_config($objConfig);

# Given a directory to explore (explore_dir), this sub gets
# all file names at that directory minus a) standard removals
# like '.' and '..' b) excluded files that were excluded from
# via a config file.
#
# candidates_for_processing is an 'all mode' context sub.
# It is not intended to be used for 'single file' mode.
#
# parameters
#	current_dir: this is a requirement for the implementation
#		but is not the main part of the logic.
#		Gitshautility::candidates needs it to do a glob
#		function correctly.  Otherwise, its not needed.
#	explore_dir: this is where candidates_for_processing will
#		explore to seek out candidates.
#	objConfig: required since candidates_for_processing needs to consider
#		excluded files (in 'no path resolution' format).
sub candidates_for_processing {
	my ($current_dir, $explore_dir, $objConfig) = @_;
	# Instantiate our utility class.
	my $nameObj = 'gitshapost.pl:gitshautility';
	my $objUtility = new Gitshautility($nameObj);
	# Specify all files.
	my $allFiles = $objUtility->fullFileListing();
	# Get candidates at $explore_dir.
	my $refCandidates = $objUtility->candidates($current_dir, $explore_dir, $allFiles);

	# Print out candidates for debugging/information purposes.
	my @candidates = @$refCandidates;
	print '... candidates(start) for:'.$current_dir."\n";
	foreach my $aCandidate (@candidates)
	{
		print '... ... aCandidate='.$aCandidate."\n";
	}
	print '... candidates(end)'."\n";

	# Calculate the standard removals from consideration.  Things like '.' and '..'.
	my $refToBeRemoved = $objUtility->standardRemovals();
	# Remove the standard removals from the candidate list.
	my $refFilteredCandidates = $objUtility->removeElements($refToBeRemoved, $refCandidates);

	# Get an array reference for those excluded files, in format known as 'no path resolution'.
	my $refExcNpr = $objConfig->get_excluded_npr();

	$logger->info('... ... excluded files');
	foreach my $exf (@$refExcNpr) {
		$logger->info('... ... ... excluded:'.$exf);
	}
	$logger->info('... ... end excluded files');

	# Remove excluded files from filtered candidates.
	my $refNprFilteredCandidates = $objUtility->removeElements($refExcNpr, $refFilteredCandidates);
	# Return the result.
	$logger->info('... ... candidates for processing');
	foreach my $npf (@$refNprFilteredCandidates) {
		$logger->info('... ... ... filtered candidate:'.$npf);
	}
	$logger->info('... ... end candidates for processing');
	return $refNprFilteredCandidates;
}
	my $refNprFilteredCandidates = candidates_for_processing($current_dir, $explore_dir, $objConfig);

	remote_repo_compare($refNprFilteredCandidates, $objConfig);
	if (0==1) {
	# A ref to an array of the candidates that should be processed is in: $refNprFilteredCandidates
	foreach my $aFile_input (@$refNprFilteredCandidates)
	{
		# Process the file (retrieving details from across the web)
		# (Looking at a deployed file.)
		print 'Process:'.$aFile_input."\n";
		my $ret_pf = $objGS->process_file($aFile_input);
		if ($ret_pf->{'ret_code'} < 0)
		{
			# error condition detected by process_file.
			$logger->info('... gitshapost.pl-error with process_file');
			$logger->info('... ... aFile_input='.$aFile_input);
			$logger->info('... ... ret_pf->{"ret_code"}='.$ret_pf->{'ret_code'});
			print 'Problem with:'.$aFile_input."\n";
			next;
			# exit(1); # failure
		}
		print 'Processed ok:'.$aFile_input."\n";
	}
	}

	print "all mode (end)..."."\n";
}
if ($file_input ne "")
{

	# Take care of the config file and config object.
	my $nameConfig = 'name:gitshapost::Gitshapostconfig';
	my $objConfig = new Gitshapostconfig($nameConfig);
	my $current_dir = cwd();
	$current_dir .= '/';
	my $ncf = normalize_config_file($config_file, $current_dir, $file_input);
	my $ret_read = $objConfig->read($ncf);
	# The config file and config object are taken care of at this point.

	my @array_file_input = [$file_input];

# Determines if file_input is a valid candidate for single file mode,
# which is specified by a Gitshapostconfig object, delivered
# as objConfig.  Note that the read method is usually called
# on the Gitshapostconfig object so as to read in anything
# that might be excluded, among other details.
sub candidates_for_processing_1 {
	my ($file_input, $objConfig) = @_;
	# Form the 'no path resolution' (npr) from $file_input.
	# e.g. ./Account.php resolves to 'Account.php'
	# e.g. ./controllers/Account.php resolves to 'Account.php'
	# (Basically just get the file name component).
	my $nameObj = 'Gitshautility::gitshapost.pl';
	my $objUtility = new Gitshautility($nameObj);
	my $npr = $objUtility->no_path_resolution($file_input);
	my $excludeFile = $objConfig->is_excluded($npr);
	if ($excludeFile == 1)
	{
		# The file is excluded by configuration.
		$logger->info('gitshapost.pl-candidates_for_processing_1-excluded file-normal exit (file:'.$file_input.')');
		print 'File excluded:'.$file_input."\n";
		print 'No path resolution:'.$npr."\n";
		my $ref_empty_array = [];
		return $ref_empty_array;
		# success, albeit excluded file
	}
	# The file is not excluded. Return a reference
	# to an anonymous array.
	return [$file_input];
}
	my $ref_candidates = candidates_for_processing_1($file_input, $objConfig);
	# remote_repo_compare(\@array_file_input, $objConfig);
	remote_repo_compare($ref_candidates, $objConfig);
}
sub remote_repo_compare {
	$logger->info('remote_repo_compare-start');
	my ($ref_array_file_input, $objConfig) = @_;
	my @array_file_input = @$ref_array_file_input;
	foreach my $file_input (@array_file_input)
	{
		$logger->info('... (remote_repo_compare)file_input='.$file_input);
		remote_repo_compare_single($file_input, $objConfig);
	}
	$logger->info('remote_repo_compare-end');
}
sub remote_repo_compare_single {
	my ($file_input, $objConfig) = @_;
	$logger->info('... ... remote_repo_compare_single-start');
	$logger->info('... ... ... file_input='.$file_input);
	### my $len_file_input = @array_file_input;
	### if ($len_file_input == 1) {
	###	$logger->info('... gitshapost.pl-start of single file mode');
	###	# we are in single file mode.
	### }
	my $nameGitsha = 'name:gitshapost::Gitshapost';
	my $objGS = new Gitshapost($nameGitsha);

	# Associate config object with Gitshapost object.
	$objGS->set_config($objConfig);

	# Process the file (retrieving details from across the web)
	# (Looking at a deployed file.)
	my $ret_pf = $objGS->process_file($file_input);
	if ($ret_pf->{'ret_code'} < 0)
	{
		# error condition detected by process_file.
		$logger->info('... gitshapost.pl-error with process_file');
		$logger->info('... ... ret_pf->{"ret_code"}='.$ret_pf->{'ret_code'});
		exit(1); # failure
	}

	# Do some XML processing
	my $hashGitDetailsRemote = $objGS->process_xml($ret_pf->{'xml_remote_file'});
	
	# See ~/git/git-php-rewrite/document_root/php-bin/gitshaxml.php
	# gitshaxml.php is used for config.utility_page.
	$logger->info('... ... hashGit...error_code='.$hashGitDetailsRemote->{'errorcode'});

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
	$logger->info('... ... remote_base='.$remote_base);

	my $rel_filename = 'there'; #@todo fix this
	$rel_filename = $objGS->relative_part($infoabout, $remote_base);
	my $trim_rel_filename = $rel_filename;
	$trim_rel_filename =~ s{^/+}{};
	$logger->info('... ... rel_filename='.$rel_filename);
	$logger->info('... ... trim_rel_filename='.$trim_rel_filename);
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

$logger->info('gitshapost.pl-normal exit');
exit(0); # success
