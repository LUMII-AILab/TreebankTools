# LvCorporaTools::UIs::TreeTransformatorUI package


- Get help
```
perl -I ./ LvCorporaTools/UIs/TreeTransformatorUI.pm
```

- Collect data, reorder token nodes only and knit in
```
perl -I ./ LvCorporaTools/UIs/TreeTransformatorUI.pm --dir data --collect --ord mode=TOKEN --knit
```

- Collect data, remove AUTO/FIXME files and reorder all nodes 
```
perl -I ./ LvCorporaTools/UIs/TreeTransformatorUI.pm --dir data --collect --clean --ord mode=NODE
```

- Count different roles in a conll file
```
perl -I ./ LvCorporaTools/RoleCounter.pm data/fold corpus.conll
```

- Concatenate all conll files in a single folder
```
perl -I ./ LvCorporaTools/UIs/TreeTransformatorUI.pm --dir data/conll --fold p=1
```

- (Obselete) Obtaing data for old parser experiments "syntax-style", variants
```
perl -I ./  LvCorporaTools/UIs/TreeTransformatorUI.pm --dir data --collect --unnest --dep xpred=DEFAULT coord=DEFAULT pmc=DEFAULT root=0 phdep=1 na=0 subrt=0 --red label=0 --knit --conll label=1 cpostag=FIRST postag=FULL conll09=0 --fold p=1
perl -I ./ LvCorporaTools/UIs/TreeTransformatorUI.pm --dir data --collect --unnest --dep xpred=DEFAULT coord=DEFAULT pmc=DEFAULT root=0 phdep=1 na=0 subrt=0 --red label=0 --knit --conll label=1 cpostag=FIRST postag=FULL conll09=0
```
- (Obselete) Obtaining data for old parser experiments "semantics-style", variants
```
perl -I ./ LvCorporaTools/UIs/TreeTransformatorUI.pm --dir data --collect --unnest --dep xpred=BASELEM coord=ROW pmc=BASELEM root=0 phdep=1 na=0 subrt=0 --red label=0 --knit --conll label=1 cpostag=FIRST postag=FULL conll09=0 --fold p=1
perl -I ./ LvCorporaTools/UIs/TreeTransformatorUI.pm --dir data --collect --unnest --dep xpred=BASELEM coord=ROW pmc=BASELEM root=0 phdep=1 na=0 subrt=0 --red label=0 --knit --conll label=1 cpostag=FIRST postag=FULL conll09=0
```
