import 'package:annotator/annotations.dart';
import 'package:example/widget/drama.dart';

@Analyse()
class TestEvent implements Greetings {
  final String name;
  final String varPath;

  const TestEvent()
      : this.name = "",
        this.varPath = "";

  const TestEvent.withValue(this.name, this.varPath);

  factory TestEvent.fromJson(Map<String, dynamic> json) =>
      TestEvent.withValue('name', '/toPath');

  @override
  void sayHi() {
    print("hi I'm TestEvent!");
  }
}

class DumbEvent {}
