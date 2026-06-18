# Preparing LVTB for publication on LINDAT and Clarind

1. Collect LVTB data and remove AUTO/FIXME files
```
perl -I ./ LvCorporaTools/UIs/TreeTransformatorUI.pm --dir data --collect --clean --ord mode=NODE
```

2. Split off the UD skip-files (unite all folders except `skip`) (FIXME: needs Linux update!)
```
perl -e "use LvCorporaTools::DataSelector::SplitByList qw(splitTDT); splitTDT(@ARGV)" data/ord ../../Treebank/Datasplits/testdevtrain.tsv data
mkdir data/publish
move data/train/*.* data/publish >nul
rmdir data/train
move data/test/*.* data/publish >nul
rmdir data/test
move data/dev/*.* data/publish >nul
rmdir data/dev
if exist data/not-mentioned move data/not-mentioned/*.* data/publish >nul
if exist data/not-mentioned rmdir data/not-mentioned
```

3. To publish with LINDAT, a documentation in markdown and `lv-treebank`  extension module (TrEd/Treex) is also needed.

NB! UFAL LINDAT server uses the same lv-treebank version for all LVTB versions, unless specifically asked to do otherwise. Thus, if backwards-uncompatible changes in lv-treebank are introduced, we must negotiate with UFAL before next release.
