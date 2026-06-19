#!/bin/sh

cd ..

echo "-- For file. --"
perl -I ./ -e "use LvCorporaTools::PMLUtils::CalcStats qw(calcStats); calcStats(@ARGV)" testdata/CalcStats zeens.m

echo "-- For folder. --"
perl -I ./ -e "use LvCorporaTools::PMLUtils::CalcStats qw(processDir); processDir(@ARGV)" testdata/CalcStats
