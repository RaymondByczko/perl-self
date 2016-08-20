package GitManifestUnit;
use parent 'ManifestUnit';
use strict;

sub new {
	my ($class, $url, $src, $des, $ow) = @_;
	print 'GitManifestUnit->new'."\n";
	print '...GitManifestUnit(class):'.$class."\n";
	print '...class->SUPER:'.$class->SUPER."\n";

	# my $obj_mu = $class->SUPER::new('ManifestUnit', $src, $des, $ow);
	my $obj_mu = $class->SUPER::new($src, $des, $ow);
	my %obj_muh = %$obj_mu;
	# add the attitribute to the already created and blessed object.
	$obj_muh{'url'} = $url;
	# This is the second blessing.
	my $self = bless \%obj_muh, $class;
	return $self;
}

sub git_log {
	my ($self) = @_;
	my %selfh = %$self;
	my $url = $selfh{'url'};
	print 'git log url='.$url."\n";
}

sub display {
	my ($self) = @_;
	$self->SUPER::display();

	my %selfh = %$self;
	my $url = $selfh{'url'};
	print 'GitManifestUnit - display'."\n";
	print '... url='.$url."\n";
}
1;
