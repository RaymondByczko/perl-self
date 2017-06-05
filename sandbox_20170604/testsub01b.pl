# @file testsub01b.pl
# @location perl-self/sandbox_20170604/
# @company self
# @author Raymond Byczko
# @start_date 2017-06-04 June 4, 2017
# @purpose To see what happens a hash is given
# to a sub that treats it like a list.
# @conclusion The arg to printouthash loses its identity.

use strict;

sub printouthash {
	my $firstthing = shift(@_);
	print '... firstthing='.$firstthing."\n";
	my $nextthing;
	foreach $nextthing (@_) {	
		print '... nextthing='.$nextthing."\n";
	}
	return 'done'; 
}

my %a_hash = (
	'lemon'=>'yellow',
	'apple'=>'red',
	'eggplant'=>'purple'
);

my $ret_print = printouthash(%a_hash);

print 'ret_print='.$ret_print."\n";
