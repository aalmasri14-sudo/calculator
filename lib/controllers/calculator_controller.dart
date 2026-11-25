import 'package:flutter/foundation.dart';

import '../models/calculator_model.dart';

/// يدير حالة الحاسبة ويربط الواجهة بالـModel
class CalculatorController extends ChangeNotifier {
  final CalculatorModel _calculatorModel = CalculatorModel();

  String _result = '0';
  String? _errorMessage;
  String? _selectedOperation;

  /// يرجع الناتج الحالي
  String get result => _result;

  /// يرجع رسالة الخطأ الحالية أو null إذا لم يوجد خطأ
  String? get errorMessage => _errorMessage;

  /// يرجع العملية الحسابية المختارة
  String? get selectedOperation => _selectedOperation;

  /// يخزن العملية المختارة ويبلغ الواجهة بالتغيير
  void selectOperation(String operation) {
    const supportedOperations = {'+', '-', '×', '÷'};

    if (!supportedOperations.contains(operation)) {
      _errorMessage = 'العملية الحسابية غير مدعومة';
      notifyListeners();
      return;
    }

    _selectedOperation = operation;
    _errorMessage = null;
    notifyListeners();
  }

  /// يتحقق من الأرقام والعملية ثم يطلب من الـModel حساب الناتج
  void calculate({
    required String firstNumber,
    required String secondNumber,

    // هذا الوسيط مؤقت للتوافق مع الواجهة الحالية سنحذفه بعد تعديلها
    String? operation,
  }) {
    final operationToUse = operation ?? _selectedOperation;

    if (operationToUse == null) {
      _result = '0';
      _errorMessage = 'يرجى اختيار العملية الحسابية';
      notifyListeners();
      return;
    }

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
        operation: operationToUse,
      );

      _result = _formatResult(calculatedResult);
      _errorMessage = null;
    } on ArgumentError catch (error) {
      _result = '0';
      _errorMessage = error.message?.toString() ?? 'تعذر تنفيذ العملية';
    }

    notifyListeners();
  }

  /// يمسح الناتج والخطأ والعملية المختارة
  void clear() {
    _result = '0';
    _errorMessage = null;
    _selectedOperation = null;
    notifyListeners();
  }

  /// يحذف `.0` من نهاية الناتج إذا كان عددًا صحيحا
  String _formatResult(double value) {
    final formattedValue = value.toString();

    if (formattedValue.endsWith('.0')) {
      return formattedValue.substring(0, formattedValue.length - 2);
    }

    return formattedValue;
  }
}
