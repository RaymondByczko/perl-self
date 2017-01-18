# @author Raymond Byczko
# @file Gitshapostconfig.pm
# @location perl-self/lib
# @purpose To provide a perl class for manipulating the config
# of the script gitshappost.
# @start_date 2016-10-14 October 14, 2016
# @change_history RByczko; 2016-10-15 October 15, 2016; Added gitshapostconfigstring.
# See p. 100, Diary #7.
# @change_history RByczko; 2016-10-16 October 16, 2016; Removed add_zone. (Artifact
# of copy and past.  Zone is not a concept in git sha post config.)  Likewise for
# in_zone.
# @change_history RByczko;2016-12-25 December 25, 2016; Added 'documentation'.  Its
# a good start but needs review.  (This comment is well after 'documentation' was
# added, sometime in November or so.)  Also migrated print to logger.  Work
# on excluded.  @todo need to review 'exclude' mechanism.
# @change_history RByczko;2017-01-05 January 05, 2017; Added is_excluded method.
# @change_history RByczko;2017-01-17 January 17, 2017; Added excluded_npr to hash
# representing a Gitshapostconfig object.  This will provide better support for
# is_excluded.  It will rely on excluded_npr.

# @documentation
# Gitshapostconf is a configuration mechanism that allows for checking a deployment
# on a remote web server
# against what is in a local git repository.  The configuration is specified
# in a text file and read into the Gitshapostconf object.
#
# Here is what is involved in the checking process.
#
# 1) A deployed web site
#	a) a remote base; what is the root of the deployed website?
#	b) one or more directories each of which is mapped to a directory in the
#	git repository.
#
# 2) A local git repository
#
# The Gitshapostconfig represents a class to a set of objects.
# Each object is related to a directory in a local git repository.
# A text file form of that object is located in that directory and is
# read into a Gitshapostconfig object using the read method.
#
# A Gitshapostconfig has a text file associated with it at a directory.
# At the same directory are other files, which are mostly deployed
# to the remote server.  A particular Gitshapostconfig is connected
# to those other files.  It specifies where they are local and where
# they are remotely.  This file set is called the 'managed file set'.
#
# What does Gitshapostconfig represent?
#
# It represents the github repo copy used locally, and where is
# the 'root' of that copy located. The root is where the .git
# directory is stored. @todo check this.
#
# remote_base: location on the server that contains the subdomain.
# 	e.g. remindme.lunarrays.com has a place in the file system:
#	/home/lunar51/public_html/remindme
#	Thus remote_base in this example is /home/lunar51/public_html/remindme.
#
# remote_relative_part: relative to remote_base, remote_relative_part
#	contains the directory path piece where the 'managed file
#	set' (minus exceptions) is located on the remote server.
#
#	Each file in the 'managed file set' is deployed to:
#	remote_base + remote_relative_part
#
#	This is true for each file in the 'managed file set' except for those
#	marked as exceptions.   Exceptions are of two forms.  One is
#	a file that is excluded; it does not belong on the remote
#	server.  The other form is a file that will be put into a
#	remote location other than: remote_base + remote_relative_part.
#
# excluded: this is a hash where each key represents a file that is
#	excluded.

package Gitshapostconfig;
use overload '""' =>"gitshapostconfigstring";
use File::Copy;
use File::Basename;
# use Shell qw(diff date);
# use Text::Diff;
require Gitshautility;

use strict;
require Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw();
our @EXPORT_OK = qw();

use Log::Log4perl qw(get_logger);
my $logger = get_logger("Gitshapostconfig");

# nameOfObject: this is just a notation attribute to help tag our
# objects.  It can be any string the client code wants to use
# or finds important.  It is not important for any implementation
# of a sorting procedure, but it might be useful for logging,
# for example.
sub new {
	my ($class, $nameOfObject) = @_;
	my $new_obj = {
		'name_of_object'=>$nameOfObject,
		# This subarea is where config values are stored.
		'local_base'=>'',
		'checked_website'=>'',
		'utility_location'=>'',
		'utility_get'=>'',
		'utility_page'=>'',
		'remote_base'=>'',
		'remote_relative_part'=>'',
		'excluded'=>{
		},
		# excluded_npr: represents 'no path representation' of excluded files.
		'excluded_npr'=>{
		},
		# config_names represents a list of valid config names.
		# Its a little redundant since these are the same as above,
		# yet I like to list them expliciting.  There are some
		# object attributes, like name_of_object, that are not
		# config names.  Each value in the hash is set to 1.
		# At this point, that value of 1 has no meaning.
		'config_names'=>{
			'config.local_base'=>1,
			'config.checked_website'=>1,
			'config.utility_location'=>1,
			'config.utility_get'=>1,
			'config.utility_page'=>1,
			'config.remote_base'=>1,
			'config.remote_relative_part'=>1,
			'config.excluded'=>'',
		},
		# A config file can contain comment lines.  Any line that
		# starts with a comment symbol is a comment is not parsed.
		'comment_symbol'=>'#'
	};
	my $self = bless $new_obj, $class;
	$logger->info('Gitshapostconfig::new-start');
	return $self;
}


# The tmp_area is where newly created files are stored temporarily.
# In the end, it is up to the client code to determine if these
# files are eventually deleted.
sub tmp_area {
	my ($self) = @_;
	print '... tmp_area::start'."\n";
	
	print '... tmp_area::end'."\n";
	return $self->{'tmp_zone'};
}

sub set_tmp_area {
	my ($self, $new_tmp_area) = @_;
	$logger->info('... Gitshapostconfig::set_tmp_area-start');
	$self->{'tmp_area'} = $new_tmp_area;
	$logger->info('... ... new_tmp_area='.$new_tmp_area);
	$logger->info('... Gitshapostconfig::set_tmp_area-end');
}

# A config file can contain comment lines which is a nice thing.
sub comment_symbol {
	my ($self) = @_;
	return $self->{'comment_symbol'};
}

sub set_comment_symbol {
	my ($self, $new_comment_symbol) = @_;
	$self->{'comment_symbol'} = $new_comment_symbol;
}

# This method overloads a Gitshapostconfig object when it is used in
# a string.

sub gitshapostconfigstring {
	my ($self) = @_;
	my $ret_string = '<ret_string>'."\n";

	my $name_of_object = $self->{'name_of_object'};
	$ret_string .= 'name_of_object='.$name_of_object."\n";

	my $local_base = $self->{'local_base'};
	$ret_string .= 'local_base='.$local_base."\n";

	my $checked_website = $self->{'checked_website'};
	$ret_string .= 'checked_website='.$checked_website."\n";

	my $utility_location = $self->{'utility_location'};
	$ret_string .= 'utility_location='.$utility_location."\n";

	my $utility_get = $self->{'utility_get'};
	$ret_string .= 'utility_get='.$utility_get."\n";

	my $utility_page = $self->{'utility_page'};
	$ret_string .= 'utility_page='.$utility_page."\n";

	my $ref_config_names = $self->{'config_names'};
	my %h_config_names = %$ref_config_names;
	$ret_string .= 'config_names{"config.local_base"}='.$h_config_names{'config.local_base'}."\n";
	$ret_string .= 'config_names{"config.checked_website"}='.$h_config_names{'config.checked_website'}."\n";
	$ret_string .= 'config_names{"config.utility_location"}='.$h_config_names{'config.utility_location'}."\n";
	$ret_string .= 'config_names{"config.utility_get"}='.$h_config_names{'config.utility_get'}."\n";
	$ret_string .= 'config_names{"config.utility_page"}='.$h_config_names{'config.utility_page'}."\n";

	my $ref_excluded = $self->{'excluded'};

	my @h_excluded_files = keys %$ref_excluded;
	foreach my $excluded (@h_excluded_files) {
		$ret_string .= 'excluded='.$excluded."\n";
	}
	my $comment_symbol = $self->{'comment_symbol'};
	$ret_string .= 'comment_symbol='.$comment_symbol."\n";

	$ret_string .= '</ret_string>'."\n";
	return $ret_string;
}

# Copies the contents of a config file into the current Gitshapostconfig
# object.
sub read {
	my ($self, $srcFile) = @_;
	$logger->info('... Gitshapostconfig::read-start');
	open(FHS,"<".$srcFile);
	
	while (<FHS>)
	{
		# $logger->info('... ... line read='.$_);
		chomp;
		my $input_line = $_;
		$logger->info('... ... input_line='.$input_line);
		# Test for a possibly empty line before looking for a comment
		# symbol.
		if (length($input_line)<1)
		{
			next;	# empty line, trying reading the next at the top of
					# the loop.
		}
		my $first_char = substr $input_line, 0, 1;
		my $comment_symbol;
		$comment_symbol = $self->comment_symbol();
		if ($first_char eq $comment_symbol)
		{
			next;	# a comment line, skip it.
		}
		my ($config_name, $config_value) = split /=/, $input_line;
		if (exists $self->{config_names}->{$config_name})	
		{
			# Its a recognized config value.
			# my ($parent_name, $child_name) = split /./, $config_name;
			$logger->info('... ... ... recognized, config_name:'.$config_name);
			my ($parent_name, $child_name) = split /\./, $config_name;
			$logger->info('... ... ... parent_name='.$parent_name);
			$logger->info('... ... ... child_name='.$child_name);
			$logger->info('... ... ... config_value:'.$config_value);

			if ($child_name ne 'excluded')
			{
				$self->{$child_name} = $config_value;
				$logger->info('... ... ... config_value:'.$self->{$child_name});
			}
			else
			{
				# excluded file
				# NOTE: $child_name is 'excluded' here.
				$self->{$child_name}->{$config_value} = '1';
				$logger->info('... ... ... config_value:'.$self->{$child_name}->{$config_value});
				
				# Store the 'no path resolution' format under 'excluded_npr'.
				my $nameObj = 'Gitshapostconfig::Gitshautility';
				my $objUtility = new Gitshautility($nameObj);
				my $npr = $objUtility->no_path_resolution($config_value);
				$logger->info('... ... ... npr:'.$npr);
				$self->{'excluded_npr'}->{$npr} = '1';
			}

			# print '... config_value:'.$self->{$child_name}."\n";
		}
		else
		{
			# Its not a recognized config value.
			$logger->info('... ... ... not recognized, config_name:'.$config_name);
		}
	}
	close(FHS);
	$logger->info('... Gitshapostconfig::read-end');
}

# is_excluded: returns true or false depending on whether or not a file is excluded.
# The client code could test against the excluded_npr hash, but naming
# this functionality makes intention clearer.
# 
sub is_excluded {
	my ($self, $fileName) = @_;
	my $retValue;
	if (exists($self->{'excluded_npr'}->{$fileName}))
	{
		$retValue = 1; # true
	}
	else
	{
		$retValue = 0; # false
	}
	return $retValue;
}
1;
