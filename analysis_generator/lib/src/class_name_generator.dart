import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/dart/element/visitor.dart';
import 'package:annotator/annotations.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

class ClassNameGenerator extends GeneratorForAnnotation<Analyse> {
  @override
  dynamic generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    final visitor = ModelVisitor();
    element.visitChildren(visitor);
    return "${visitor.className}()..sayHi();";
  }
}

class ModelVisitor extends SimpleElementVisitor {
  late DartType className;

  @override
  visitConstructorElement(ConstructorElement element) {
    className = element.type.returnType;
  }
}
