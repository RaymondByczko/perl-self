# @file blessed02.pl
# @author Raymond Byczko
# @date 2015-09-11 Sept 11
# @purpose To explore use of blessed.
# apparent outside and afterwards.
# NOTE: Read and writing to two different things
# which reference the same objects yields the
# expected outcome - change in one is reflected in the other.

my $favColorA = "blueorange";
# B should reference A now.
my $favColorB = $favColorA;
print "COLOR BEFORE CHANGE", "\n";
print "favColorA is: ", $favColorA, "\n";
print "favColorB is: ", $favColorB, "\n";

$favColorA = "redorange";

print "COLOR AFTER CHANGE", "\n";
print "favColorA is: ", $favColorA, "\n";
print "favColorB is: ", $favColorB, "\n";

$favColorB = "bluegreen";

print "COLOR AFTER 2nd CHANGE", "\n";
print "favColorA is: ", $favColorA, "\n";
print "favColorB is: ", $favColorB, "\n";

bless $favColorB; # Now favColorB should be its own object
					# and not have any connection to favColorA.

$favColorB = "purplered";

print "COLOR AFTER 3rd CHANGE (after bless)", "\n";
print "favColorA is: ", $favColorA, "\n";
print "favColorB is: ", $favColorB, "\n";
