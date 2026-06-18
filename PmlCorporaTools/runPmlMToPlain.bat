REM Single file.
perl -e "use LvCorporaTools::GenericUtils::ApplyXSLT qw(applyXSLT1_0); applyXSLT1_0(@ARGV)" testdata\PmlMToPlain\zeens.m resources\pmlM2plain.xsl testdata\PmlMToPlain\zeens.txt

REM Multiple files in folder.
perl -e "use LvCorporaTools::GenericUtils::ApplyXSLT qw(transformDir); transformDir(@ARGV)" testdata\PmlMToPlain resources\pmlM2plain.xsl testdata\PmlMToPlain\res .m .vert

pause