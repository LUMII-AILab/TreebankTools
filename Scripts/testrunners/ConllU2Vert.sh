#!/bin/sh

cd ..

echo "-- Process single file. --"
perl -I ./ -e "use LvCorporaTools::FormatTransf::ConllU2Vert qw(processFile); processFile(@ARGV)" testdata/ConllU2Vert/lv_lvtb-ud-tb.conllu
