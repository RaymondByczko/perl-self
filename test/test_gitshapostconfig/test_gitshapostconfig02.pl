# @author Raymond Byczko
# @file test_gitshapostconfig02.pl
# @location perl-self/test/test_gitshapostconfig/
# @purpose To provide a test for the Gitshapostconfig perl class.
# @start_date 2016-11-17 November 17, 2016

use strict;
require Gitshapostconfig;

print 'test_gitshapostconfig02.pl:start'."\n";
my $nameObj = 'name:test_gitshapostconfig02';
my $objGS = new Gitshapostconfig($nameObj);

print 'Here is the string of objGS (pre read):'."\n";
print $objGS;
print "\n";

my $aConfigFile = './sampleconfig02.cfg';
my $ret_read = $objGS->read($aConfigFile);

print 'Here is the string of objGS (post read):'."\n";
print $objGS;
print "\n";
print 'test_gitshapostconfig02.pl:end'."\n";
