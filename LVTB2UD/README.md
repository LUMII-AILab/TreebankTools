# LVTB2UD – tool to convert Latvian Treebank native annotations to Universal Dependencies

## Requirements
- Java, IDK, 25?
- access to Internet to get lv.ailab.morphology from Maven

## Building

From commandline:
- `./gradlew build` to get jar without dependencies
- `./gradlew bootJar` to get full jar with dependencies


## Running 

Assuming Gradle produced `./build/libs/LVTB2UD.jar` containing all dependencies then running `java -jar ./build/libs/LVTB2UD.jar` will produce documentation on all possible parameters. However, most important invocation examples are:

- **For LV**: `java -jar ./build/libs/LVTB2UD.jar add_node_ids=true omit_whole_files=true` (assumes data in `./data/pml`)
- **For LTG**: `java -jar ./build/libs/LVTB2UD.jar add_node_ids=true omit_whole_files=true latgalian=true` (assumes data in `./data/pml`)
- **For LV testing on `./testdata` forlder** `java -jar ./build/libs/LVTB2UD.jar add_node_ids=true omit_whole_files=false input=./testdata/pml output=./testdata/conll-u log=./testdata/log` (omits only truly broken sentences, not whole file with a broken sentence)
