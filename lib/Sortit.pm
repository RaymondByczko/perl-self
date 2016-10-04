# @author Raymond Byczko
# @file Sortit.pm
# @location perl-self/lib
# @purpose To provide a perl class for sorting - quick, shell sort etc.
# @start_date 2016-10-03 October 21, 2016

package Sortit;

use strict;
require Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw();
our @EXPORT_OK = qw();

# use WWW::Mechanize;
# use Crypt::Digest::SHA1 qw(sha1_hex);

# nameOfObject: this is just a notation attribute to help tag our
# objects.  It can be any string the client code wants to use
# or finds important.  It is not important for any implementation
# of a sorting procedure, but it might be useful for logging,
# for example.
sub new {
	my ($class, $nameOfObject) = @_;
	my $new_obj = {
		"name_of_object"=>$nameOfObject
	};
	my $self = bless $new_obj, $class;
	return $self;
}

# @purpose To implement a quicksort algorithm as given by 'Algorithms in C'
# by Robert Sedgewick.  See p. 118.  The code on that page is in C.  It has
# been translated to Perl.
#
# The lower_limit and upper_limit are 1's based.  However,
# typical array bounds are 0's based.  The client code needs to
# convert its array bound from 0 based to 1 based.
sub quicksort {
	my ($self, $refArray, $lower_limit, $upper_limit) = @_;
	my %self = %$self;
	print '... quicksort::start'."\n";
	print '... ... lower_limit='.$lower_limit."\n";
	print '... ... upper_limit='.$upper_limit."\n";

	my $v;
	my $i;
	my $j;
	my $t;

	if ($upper_limit > $lower_limit)
	{
		$v = $refArray->[$upper_limit];
		$i = $lower_limit - 1;
		$j = $upper_limit;

		print '...i,j='.$i.', '.$j.' INITIAL ASSIGN'."\n";
		### my $polled_url = $self{'polled_url'};
		#for (my $ct=0; 1==1; $ct++)
		for (;;)
		{
			# @note Pre and post increment,decrement are honored in Perl
			# like in C.  See p. 17 in 'Programming Perl' @note_end
			while($refArray->[++$i]<$v){};
			while($refArray->[--$j]>$v){};

			if ($i >= $j)
			{
				print '...i,j='.$i.', '.$j.' AFTER TWO WHILE-IN COND'."\n";
				# @note Perl uses 'last' instead of 'break' which is used in C. @note_end
				last;
			};

			print '...i,j='.$i.', '.$j.' AFTER TWO WHILE-AFTER COND'."\n";
			$t = $refArray->[$i];
			$refArray->[$i] = $refArray->[$j]; 
			$refArray->[$j] = $t;

			# In development, this will limit the outer for loop.
			# @todo Translated to infinite loop with suitable
			# test condition and break. @todo_end
			# if ($ct == 500)
			# {
			#	return;
			# }
		}

		$t = $refArray->[$i];
		$refArray->[$i] = $refArray->[$upper_limit]; 
		$refArray->[$upper_limit] = $t;

		$self->quicksort($refArray, $lower_limit, $i-1);
		$self->quicksort($refArray, $i+1, $upper_limit);
		### my $len_content = length $content;
		### print 'len_content='.$len_content."\n";
	}

	print '... quicksort::end'."\n";
}
1;
