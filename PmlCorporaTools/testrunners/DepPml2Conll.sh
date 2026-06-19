#!/bin/sh

cd ..

echo "-- Unlabeled trees in \"small\" CoNLL with default POSTAG and CPOSTAG; single file. --"
perl -I ./ -e "use LvCorporaTools::FormatTransf::DepPml2Conll qw(transformFile); transformFile(@ARGV)" testdata/DepPml2Conll zeens-dep.xml zeens-unlabeled.conll 0 0

echo "-- Labeled trees in \"large\" CoNLL format with custom POSTAG and CPOSTAG; single file. --"
perl -I ./ -e 'use LvCorporaTools::FormatTransf::DepPml2Conll qw(transformFile POSTAG CPOSTAG); $POSTAG = "FULL"; $CPOSTAG = "FIRST"; transformFile(@ARGV)' testdata/DepPml2Conll zeens-dep.xml zeens-omit-reductions.conll 1 1

echo "-- Unlabeled trees in \"small\" CoNLL with default POSTAG and CPOSTAG; entire folder. --"
perl -I ./ -e "use LvCorporaTools::FormatTransf::DepPml2Conll qw(processDir); processDir(@ARGV)" testdata/DepPml2Conll 0 0

echo "-- Labeled trees in \"small\" CoNLL format with custom POSTAG and CPOSTAG; entire folder. --"
perl -I ./ -e 'use LvCorporaTools::FormatTransf::DepPml2Conll qw(processDir POSTAG CPOSTAG); $POSTAG = "FULL"; $CPOSTAG = "FIRST"; processDir(@ARGV)' testdata/DepPml2Conll 1 0
