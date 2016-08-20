use strict;
use ManifestUnit;
use GitManifestUnit;
use Scalar::Util 'blessed';

my $objMU = new ManifestUnit('/src/filea.php', '/des/filea.php', 1);
$objMU->filePresent();

my $ret_blessed = blessed($objMU);
if (defined $ret_blessed)
{
	print 'ret_blessed='.$ret_blessed."\n";
}
else
{
	
	print 'ret_blessed is not defined'."\n";
}

my $ret_can_fp = $objMU->can('filePresent');
if (defined $ret_can_fp)
{
	print 'ret_can_fp is defined like it should be (OK)'."\n";
}
else
{
	print 'ret_can_fp is not defined (NOT OK)'."\n";
}

my $ret_can_ni = $objMU->can('notImplemented');
if (defined $ret_can_ni)
{
	print 'ret_can_ni is defined like it should not be (NOT OK)'."\n";
}
else
{
	print 'ret_can_ni is not defined (OK)'."\n";
}
my $objGMU = new GitManifestUnit('gitrepo.com', '/src/filea.php', '/des/filea.php', 1);
$objGMU->git_log();
my $ret_gmu_b = blessed($objGMU);
if (defined $ret_gmu_b)
{
	print 'ret_gmu_b='.$ret_gmu_b."\n";
}
else
{
	
	print 'ret_gmu_b is not defined'."\n";
}
$objGMU->display();
