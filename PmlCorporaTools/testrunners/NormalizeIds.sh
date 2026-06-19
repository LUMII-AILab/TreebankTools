#!/bin/sh

cd ..

echo "-- For single dataset. --"
perl -I ./ -e "use LvCorporaTools::PMLUtils::NormalizeIds qw(normalizeIds); normalizeIds(@ARGV)" testdata/NormalizeIds bildes bildes_p17 bildes 17 3 2 0

echo "-- For multiple datasets. --"
perl -I ./ -e "use LvCorporaTools::PMLUtils::NormalizeIds qw(processDir); processDir(@ARGV)" testdata/NormalizeIds
