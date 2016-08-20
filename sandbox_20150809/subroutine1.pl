# @company self
# @author Raymond Byczko
# @file subroutine1.pl
# @directory RByczko007_Perl/sandbox_20150809/
# @purpose To explore subroutines.
# @lesson a) Just write down the result and omit the return.
# b) Defining anonymous subroutines.

sub multiply_2_nums {
	my ($a, $b) = @_;
	my $res = $a * $b;
	# Here , simply putting down the result will return it.
	$res;
}

my $theAnswer = multiply_2_nums(4,5);
print "The Answer is ", $theAnswer, "\n";

# An example of defining an anonymous subroutine.
# (Its ok with my)
my $ref_addition = sub {
	my ($c, $d) = @_;
	my $theSum = $c + $d;
	$theSum;
};
# Need to have the semi-colon above, else an error.

my $someSum = &$ref_addition(17, 18);
print "The sum of 17, 18 is: ", $someSum, "\n";


my $ref_this = sub {
	print "THISTHISTHIS", "\n";
};

my $ref_that = sub {
	print "THATTHATTHAT", "\n";
};

# Experiment with calling two subroutines delivered to a third
# subroutine.
sub do_2_things {
	# NOTE - no backslash before $one_thing, and before $second_thing.
	my ($one_thing, $second_thing) = @_;
	# Use the ampersand and dollar sign.
	&$one_thing();
	&$second_thing();
};
do_2_things($ref_this, $ref_that);

