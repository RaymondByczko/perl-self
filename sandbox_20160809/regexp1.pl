# @file regexp1.pl
# @author Raymond Byczko
# @company self
# @start_date 2016-08-09 August 9, 2016

use strict;
print 'START: regexp1.pl'."\n";
my $res_hw = "Hello World" =~ /World/;
print 'The following should be 1:'."\n";
print '... res_hw='.$res_hw."\n";


my $res_hp = "Hello World" =~ /Planet/;
print 'The following should be 0:'."\n";
print '... res_hp='.$res_hp."\n";
if ($res_hp == undef )
{
	print 'res_hp is undefined.'."\n";
}
else
{
	print 'res_hp is not undefined.'."\n";
}

my $res_not_hp = "Hello World" !~ /Planet/;
print 'The following should be 1:'."\n";
print '... res_not_hp='.$res_not_hp."\n";

my $srcline = 'author Raymond Byczko';
if ($srcline =~ m!author!)
{
	print '... author was found using different delimiters'."\n";
}
else
{
	print '... author was not found using different delimiters'."\n";
}
print 'END: regexp1.pl'."\n";
