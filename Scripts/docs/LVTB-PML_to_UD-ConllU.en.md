# Step by step converting LVTB to UD and preparing UD release

Lets assume that folder `Treebank/Corpora` or `Treebank/LTG` is copied to this repo `TreebankTools/Scripts/data`. Lets also assume that `.` location is `TreebankTools/Scripts` and that `Treebank` folder is right next to `TreebankTools`


## Ignores

In some releases one might need to remove manually sample data from folder `./data/Corpora/Paraugi`. However, for standard UDrelease TDT file handles this, and for Sembank release -- the Sembank ignore file.


## Preparing LVTB data for transforming

```
perl -I ./ LvCorporaTools/UIs/TreeTransformatorUI.pm --dir data --collect --ord mode=TOKEN --knit
```

## Converting to UD

1. Copy all the data from `./data/knitted` to the compiled `LVTB2UD` tool's data folder (with default configuration it is `TreebankTools/LVTB2UD/data`)
2. Run accoding to `TreebankTools/LVTB2UD/README.md`, something like 
`java -jar LVTB2UD.jar add_node_ids=true omit_whole_files=true` or
`java -jar ./build/libs/LVTB2UD.jar add_node_ids=true omit_whole_files=true latgalian=true`
3. Results by default are in `TreebankTools/LVTB2UD/data/conll-u`


## Data splits

1. Copy results from `CorporaTools/LVTB2UD/data/conll-u` to `./data/conll-u`
2. Create data splits in folders `./data/train`, `./data/test`, `./data/dev` and `./data/skip` by
```
perl -I ./ -e "use LvCorporaTools::DataSelector::SplitByList qw(splitTDT); splitTDT(@ARGV)" data/conll-u ../../Treebank/Datasplits/testdevtrain.tsv data
```
3. Fold everything neatly (assumed files are separated in folders "train", "test", "dev") into singular files
```
perl -I ./ LvCorporaTools/UIs/TreeTransformatorUI.pm --dir data/train --fold p=1 name=lv_lvtb-ud-train
perl -I ./ LvCorporaTools/UIs/TreeTransformatorUI.pm --dir data/test --fold p=1 name=lv_lvtb-ud-test
perl -I ./ LvCorporaTools/UIs/TreeTransformatorUI.pm --dir data/dev --fold p=1 name=lv_lvtb-ud-dev
perl -I ./ LvCorporaTools/UIs/TreeTransformatorUI.pm --dir data/conll-u --fold p=1 name=lv_lvtb-ud-everything
```
4. Collect folded files from `./data/conll-u/fold`, `./data/train/fold`, `./data/dev/fold`, `./data/test/fold`
5. Make additional file for more convenient validation and satistics calculation by concatenating train, test, dev: lv_lvtb-ud-tb = lv_lvtb-ud-train + lv_lvtb-ud-test + lv_lvtb-ud-dev

All together:
```
perl -I ./ -e "use LvCorporaTools::DataSelector::SplitByList qw(splitTDT); splitTDT(@ARGV)" data/conll-u ../../Treebank/Datasplits/testdevtrain.tsv data ;\
perl -I ./ LvCorporaTools/UIs/TreeTransformatorUI.pm --dir data/train --fold p=1 ext=conllu name=lv_lvtb-ud-train ;\
perl -I ./ LvCorporaTools/UIs/TreeTransformatorUI.pm --dir data/test --fold p=1 ext=conllu name=lv_lvtb-ud-test ;\
perl -I ./ LvCorporaTools/UIs/TreeTransformatorUI.pm --dir data/dev --fold p=1 ext=conllu name=lv_lvtb-ud-dev ;\
perl -I ./ LvCorporaTools/UIs/TreeTransformatorUI.pm --dir data/conll-u --fold p=1 ext=conllu name=lv_lvtb-ud-everything ;\
rm -rf data/fold ;\
mv -f data/train/fold data/fold && rm -rf data/train/fold ;\
mv -f data/test/fold/* data/fold/ && rm -rf data/test/fold ;\
mv -f data/dev/fold/* data/fold/ && rm -rf data/dev/fold ;\
perl -I ./ LvCorporaTools/UIs/TreeTransformatorUI.pm --dir data/fold --fold p=1 ext=conllu name=lv_lvtb-ud-tb ;\
mv -f data/fold/fold/* data/fold/ && rm -rf data/fold/fold ;\
mv -f data/conll-u/fold/* data/fold/ && rm -rf data/conll-u/fold
```

## Delivery

1. Convert everything to Linux line endings, if need be
2. Rename files from `.conll` to `.conllu`, if need be
3. Copy `lv_lvtb-ud-train.conllu`, `lv_lvtb-ud-test.conllu`, `lv_lvtb-ud-dev.conllu` to repository folder `UD_Latvian-LVTB`
4. Take `./data/skip/c70-Cairo.conllu`, copy to repository folder `UD_Latvian-Cairo` and rename it to `lv_cairo-ud-test.conllu`
`cp data/skip/c70-Cairo.conllu data/fold/lv_cairo-ud-test.conllu`
5. Or, for Latgalian, take the only file in `conll-u` folder, that is, `ltg-Cairo.conllu`, copy to repository folder `UD_Latgalian-Cairo` and rename it to `ltg_cairo-ud-test.conllu`.


## Validation and stats

### First setup
0. Get newest Python 3.
1. Get UD tools version from github to folder some folder `tools`.
2. In case of Linux set up Python _venv_ in `tools/.venv` by `python3 -m venv ./.venv` while in `tools` folder, and further use `./.venv/bin/python` or `./.venv/bin/pip` instead of system-wide comands `python3` and `pip`
3. As of 2026-10-12, next step is to install dependencies by `pip install -r requirements.txt` or `./.venv/bin/pip install -r requirements.txt` if the _venv_ from previous step is used.
4. For _perl_ statistics tool `JSON::Parse` from CPAN is needed.


### Version process
Lets assume that next to `tools` folder are UD repository folders `UD_Latvian-LVTB`, `UD_Latvian-Cairo` and `UD_Latgalian-Cairo`.
1. Copy `lv_lvtb-ud-tb.conllu` and `lv_lvtb-ud-everything.conllu` files to that `tools` folder.
2. Validating corpus files from `tools` as `.` folder:
```
./.venv/bin/python validate.py --lang=lv ../UD_Latvian-LVTB/lv_lvtb-ud-train.conllu
./.venv/bin/python validate.py --lang=lv ../UD_Latvian-LVTB/lv_lvtb-ud-dev.conllu
./.venv/bin/python validate.py --lang=lv ../UD_Latvian-LVTB/lv_lvtb-ud-test.conllu
./.venv/bin/python validate.py --lang=lv ../UD_Latvian-Cairo/lv_cairo-ud-test.conllu
./.venv/bin/python validate.py --lang=ltg ../UD_Latgalian-Cairo/ltg_cairo-ud-test.conllu
```
4. If you want to validate full corpus located in `tools`, do one of these:
```
./.venv/bin/python validate.py --lang=lv lv_lvtb-ud-everything.conllu
./.venv/bin/python validate.py --lang=lv --max-err=0 lv_lvtb-ud-everything.conllu > ud-validator-full.lv.log 2>&1
```
or to validate corpus to be published without ommited example sentences, do one of these
```
./.venv/bin/python validate.py --lang=lv lv_lvtb-ud-tb.conllu
./.venv/bin/python validate.py --lang=lv --max-err=0 lv_lvtb-ud-tb.conllu > ud-validator-corpus.lv.log 2>&1
```
5. Get `stats.xml` for big corpus (not mandatory, as Dan does it anyway, but interesting)
```
perl conllu-stats.pl < lv_lvtb-ud-tb.conllu > stats.xml ;\
mv -f stats.xml ../UD_Latvian-LVTB/
```
6. Update UD readme with new TDT sentence counts and numbers in the first paragraph.


## Don't forget to commit everything in `UD_Latvian-LVTB`, `UD_Latvian-Cairo` and `UD_Latgalian-Cairo`
