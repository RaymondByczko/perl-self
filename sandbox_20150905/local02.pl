# @file local02.pl
# @author Raymond Byczko
# @date 2015-09-05 Sept 05
# @purpose To explore use of local.
# Local mods to a 'local'ized variable should not be
# apparent outside and afterwards.
use strict;
package main;
$::favColor = "Blue";

sub useColor {
	local $::favColor="Purple";
	print "useColor: start\n";
	print "favColor=", $::favColor, "\n";
	$main::favColor = "Red";
	print "after adjust favColor\n";
	print "favColor=", $main::favColor, "\n";
	print "useColor: end\n";
}

print "BEFORE useColor-favColor=", $main::favColor, "\n";
useColor();
print "AFTER useColor-favColor=", $main::favColor, "\n";
