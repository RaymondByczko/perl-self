# @file test_prototype03.pl
# @location perl-self/sandbox_20161220/
# @company self
# @author Raymond Byczko
# @start_date 2016-12-22
#
# @purpose To explore the use of prototypes and the difference
# between handing a prototyped sub a) an array b) a reference
# to an array c) a reference to an array that is dereferenced
# as an array.

# @reference Programming Perl (Wall, Christiansen, Schwartz), p. 118 (Prototypes)
# @reference Programming Perl (Wall, Christiansen, Schwartz), p. 204 (ref)
# @reference Modern Perl (Location 5524 of 6621) Prototypes section
# @reference Diary #7, p. 134,5
#
# @test_result Calling the prototype with an array works fine (case a).
# Calling the prototype with a reference to an array generates a
# compile error (case b).  Calling the prototype with a dereferenced array reference
# works fine (case c).
#
# @note Interesting how Perl 5 case b fails.  Just can't convert that
# array reference.  Wonder why?

use strict;
sub house_array_prototype (\@);

# This sub does not do anything special.  It just
# prints out some analysis on the 'extra' parameter
# which is param_2.  And then it prints out each
# element in the house array.
#
# I call it 'house' because I am trying to avoid
# extremely vanilla examples and add a little
# variety to it.  Why not?
sub house_array_prototype (\@)   {
	my ($ref_array, $param_2) = @_;
	print 'house_array_prototype:start'."\n";

	if (not ref $param_2)
	{
		print '... param_2 is not a ref'."\n";
	}
	else
	{
		print "... param_2 is a: ".ref($param_2)."\n";
	}
	if (defined($param_2)) {
		print '... param_2 is defined'."\n";
	}
	else
	{
		print '... param_2 is not defined'."\n";
	}
	my @the_array = @$ref_array;
	foreach my $house_element (@the_array) {
		print '... house='.$house_element."\n";
	}
	print 'house_array_prototype:end'."\n";
}

my @house_array = ('brick', 'wood', 'log');


print "Deliver house_array as expected (case a)"."\n";
print "(The prototype will convert to array ref.)"."\n";
house_array_prototype (@house_array);
print "\n"."\n";
print "Deliver house_array as a reference (case b)"."\n";
print "(If the perl interpreter is smart, it will not try to double"."\n";
print "convert and mess things up.)"."\n";
my $ra_buildings = ['treehouse', 'shed', 'singleunit'];
# The following compilation error is generated due to COMP_ERROR_CAUSE
# raymond@raymond-desktop:~/RByczko007_Perl/perl-self/sandbox_20161220$ perl -c test_prototype03.pl
# Type of arg 1 to main::house_array_prototype must be array (not private variable) at test_prototype03.pl line 77, near "$ra_buildings)"
# test_prototype03.pl had compilation errors.
### @COMP_ERROR_CAUSE (start)
# house_array_prototype ($ra_buildings);
### @COMP_ERROR_CAUSE (end)
# @conclusion You cannot build your own reference to some array and give it to a sub that
# is prototyped to expect an array itself.  It wants to do the conversion itself. OK.
# @conclusion_end
print "\n"."\n";
print "Now try to dereference the reference properly, and supply the result (case c)"."\n";
my @a_buildings = @$ra_buildings;
house_array_prototype (@a_buildings);
