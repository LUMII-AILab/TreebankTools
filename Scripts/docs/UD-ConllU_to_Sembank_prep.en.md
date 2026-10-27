# Preparing UD (CoNLL-U) data for Sembank

1. Use only Treebank's _normalizedIds_ branch.
2. Obtain CoNLL-U files as for UD, but do not split TDT and do not fold together in one file.

Let's assume all CoNLL-U files are in `TreebankTools/Scripts/data/conll-u`. Let's also assume `Treebank` repository folder is right next to `Treebanktools`.


## Clean according to Sembank ignore list

```
perl -I ./  -e "use LvCorporaTools::DataSelector::SplitByList qw(splitOnOffList); splitOnOffList(@ARGV)" data/conll-u ../../Treebank/Datasplits/SemBank-ignored.tsv data ;\
mv ./data/on-list ./data/ignore ;\
mv ./data/off-list ./data/good
```

## Split into paragraphs

1. If "Verbu rindkopas" still uses the old naming convention for paragraphs, e.g., c1_r15-p1, they should not undergo paragraph splitting transformation, as it would make file names and IDs wrong for these files, e.g., _c1_r15.conllu_ to _c1_r15-p1.conllu_. To separate "Verbu rindkopas" one can dom something like this:
```
mkdir ./data/verbPar ;\
mv ./data/good/*_r*.conllu ./data/verbPar >nul
```
2. Split into paragraphs:
```
rm -rf ./data/splitedPar ;\
perl -I ./ -e "use LvCorporaTools::DataSelector::SplitConll2Para qw(processDir); processDir(@ARGV)" data/good ;\
mv ./data/good/res ./data/splitedPar
```
3. If you separated "Verbu rindkopas" earlier, for next step use data both in `verbPar` and `splitedPar`.


## Update `Sembank` repo

1. Delete everything in `Sembank/UD`
2. Copy data obtained above into `Sembank/UD`
3. Copy `status.log` and `ids.log` obtained during transformation to UD to `Sembank/scripts/Kamols-to-UD.log` and `Sembank/scripts/Kamols-to-UD-ids.log` accordingly

1-3 together, assuming `Sembank` repo is right next to `TreebankTools`, the working dir is `TreebankTools/Scripts` and the logs are copied in `TreebankTools/Scripts/data/log`
```
cd ../.. ;\
rm -rf Sembank/UD ;\
cp -r TreebankTools/Scripts/data/splitedPar Sembank/UD ;\
cp TreebankTools/Scripts/data/log/status.log Sembank/scripts/Kamols-to-UD.log ;\
cp TreebankTools/Scripts/data/log/ids.log Sembank/scripts/Kamols-to-UD-ids.log
```

4. Update `Sembank/scripts/Kamols-source.txt` with links to precise `Treebank` and `TreebankTools` commits used to prepare this version.


## Commit `Sembank`

Don't forget it :)
