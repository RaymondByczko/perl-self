# @author Raymond Byczko
# @file Webpoll.pm
# @location perl-self/lib
# @purpose To provide a perl class for polling the web.
# @start_date 2016-09-21 September 21, 2016
# @change_history RByczko, 2016-10-13 October 13, 2016,  Added
# post_enc to each element that is produced as a result of a poll.

package Webpoll;
use overload '""' =>"webpollstring";
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
	my $latest_poll_run = ();
	my $new_obj = {
		"polled_url"=>$url,
		"latest_run"=>$latest_poll_run
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
	my $ret_value = ();
	my $polled_url = $self{'polled_url'};
	for (my $ct=0; $ct<$num_iterations; $ct++)
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
		my $ret_element = {
			'ct'=>$ct,
			'sha'=>$content_sha,
			'length'=>$len_content,
			'post_enc'=>$post_enc
		};
		push @$ret_value, $ret_element;

		my $pathName = $basePathName.'.'.$ct.'.'.$suffix;
		open CFH, ">>".$pathName;
		print CFH $post_enc;
		close CFH;
		sleep $delay;
	}

	$self->{latest_poll_run} = $ret_value;
	print '... poll::end'."\n";
	return $ret_value;
}

# This method overloads a Webpoll object when it is used in
# a string.
sub webpollstring {
	my ($self) = @_;
	my $ret_string = '<ret_string>'."\n";
	my $polled_url = $self->{'polled_url'};
	$ret_string .= 'polled_url='.$polled_url."\n";
	my $len_latest_poll_run = @{$self->{latest_poll_run}};
	if ($len_latest_poll_run == 0)
	{
		$ret_string .= 'latest_poll_run=false'."\n";
	}
	else
	{
		$ret_string .= 'latest_poll_run=true'."\n";
	}
	foreach my $a_run (@{$self->{latest_poll_run}})
	{
		my $ct = $a_run->{ct};
		my $sha = $a_run->{sha};
		my $length = $a_run->{length};
		$ret_string .= 'ct='.$ct."\n";
		$ret_string .= 'sha='.$sha."\n";
		$ret_string .= 'length='.$length."\n";
	}
	$ret_string .= '</ret_string>'."\n";
	return $ret_string;
}
1;
