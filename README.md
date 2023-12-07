# dart-aggregate-codegen
* forked from https://github.com/sagrgpt/dart-code-generation/tree/aggregateAnalyser
* Original Author's blog : https://sprout.nurture.farm/code-generation-with-an-aggregate-builder-d8bd25996a27

Changes from original code are,
 - Updated environment and dependency versions to make it runnable on latest dart platform
 - Generates 'main.dart' other then 'analysis.gen.txt'
 - Added Greetings interface and main.dart invokes each classes' sayHi() function

## How to run
1. go to example directory

    <code>$ cd example</code>

2. get dependencies

    <code>$ dart pub get</code>
    
3. run build

   <code>$ dart run build_runner build</code>
   
5. check generated 'main.dart' file works fine.

   <code>$ dart ./lib/main.dart</code>
   
