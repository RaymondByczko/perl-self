
# @file test_my02.pl
# @company self
# @author Raymond Byczko
# @location perl-self/sandbox_20160824/
# @start_date 2016-08-24 August 24, 2016
# @purpose To test how the introduction of a my declared variable
# at an outer file scope can be seen in subroutines, and seen
# in subroutines called by that one.  These subroutines are defined
# in their own lexical scope (delimited by curly brackets).  In
# test_my01.pl they were declared at outer file scope.
# @conclusion x is see from top down through call stack.
use strict;
my $x = 99;
{
	sub get_smart {
		print 'get_smart:start'."\n";
		print '... x='.$x."\n";
		hi_agent_99();
		print 'get_smart:end'."\n";
	}

	sub hi_agent_99 {
		print 'hi_agent:start'."\n";
		print '... x='.$x."\n";
		print 'hi_agent:end'."\n";
	}

	get_smart();
}
