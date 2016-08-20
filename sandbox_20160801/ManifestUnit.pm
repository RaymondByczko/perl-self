package ManifestUnit;
use strict;

BEGIN {
	print 'ManifestUnit beginning'."\n";
}
END {
	print 'ManifestUnit ending'."\n";
}
sub new {
	my ($class, $src, $des, $ow) = @_;
	my $new_obj = {
		src=>$src,
		des=>$des,
		ow=>$ow
	};
	my $self = bless $new_obj, $class;
	return $self;
}

sub filePresent {
	my ($self) = @_;
	my %selfh = %$self;
	my $des = $selfh{'des'};
	print 'des='.$des."\n";
}

sub display {
	my ($self) = @_;
	my %selfh = %$self;
	my $src = $selfh{'src'};
	my $des = $selfh{'des'};
	my $ow = $selfh{'ow'};
	print 'ManifestUnit - display'."\n";
	print '... src='.$src."\n";
	print '... des='.$des."\n";
	print '... ow='.$ow."\n";
}
1;
