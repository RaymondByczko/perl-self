# @file test_prototype01.pl
# @location perl-self/sandbox_20161220/
# @company self
# @author Raymond Byczko
#
# @purpose To explore the use of prototypes.
# @reference Programming Perl (Wall, Christiansen, Schwartz), p. 118
# @reference Modern Perl (Location 5524 of 6621) Prototypes section

use strict;
# Lets test how we can get the perl parser to make a perl array actual
# argument into a reference, for the first argument, rather than
# flattening the array.  In theory, flattening the array should
# not happen.  Accordingly, $second_param and $third_param should be
# something like null or undefined or something like that.
# @test_result $second_param, $third_param are both not defined as
# predicted.
sub printall_array_prototype (\@);

# @note If '\@' is not supplied in the actual sub definition, then
# a warning message is shown when this file is checked with:
# perl -c test_prototype01.pl
# The warning message is something like:
#	Prototype mismatch: sub main::printall_array_prototype (\@) vs 
#	none at test_prototype01.pl line 50.
sub printall_array_prototype (\@)   {
	my ($ref_array, $second_param, $third_param) = @_;
	print 'printall_array_prototype:start'."\n";
	my @the_array = @$ref_array;
	foreach my $one_element (@the_array) {
		print '... element='.$one_element."\n";
	}
	print '... second_param='.$second_param."\n";
	if (defined($second_param)) {
		print '... second_param is defined'."\n";
	}
	else
	{
		print '... second_param is not defined'."\n";
	}
	print '... third_param='.$third_param."\n";
	if (defined($third_param)) {
		print '... third_param is defined'."\n";
	}
	else
	{
		print '... third_param is not defined'."\n";
	}
	print 'printall_array_prototype:end'."\n";
}

# This is an example of a printall_array function but
# it has no prototype.  Accordingly, $second_param
# and $third_param should be set.  Lets see!
# @test_result Array flattening is happening! The 1st, 2nd,
# and 3rd parameters are all set! (as expected).
sub printall_array_noprototype  {
	my ($ref_array, $second_param, $third_param) = @_;
	print 'printall_array_noprototype:start'."\n";
	# EXECUTION ERROR: $ref_array is not an array reference.
	# The assignment to @the_array cannot be done.
	# This implies $second_param and $third_param are defined.
	my @the_array = @$ref_array;
	foreach my $one_element (@the_array) {
		print '... element='.$one_element."\n";
	}
	print '... second_param='.$second_param."\n";
	if (defined($second_param)) {
		print '... second_param is defined'."\n";
	}
	else
	{
		print '... second_param is not defined'."\n";
	}
	print '... third_param='.$third_param."\n";
	if (defined($third_param)) {
		print '... third_param is defined'."\n";
	}
	else
	{
		print '... third_param is not defined'."\n";
	}
	print 'printall_array_noprototype:end'."\n";
}

my @fruit_array = ('apple', 'banana', 'stawberry');

printall_array_prototype(@fruit_array);
print "\n"."\n";
printall_array_noprototype(@fruit_array);
