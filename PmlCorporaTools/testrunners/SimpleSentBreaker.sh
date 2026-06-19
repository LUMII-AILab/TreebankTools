#!/bin/sh

cd ..
perl -I ./ -e "use LvCorporaTools::GenericUtils::SimpleSentBreaker qw(simpleSentBreaker); simpleSentBreaker(@ARGV)" testdata/SimpleSentBreaker/data testdata/SimpleSentBreaker/res UTF-8
