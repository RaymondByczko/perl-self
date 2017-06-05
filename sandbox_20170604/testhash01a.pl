# @file testhash01a.pl
# @location perl-self/sandbox_20170604/
# @company self
# @author Raymond Byczko
# @start_date 2017-06-04 June 4, 2017
# @purpose To experiment with hashes.
# @output h_great_people=2/8
# @note Evaluate a hash variable in scalar context returns a string
# indicative of the number of used buckets and the number of allocated
# buckets, seperated by a slash.  See p. 51, Programming Perl by Wall,
# Christiansen, and Schwartz.

use strict;
my %great_people = ();
$great_people{darwin} = 'Discovered evolution';
$great_people{einstein} = 'Its all relativity';

my $h_great_people = %great_people;
print 'h_great_people='.$h_great_people."\n";
