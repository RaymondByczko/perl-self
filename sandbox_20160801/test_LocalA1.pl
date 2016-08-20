use LocalA;

print 'test_LocalA1.pl: start'."\n";
LocalA::do_something();

print '... (from test)LocalA::A'.$LocalA::A."\n";
LocalA::do_something_else();

print 'test_LocalA1.pl: end'."\n";
