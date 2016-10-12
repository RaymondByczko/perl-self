# @author Raymond Byczko
# @file test_diffdiff01.pl
# @location perl-self/test/test_diffdiff/
# @purpose To provide a test for the Diffdiff perl class.
# @start_date 2016-10-09 October 09, 2016

use strict;
require Diffdiff;

print 'test_diffdiff01.pl:start'."\n";

my $nameOfObject = "diffdiff01";
my $zone1 = [1,4];
my $zone2 = [9,11];
my $zone3 = [20,25];
my $refArrayZone = [$zone1, $zone2, $zone3];
my $commentSymbol = "#";

my $objDD = new Diffdiff($nameOfObject, $refArrayZone, $commentSymbol);
$objDD->files('./sample01a.txt', './sample01b.txt');
$objDD->set_tmp_area('/home/raymond/RByczko007_Perl/perl-self/test/test_diffdiff/tmp/');
$objDD->diff();
print 'Here is the string of objDD:'."\n";
print $objDD;
print "\n";
print 'test_diffdiff01.pl:end'."\n";
