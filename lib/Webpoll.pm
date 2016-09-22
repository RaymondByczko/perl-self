# @author Raymond Byczko
# @file Webpoll.pm
# @location perl-self/lib
# @purpose To provide a perl class for polling the web.
# @start_date 2016-09-21 September 21, 2016

package Webpoll;

use strict;
require Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw();
our @EXPORT_OK = qw();

use WWW::Mechanize;
use Crypt::Digest::SHA1 qw(sha1_hex);

sub new {
	my ($class, $url) = @_;
	my $attributes_href = {};
	my $new_obj = {
		"polled_url"=>$url
	};
	my $self = bless $new_obj, $class;
	return $self;
}

# @purpose To poll the website indicated by polled_url associated with
# the object it is with.  The polling is done for a certain number of
# times given by num_iterations.  Between each iteration, there is a delay
# of $delay seconds. 
#
# As content is grabbed during each iteration, it is stored in a filename
# build from the concatenation of $basePathName, the iteration count, and
# suffix.
sub poll {
	my ($self, $num_iterations, $delay, $basePathName, $suffix) = @_;
	my %self = %$self;
	print '... poll::start'."\n";
	print '... ... num_iterations='.$num_iterations."\n";
	print '... ... delay='.$delay."\n";
	my $polled_url = $self{'polled_url'};
	for (my $ct=0; $ct<=$num_iterations; $ct++)
	{
		my $mech = WWW::Mechanize->new(autocheck=>1);
		$mech->get($polled_url);
		my $content = $mech->content;
		my $len_content = length $content;
		print 'len_content='.$len_content."\n";
		my $post_enc;
		if (utf8::is_utf8($content))
		{
			print '... content is utf8 encoded'."\n";
			$post_enc = Encode::encode_utf8($content);
		}
		else
		{
			print '... content is not utf8 encoded'."\n";
			$post_enc = $content;
		}
		my $content_sha = sha1_hex($post_enc);

		my $pathName = $basePathName.'.'.$ct.'.'.$suffix;
		open CFH, ">>".$pathName;
		print CFH $post_enc;
		close CFH;
	}

	print '... poll::end'."\n";
}
1;
