# @file test_my03.pl
# @company self
# @author Raymond Byczko
# @location perl-self/sandbox_20160824/
# @purpose To test how the introduction of nested lexical?? scopes
# will impact the value of variables declared with my.
# @observation  As long as x is declared with my, then the ones in previous
# upper scopes will be preserved.
use strict;
my $x = 10;
print 'outer:x='.$x."\n";
{
	my $x = 20;
	print '... inner:x='.$x."\n";
	{
		my $x = 30;
		print '... ... innerX2:x='.$x."\n";
		{
			my $x = 40;
			print '... ... ... innerX3:x='.$x."\n";
		}
		print '... ... innerX2:x='.$x."\n";
	}
	print '... inner:x='.$x."\n";
}
print 'outer:x='.$x."\n";
