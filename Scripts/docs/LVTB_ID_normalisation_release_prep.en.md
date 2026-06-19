# Format check-ups and ID normalization for LVTB.

Lets assume that `.` folder is `TreebankTools/Scripts` and that data to be checked is flattly (no subfolders!) coppied in folder `./data/original`. Results wil be given in the `./data/normalizedIds`.

## First phase -- checking (FIXME: needs Linux update!)

1. Run check for whether w file matches original text.
2. Run ID check.
3. Review output for errors, fix errors, repeat this phase until no errors.

```
perl -e "use LvCorporaTools::PMLUtils::CheckW qw(processDir); processDir(@ARGV)" data/original
@if exist ./data/checkedW rmdir ./data/checkedW /Q /S >nul
@move ./data/original/res ./data/checkedW >nul
@copy ./data/original/*.a ./data/checkedW >nul
@copy ./data/original/*.m ./data/checkedW >nul

@if exist ./data/checkedAll rmdir ./data/checkedAll /Q /S >nul
@mkdir ./data/checkedAll >nul
@copy ./data/checkedW/*.a ./data/checkedAll/ >nul
@copy ./data/checkedW/*.m ./data/checkedAll/ >nul
@copy ./data/checkedW/*.w ./data/checkedAll/ >nul
perl -e "use LvCorporaTools::PMLUtils::CheckLvPml qw(processDir); processDir(@ARGV)" data/checkedAll A
```

## Secong phase -- ID normalisation (FIXME: needs Linux update!)

1. Run ID normalization.
2. Run ID check to ensure that normalization broke nothing.
3. Review output for errors, if there are errors, fix normalizing script.

```
perl -e "use LvCorporaTools::PMLUtils::NormalizeIds qw(processDir); processDir(@ARGV)" data/checkedAll 0 0
@if exist ./data/normalizedIds rmdir ./data/normalizedIds /Q /S >nul
@move ./data/checkedAll/res ./data/normalizedIds >nul
perl -e "use LvCorporaTools::PMLUtils::CheckLvPml qw(processDir); processDir(@ARGV)" data/normalizedIds A
```

## Finish

1. Copy results (.a + .m + .w files) from `./data/normalizedIds` to appropriate place in `Treebank/Corpora`
2. If you need to track ID changes (for SemBank), collect the `.log` files as well.
3. When everything in `Treebank/Corpora` has been checked, push results must be pushed in `Treebank` repository branch _normalizedIds_. Only such states where whole `Treebank` is normalized should be pushed to _normalizedIds_ branch!!!
