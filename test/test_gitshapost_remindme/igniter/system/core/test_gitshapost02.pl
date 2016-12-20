# @author Raymond Byczko
# @file test_gitshapost02.pl
# @location perl-self/test/test_gitshapost_remindme/igniter/system/core/
# @purpose To provide a test for the Gitshapost perl class.  It will test from
# a directory which reflects the install location at the remindme website
# and yet still be in a test directory.
# @start_date 2016-10-21 October 21, 2016
# @change_history 2016-10-28 October 28, 2016.  Added XML processing
# @status 2016-10-29 October 29, 2016.  Basically works but needs refinement.

use strict;
require XML::Twig;
require Gitshapost;
require Gitshapostconfig;

print 'test_gitshapost02.pl:start'."\n";
my $nameGitsha = 'name:test_gitshapost02';
my $objGS = new Gitshapost($nameGitsha);

print 'Here is the string of objGS (pre read):'."\n";
print $objGS;
print "\n";

# Take care of the config file and config object.
my $nameConfig = 'name:test_gitshapostconfig01';
my $objConfig = new Gitshapostconfig($nameConfig);
my $aConfigFile = './sampleconfig.cfg';
my $ret_read = $objConfig->read($aConfigFile);

# Associate config object with Gitshapost.
$objGS->set_config($objConfig);
my $a_file = './Common.php';
my $ret_pf = $objGS->process_file($a_file);
print 'ret_pf:start'."\n";
print '...'."\n";
print $ret_pf."\n";
print '...'."\n";
print 'ret_pf:end'."\n";
# Lets do some xml processing here
my $twigObj = XML::Twig->new();
$twigObj->parse($ret_pf);
my $twigObjRoot = $twigObj->root;
my $infoabout = $twigObjRoot->first_child('infoabout');
my $gitshavalue = $twigObjRoot->first_child('gitshavalue');
print 'infoabout='.$infoabout."\n";
my @keysinfoabout = keys %$infoabout;
my @valuesinfoabout = values %$infoabout;
print 'keysinfoabout='.join(':',@keysinfoabout)."\n";
print 'valuesinfoabout='.join(':',@valuesinfoabout)."\n";
print 'infoabout->first_child='.$infoabout->{'first_child'}."\n";

my $eltInfoabout = $twigObj->first_elt('infoabout');
print 'infoabout text='.$eltInfoabout->text."\n";
### my @kfc = keys $infoabout->{'first_child'};
### print 'kfc-joined='.join(':',@kfc)."\n";
print 'gitshavalue='.$gitshavalue."\n";
# End of xml processing
print 'Here is the string of objGS (post read):'."\n";
print $objGS;
print "\n";
print 'test_gitshapost02.pl:end'."\n";
