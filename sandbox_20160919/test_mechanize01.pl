# @file test_mechanize01.pl
# @company self
# @author Raymond Byczko
# @location perl-self/sandbox_20160919/
# @start_date 2016-09-19 September 19, 2016
# @purpose To test mechanize and determine the SHA1 digest of
# a retrieved webpage.
# @conclusion This seems to work well. With the observation that
# follows, another test, test_mechanize02.pl will output two
# retrieved webpages and the user can do a diff on them.
# @see 
# @itsays
# @enditsays
# @observation Repeated invocations of this program yields different
# sha1 digests. @endobservation

use strict;
use WWW::Mechanize;
use Crypt::Digest::SHA1 qw(sha1_hex);
# use Encode;
# use utf8;

my $mech = WWW::Mechanize->new(autocheck=>1);
$mech->get("http://www.nytimes.com");
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
# @note The following does show the contents of the page.
# print $mech->content;
print 'content_sha='.$content_sha."\n";
