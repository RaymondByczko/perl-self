# @file testhash01d.pl
# @location perl-self/sandbox_20170604/
# @company self
# @author Raymond Byczko
# @start_date 2017-06-04 June 4, 2017
# @purpose To see what happens keys and values are used on a hash.

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

my @keys_great_people = keys %great_people;
my @values_great_people = values %great_people;

my $len_keys = @keys_great_people;
my $i;
foreach ($i=0; $i < ($len_keys-1); $i++) {
	my $the_key;
	my $the_value;
	$the_key = $keys_great_people[$i];
	$the_value = $values_great_people[$i];
	print 'key,value='.$the_key.', '.$the_value."\n";
}
