use strict;
use GD;

GD::Image->trueColor(1);
my $image = GD::Image->new('./seaweed.JPG');
my ($w, $h) = $image->getBounds();
# print '... w='.$w."\n";
# print '... h='.$h."\n";
## $image->trueColor(0);
my $outim = new GD::Image($w, $h);
## $outim->trueColor(0);
for (my $x=1;$x <= $w; $x++)
{
    for (my $y=1; $y <= $h; $y++)
    {
        my $index = $image->getPixel($x-1,$y-1);
        my ($rc,$gc,$bc) = $image->rgb($index);
		# print '... ...r='.$rc."\n";
		# print '... ...g='.$gc."\n";
		# print '... ...b='.$bc."\n";
		my $color;
		if ($rc > 160)
		{
			$color = $outim->colorAllocate(253,$gc,$bc);
		}
		else
		{
			$color = $outim->colorAllocate($rc,$gc,$bc);
		}
        $outim->setPixel($x-1,$y-1,$color);
		$outim->colorDeallocate($color);
	}
}
binmode STDOUT;
print $outim->jpeg;
