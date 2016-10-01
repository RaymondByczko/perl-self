use strict;
my $bar;
*foo = *bar;
$bar = 1;
print 'variables outside brackets (before)'."\n";
print '... bar='.$bar."\n";
print '... foo='.$foo."\n";
{
	local $bar = 2;
	print 'variables inside brackets'."\n";
	print '... bar='.$bar."\n";
	print '... foo='.$foo."\n";
}
print 'variables outside brackets (after)'."\n";
print '... bar='.$bar."\n";
print '... foo='.$foo."\n";
