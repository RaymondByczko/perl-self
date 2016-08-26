@file README.txt
@location perl-self/sandbox20160824/
@author Raymond Byczko
@start_date 2016-08-24 August 24, 2016
The work in this sandbox is inspired by typeglob
and local use, per reading 'perldoc perlmod'.  Lets
try some experiments!

test_my01.pl: introduce my var at file scope and see how it can
be read from by subroutines.

test_my02.pl: this is a variant of test_my01.pl.  A lexical scope
with curly brackets is introduced and the subroutines are defined
and called there, with the my declared var outside.

test_my03.pl: nested lexical scopes with curly brackets and vars
declared with my.

test_local01a.pl: tests how local can be applied to an outerscope
defined my variable.

test_local01b.pl: a variant of test_local01a.pl.  Tests how local can
be applied to an outerscope global variable.
