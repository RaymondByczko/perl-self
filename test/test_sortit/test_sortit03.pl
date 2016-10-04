# @author Raymond Byczko
# @file test_sortit03.pl
# @location perl-self/test/test_sortit/
# @purpose To provide a perl test harness for class Sortit and test shellsort.
# @start_date 2016-10-04 October 4, 2016

use strict;
use Data::Dumper;
require Sortit;

print 'test_sortit03.pl::start'."\n";
# These are the numbers 1 through 21 unsorted.
my @unsortedInts = (9,8,7,1,2,3,5,4,6, 21, 20, 18,19, 17, 16, 14, 15, 10, 11, 12, 13);

print '... pre shellsort'."\n";
print Dumper(\@unsortedInts);

my $objName = "My Perl Object";
my $objSI = new Sortit($objName);

$objSI->shellsort(\@unsortedInts);

print '... post shellsort'."\n";
print Dumper(\@unsortedInts);

print 'test_sortit03.pl::end'."\n";
