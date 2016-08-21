# @author Raymond Byczko
# @file documentation.pm
# @location perl-self/lib
# @purpose To provide a perl class for processing documentation.
# @start_date 2016-08-21 August 21, 2016

package documentation;

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
	my $attributes = {};
	my $new_obj = {
		attributes=>$attributes
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
	$self->attributes->$start_attribute = $new_attribute;
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

1;
