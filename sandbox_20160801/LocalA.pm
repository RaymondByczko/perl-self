package LocalA;
use strict;
# Remove the LocalA from LocalA::A and see what happens (errors).
# use vars $a;
$LocalA::aa = 'aa_lvalue';
sub do_something {
	print 'do_something: start'."\n";
	local $LocalA::aa = $LocalA::aa;
	my $valueA = $LocalA::aa;
	print '... valueA='.$valueA."\n";
	print '... ... aa='.$LocalA::aa."\n";
	print '... changing aa'."\n";
	$LocalA::aa = 'aa_lvalue_changed';
	print '... ... aa='.$LocalA::aa."\n";
	print 'do_something: end'."\n";
}
sub do_something_else {
	print 'do_something_else: start'."\n";
	print '... ....aa='.$LocalA::aa."\n";
	print 'do_something_else: end'."\n";
}
1;
