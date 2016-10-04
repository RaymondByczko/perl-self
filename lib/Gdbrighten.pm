# @file Gdbrighten.pm
# @location perl-self/scripts/
# @company self
# @author Raymond Byczko
# @start_date 2016-08-31 August 31, 2016
# @purpose To offer a package for processing graphic files,
# notably, JPG.
# @note This utility is inspired by a perl script:
# @reference perl-self/scripts/Gdbrighten.pm
# @change_history 2016-08-31, RByczko, Started this file.
# @change_history 2016-09-04, RByczko, Added extract_pixel_data.

package Gdbrighten;

use strict;
## use Getopt::Long;
use GD;
use File::Basename;


$Gdbright::min_color = 0;
$Gdbright::max_color = 255;

# create an output file from an input file by analyzing a particular colors
# value for each pixel and if its at or above a threshold, it will set
# that value to a new value, for those applicable pixels.
sub modify_one {
	my ($color, $threshold, $new_value, $input_file, $output_file) = @_;
	print 'modify_one:START'."\n";
	print '... color='.$color."\n";
	print '... threshold='.$threshold."\n";
	print '... new_value='.$new_value."\n";
	print '... input_file='.$input_file."\n";
	print '... output_file='.$output_file."\n";

## my $color = 'red';
## my $threshold = 126;
## my $input_file = 'input.JPG';
## my $output_file = 'output.JPG';

## GetOptions(
##	"color=s"=> \$color,
##	"threshold=i"=> \$threshold,
##	"in=s"=> \$input_file,
##	"out=s"=> \$output_file
## ) or die ('Error in command line arguments'."\n");

	GD::Image->trueColor(1);
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
			my $colorAll;
			if ($color eq 'red')
			{
				if ($rc > $threshold)
				{
					$colorAll = $outim->colorAllocate($new_value,$gc,$bc);
				}
			}
			if ($color eq 'green')
			{
				if ($rc > $threshold)
				{
					$colorAll = $outim->colorAllocate($rc,$new_value,$bc);
				}
			}
			if ($color eq 'blue')
			{
				if ($rc > $threshold)
				{
					$colorAll = $outim->colorAllocate($rc,$gc,$new_value);
				}
			}
			if ($rc <= $threshold)
			{
				$colorAll = $outim->colorAllocate($rc,$gc,$bc);
			}
			$outim->setPixel($x-1,$y-1,$colorAll);
			$outim->colorDeallocate($colorAll);
		}
	}
	binmode STDOUT;
	open my $outfh, '>', $output_file;
	print $outfh $outim->jpeg;
	close $outfh;
}

# Takes an input_file and creates a set of new JPG files, one for each value
# between $start_value and $end_value inclusive.  An output file is created
# by looking at each pixel, examining one of its color, see if its at or
# above a threshold, and if so, replace the color with the current value between
# start_value and end_value.
sub one_to_many {
	my ($color, $new_intensity, $start_value, $end_value, $step, $input_file, $output_dir) = @_;
	if ($end_value < $start_value)
	{
		# non-fatal error.
	}
	if (($end_value<$Gdbright::min_color)||($end_value>$Gdbright::max_color))
	{
		# error
	}
	if (($start_value<$Gdbright::min_color)||($start_value>$Gdbright::max_color))
	{
		# error
	}
	if ($step < 0)
	{
		# error
	}
	my ($name, $path, $suffix) = fileparse($input_file,'\.\w+');
	print 'name='.$name."\n";
	print 'path='.$path."\n";
	print 'suffix='.$suffix."\n";
	for (my $current_value=$start_value; $current_value<=$end_value; $current_value=$current_value+$step)
	{
		my $output_file = $output_dir.$name.'.'.$current_value.$suffix;
		print 'output_file='.$output_file."\n";

		my $threshold = $current_value;
		Gdbrighten::modify_one($color, $threshold, $new_intensity, $input_file, $output_file);
	}
}

# This subroutine reads from a JPG file and extracts pixel data, for one particular
# color.  The data is characterised by the pixel value from 0 to 254.  Each pixel value
# is presented by an array.  An element in an array is the pair of coordinates that match
# the pixel value.  The pair is (x,y).
sub extract_pixel_data {
	my ($input_file) = @_;
	print 'extract_pixel_data:START'."\n";
	print '... input_file='.$input_file."\n";

	my $ref_r_output = []; # empty array (red).
	my $ref_g_output = []; # empty array (green).
	my $ref_b_output = []; # empty array (blue).

	# setup the hash return value.
	my $ret_all = { 'red'=>$ref_r_output, 'green'=>$ref_g_output, 'blue'=>$ref_b_output };

	for (my $i=$Gdbright::min_color; $i<=$Gdbright::max_color; $i++)
	{

		push @{$ref_r_output}, []; #assign subarray - one for each pixel intensity.
		push @{$ref_g_output}, []; #assign subarray - one for each pixel intensity.
		push @{$ref_b_output}, []; #assign subarray - one for each pixel intensity.

		# ${@{$ref_r_output}}[$i] = (); #assign subarray - one for each pixel intensity.
		# ${@$ref_g_output}[0] = (); #assign subarray - one for each pixel intensity.
		# ${@$ref_b_output}[0] = (); #assign subarray - one for each pixel intensity.
	}
	GD::Image->trueColor(1);
	my $image = GD::Image->new($input_file);
	my ($w, $h) = $image->getBounds();
	for (my $x=1;$x <= $w; $x++)
	{
		for (my $y=1; $y <= $h; $y++)
		{
			print 'x='.$x.', y='.$y."\n";
			my $index = $image->getPixel($x-1,$y-1);
			my ($rc,$gc,$bc) = $image->rgb($index);
			# print '... ...r='.$rc."\n";
			# print '... ...g='.$gc."\n";
			# print '... ...b='.$bc."\n";
			my @new_point = ($x, $y);
			push @$ref_r_output[$rc], \@new_point;
			# push @{$ref_g_output}[$gc], ($x,$y);
			push @$ref_g_output[$gc], \@new_point;
			push @$ref_b_output[$bc], \@new_point;
		}
	}
	return $ret_all;
}
1;
