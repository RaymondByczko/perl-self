use strict;
my $bar;
# $bar = 1;
my $foo;
*foo = \$bar;
$bar = 1;
print 'variables outside brackets (before)'."\n";
print '... bar='.$bar."\n";
print '... foo='.$foo."\n";
{
	# local $main::bar = 2;
	local $bar = 2;
	print 'variables inside brackets'."\n";
	print '... bar='.$bar."\n";
	print '... foo='.$foo."\n";
}
print 'variables outside brackets (after)'."\n";
print '... bar='.$bar."\n";
print '... foo='.$foo."\n";
