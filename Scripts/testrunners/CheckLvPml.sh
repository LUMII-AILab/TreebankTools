#!/bin/sh

cd ..

echo "-- For single .w + .m dataset. --"
perl -I ./ -e "use LvCorporaTools::PMLUtils::CheckLvPml qw(checkLvPml); checkLvPml(@ARGV)" testdata/CheckLvPml zeens M

echo "-- For multiple .w + .m + .a datasets. --"
perl -I ./ -e "use LvCorporaTools::PMLUtils::CheckLvPml qw(processDir); processDir(@ARGV)" testdata/CheckLvPml A
