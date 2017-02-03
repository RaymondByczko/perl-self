# @author Raymond Byczko
# @file Gitshautility.pm
# @location perl-self/lib
# @purpose To provide a perl class for certain utility
# methods that don't fit conveniently into a specific
# well defined class.
# @change_history 2017-01-18, January 18, 2017; Added candidates method,
# fullFileListing method.
# @todo Document fullFileListing @todo_end
# @change_history 2017-01-19, January 19, 2017; Added method removeElements.
# And method: standardRemovals.

package Gitshautility;
use overload '""' =>"gitshautilitystring";

use strict;
require Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw();
our @EXPORT_OK = qw();

use Log::Log4perl qw(get_logger);
my $logger = get_logger("Gitshautility");

use Cwd qw(realpath);
use File::Basename;

# nameOfObject: this is just a notation attribute to help tag our
# objects.  It can be any string the client code wants to use
# or finds important.  It is not important for any implementation
# of a sorting procedure, but it might be useful for logging,
# for example.
sub new {
	my ($class, $nameOfObject) = @_;
	my $new_obj = {
		'name_of_object'=>$nameOfObject,
	};
	my $self = bless $new_obj, $class;
	$logger->info('Gitshautility::new-start');
	return $self;
}

# no_path_resolution: this method takes a pathName and translates it to a fileName.
# The pathName can include a directory and its fileName at the end.  This ending
# fileName is called the 'no_path_resolution' since the path component is removed (implying
# 'no path').  This method figures out the 'no_path_resolution' and returns it.
#
# Admittingly, this might seem like an obscure method.  Why would it be used?
#
# This method insures a consistent standard between two areas.  One area is the
# command line.  The other area is within config files.  That standard is where the two
# areas meet, so appropriate comparsion can be made.  
#
# On a command line, there are a number of ways to specify a file to which something should
# be done. Here are some examples:
#
#	notdeployed.php
#	./notdeployed.php
#	./webcodebase/notdeployed.php
#
# Given the above, each resolves to 'notdeployed.php'.  (Notice there is no path in it.).
# 
sub no_path_resolution {
	my ($self, $pathName) = @_;
	$logger->info('... Gitshautility::no_path_resolution-start');
	# npr stands for no_path_resolution
	my $ret_npr;
	my $abs_path = Cwd::realpath($pathName);
	$logger->info('... abs_path='.$abs_path);
	# The 'p' prefix indicates the quanity is the result of parsing
	# (or in other words, fileparse).
	my ($p_name, $p_path, $p_suffix) = fileparse($abs_path);
	$logger->info('... p_name='.$p_name);
	$logger->info('... p_path='.$p_path);
	$logger->info('... p_suffix='.$p_suffix);
	print '... p_name='.$p_name."\n";
	print '... p_path='.$p_path."\n";
	print '... p_suffix='.$p_suffix."\n";
	# Test to see if its a directory.  If it is, $p_name will be a directory.
	# And what we want is for the case of "./", the returned value should
	# be empty.
	if (-d $p_path.$p_name.$p_suffix)
	{
		$ret_npr = '';
	}
	else
	{
		$ret_npr = $p_name;
	}
	$logger->info('... Gitshautility::no_path_resolution-end');
	return $ret_npr;

}

# This method overloads a Gitshautility object when it is used in
# a string.
sub gitshautilitystring {
	my ($self) = @_;
	my $ret_string = '<ret_string>'."\n";

	my $name_of_object = $self->{'name_of_object'};
	$ret_string .= 'name_of_object='.$name_of_object."\n";
	$ret_string .= '</ret_string>'."\n";
	return $ret_string;
}

# candidates does a file listing at the candidateDirectory specified.
# To enable a full file listing (with . .. hidden files directories regular files),
# a fileMatchPattern of ".* *" can be used.  This is actually the preferred mode.
# But you can utilize other patterns too.
#
# Note that the above fileMatchPattern is delivered by the convenience method
# fullFileListing.  Its found below this method.
#
# The reason for the presence of two Dir parameters (currentDir, candidateDir).
# is as follows.
#
# glob likes to work in the current directory.  So we change to the candidateDir
# and make it the current directory.  Glob will be called there.  Then
# before returning, the current directory is switched back to the known
# original (which is set in currentDir, by the client code).
# This type of operating is useful for getting full file listings.
# Otherwise, experiment indicates less than full listing is available
# if we call glob ($candidateDir.$fileMatchPattern).
# @todo Research this further, although the current implementation
# is useful as is.  And its recommended on the web.  See url:
# http://perldoc.perl.org/functions/glob.html
#
# candidates returns a reference to an array of the file listing.
sub candidates {
	my ($self, $currentDir, $candidateDir, $fileMatchPattern) = @_;
	chdir $candidateDir;
	my @theCandidates = glob($fileMatchPattern);	
	chdir $currentDir;
	return \@theCandidates;
}

sub fullFileListing {
	my $retFullFileL = ".* *";
	return $retFullFileL;
}

# This method removes elements from a referenced array returned by method
# candidates.  The elements removed are specified in a referenced array
# refToBeRemoved.  The elements are removed from refCandidates.  The result
# of this removal is returned by this method.  A reference to an array is
# returned.
#
# The array referred to by refToBeRemoved typically contains two elements.
# These include a) . b) ..
#
sub removeElements {
	my ($self, $refToBeRemoved, $refCandidates) = @_;
	my @toBeRemoved = @$refToBeRemoved;
	my @theCandidates = @$refCandidates;

	my @resultArray;

	foreach my $aCandidate (@theCandidates) {
		## smartmatch is experimental
		## if ($aCandidate ~~ @toBeRemoved)
		if (grep( /^$aCandidate$/, @toBeRemoved))
		{
			# ignore since its on removal list.
		}
		else
		{
			push @resultArray, $aCandidate
		}
	}
	my $refResultArray = \@resultArray;
	return $refResultArray;
}

sub standardRemovals {
	my @toBeRemoved = (".", "..");
	return \@toBeRemoved;
}
1;
