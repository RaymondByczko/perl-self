# @author Raymond Byczko
# @file test_gitshapostconfig01.pl
# @location perl-self/test/test_gitshapostconfig/
# @purpose To provide a test for the Gitshapostconfig perl class.
# @start_date 2016-10-15 October 15, 2016

use strict;
require Gitshapostconfig;

print 'test_gitshapostconfig01.pl:start'."\n";
my $nameObj = 'name:test_gitshapostconfig01';
my $objGS = new Gitshapostconfig($nameObj);

print 'Here is the string of objGS (pre read):'."\n";
print $objGS;
print "\n";

my $aConfigFile = './sampleconfig.cfg';
my $ret_read = $objGS->read($aConfigFile);

print 'Here is the string of objGS (post read):'."\n";
print $objGS;
print "\n";
print 'test_gitshapostconfig01.pl:end'."\n";
