# @file blessed01.pl
# @author Raymond Byczko
# @date 2015-09-11 Sept 11
# @purpose To explore use of blessed.
# apparent outside and afterwards.
# NOTE: Read and writing to two different things
# which reference the same objects yields the
# expected outcome - change in one is reflected in the other.

my $favColor = "blueorange";
my $refFavColor = \$favColor;
print "COLOR BEFORE CHANGE", "\n";
print "favColor is: ", $favColor, "\n";
print "refFavColor is: ", $$refFavColor, "\n";

$favColor = "redorange";

print "COLOR AFTER CHANGE", "\n";
print "favColor is: ", $favColor, "\n";
print "refFavColor is: ", $$refFavColor, "\n";

$$refFavColor = "bluegreen";

print "COLOR AFTER 2nd CHANGE", "\n";
print "favColor is: ", $favColor, "\n";
print "refFavColor is: ", $$refFavColor, "\n";

bless $refFavColor; # Now refFavColor should be its own object
					# and not have any connection to favColor.

$$refFavColor = "purplered";

print "COLOR AFTER 3rd CHANGE (after bless)", "\n";
print "favColor is: ", $favColor, "\n";
print "refFavColor is(double dollar): ", $$refFavColor, "\n";
print "refFavColor is(single dollar): ", $refFavColor, "\n";
