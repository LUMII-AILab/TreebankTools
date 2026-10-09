#!/bin/sh

cd ..

echo "-- Seperate 1/5 into one data set and 2/5 into other (seed: 0). --"
perl -I ./ -e "use LvCorporaTools::DataSelector::SplitterFolder qw(splitCorpus); splitCorpus(@ARGV)" testdata/SplitterFolder 0.2 0

echo "-- Make 4 aproximetly even-sized datasets (seed: 0). --"
perl -I ./ -e "use LvCorporaTools::DataSelector::SplitterFolder qw(splitCorpus); splitCorpus(@ARGV)" testdata/SplitterFolder 4 0

echo "-- To concatenate multiple CoNLL files. --"
perl -I ./ -e "use LvCorporaTools::DataSelector::SplitterFolder qw(splitCorpus); splitCorpus(@ARGV)" testdata/SplitterFolder 1
