# @author Raymond Byczko
# @file test_gitshautility02.pl
# @location perl-self/test/test_gitshautility/
# @purpose To provide a test for the Gitshautility perl class.
# Specifically the method candidates is tested.  Two tests are
# done in this test harness.  'Candidates' are all files/dirs at
# a certain directory.
# @associated_files
# @start_date 2017-01-18 January 18, 2017
# @usage Invoke from the current directory:
#	perl -I../../lib ./test_gitshautility02.pl
#
# @status When running this script, two directories are
# investigated.  These are denoted in the code as comments.
# The following are shown for each: . , .. , regular files , hidden files
# Thus this test is a success.
# @note 
#
# @note_end
#
# @todo
# Upon executing this script, the following is printed.
# Log4perl: Seems like no initialization happened. Forgot to call init()?
# This needs to be resolved.
# @todo_end

use strict;
require Gitshautility;
use Cwd;

print 'test_gitshautility02.pl:start'."\n";
my $nameObj = 'name:test_gitshautility02';
my $objUtility = new Gitshautility($nameObj);

print 'Here is the string of objUtility (start):'."\n";
print $objUtility;
print "\n";

my $current_dir = cwd();
# $current_dir .= '/';
# Investigate the first directory
my $explore_dir = $current_dir;
my $file_match1 = $objUtility->fullFileListing();
my $refCandidates1 = $objUtility->candidates($current_dir, $explore_dir, $file_match1);
my @candidates = @$refCandidates1;
print 'candidates(start) for:'.$current_dir."\n";
foreach my $aCandidate1 (@candidates)
{
	print '... aCandidate='.$aCandidate1."\n";
}
print 'candidates(end)'."\n";

print "\n";
# Investigate the second directory
my $sampleWebDirectory = '/home/raymond/RByczko_Perl/test/test_gitshautility/webcodebase/';
## THESE ARE SOME FILE MATCH PATTERNS THAT HAVE BEEN TRIED.
# my $file_match2 = '.* *';
# my $file_match2 = '.*';
# my $file_match2 = '*';
# my $file_match2 = ".* *";
# my $file_match2 = "{.* *}";
my $file_match2 = $objUtility->fullFileListing();
my $refCandidates2 = $objUtility->candidates($current_dir, $sampleWebDirectory, $file_match2);
my @candidates2 = @$refCandidates2;
print 'candidates(start) for:'.$sampleWebDirectory."\n";
foreach my $aCandidate2 (@candidates2)
{
	print '... aCandidate='.$aCandidate2."\n";
}
print 'candidates(end)'."\n";
print "\n";
print 'test_gitshapostutility02.pl:end'."\n";
