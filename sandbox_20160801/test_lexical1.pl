use strict;
sub before_red {
	## FOLLOWING PRODUCES ERROR: GLOBAL SYMBOL requires EXPLICIT PACKAGE NAME.
	# print 'before_red:cr='.$cr."\n";
}
sub colar_red {
	my $cr = 'red here';
	sub colar_white {
		print 'color_white: cr='.$cr."\n";
	}
	colar_white();
}

colar_red();

my $fish = 'bass';

sub catch_fish {
	print 'I hooked a '.$fish."\n";
}

catch_fish();
