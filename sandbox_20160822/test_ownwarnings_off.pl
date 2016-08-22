# @file test_ownwarnings_off.pl
# @author Raymond Byczko
# @company self
# @start_date 2016-08-22 August 22, 2016
# @purpose Testing the registration of one's own warnings
# with client code using 'no warnings' (off)
# @endpurpose
# @reference See p. (191 of 278) in modern-perl-fourth-edition_p1_0.pdf
use Ownwarnings;
no warnings 'Ownwarnings';

Ownwarnings::own_sub_check_enabled_2(2);
Ownwarnings::own_sub_no_check_enabled_4(3);

