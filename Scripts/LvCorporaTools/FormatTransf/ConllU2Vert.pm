#!C:\strawberry\perl\bin\perl -w
package LvCorporaTools::FormatTransf::ConllU2Vert;

use warnings;
use utf8;
use strict;

use IO::File;
use Data::Dumper;

use Exporter();
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(processFile);

# TODO: As of now we assume that LVTB doesn't use split tokens represented with token numbers like 3-4.

sub processFile
{
	autoflush STDOUT 1;
	if (@_ < 1)
	{
		print <<END;
Script for converting CONLL-U formated UD treebank to SketchEngine/NoSketch
friendly vert file.

Params:
   file to process

AILab, LUMII, 2022, provided under GPL
END
		exit 1;
	}

	my $file = shift @_;
	$file =~ /^(.*?)(.conllu)?$/i;
	my $namestub = $1;

	my $in = IO::File->new($file, "< :encoding(UTF-8)")
		or die "Could not open file $file: $!";
	my $out = IO::File->new("$namestub.vert", "> :encoding(UTF-8)")
		or die "Could not open file $namestub.vert: $!";

	my ($indoc, $inpar, $insentence) = (0, 0, 0);
	while (my $line = <$in>)
	{
		if ($line =~ /^\s*#\s*newdoc(\s+id\s*=\s*(.*?))?\s*$/)
		{
			my $id = $2;
			if ($inpar)
			{
				print $out "</p>\n";
				$inpar = 0;
			}
			print $out "</doc>\n" if ($indoc);
			$indoc = 1;
			print $out "<doc";
			print $out " id=\"$id\"" if ($id);
			print $out ">\n";
		}
		elsif ($line =~ /^\s*#\s*newpar(\s+id\s*=\s*(.*?))?\s*$/)
		{
			my $id = $2;
			print $out "</p>\n" if ($inpar);
			$inpar = 1;
			print $out "<p";
			print $out " id=\"$id\"" if ($id);
			print $out ">\n";
		}
		elsif ($line =~ /^\s*#\s*sent_id\s*=\s*(.*?)\s*$/)
		{
			my $id = $1;
			print $out "</s>\n" if ($insentence);
			$insentence = 1;
			print $out "<s id=\"$id\">\n";
		}
		elsif ($line =~ /^\s*#\s*text\s*.*$/)
		{
			#skip.
		}
		elsif ($line =~/^([^\t]+)\t([^\t]+)\t([^\t]+)\t([^\t]+)\t([^\t]+)\t([^\t]+)\t([^\t]+)\t([^\t]+)\t([^\t]+)\t([^\t]+)\s*$/)
		{
			my ($tokenNo, $token, $lemma, $upos, $xpos, $deprel, $misc) = ($1, $2, $3, $4, $5, $8, $10);
			if ($tokenNo =~/^\d+$/)
			{
				my $nospace = ($misc =~ /SpaceAfter=No/);
				print $out "$token\t$lemma\t$xpos\t$upos\t$deprel\n";
				print $out "<g/>\n" if ($nospace);
			}
			# Tokens with decimal and interval numbers are ignored.
		}
		elsif ($line =~ /^\s*$/)
		{
			print $out "</s>\n" if ($insentence);
			$insentence = 0;
		}
		else
		{
			print "Line ignored: $line"
		}
	}
	print $out "</s>\n" if ($insentence);
	print $out "</p>\n" if ($inpar);
	print $out "</doc>\n" if ($indoc);

	$in -> close();
	$out -> close();
}

1;
