#!/bin/sh

cd ..

echo "-- Knit-in single A file. --"
perl -I ./ -e "use LvCorporaTools::PMLUtils::Knit qw(knit); knit(@ARGV)" testdata/Knit zeens.a zeens-a.pml

echo "-- Knit-in single M file. --"
perl -I ./ -e "use LvCorporaTools::PMLUtils::Knit qw(knit); knit(@ARGV)" testdata/Knit zeens.m zeens-m.pml

echo "-- Process a folder with filesets containing A files. --"
perl -I ./ -e "use LvCorporaTools::PMLUtils::Knit qw(processDir); processDir(@ARGV)" testdata/Knit/ a

echo "-- Process a folder with filesets containing M files. --"
perl -I ./ -e "use LvCorporaTools::PMLUtils::Knit qw(processDir); processDir(@ARGV)" testdata/Knit/ m
