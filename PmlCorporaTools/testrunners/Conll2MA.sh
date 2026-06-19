#!/bin/sh

cd ..

echo "-- Process single file set. --"
perl -I ./ -e "use LvCorporaTools::FormatTransf::Conll2MA qw(processFileSet); processFileSet(@ARGV)" testdata/Conll2MA/w/zeens.w  testdata/Conll2MA/m-a testdata/Conll2MA/conll/zeens.conll

echo "-- Process all folder. --"
perl -I ./ -e "use LvCorporaTools::FormatTransf::Conll2MA qw(processDir); processDir(@ARGV)" testdata/Conll2MA/w testdata/Conll2MA/conll testdata/Conll2MA/m-a
