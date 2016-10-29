# @author Raymond Byczko
# @file Gitshapost.pm
# @location perl-self/lib
# @purpose To provide a perl class checking a deployed site with a git repo.
# @start_date 2016-10-17 October 17, 2016
# @change_history RByczko; 2016-10-17 October 17, 2016; Started this file.
# See p. 100, Diary #7.
# @change_history RByczko; 2016-10-17 October 17, 2016; Adjust overload for string.
# @change_history RByczko; 2016-10-17 October 17, 2016, Removed methods:
# comment_symbol, set_comment_symbol.  These are used in config via Gitshapostconfig.
# No need for them here.
# @change_history RByczko; 2016-10-18 October 18, 2016; Composed $url_for_check.
# Added xmlpoll.


package Gitshapost;
use overload '""' =>"gitshapoststring";
# use File::Copy;
# use File::Basename;
use Cwd qw(realpath);
use WWW::Mechanize;

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
		'config'=>{},

		## IMPT: The following is just artifact from a copied file
		## It will probably be superceded by the config attribute.

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

# @purpose To process the file specified as the -f paremeter.
# The argument given to -f is supplied for $a_file.
#
sub process_file {
	my ($self, $a_file) = @_;
	my %self = %$self;
	print '... process_file::start'."\n";
	print '... ... a_file='.$a_file."\n";
	my $abs_path = realpath($a_file);
	print '... ... abs_path='.$abs_path."\n";
	if (ref($self->{'config'}) ne 'Gitshapostconfig')
	{
		# unexpected.  Need a reference to a Gitshapostconfig stored under
		# the config attribute of this Gitshapost object.
		return -1; # @todo - consider throwing an exception here etc.
	}
	my $loc_base = $self->{'config'}->{'local_base'};
	print '... ... loc_base='.$loc_base."\n";
	my $pos = index $abs_path, $loc_base;
	if ($pos == -1)
	{
		# unexpected.  The local_base in the Gitshapostconfig object might
		# not be set properly.
	}
	my $len_loc_base = length $loc_base;
	my $relative_part_start = $pos + $len_loc_base;
	my $relative_part = substr $abs_path, $relative_part_start;
	print '... ... relative_part='.$relative_part."\n";
	# Trying to avoid long variable names in the following fragment.
	# See p. 99,100 Diary #7
	#	W stands for config.checked_website - the website to check
	#	L stands for config.utility_location - the url with respect to checked_website that serves to check code.
	#	P stands for config.utility_page - the page itself to checked deployed files against repo.
	#	G stands for config.utility_get - the get parameter used.
	my $W = $self->{'config'}->{'checked_website'};
	my $L = $self->{'config'}->{'utility_location'};
	my $P = $self->{'config'}->{'utility_page'};
	my $G = $self->{'config'}->{'utility_get'};
	my $url_for_check = $W.$L.'/'.$P.'?'.$G.'='.$relative_part;
	my $xml_remote_file = $self->xml_poll($url_for_check);
	print '... ... url_for_check='.$url_for_check."\n";
	return $xml_remote_file;
	print '... process_file::end'."\n";
}

# The config for a gitshapost object is represented by
# a Gitshapostconfig object.  Simple.
sub get_config {
	my ($self) = @_;
	print '... get_config::start'."\n";
	
	print '... get_config::end'."\n";
	return $self->{'config'};
}

sub set_config {
	my ($self, $new_config) = @_;
	print '... set_config::start'."\n";
	if (ref($new_config) eq 'Gitshapostconfig')
	{
		$self->{'config'} = $new_config;
	}
	else
	{
		print '... ... new_config is not a blessed Gitshapostconfig object'."\n";
	}
	print '... set_config::end'."\n";
}

# This method does a network call, to retrieve git sha information, on a requested page
# within a monitored website.
sub xml_poll {
	my ($self, $polled_url) = @_;
	print '... xmlpoll::start'."\n";
	my $mech = WWW::Mechanize->new(autocheck=>1);
	$mech->get($polled_url);
	my $content = $mech->content;
	my $len_content = length $content;
	print 'len_content='.$len_content."\n";
	my $post_enc;
	if (utf8::is_utf8($content))
	{
		print '... content is utf8 encoded'."\n";
		$post_enc = Encode::encode_utf8($content);
	}
	else
	{
		print '... content is not utf8 encoded'."\n";
		$post_enc = $content;
	}
	print '... xmlpoll::end'."\n";
	return $post_enc;
}

# This method overloads a Gitshapostconfig object when it is used in
# a string.

sub gitshapoststring {
	my ($self) = @_;
	my $ret_string = '<ret_string>'."\n";

	my $name_of_object = $self->{'name_of_object'};
	$ret_string .= 'name_of_object='.$name_of_object."\n";

	if (ref($self->{'config'}) ne 'Gitshapostconfig')
	{
		$ret_string .= 'config=NOT_A_GITSHAPOSTCONFIG'."\n";
	}
	else
	{
		# my $local_base = $self->{'config'}->{'local_base'};
		# $ret_string .= 'config->local_base='.$local_base."\n";
		## IMPT: The above is prone to sync errors if Gitshapostconfig
		## objects should change.

		# The following should allow the string overload for Gitshapostconfig
		# to be called.
		print $self->{'config'};
	}
	# IMPT: The remainder of this method will probably
	# be removed, from HERE to ...HEREHERE
	if (0 == 1)
	{
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
	# ...HEREHERE
	}

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
