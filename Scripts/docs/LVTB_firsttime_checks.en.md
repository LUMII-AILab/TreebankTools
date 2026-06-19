# Steps for adding a new source for including in Latvian Treebank.

To add new file to Latvian Treebank, following things must be done:
 * Convert all files to UTF-8 without BOM
 * Do `PMLUtils::Unite` to unite file parts if necessary
 * Do `PMLUtils::CheckW` and use newly-created w file
 * Do `PMLUtils::NormalizeSpaces` to ensure no spaces are lost in m file
 * Do `PMLUtils::CheckLvPml` and solve all identified problems
 * Do `PMLUtils::NormalizeIds` to obtain sequential IDs


## Unite files, if need be

```
perl -I ./ -e "use LvCorporaTools::PMLUtils::Unite qw(unite); unite(@ARGV)" data DIENA_intervija_28012013
```

## Check W

For a whole folder:
```
perl -I ./ -e "use LvCorporaTools::PMLUtils::CheckW qw(processDir); processDir(@ARGV)" data
```
Or for single file:
```
perl -I ./ -e "use LvCorporaTools::PMLUtils::CheckW qw(checkW); checkW(@ARGV)" data filename.w filename.txt
```

## Normalize spaces
```
perl -I ./ -e "use LvCorporaTools::PMLUtils::NormalizeSpaces qw(processDir); processDir(@ARGV)" data 
```

## Check ID consistency
```
perl -I ./ -e "use LvCorporaTools::PMLUtils::CheckLvPml qw(processDir); processDir(@ARGV)" data A
```

## Normalize IDs
For a whole folder:
```
perl -I ./ -e "use LvCorporaTools::PMLUtils::NormalizeIds qw(processDir); processDir(@ARGV)" data
```
Or for single file:
```
perl -I ./ -e "use LvCorporaTools::PMLUtils::NormalizeIds qw(normalizeIds); normalizeIds(@ARGV)" data old_filename new_filename
```

## Other usefull things:

Checking consistency for w and m files, if no a file available:
```
perl -I ./ -e "use LvCorporaTools::PMLUtils::CheckLvPml qw(processDir); processDir(@ARGV)" data/v M
```

Making TrEd filelist from all data files.
```
perl -I ./ LvCorporaTools/GenericUtils/MakeFilelist.pm data LatvianTreebank
```

