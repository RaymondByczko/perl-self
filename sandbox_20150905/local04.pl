# @file local04.pl
# @author Raymond Byczko
# @date 2015-09-05 Sept 05
# @purpose To explore use of local.
# Local mods to a 'local'ized variable should not be
# apparent outside and afterwards.
# NOTE: This kind of works as expected.  In compiling/executing
# the creation of local for favColor, its outside value is
# fetched and used in the assignment.
use strict;
package main;
$::favColor = "Blue";

sub useColor {
	local $::favColor = $::favColor;
	print "useColor: start\n";
	print "favColor=", $::favColor, "\n";
	$::favColor = "Red";
	print "after adjust favColor\n";
	print "favColor=", $::favColor, "\n";
	print "useColor: end\n";
}

print "BEFORE useColor-favColor=", $::favColor, "\n";
useColor();
print "AFTER useColor-favColor=", $::favColor, "\n";
