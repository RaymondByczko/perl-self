# @author Raymond Byczko
# @file documentation.pm
# @location perl-self/lib
# @purpose To provide a perl class for processing documentation.
# @start_date 2016-08-21 August 21, 2016
# @change_history 2016-08-23 August 23, 2016, Started process attribute
# documentation.

package Documentation;

# @comment A note about attributes.  These are used to denote documentation in source
# files.  As such they can be picked up by documentation parsers, like this one
# for example.  This is inspired by PHPDoc.
#
# Attributes can exist as either single entities like @author, or @start_date, or they
# can exist as pairs, like @comment,@endcomment.  Single entity attributes exist on one line
# while pairs can exist on one or more lines.
use strict;
require Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw();
our @EXPORT_OK = qw();


sub new {
	my ($class) = @_;
	my $attributes_href = {};
	my $short_names_href = {};
	my $new_obj = {
		"attributes"=>$attributes_href,
		"short_name"=>$short_names_href
	};
	my $self = bless $new_obj, $class;
	return $self;
}

# This adds an attribute to the documentation system.
# For example it can add:
#	@author
#
# In this case, there is no end attribute.  There is no @endauthor for
# example.
# Another example is something like the following:
# 	@comment
#	@endcomment
#
# In this case the comment is between the two attributes, @comment
# and @endcomment.  This can imply multi-line comments.
sub add_attribute {
	my ($self, $start_attribute, $end_attribute, $max_lines) = @_;
	my %selfh = %$self;
	my $new_attribute = {
		start=>$start_attribute,
		end=>$end_attribute,
		max_lines=>$max_lines
	};
	$self->{attributes}->{$start_attribute} = $new_attribute;
}

# Extracts from the file indicating the documenation found in
# that file, per the attributes already added via add_attribute.
sub extract {
	my ($self, $path_name) = @_;
	print 'extract:start'."\n";
	unless (open(FILE_H,'<'.$path_name)) {
		die 'Unable to open '.$path_name."\n";
	}
	while (<FILE_H>) { 
		my $current_line = $_;	
		print 'current_line='.$current_line."\n";
	}
	close(FILE_H);
	
}

# Gets the valid attributes for this Documentation object.
# It basically gets the keys for each attribute.  This represents
# the start_attribute for each attribute.
sub get_attributes {
	my ($self) = @_;
	my @attribute_start = keys $self->{attributes};
	my $attr_all = join ':', @attribute_start;
	# print 'All attribute_start are:'.@attribute_start."\n";
	print 'All attribute_start are:'.$attr_all."\n";
	return @attribute_start;
}

# This sub assigns the case short name to each attribute
# depending on the values of the start_attribute, end_attribute,
# and max_lines.
sub assign_short_name {
	my ($self) = @_;
	my @attribute_starts = keys $self->{attributes};
	foreach my $attr (@attribute_starts) {
		my $start_attribute = $self->{attributes}->{$attr}->{start};
		my $end_attribute = $self->{attributes}->{$attr}->{end};
		my $max_lines = $self->{attributes}->{$attr}->{max_lines};
		if (($start_attribute ne "") && ($end_attribute eq "") && ($max_lines == 1))
		{
			$self->{short_name}->{$attr} = 'START_ONLY'; 
			next;
		}
		if (($start_attribute ne "") && ($end_attribute ne "") && ($max_lines == 1))
		{
			$self->{short_name}->{$attr} = 'START_END_ONE_LINE'; 
			next;
		}
		if (($start_attribute ne "") && ($end_attribute ne "") && ($max_lines > 1))
		{
			$self->{short_name}->{$attr} = 'START_END_MULTI_LINE'; 
			next;
		}
	}
}

# process each attribute, given a line
#
#

# start_attribute!="", end_attribute=="", max_lines==1
# ---------------------------------------------------- 
# case short name: START_ONLY
# valid states: NOT_ENCOUNTERED, ENCOUNTERED_START
#
# start_attribute!="", end_attribute!="", max_lines==1
# ---------------------------------------------------- 
# case short name: START_END_ONE_LINE
# valid states: NOT_ENCOUNTERED, ENCOUNTERED_START,
# ENCOUNTERED_END, ENCOUNTERED_START_END
#
# start_attribute!="", end_attribute!="", max_lines>1
# ---------------------------------------------------- 
# case short name: START_END_MULTI_LINE
# valid states: NOT_ENCOUNTERED, ENCOUNTERED_START,
# ENCOUNTERED_END
#

# ... start_attribute!="", end_attribute=="", max_lines==1
#
# get attribute
# ... get start_attribute
# ... get end_attribute
# ... get max_lines
#
# ... get case short name
# ... if short name == START_ONLY then
# ... {
#		if state[attribute] == NOT_ENCOUNTERED then
#		{
#			do regexp with start_attribute
#			if start_attribute encountered
#			{
#				state[attribute] = ENCOUNTERED_START
#				return
#			}
#		}
#		if state[attribute] == ENCOUNTERED_START then
#		{
#			state[attribute] = NOT_ENCOUNTERED
#			return
#		}
# ... }
# ... if short name == START_END_ONE_LINE then
# ... {
#		if state[attribute] == NOT_ENCOUNTERED then
#		{
#			do regexp with start_attribute,end_attribute
#			if start_attribute,end_attribute encountered
#			{
#				state[attribute] = ENCOUNTERED_START_END 
#				record state[attribute]
#				state[attribute] = NOT_ECOUNTERED
#				record state[attribute]
#			}
#			return
#		}
#		if state[attribute] = ENCOUNTERED_START_END
#		{
#			do regexp with start_attribute,end_attribute
#			if start_attribute,end_attribute encountered
#			{
#				state[attribute] = ENCOUNTERED_START_END 
#				record state[attribute]
#				state[attribute] = NOT_ECOUNTERED
#				record state[attribute]
#			}
#			return
#		}
# ... }
# ... if short name == START_END_MULTI_LINE then
# ... {
# ... }
#
# ... if state[attribute] == 
# ... start_attribute!="", end_attribute=="", max_lines==1

1;
