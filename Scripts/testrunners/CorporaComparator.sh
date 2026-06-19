#!/bin/sh

cd ..

echo "-- Comparison examples: equal, nonequal, second shorter, first shorter. --"
perl -I ./ LvCorporaTools/CorporaComparator.pm testdata/CorporaComparator/zeens-dep-nored.conll testdata/CorporaComparator/zeens-dep-nored-copy.conll
perl -I ./ LvCorporaTools/CorporaComparator.pm testdata/CorporaComparator/zeens-dep-nored.conll testdata/CorporaComparator/zeens-dep-nored-NA.conll
perl -I ./ LvCorporaTools/CorporaComparator.pm testdata/CorporaComparator/zeens-dep-nored.conll testdata/CorporaComparator/zeens-short.conll
perl -I ./ LvCorporaTools/CorporaComparator.pm testdata/CorporaComparator/zeens-short.conll testdata/CorporaComparator/zeens-dep-nored.conll
