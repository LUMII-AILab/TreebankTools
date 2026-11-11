package LvCorporaTools::PMLUtils::TagChangeUtils;
use strict;
use warnings;

use XML::LibXML;

our @ISA = qw(Exporter);
our @EXPORT_OK = qw(change_m_tag change_a_tags);

################################################################################
# Helper functions to change tags in an PML-M node and PML-A tree. Both
# functions expect XML::LibXML::XPath context, node to work with (M node or
# A tree, but not M sentence), regexp to match changable tags, regexp for
# substitution and optional ID whitelist. If no whitelist is given, all matching
# nodes will be changed.
# 2026.
################################################################################

sub change_a_tags
{
    my $xpc = shift @_; # XPath context
    my $treeNode = shift @_;
    my $tagMatchRegexp = shift @_;
    my $tagSubstRegexp = shift @_;
    my $id_whitelist = (shift @_ or 0);

    my @nodes = $xpc->findnodes('.//pml:node', $treeNode);
    for my $node (@nodes)
    {
        my $aId = $xpc->findvalue('@id', $node);
        if (not $id_whitelist or grep( /^$aId$/, @$id_whitelist) )
        {
            my @redTags = $xpc->findnodes('pml:reduction', $node);
            &_applyRegexpToContents($_, 'reduction', $tagMatchRegexp, $tagSubstRegexp)
                for (@redTags); # Should be no more than one
            my @xTags = $xpc->findnodes('pml:xinfo/pml:tag|pml:coordinfo/pml:tag', $node);
            &_applyRegexpToContents($_, 'tag', $tagMatchRegexp, $tagSubstRegexp)
                for (@xTags); # Should be no more than one
        }
    }
}

sub change_m_tag
{
    my $xpc = shift @_; # XPath context
    my $mNode = shift @_;
    my $tagMatchRegexp = shift @_;
    my $tagSubstRegexp = shift @_;
    my $id_whitelist = (shift @_ or 0);

    my $mId = $xpc->findvalue('@id', $mNode);
    if (not $id_whitelist or grep( /^$mId$/, @$id_whitelist) )
    {
        my @tags = $xpc->findnodes(
            'pml:tag', $mNode);
        &_applyRegexpToContents($_, 'tag', $tagMatchRegexp, $tagSubstRegexp)
            for (@tags); # Should be only one
    }
}

sub _applyRegexpToContents
{
    my $node = shift @_;
    my $nodeName = shift @_;
    my $tagMatchRegexp = shift @_;
    my $tagSubstRegexp = shift @_;

    my $newNode = XML::LibXML::Element->new($nodeName);
    $newNode->setNamespace('http://ufal.mff.cuni.cz/pdt/pml/');
    my $textCotent = $node->textContent();
    if ($textCotent =~ /$tagMatchRegexp/)
    {
        $textCotent =~ s/$tagMatchRegexp/$tagSubstRegexp/;
        $newNode->appendTextNode($textCotent);
        $node->replaceNode($newNode);
    }
}

1;