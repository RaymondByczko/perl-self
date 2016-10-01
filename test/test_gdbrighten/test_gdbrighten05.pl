# @author Raymond Byczko
# @file test_gdbrighten05.pl
# @location perl-self/test/test_gdbrighten/
# @purpose To provide a perl test harness for testing the
# package Gdbrighten.
# @start_date 2016-09-04 September 04, 2016
# @status Working/not working

use strict;
use Gdbrighten;

my $input_file = '/home/raymond/RByczko007_Perl/perl-self/test/test_gdbrighten/seaweed.JPG';

my $ref_data = Gdbrighten::extract_pixel_data(
	$input_file
);

print 'red array'."\n";
my $ref_red = $ref_data->{red};
my @red_array = @$ref_red;
my $num_red = @red_array;
print 'num_red='.$num_red."\n";
my $total_red = 0;
for (my $i=0;$i<=255;$i++)
{
	my $num = @{$red_array[$i]};
	print 'num='.$num.', i='.$i."\n";
	$total_red = $total_red + $num;
}
print 'total_red='.$total_red."\n";


print 'green array'."\n";
my $ref_green = $ref_data->{green};
my @green_array = @$ref_green;
my $num_green = @green_array;
print 'num_green='.$num_green."\n";
my $total_green = 0;
for (my $i=0;$i<=255;$i++)
{
	my $num = @{$green_array[$i]};
	print 'num='.$num.', i='.$i."\n";
	$total_green = $total_green + $num;
}
print 'total_green='.$total_green."\n";

print 'blue array'."\n";
my $ref_blue = $ref_data->{blue};
my @blue_array = @$ref_blue;
my $num_blue = @blue_array;
print 'num_blue='.$num_blue."\n";
my $total_blue = 0;
for (my $i=0;$i<=255;$i++)
{
	my $num = @{$blue_array[$i]};
	print 'num='.$num.', i='.$i."\n";
	$total_blue = $total_blue + $num;
}
print 'total_blue='.$total_blue."\n";

