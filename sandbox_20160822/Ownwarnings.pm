# @file Ownwarnings.pm
# @author Raymond Byczko
# @company self
# @start_date 2016-08-22 August 22, 2016
# @purpose Testing the registration of one's own warnings.
# @endpurpose
# @reference See p. (191 of 278) in moder-perl-fourth-editioni_p1_0.pdf

package Ownwarnings;
use warnings::register;

sub own_sub_check_enabled_2 {
	my ($first_arg) = @_;
	print 'start:own_sub_check_enabled_2'."\n";
	print '...first_arg='.$first_arg."\n";
	if (warnings::enabled() && ($first_arg == 2))
	{
		warnings::warn('...WARN:The first arg is 2');
	}
	print 'end:own_sub_check_enabled_2'."\n";
}

sub own_sub_no_check_enabled_4 {
	my ($first_arg) = @_;
	print 'start:own_sub_no_check_enabled_4'."\n";
	print '... first_arg='.$first_arg."\n";
	if ($first_arg == 4)
	{
		warnings::warn('...WARN:The first arg is 4');
	}
	print 'end:own_sub_no_check_enabled_4'."\n";
}
1;
