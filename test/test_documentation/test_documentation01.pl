# @author Raymond Byczko
# @file test_documentation01.pl
# @location perl-self/test_documentation/
# @purpose To provide a perl test harness for testing the
# documentation class.
# @start_date 2016-08-21 August 21, 2016
# @status Working as of August 22, 2016

use strict;
use Documentation;


my $objDoc = new Documentation();

my $start_attribute1 = "\@author";
my $end_attribute1 = '';
my $max_lines1 = 1;
$objDoc->add_attribute($start_attribute1, $end_attribute1, $max_lines1);

my $start_attribute2 = "\@file";
my $end_attribute2 = '';
my $max_lines2 = 1;
$objDoc->add_attribute($start_attribute2, $end_attribute2, $max_lines2);

my $pathName = "./somefile.pl";
$objDoc->extract($pathName);
my @att = $objDoc->get_attributes();
foreach my $one_att (@att) {
	print 'one_att:'.$one_att."\n";
}
