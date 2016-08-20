# @file local03.pl
# @author Raymond Byczko
# @date 2015-09-05 Sept 05
# @purpose To explore use of local.
# Local mods to a 'local'ized variable should not be
# apparent outside and afterwards.
# NOTE: This trys not using local, and seeing how favColor
# is changed from within subroutine useColor.  It works
# at demonstrating 'non-local' usage.
use strict;
package main;
$::favColor = "Blue";

sub useColor {
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
