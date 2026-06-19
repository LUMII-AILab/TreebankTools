#!/bin/sh

cd ..

echo "-- For single file with default settings. --"
perl -I ./ -e "use LvCorporaTools::TreeTransf::RemoveReduction qw(transformFile); transformFile(@ARGV)" testdata/RemoveReduction zeens-synt.a zeens-synt-noRed.a
echo "-- For single file without empty element labeling. --"
perl -I ./ -e 'use LvCorporaTools::TreeTransf::RemoveReduction qw($LABEL_EMPTY transformFile); $LABEL_EMPTY = 0; transformFile(@ARGV)' testdata/RemoveReduction zeens-sem.a zeens-sem-noRed.a

echo "-- For folder. --"
perl -I ./ -e "use LvCorporaTools::TreeTransf::RemoveReduction qw(processDir); processDir(@ARGV)" testdata/RemoveReduction
