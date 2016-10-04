use strict;
require LWP::UserAgent;
require HTTP::Request;
print 'test_lwp_ua01.pl: start'."\n";
my $website1 = 'http://www.nytimes.com/';
my $website2 = "http://www.usatoday.com/";
my $request = HTTP::Request->new(GET=>$website2);
# my $request = HTTP::Request->new('GET', $website1);
$request->header('Accept'=>'text/html');
my $theUA = 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:48.0) Gecko/20100101 Firefox/48.0';
my $theUAShort = 'Mozilla/5.0';
my $len_request = length $request;
print '... len_request='.$len_request."\n";
my $ua = LWP::UserAgent->new;
$ua->agent($theUAShort);
$ua->timeout(10);
my $response = $ua->request($request);
# my $response = $ua->get($website2);
my $len_response = length $response;
print '... len_response='.$len_response."\n";
print '... response='.$response."\n";
my @keys_response = keys %$response;
my $joined_keys = join ':',@keys_response;
print '... keys_response='.@keys_response."\n";
print '... joined_keys='.$joined_keys."\n";
print '... _content='.$%{$response}{_content}."\n";
print '... _content='.$response->_content."\n";
# print '... _msg='.$response->_msg."\n";
print '... message='.$response->message."\n";
print '... content='.$response->content."\n";
print '... code='.$response->code."\n";
if ($response->is_success) {
	print '... success'."\n";	
	print '... decoded_content='.$response->decoded_content."\n";
	print '... as_string='.$response->as_string."\n";
	my $length_decoded_content = length $response->decoded_content;
	print '... length_decoded_content='.$length_decoded_content."\n";
}
else {
	print '... no success'."\n";	
}
print 'test_lwp_ua01.pl: end'."\n";

