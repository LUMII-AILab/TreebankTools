package LvCorporaTools::PMLUtils::Knit;
###############################################################################
# Originally meant as for knitting in arbitrary PML files, without calling
# depracated fslib, but in 2026 remade as custom knitter for LVTB due to
# unreliable nature of XML::CompactTree::XS (Treex::PML secret dependency) in
# various perl enviroments -- when XML::CompactTree::XS is installed, knitting
# sometimes gives segfaults and IO buffer fullness.
###############################################################################

use strict;
use warnings;

#use Carp::Always;	# Print stack trace on die.

use File::Path;
use IO::Dir;
#use Treex::PML;
#use Treex::PML::Instance;
#use Treex::PML::Instance::Writer;
use LvCorporaTools::GenericUtils::UIWrapper;

use Exporter();
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(knit processDir);

# This is the list of the elements that are going to be replaced with extended
# information. Order is important!
our @whereToKnit = ('m.rf', 'w.rf');

# Knit-in all the referenced data into provided PML file, print out with
# different file name. This can be used as entry point, if this module
# is used standalone.
sub knit
{
	autoflush STDOUT 1;
	if (not @_ or @_ < 2)
	{
		print <<END;
Script for knitting LVTB PML file. Works, if internal references ar local files.
Will try to knit in m.rf and w.rf elements.

Params:
   directory prefix
   input file name
   output file name

Latvian Treebank project, LUMII, 2026, provided under GPL
END
		exit 1;
	}

	my $dirPrefix = shift @_;
	my $inFile = shift @_;
	my $outFile = shift @_;

	print "Processing $inFile ";

	mkpath("$dirPrefix/res/");
	# Init XML stuff.
	my $xpc = XML::LibXML::XPathContext->new();
	$xpc->registerNs('pml', 'http://ufal.mff.cuni.cz/pdt/pml/');
	$xpc->registerNs('fn', 'http://www.w3.org/2005/xpath-functions/');
	my $parser = XML::LibXML->new('no_blanks' => 1);

	# The base XML, where to knit in fragments from other files.
	my $pmlTop = $parser->load_xml('location' => "$dirPrefix/$inFile");

	# The additional XMLs, from which the fragments are taken.
	my $refFiles = {};
	foreach my $pmlRef ($xpc->findnodes('/*/pml:head/pml:references/pml:reffile', $pmlTop))
	{
		my $refId = $xpc->findvalue('@id', $pmlRef);
		my $refTarget = $xpc->findvalue('@href', $pmlRef);
		$refTarget = "$dirPrefix/$refTarget" unless $refTarget =~ m#^[\\//]#;
		$refFiles->{$refId} = $parser->load_xml('location' => $refTarget);
	}

	# Knitting itself.
	foreach my $elemName (@whereToKnit)
	{
		&_processRfElement($pmlTop, $xpc, $refFiles, $elemName)
	}

	# Output.
	my $out = IO::File->new("$dirPrefix/res/$outFile", ">")
		or die "Output file opening: $!";
	print $out $pmlTop->toString(1);
	$out->close();

	print "finished!\n";
}

sub _processRfElement
{
	my $pmlTop = shift @_;
	my $xpc = shift @_;
	my $refFiles = shift @_;
	my $elementName = shift @_;


	foreach my $rfContainer ($xpc->findnodes("//pml:$elementName", $pmlTop))
	{
		# PML specific thing -- LM means list of potentially knitable things and
		# AM means alternatives. Semantic differences aside, both mean that the
		# actual element that needs to be changed is one level lower.
		my @mRefs = $xpc->findnodes('pml:LM|pml:AM', $rfContainer);
		@mRefs = ($rfContainer) if (@mRefs < 1);

		foreach my $refNode (@mRefs)
		{
			$refNode->textContent =~ /^\s*([^#]+)#(.*?)\s*$/; # e.g., w#w-zeens-p1w1
			my ($fileId, $nodeId) = ($1, $2);

			my @insertNodes = $xpc->findnodes("//*[\@id='$nodeId']", $refFiles->{$fileId});
			if (not @insertNodes)
			{
				warn("Reference " . $refNode->textContent . " could not be dereferenced!\n");
			}
			else
			{
				warn("Reference " . $refNode->textContent . " has multiple targets, first chosen!\n")
					if (@insertNodes > 1);
				my $insertNode = $insertNodes[0];
				#my $refNodeName = $refNode->getName();
				$insertNode->setName($refNode->getName());
				$insertNode->setOwnerDocument($refNode->getOwnerDocument());
				$refNode->replaceNode($insertNode);
			}
		}
	}
}

# Knit-in all files with given extension in given directory. This can be used
# as entry point, if this module is used standalone.
sub processDir
{
	autoflush STDOUT 1;
	if (not @_ or @_ < 2)
	{
		print <<END;
Script for batch knitting arbitrary PML files.

Params:
   data directory 
   file extension (only these files will be processed) 

Latvian Treebank project, LUMII, 2013, provided under GPL
END
		exit 1;
	}
	
	my $dirName = shift @_;
	my $ext = shift @_;
	#my $schemaDir = (shift @_ or 0);
	LvCorporaTools::GenericUtils::UIWrapper::processDir(
		\&knit, "^.+\\.\Q$ext\E\$", '.pml', 1, 0, $dirName);#, $schemaDir);
}

# sub knitDeprecated
# {
# 	autoflush STDOUT 1;
# 	if (not @_ or @_ < 2)
# 	{
# 		print <<END;
# Script for knitting arbitrary PML file.
#
# Params:
#    directory prefix
#    input file name
#    output file name
#    directory with PML schema/-s are [opt]
#
# Latvian Treebank project, LUMII, 2013, provided under GPL
# END
# 		exit 1;
# 	}
#
# 	my $dirPrefix = shift @_;
# 	my $inFile = shift @_;
# 	my $outFile = shift @_;
# 	my $schemaDir = shift @_;
#
# 	mkpath("$dirPrefix/res/");
#
# 	Treex::PML::AddResourcePath( $schemaDir ) if ($schemaDir);
# 	my $pml = Treex::PML::Instance->load({ 'filename' => "$dirPrefix/$inFile" });
# 	$Treex::PML::Instance::Writer::KEEP_KNIT = 1;
# 	$pml->save({ 'filename' => "$dirPrefix/res/$outFile", 'refs_save' => {}});
#
# 	print "Processing $inFile finished!\n";
# }

1;