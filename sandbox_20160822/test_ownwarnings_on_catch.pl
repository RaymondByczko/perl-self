# @file test_ownwarnings_on_catch.pl
# @author Raymond Byczko
# @company self
# @start_date 2016-08-22 August 22, 2016
# @purpose Testing the registration of one's own warnings
# with client code using 'use warnings' (on).  However, an attempt
# is made to catch these warnings.
# @endpurpose
# @reference See p. (191 of 278) in modern-perl-fourth-edition_p1_0.pdf
# @reference See p. (190 of 278) in modern-perl-fourth_edition_p1_0.pdf
# for catching warnings.

use Ownwarnings;
use warnings 'Ownwarnings';

Ownwarnings::own_sub_check_enabled_2(2);
Ownwarnings::own_sub_check_enabled_2(3);


{
# my $warning;
local $SIG{__WARN__} = sub {
	my ($warning) = @_;
	print 'WARNING CAUGHT'."\n";
	print '... caught this:'.$warning."\n";
};
Ownwarnings::own_sub_no_check_enabled_4(4);
Ownwarnings::own_sub_no_check_enabled_4(5);
}
