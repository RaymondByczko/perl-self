# @author Raymond Byczko
# @file test_gdbrighten03.pl
# @location perl-self/test/test_gdbrighten/
# @purpose To provide a perl test harness for testing the
# package Gdbrighten.
# @start_date 2016-08-31 August 31, 2016
# @status Working as of August 31, 2016

use strict;
use Gdbrighten;

my $color = 'red';
my $new_intensity = 255;
my $start_value = 140;
my $end_value = 200;
my $step = 10;
my $input_file = '/home/raymond/RByczko007_Perl/perl-self/test/test_gdbrighten/seaweed.JPG';
my $output_dir = '/home/raymond/RByczko007_Perl/perl-self/test/test_gdbrighten/output03/';

Gdbrighten::one_to_many (
	$color,
	$new_intensity,
	$start_value,
	$end_value,
	$step,
	$input_file,
	$output_dir);

