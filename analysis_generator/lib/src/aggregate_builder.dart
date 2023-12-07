import 'dart:async';

import 'package:build/build.dart';
import 'package:glob/glob.dart';
import 'package:path/path.dart' as p;
import 'package:source_gen/source_gen.dart';

class AggregateBuilder extends Builder {
  final _fileScope = Glob('lib/**');
  final outputBuffer = StringBuffer();
  final Generator generator;
  final placeholderMap = <String, StringBuffer>{};

  AggregateBuilder(this.generator);

  @override
  Map<String, List<String>> get buildExtensions => {
        r'$lib$': ['main.dart'],
      };

  @override
  FutureOr<void> build(BuildStep buildStep) async {
    outputBuffer.clear();
    final files = await _createContentForEachFileInScope(buildStep);
    return _writeToSingleAsset(buildStep, files);
  }

  Future<List<String>> _createContentForEachFileInScope(
      BuildStep buildStep) async {
    List<String> files = [];
    await for (final fileAsset in buildStep
        .findAssets(_fileScope)
        .where((asset) => asset.extension == '.dart')) {
      if (await buildForFiles(fileAsset, buildStep, outputBuffer)) {
        // fileAsset.path property is 'lib/foo/bar/char.dart'
        // fileAsset.pathSegments art ['lib', 'foo', 'bar, 'char']
        // remove first segment because we want create "import 'foo/bar/char.dart';"
        files.add(fileAsset.pathSegments.sublist(1).join("/"));
      }
    }
    return files;
  }

  Future<bool> buildForFiles(
    AssetId inputId,
    BuildStep buildStep,
    StringBuffer outputBuffer,
  ) async {
    final library = await _getLibraryFor(inputId, buildStep);
    final output = await generator.generate(library, buildStep);
    outputBuffer.writeln(output);
    return !(output?.isEmpty ?? true);
  }

  FutureOr<void> _writeToSingleAsset(
      BuildStep buildStep, List<String> addedFiles) {
    try {
      var str = """
${addedFiles.map((path) => "import '${path}';").join("\n")}

${_getAlertString()}

void main() {
  ${outputBuffer.toString()}
}
""";

      return buildStep.writeAsString(
        _getOutputAssetId(buildStep),
        str,
      );
    } catch (exception) {
      print('unable to write file reason: $exception');
    }
  }

  Future<LibraryReader> _getLibraryFor(
      AssetId assetId, BuildStep buildStep) async {
    final element = await buildStep.resolver.libraryFor(assetId);
    return LibraryReader(element);
  }

  AssetId _getOutputAssetId(BuildStep buildStep) {
    print('Package: ${buildStep.inputId.package}');
    print('Asset Path: ${buildStep.inputId.path}');
    print('Set Path: ${p.join('lib', 'main.dart')}');
    return AssetId(
      buildStep.inputId.package,
      p.join('lib', 'main.dart'),
    );
  }

  String _getAlertString() {
    return """
//*******************************************
// GENERATED CODE - DO NOT MODIFY BY HAND");
//*******************************************
""";
  }
}
