my $name = 'Jacob';
{
	print "Inside block\n";
	my $name = 'Edward';
	print $name, "\n";
}
print "Outside block\n";
print $name, "\n";
