import 'package:math_expressions/math_expressions.dart';

class CalculatorService {
  static const operators = ["*", "/", "-", "+"];
  Parser parser = Parser();

  dynamic calculate({String input}) {
    try {
      Expression exp = parser.parse(input);
      return exp.evaluate(EvaluationType.REAL, null);
    } catch (e) {}

    return null;
  }
}
