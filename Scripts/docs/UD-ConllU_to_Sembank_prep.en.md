# Preparing UD (CoNLL-U) data for Sembank

1. Use only Treebank's _normalizedIds_ branch.
2. Obtain CoNLL-U files as for UD, but do not split TDT and do not fold together in one file.

Let's assume all CoNLL-U files are in `TreebankTools/Scripts/data/conll-u`. Let's also assume `Treebank` repository folder is right next to `Treebanktools`.


## Clean according to Sembank ignore list (FIXME: needs Linux update!)

```
perl -I ./  -e "use LvCorporaTools::DataSelector::SplitByList qw(splitOnOffList); splitOnOffList(@ARGV)" data/conll-u ../../Treebank/Datasplits/SemBank-ignored.tsv data
@move ./data/on-list ./data/ignore >nul
@move ./data/off-list ./data/good >nul
```

## Split into paragraphs (FIXME: needs Linux update!)

1. If "Verbu rindkopas" still uses the old naming convention for paragraphs, e.g., c1_r15-p1, they should not undergo paragraph splitting transformation, as it would make file names and IDs wrong for these files, e.g., _c1_r15.conllu_ to _c1_r15-p1.conllu_. To separate "Verbu rindkopas" one can dom something like this:
```
@mkdir ./data/verbPar >nul
@move ./data/good/*_r*.conllu ./data/verbPar >nul
```
2. Split into paragraphs:
```
@if exist ./data/splitedPar rmdir ./data/splitedPar /Q /S >nul
perl -e "use LvCorporaTools::DataSelector::SplitConll2Para qw(processDir); processDir(@ARGV)" data/good
@move ./data/good/res ./data/splitedPar >nul
```
3. If you separated "Verbu rindkopas" earlier, for next step use data both in `verbPar` and `splitedPar`.


## Update `Sembank` repo

1. Delete everything in `Sembank/UD`
2. Copy data obtained above into `Sembank/UD`
3. Update `Sembank/scripts/Kamols-source.txt` with links to precise `Treebank` and `TreebankTools` commits used to prepare this version.
4. Copy `status.log` and 'ids.log' obtained during transformation to UD to `Sembank/scripts/Kamols-to-UD.log` and `Sembank/scripts/Kamols-to-UD-ids.log` accordingly


## Commit `Sembank`
