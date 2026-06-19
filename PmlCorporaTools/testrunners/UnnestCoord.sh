#!/bin/sh

cd ..

echo "-- For single file. --"
perl -I ./ -e "use LvCorporaTools::TreeTransf::UnnestCoord qw(transformFile); transformFile(@ARGV)" testdata/UnnestCoord zeens.a zeens-flatCoord.a

echo "-- For folder. --"
perl -I ./ -e "use LvCorporaTools::TreeTransf::UnnestCoord qw(processDir); processDir(@ARGV)" testdata/UnnestCoord
