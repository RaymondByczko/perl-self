# @author Raymond Byczko
# @file test_sortit01.pl
# @location perl-self/test/test_sortit/
# @purpose To provide a perl test harness for class Sortit and test quicksort.
# @start_date 2016-10-03 October 21, 2016

use strict;
use Data::Dumper;
require Sortit;

print 'test_sortit01.pl::start'."\n";
# These are the numbers 1 through 9 unsorted.
my @unsortedInts = (9,8,7,1,2,3,5,4,6);

print '... pre quicksort'."\n";
print Dumper(\@unsortedInts);

my $objName = "My Perl Object";
my $objSI = new Sortit($objName);

# @note Specify zero (0) based indexes for quicksort method.

## $objSI->quicksort(\@unsortedInts, 1, 9);
$objSI->quicksort(\@unsortedInts, 0, 8);

print '... post quicksort'."\n";
print Dumper(\@unsortedInts);

print 'test_sortit01.pl::end'."\n";
