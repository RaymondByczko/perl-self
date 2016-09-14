# @file test_warn01.pl
# @location perl-self/sandbox_20160824/
# @company self
# @author Raymond Byczko
# @start_date 2016-08-27 August 27, 2016
# @purpose To test what warn does.
# @note This file is identical to test_carp01.pl except it uses
# warn.
# @note Run test_carp01.pl and then test_warn01.pl and compare.
# @note test_carp01.pl and test_war01.pl are a related pair.


use strict;
use Carp;

sub do_a_positive {
	my ($a,$b) = @_;	
	print '... start: do_a_positive'."\n";
	print '... a='.$a."\n";
	print '... b='.$b."\n";
	if ($a < 0)
	{
		carp '... a is not positive'."\n";	
	}
	do_b_negative($b);
	print '... end: do_a_positive'."\n";
}

sub do_b_negative {
	my ($b) = @_;	
	print '... ... start: do_b_negative'."\n";
	print '... ... b='.$b."\n";
	if ($b >= 0)
	{
		warn 'b is not negative'."\n";	
	}
	print '... ... end: do_b_negative'."\n";
}

sub d_a_pos_b_pos {
	print 'start: d_a_pos_b_pos'."\n";
	do_a_positive(2,3);
	print 'end: d_a_pos_b_pos'."\n";
}

d_a_pos_b_pos();
