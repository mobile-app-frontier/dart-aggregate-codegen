import 'package:annotator/annotations.dart';

abstract interface class Greetings {
  void sayHi();
}

@Analyse()
class Drama implements Greetings {
  final double amountCollected;

  const Drama() : amountCollected = 0.0;

  const Drama.withValue(this.amountCollected);

  factory Drama.fromJson(Map<String, dynamic> json) => Drama.withValue(12.1);

  @override
  void sayHi() {
    print("hi I'm Drama!");
  }
}

@Analyse()
class Foo implements Greetings {
  const Foo();

  factory Foo.fromJson(Map<String, dynamic> json) => Foo();

  @override
  void sayHi() {
    print("hi I'm Foo!");
  }
}
