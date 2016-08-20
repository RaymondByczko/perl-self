sub class_like {
	my ($x,$y,$z) = @_;
	sub get_x {
		return $x;
	}
	sub get_y {
		return $y;
	}
# 	my %cl_methods = ("get_x",get_x,"get_y",get_y);
#	my %cl_methods = ("get_x",\&get_x,"get_y",\&get_y);
# 	my %cl_methods = ("get_x"=>\&get_x,"get_y"=>\&get_y);
 	my %cl_methods = ('get_x'=>\&get_x,'get_y'=>\&get_y);
	return sub {
		return %cl_methods; 
	}
}

my $obj3D =  class_like( qw(3 4 5)); 
print "start of keys\n";
print $obj3D->();
print "\n\n";
my %copyhash = $obj3D->();
print keys(%copyhash);
print "end of keys\n";
# my $a_x = $obj3D->(){"get_x"}->();
# my $a_x = %$obj3D->(){"get_x"};
print "HERESCOPYHASH: ", $copyhash{'get_x'}->(), "\n";

my $a_x = $copyhash{'get_x'}->();
print "a_x=", $a_x, "\n";
