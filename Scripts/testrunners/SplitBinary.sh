#!/bin/sh

cd ..
echo "-- Split the given folder according to given split list. --"
perl -I ./ -e "use LvCorporaTools::DataSelector::SplitByList qw(splitOnOffList); splitOnOffList(@ARGV)" testdata/SplitBinary/data testdata/SplitBinary/split.tsv testdata/SplitBinary
