#!/bin/sh

cd ..

echo "-- For single file. --"
perl -I ./ -e "use LvCorporaTools::DataSelector::SplitConll2Para qw(transformFile); transformFile(@ARGV)" testdata/SplitConll2Para tenis3.conllu

echo "-- For folder. --"
perl -I ./ -e "use LvCorporaTools::DataSelector::SplitConll2Para qw(processDir); processDir(@ARGV)" testdata/SplitConll2Para
