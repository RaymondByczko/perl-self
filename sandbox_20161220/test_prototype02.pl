# @file test_prototype02.pl
# @location perl-self/sandbox_20161220/
# @company self
# @author Raymond Byczko
# @start_date 2016-12-22
#
# @purpose To explore the use of prototypes and how they are called
# the old fashioned and new fashioned ways.
# @reference Programming Perl (Wall, Christiansen, Schwartz), p. 118 (Prototypes)
# @reference Programming Perl (Wall, Christiansen, Schwartz), p. 204 (ref)
# @reference Modern Perl (Location 5524 of 6621) Prototypes section
# @reference Diary #7, p. 134,5
#
# @test_result Calling the prototype the new way insures the array is not
# flattened, and we see it as a) an ARRAY ref and b) as defined.  Because of
# this, the rest of the parameters are a) not a ref and b) not defined.  Logical.
#
# On the other hand, calling the prototype the old way (with the call preceeded
# by &) indicates that the array is flattened.  Each parameter (param_1 to param_3)
# is not a reference but it is defined.
#
# @note Interesting how Perl 5 has this duality in flattening (or not) an array.

use strict;
sub array_new_style_prototype (\@);

# This sub does not do anything special.  It just
# determines whether or not the first three supplied
# parameters are a ref or not, and if a ref, what kind.
# Further, it determines whether each parameter is
# defined or not.
sub array_new_style_prototype (\@)   {
	my ($param_1, $param_2, $param_3) = @_;
	print 'array_new_style_prototype:start'."\n";

	if (not ref $param_1)
	{
		print '... param_1 is not a ref'."\n";
	}
	else
	{
		print "... param_1 is a: ".ref($param_1)."\n";
	}
	if (defined($param_1)) {
		print '... param_1 is defined'."\n";
	}
	else
	{
		print '... param_1 is not defined'."\n";
	}
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
	if (not ref $param_3)
	{
		print '... param_3 is not a ref'."\n";
	}
	else
	{
		print "... param_3 is a: ".ref($param_3)."\n";
	}
	if (defined($param_3)) {
		print '... param_3 is defined'."\n";
	}
	else
	{
		print '... param_3 is not defined'."\n";
	}

	print 'array_newstyle_prototype:end'."\n";
}

my @colar_array = ('red', 'green', 'yellow');


print "Call new style-prototype should be in effect"."\n";
array_new_style_prototype (@colar_array);
print "\n"."\n";
print "Call old style-prototype should be in effect"."\n";
&array_new_style_prototype (@colar_array);
