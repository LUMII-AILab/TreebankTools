# Format check-ups and ID normalization for LVTB.

Lets assume that `.` folder is `TreebankTools/Scripts` and that data to be checked is flattly (no subfolders!) coppied in folder `./data/original`. Results wil be given in the `./data/normalizedIds`, renamed ID logs will be collected in `./logs/`. Script examples in this readme assumes Linux terminal.

## First phase -- checking

1. Run check for whether w file matches original text.
2. Run ID check.
3. Review output for errors, fix errors, repeat this phase until no errors.

```
perl -I ./ -e "use LvCorporaTools::PMLUtils::CheckW qw(processDir); processDir(@ARGV)" data/original ;\
rm -rf ./data/checkedW ;\
mv ./data/original/res ./data/checkedW ;\
cp ./data/original/*.a ./data/checkedW ;\
cp ./data/original/*.m ./data/checkedW ;\
rm -rf ./data/checkedAll ;\
mkdir ./data/checkedAll ;\
cp ./data/checkedW/*.a ./data/checkedAll/ ;\
cp ./data/checkedW/*.m ./data/checkedAll/ ;\
cp ./data/checkedW/*.w ./data/checkedAll/ ;\
perl -I ./ -e "use LvCorporaTools::PMLUtils::CheckLvPml qw(processDir); processDir(@ARGV)" data/checkedAll A ;\
rm -rf ./data/checkedAll-errs ;\
mkdir ./data/checkedAll-errs ;\
mv ./data/checkedAll/*.txt ./data/checkedAll-errs ;\
echo "Check for errors in terminal and ./data/checkedAll-errs!"
```

## Secong phase -- ID normalisation

1. Run ID normalization.
2. Run ID check to ensure that normalization broke nothing.
3. Review output for errors, if there are errors, fix normalizing script.

```
perl -I ./ -e "use LvCorporaTools::PMLUtils::NormalizeIds qw(processDir); processDir(@ARGV)" data/checkedAll 0 0 ;\
rm -rf ./data/normalizedIds ;\
mv ./data/checkedAll/res ./data/normalizedIds ;\
perl -I ./ -e "use LvCorporaTools::PMLUtils::CheckLvPml qw(processDir); processDir(@ARGV)" data/normalizedIds A ;\
rm -rf ./data/normalizedIds-errs ;\
mkdir ./data/normalizedIds-errs ;\
mv ./data/normalizedIds/*.txt ./data/normalizedIds-errs ;\
mkdir -p ./logs ;\
find ./data/normalizedIds/ -name '*.log' -exec mv -t ./logs {} + ;\
echo "Check for errors in terminal and ./data/normalizedIds-errs!"

```
Piezīme: `find ./data/normalizedIds/ -name '*.log' -exec mv -t ./logs {} +` var aizstāt ar `mv ./data/normalizedIds/*.log ./logs`, ja netraucē, ka logu trūkuma gadījumā parādās brīdinājums.


## Finish

1. Copy results (.a + .m + .w files) from `./data/normalizedIds` to appropriate place in `Treebank/Corpora`
2. If you need to track ID changes (for SemBank), collect the `.log` files as well.
3. When everything in `Treebank/Corpora` has been checked, push results must be pushed in `Treebank` repository branch _normalizedIds_. Only such states where whole `Treebank` is normalized should be pushed to _normalizedIds_ branch!!!
