#!/bin/sh

cd ..

echo "-- For single file. --"
perl -I ./ -e "use LvCorporaTools::PMLUtils::CheckW qw(checkW); checkW(@ARGV)" testdata/CheckW wtest.w wtest.txt

echo "-- For folder. --"
perl -I ./ -e "use LvCorporaTools::PMLUtils::CheckW qw(processDir); processDir(@ARGV)" testdata/CheckW
