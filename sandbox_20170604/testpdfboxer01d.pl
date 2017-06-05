# @file testpdfboxer01d.pl
# @location perl-self/sandbox_20170604/
# @company self
# @author Raymond Byczko
# @start_date 2017-06-04 June 4, 2017
# @purpose To experiment with PDF::Boxer and creating a pdf.
# Border and border_color was experimented with it.
# @note To install PDF::Boxer do:
#
#	cpan
#	get PDF::Boxer
#	install PDF::Boxer
#
# @credit To https://metacpan.org/pod/PDF::Boxer
# by Jason Galea.

$pdfml = <<'__EOP__';
<row>
<column border_color="blue" border="2">
<text align="center">Iron
</text>
</column>
<column>
<text align="center">Wood
</text>
</column>
</row>
__EOP__
 
use PDF::Boxer qw(SpecParser);
use PDF::Boxer::SpecParser;

$parser = PDF::Boxer::SpecParser->new;
$spec = $parser->parse($pdfml);
 
$boxer = PDF::Boxer->new( doc => { file => 'test_pdfboxer01d.pdf' } );
 
$boxer->add_to_pdf($spec);
$boxer->finish;
