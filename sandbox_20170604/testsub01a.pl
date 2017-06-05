# @file testsub01a.pl
# @location perl-self/sandbox_20170604/
# @company self
# @author Raymond Byczko
# @start_date 2017-06-04 June 4, 2017
# @purpose To try writing a subroutine for practice.

use strict;

my $i;
my $j;

sub mysumnow {
	my ($x,$y) = @_;
	my $thesum = $x + $y;
	return $thesum;
}

$i = 11;
$j = 12;

my $a_sum;
$a_sum = mysumnow($i, $j);

print 'a_sum='.$a_sum."\n";
