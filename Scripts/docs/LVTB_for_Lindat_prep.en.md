# Preparing LVTB for publication on LINDAT and Clarin

1. Collect LVTB data and remove AUTO/FIXME files: coppy `Corpora` folder from `Treebank` into `TreebankTools/Scripts/data` and run
```
perl -I ./ LvCorporaTools/UIs/TreeTransformatorUI.pm --dir data --collect --clean --ord mode=NODE
```

2. Split off the UD skip-files (unite all folders except `skip`)
```
perl -I ./ -e "use LvCorporaTools::DataSelector::SplitByList qw(splitTDT); splitTDT(@ARGV)" data/ord ../../Treebank/Datasplits/testdevtrain.tsv data ;\
rm -rf data/publish ;\
mv data/train data/publish ;\
mv data/test/*.* data/publish && rm -rf data/test ;\
mv data/dev/*.* data/publish && rm -rf data/dev ;\
[ ! -d data/not-mentioned ] || mv data/not-mentioned/*.* data/publish && rm -rf data/not-mentioned
```

3. To publish with LINDAT, a documentation in markdown and `lv-treebank`  extension module (TrEd/Treex) is also needed.

NB! UFAL LINDAT server uses the same lv-treebank version for all LVTB versions, unless specifically asked to do otherwise. Thus, if backwards-uncompatible changes in lv-treebank are introduced, we must negotiate with UFAL before next release.
