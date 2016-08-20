# @file sandbox_20160331/testmore01.pl
# @author Raymond Byczko
# @company self
# @purpose To try the Test::More core module.

use Test::More tests=>6;
use strict;
my $mynickname = 'John Denver';
my $country_musician = 'John Denver';
my $ziggy = 'David Bowie';

ok ($mynickname eq $country_musician, 'Test to see if nickname matches');
ok ($ziggy eq $country_musician, 'Test to see if David B is John D');

my $typetuna = 'BigEye';

isnt ($typetuna, 'Bluefish', 'Bluefish fight like tuna but not as long'); 
is ($typetuna, 'BigEye', 'The big eye puts up a big fight'); 

my @fruit = ('apple', 'banana', 'strawberry');
my %fruit = map { $_ => 1 } @fruit;

my $exApple = exists($fruit{'apple'});
print 'exApple='.$exApple."\n";

sub testmoreexists {
	my ($theArrayRef, $theElement) = @_;
	my @theArray = @$theArrayRef;
	print 'theElement='.$theElement."\n";
	print 'theArray[0]='.$theArray[0]."\n";
	print 'theArray[1]='.$theArray[1]."\n";
	print 'theArray[2]='.$theArray[2]."\n";
	my %theHash = map { $_ => 1 } @theArray;
	print 'theHash{apple}='.$theHash{'apple'}."\n";
	print 'theHash{banana}='.$theHash{'banana'}."\n";
	print 'theHash{strawberry}='.$theHash{'strawberry'}."\n";
	my $retExists = exists($theHash{$theElement});
	return $retExists;
}

print "testmoreexits with apple:".testmoreexists(\@fruit, 'apple')."\n";
print "testmoreexits with banana:".testmoreexists(\@fruit, 'banana')."\n";
print "testmoreexits with strawberry:".testmoreexists(\@fruit, 'strawberry')."\n";
print "testmoreexits with tomato:".testmoreexists(\@fruit, 'tomato')."\n";

is (testmoreexists(\@fruit, 'banana'), 1, 'banana should exists yeah');
isnt (testmoreexists(\@fruit, 'tomato'), 0 , 'tomato should not exists yeah');

