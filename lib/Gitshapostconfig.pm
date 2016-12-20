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


package Gitshapostconfig;
use overload '""' =>"gitshapostconfigstring";
use File::Copy;
use File::Basename;
# use Shell qw(diff date);
# use Text::Diff;

use strict;
require Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw();
our @EXPORT_OK = qw();

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
			'config.utility_page'=>1
		},
		# A config file can contain comment lines.  Any line that
		# starts with a comment symbol is a comment is not parsed.
		'comment_symbol'=>'#'
	};
	my $self = bless $new_obj, $class;
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
	print '... set_tmp_area::start'."\n";
	$self->{'tmp_area'} = $new_tmp_area;
	print '... set_tmp_area::end'."\n";
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

	my %h_config_names = $self->{'config_names'};
	$ret_string .= 'config_names{"config.local_base"}='.$h_config_names{'config.local_base'}."\n";
	$ret_string .= 'config_names{"config.checked_website"}='.$h_config_names{'config.checked_website'}."\n";
	$ret_string .= 'config_names{"config.utility_location"}='.$h_config_names{'config.utility_location'}."\n";
	$ret_string .= 'config_names{"config.utility_get"}='.$h_config_names{'config.utility_get'}."\n";
	$ret_string .= 'config_names{"config.utility_page"}='.$h_config_names{'config.utility_page'}."\n";

	my $comment_symbol = $self->{'comment_symbol'};
	$ret_string .= 'comment_symbol='.$comment_symbol."\n";

	$ret_string .= '</ret_string>'."\n";
	return $ret_string;
}

# Copies the contents of a config file into the current Gitshapostconfig
# object.
sub read {
	my ($self, $srcFile) = @_;
	open(FHS,"<".$srcFile);
	
	while (<FHS>)
	{
		print $_;
		chomp;
		my $input_line = $_;
		print 'input_line='.$input_line."\n";
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
			print 'recognized, config_name:'.$config_name."\n";
			my ($parent_name, $child_name) = split /\./, $config_name;
			print '... parent_name='.$parent_name."\n";
			print '... child_name='.$child_name."\n";
			print '... config_value:'.$config_value."\n";
			$self->{$child_name} = $config_value;

			print '... config_value:'.$self->{$child_name}."\n";
		}
		else
		{
			# Its not a recognized config value.
			print 'not recognized, config_name:'.$config_name."\n";
		}
	}
	close(FHS);
}
1;
