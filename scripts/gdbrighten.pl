#!/usr/bin/perl
use strict;
use Getopt::Long;
use GD;

my $color = 'red';
my $threshold = 126;
my $input_file = 'input.JPG';
my $output_file = 'output.JPG';

GetOptions(
	"color=s"=> \$color,
	"threshold=i"=> \$threshold,
	"in=s"=> \$input_file,
	"out=s"=> \$output_file
) or die ('Error in command line arguments'."\n");

GD::Image->trueColor(1);
# my $image = GD::Image->new('./seaweed.JPG');
my $image = GD::Image->new($input_file);
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
		if ($rc > $threshold)
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
open my $outfh, '>', $output_file;
print $outfh $outim->jpeg;
close $outfh;
