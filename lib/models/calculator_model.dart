class CalculatorModel {
  /// ينفّذ العملية الحسابية ويرجع الناتج
  double calculate({
    required double firstNumber,
    required double secondNumber,
    required String operation,
  }) {
    switch (operation) {
      case '+':
        return firstNumber + secondNumber;

      case '-':
        return firstNumber - secondNumber;

      case '×':
        return firstNumber * secondNumber;

      case '÷':
        if (secondNumber == 0) {
          throw ArgumentError('لا يمكن القسمة على صفر');
        }
        return firstNumber / secondNumber;

      default:
        throw ArgumentError('العملية الحسابية غير مدعومة');
    }
  }
}