import 'package:flutter/foundation.dart';

import '../models/calculator_model.dart';

/// يدير حالة الحاسبة ويربط الواجهة بالـModel
class CalculatorController extends ChangeNotifier {
  final CalculatorModel _calculatorModel = CalculatorModel();

  String _result = '0';
  String? _errorMessage;

  /// يرجع الناتج الحالي لعرضه في الواجهة
  String get result => _result;

  /// يرجع رسالة الخطأ الحالية، أو null إذا ما في خطأ
  String? get errorMessage => _errorMessage;

  /// يتحقق من الرقمين ثم يطلب من الـModel تنفيذ العملية
  void calculate({
    required String firstNumber,
    required String secondNumber,
    required String operation,
  }) {
    final first = double.tryParse(firstNumber.trim());
    final second = double.tryParse(secondNumber.trim());

    if (first == null ||
        second == null ||
        !first.isFinite ||
        !second.isFinite) {
      _result = '0';
      _errorMessage = 'يرجى إدخال رقمين صالحين';
      notifyListeners();
      return;
    }

    try {
      final calculatedResult = _calculatorModel.calculate(
        firstNumber: first,
        secondNumber: second,
        operation: operation,
      );

      _result = _formatResult(calculatedResult);
      _errorMessage = null;
    } on ArgumentError catch (error) {
      _result = '0';
      _errorMessage = error.message?.toString() ?? 'تعذّر تنفيذ العملية';
    }

    notifyListeners();
  }

  /// يمسح الناتج ورسالة الخطأ ويبلغ الواجهة بالتغيير
  void clear() {
    _result = '0';
    _errorMessage = null;
    notifyListeners();
  }

  /// يحذف `.0` من نهاية الناتج إذا كان عددت صحيحا
  String _formatResult(double value) {
    final formattedValue = value.toString();

    if (formattedValue.endsWith('.0')) {
      return formattedValue.substring(0, formattedValue.length - 2);
    }

    return formattedValue;
  }
}
