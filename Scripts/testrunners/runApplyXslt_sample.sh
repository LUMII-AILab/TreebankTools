#!/bin/sh

cd ..

echo "-- Invocation example for single file (however, currently testdata folder has no appropriate data for this) --"
perl -I ./ -e "use LvCorporaTools::GenericUtils::ApplyXSLT qw(applyXSLT1_0); applyXSLT1_0(@ARGV)" data.xml transform.xsl result.txt
