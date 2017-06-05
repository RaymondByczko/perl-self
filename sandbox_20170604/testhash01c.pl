# @file testhash01c.pl
# @location perl-self/sandbox_20170604/
# @company self
# @author Raymond Byczko
# @start_date 2017-06-04 June 4, 2017
# @purpose To see what happens to h_great_people when hash increases
# in size, especially beyond 8.
# @note The number of used buckets increases and the number of
# allocated buckets also increases.  See p. 51, Programming
# Perl by Wall, Christiansen, and Schwartz.
# @output h_great_people=7/16

use strict;
my %great_people = ();
$great_people{darwin} = 'Discovered evolution';
$great_people{einstein} = 'Its all relativity';
$great_people{curie} = 'Worked with radioactivity';
$great_people{sagan} = 'Billions and billions';
$great_people{okeefe} = 'Paintings that are great';
$great_people{mlk} = 'Equal rights';
$great_people{snoopy} = 'The one and only dog';
$great_people{cbrown} = 'The star of the peanuts';
$great_people{janegoodall} = 'Chimp lady';

my $h_great_people = %great_people;
print 'h_great_people='.$h_great_people."\n";
