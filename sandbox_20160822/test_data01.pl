# @file test_data01.pl
# @author Raymond Byczko
# @company self
# @start_date 2016-08-22 August 22, 2016
# @purpose Testing the concept of DATA filehandle and __DATA__
# section. @endpurpose
# @reference See p. (193 of 278) in moder-perl-fourth-editioni_p1_0.pdf

use strict;
while (<DATA>) {
	chop;
	my $line = $_;
	print 'The line is:'.$line."\n";
}
close(DATA);
__DATA__
Line number 1
Line number 2
Line number 3
