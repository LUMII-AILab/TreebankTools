package LvCorporaTools::GenericUtils::SimpleXmlIo;
###############################################################################
# This module contains most basic helper functions for reading and writing
# lv-PML files with XML::Simple.
# DO NOT use this for any new developments, XML::Simple is regarded obsolete and
# it messes up element order in a file. Use LibXML based AUtils and UIWrapper
# instead! (2026)
#
# Developed on Strawberry Perl 5.12.3.0
# Latvian Treebank project, 2012
# Lauma Pretkalniņa, LUMII, AILab, lauma@ailab.lv
# Licenced under GPL.
###############################################################################

use strict;
use warnings;
#use utf8;
no warnings 'recursion';

use Exporter();
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(loadXml printXml loadLVPML printLVPML @FORCE_ARRAY_W @FORCE_ARRAY_M @FORCE_ARRAY_A @LOAD_AS_ID);

use Data::Dumper;
use XML::Simple;  # XML handling library
use IO::File;

# Some convinient default values.
our @FORCE_ARRAY_W = qw(para w schema title source author authorgender published genre keywords msc);
our @FORCE_ARRAY_M = qw(s m reffile schema LM);
our @FORCE_ARRAY_A = qw(node LM reffile schema);
our @LOAD_AS_ID = qw(id);

# loadXml (file name with extension and everything, reference to array
#          containing 'ForceArray' options for XML::Simple, [reference to
#		   array containing 'KeyAttr' options for XML::Simple, empty used
#		   as default])
# returns hash refernece:
#		'xml' => loaded XML data structure, 'header' => XML header,
#       'handler' => XML::Simple object
sub loadXml
{
	my $filename = shift;
	my $forceArrayOpts = shift;
	my $keyAttrOpts = (shift or []);
	
	my $in = IO::File->new($filename, "< :encoding(UTF-8)")
		or die "Could not open file $filename: $!";
	my $xmlString = join '', <$in>;
	$xmlString =~ /^\s*(\Q<?\E.*?\Q?>\E)/;
	my $header = $1;
	my $sxml = XML::Simple->new();
	my $data = $sxml->XMLin(
		$xmlString,
		'KeyAttr' => $keyAttrOpts,
		'ForceContent' => 1,
		'ForceArray' => $forceArrayOpts,
#		'GroupTags' => {},
		);
	$in->close();
	return {'xml' => $data, 'header' => $header, 'handler' => $sxml};
}

# printXml (file name with extension and everything, XML::Simple object to
#          handle data convertation, data object, name of the root element,
#          header)
sub printXml
{
	my $filename = shift;
	my $xmlHandler = shift;
	my $data = shift;
	my $root = shift;
	my $header = shift;
	
	my $out = IO::File->new($filename, "> :encoding(UTF-8)")
		or die "Could not create file $filename: $!";
	my $xmlString = $xmlHandler->XMLout($data,
		'KeyAttr' => [],
		'AttrIndent' => 1,
		'RootName' => $root,
#		'OutputFile' => $out,
		'SuppressEmpty' => 1,
#		'NoSort' => 1,
		'XMLDecl' => $header,
#		'NoEscape' => 1,
#		'GroupTags' => {},
		);
	# Normalization for TrEd:
	# for A files
	# for M files
	# for W files
	$xmlString =~ s#(<doc[ >].*</doc>)(\s*)(<head>.*</head>\s*<meta>.*</meta>)#$3$2$1#s;
	print $out $xmlString;
	$out->close();
}

# loadLVPML (source directory, file name without extension)
# returns hash refernece:
#		'w' => XML data from &loadXML for w,
#		'm' => XML data from &loadXML for m,
#		'a' => XML data from &loadXML for a
# see &loadXML
sub loadLVPML
{
	# Input paramaters.
	my $dirPrefix = shift @_;
	my $fileName = shift @_;

	# Load w-level.
	my $wXml = loadXml ("$dirPrefix/$fileName.w", \@FORCE_ARRAY_W);
	print 'Loaded W';

	# Load m-level.
	my $mXml = loadXml ("$dirPrefix/$fileName.m", \@FORCE_ARRAY_M);
	print ', M';


	if (-f "$dirPrefix/$fileName.a")
	{
		# Load the a-level.
		my $aXml = loadXml ("$dirPrefix/$fileName.a", \@FORCE_ARRAY_A);
		print ', A. ';
		return {'w' => $wXml, 'm' => $mXml, 'a' => $aXml};
	}
	else
	{
		print '. ';
		return {'w' => $wXml, 'm' => $mXml};
	}
}

# printLVPML (source directory, file name without extension, hash with xml refs)
# prints result of &loadLVPML back out
# see &loadLVPML
sub printLVPML
{
	my $dirPrefix = shift @_;
	my $fileName = shift @_;
	my $xmls = shift @_;


	printXml ("$dirPrefix/$fileName.w", $xmls->{'w'}->{'handler'},
		$xmls->{'w'}->{'xml'}, 'lvwdata', $xmls->{'w'}->{'header'});
	print 'Printed W';
	printXml ("$dirPrefix/$fileName.m", $xmls->{'m'}->{'handler'},
		$xmls->{'m'}->{'xml'}, 'lvmdata', $xmls->{'m'}->{'header'});
	print ', M';
	if ($xmls->{'a'} and $xmls->{'a'}->{'xml'})
	{
		printXml ("$dirPrefix/$fileName.a", $xmls->{'a'}->{'handler'},
			$xmls->{'a'}->{'xml'}, 'lvadata', $xmls->{'a'}->{'header'});
		print ', A';
	}
	print '. ';

}
1;