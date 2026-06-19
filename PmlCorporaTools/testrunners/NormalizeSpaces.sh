#!/bin/sh

cd ..

echo "-- For single dataset. --"
perl -I ./ -e "use LvCorporaTools::PMLUtils::NormalizeSpaces qw(processFile); processFile(@ARGV)" testdata/NormalizeSpaces zeens

echo "-- For multiple datasets. --"
perl -I ./ -e "use LvCorporaTools::PMLUtils::NormalizeSpaces qw(processDir); processDir(@ARGV)" testdata/NormalizeSpaces
