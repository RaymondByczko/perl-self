# @file testhash01b.pl
# @location perl-self/sandbox_20170604/
# @company self
# @author Raymond Byczko
# @start_date 2017-06-04 June 4, 2017
# @purpose To see what happens to h_great_people when hash increases
# in size.
# @note The number of used buckets increases and the number of
# allocated buckets remains constant.  See p. 51, Programming
# Perl by Wall, Christiansen, and Schwartz.
# @output h_great_people=3/8

use strict;
my %great_people = ();
$great_people{darwin} = 'Discovered evolution';
$great_people{einstein} = 'Its all relativity';
$great_people{curie} = 'Worked with radioactivity';

my $h_great_people = %great_people;
print 'h_great_people='.$h_great_people."\n";
