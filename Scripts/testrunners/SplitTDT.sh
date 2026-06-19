#!/bin/sh

cd ..

echo "-- Split the given folder according to given split list. --"
perl -I ./ -e "use LvCorporaTools::DataSelector::SplitByList qw(splitTDT); splitTDT(@ARGV)" testdata/SplitTrainDevTest/data testdata/SplitTrainDevTest/split.tsv testdata/SplitTrainDevTest
