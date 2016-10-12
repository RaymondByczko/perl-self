# @author Raymond Byczko
# @file Diffdiff.pm
# @location perl-self/lib
# @purpose To provide a perl class for doing different types of diffs.
# This diff provides for ignoring one or more zones in each file.
# Each zone is comprised of line(s) that are assumed to be different, but 
# we don't care about those zone areas.  A user of Diffdiff wants to focus
# on the area outside of the zones.
# @start_date 2016-10-09 October 09, 2016
# @change_history 2016-10-09 October 9, 2016, Started this file.
# See p. 94, Diary #7.


package Diffdiff;
use overload '""' =>"diffdiffstring";
use File::Copy;
use File::Basename;
# use Shell qw(diff date);
use Text::Diff;

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
	my ($class, $nameOfObject, $refArrayZone, $commentSymbol) = @_;
	my $new_obj = {
		"name_of_object"=>$nameOfObject,
		"file1"=>'',
		"file2"=>'',
		"zone" =>$refArrayZone,
		"comment_symbol" =>$commentSymbol,
		"tmp_area" => "/tmp",
		"std_comment" => "Diffdiff.pm comment inserted"
	};
	my $self = bless $new_obj, $class;
	return $self;
}

# @purpose To implement an add zone operation.  Every zone has
# a start and end value.  Inclusive of this zone is implied
# an area which will not be diffed.
#
sub add_zone {
	my ($self, $new_zone) = @_;
	my %self = %$self;
	print '... add_zone::start'."\n";
	my $zone_start = $new_zone->[0];
	my $zone_end = $new_zone->[1];

	print '... ... zone_start='.$zone_start."\n";
	print '... ... zone_end='.$zone_end."\n";

	push $self->{'zone'}, $new_zone;

	print '... add_zone::end'."\n";
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

# Set the files to diff using this method.  This file does
# not do the diff operation itself.  It merely sets which
# files to use.
sub files {
	my ($self, $file1, $file2) = @_;
	$self->{'file1'} = $file1;
	$self->{'file2'} = $file2;
}

# Since Diffdiff could be used on a variety of programming language
# files, the comment symbol can be associated and set for a Diffdiff
# object. Why?
#
# Each zone to be ignored in the source diff files is replaced by
# an equal sized set of lines, each line of which is a comment.
#
# So, therefore, when a diff is done, line numbers are preserved between
# unchanged source files and those prepared for diff.
sub comment_symbol {
	my ($self) = @_;
	return $self->{'comment_symbol'};
}

sub set_comment_symbol {
	my ($self, $new_comment_symbol) = @_;
	$self->{'comment_symbol'} = $new_comment_symbol;
}

# This method overloads a Diffdiff object when it is used in
# a string.
sub diffdiffstring {
	my ($self) = @_;
	my $ret_string = '<ret_string>'."\n";

	my $name_of_object = $self->{'name_of_object'};
	$ret_string .= 'name_of_object='.$name_of_object."\n";

	my $file1 = $self->{'file1'};
	$ret_string .= 'file1='.$file1."\n";

	my $file2 = $self->{'file2'};
	$ret_string .= 'file2='.$file2."\n";

	my $indexZone = 0;
	foreach my $a_zone (@{$self->{'zone'}})
	{
		my $start_zone = $a_zone->[0];
		my $end_zone = $a_zone->[1];

		$ret_string .= 'zone_index='.$indexZone."\n";
		$ret_string .= 'start_zone='.$start_zone."\n";
		$ret_string .= 'end_zone='.$end_zone."\n";
		$indexZone++;
	}

	my $comment_symbol = $self->{'comment_symbol'};
	$ret_string .= 'comment_symbol='.$comment_symbol."\n";

	my $tmp_area = $self->{'tmp_area'};
	$ret_string .= 'tmp_area='.$tmp_area."\n";

	$ret_string .= '</ret_string>'."\n";
	return $ret_string;
}

# Copies the files represented by file1 and file2 to the temp location.
# It opens the copied files replacing each zone with comment blocks.
# After that, it does the diff.
sub diff {
	my ($self) = @_;
	print 'diff:start'."\n";
	my $srcFile1 = $self->{file1};
	my ($srcName1, $srcPath1, $srcSuffix1) = fileparse($srcFile1);
	print 'srcN='.$srcName1.':srcP='.$srcPath1.':srcS='.$srcSuffix1."\n";
	my $desFile1 = $self->{"tmp_area"}.$srcName1;
	# copy($srcFile1, $desFile1);

	my $srcFile2 = $self->{'file2'};
	my ($srcName2, $srcPath2, $srcSuffix2) = fileparse($srcFile2);
	my $desFile2 = $self->{"tmp_area"}.$srcName2;
	# copy($srcFile2, $desFile2);

	$self->zone_copy($srcFile1, $desFile1);
	$self->zone_copy($srcFile2, $desFile2);

	my $outDiff = diff($desFile1, $desFile2);
	# my $outDiff = 'out';
	# my $outDiff = date();
	print 'outDiff:start'."\n";
	print $outDiff;
	print "\n".'outDiff:end'."\n";
	print 'diff:end'."\n";
}

# Copies the contents of source file to destination file whereby
# certain lines in zones associated with this object are replaced with
# standard comments.
sub zone_copy {
	my ($self, $srcFile, $desFile) = @_;
	open(FHS,"<".$srcFile);
	open(FHD,">".$desFile);
	
	my $sCt = 0;
	while (<FHS>)
	{
		$sCt++;
		my $ret_in_zone;
		$ret_in_zone = $self->in_zone($sCt);
		if ($ret_in_zone == 0)
		{
			print FHD $_;
		}
		else
		{
			my $std_comment = $self->{'std_comment'};
			my $commentLine = $self->{'comment_symbol'}.$std_comment."\n";
			print FHD $commentLine;
		}
	}
	close(FHD);
	close(FHS);
}

sub in_zone {
	my ($self, $lineNum) = @_;
	foreach my $a_zone (@{$self->{'zone'}})
	{
		my $start_zone = $a_zone->[0];
		my $end_zone = $a_zone->[1];
		if (($lineNum>=$start_zone) && ($lineNum<=$end_zone))
		{
			return 1; # true
		}
	}
	return 0; # false
}

1;
