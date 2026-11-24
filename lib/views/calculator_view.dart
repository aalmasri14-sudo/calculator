import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/calculator_controller.dart';

/// شاشة الحاسبة الأولية لربط الواجهة بالـController
class CalculatorView extends StatefulWidget {
  /// ينشئ شاشة الحاسبة
  const CalculatorView({super.key});

  /// ينشئ الحالة التي تحفظ مدخلات الشاشة
  @override
  State<CalculatorView> createState() => _CalculatorViewState();
}

class _CalculatorViewState extends State<CalculatorView> {
  static const Color _backgroundColor = Color(0xFF111315);
  static const Color _surfaceColor = Color(0xFF1C2023);
  static const Color _borderColor = Color(0xFF343A3D);
  static const Color _orangeColor = Color(0xFFFF7A00);
  static const Color _neonGreenColor = Color(0xFFC6FF00);
  static const Color _mutedColor = Color(0xFF9BA3A8);

  final TextEditingController _firstNumberController =
  TextEditingController();
  final TextEditingController _secondNumberController =
  TextEditingController();

  String? _selectedOperation;

  /// يحدد العملية الحسابية التي اختارها المستخدم
  void _selectOperation(String operation) {
    setState(() {
      _selectedOperation = operation;
    });
  }

  /// ينشئ حقلًا منسقًا لإدخال أحد الرقمين
  Widget _buildNumberField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text(
            label,
            style: const TextStyle(
              color: _mutedColor,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
        ),
        const SizedBox(height: 9),
        TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(
            decimal: true,
            signed: true,
          ),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
          cursorColor: _orangeColor,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: _mutedColor),
            prefixIcon: Icon(icon, color: _orangeColor),
            filled: true,
            fillColor: _surfaceColor,
            contentPadding: const EdgeInsets.symmetric(vertical: 18),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: _borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: _orangeColor,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// ينشئ زر العملية ويبرزها عند اختيارها
  Widget _buildOperationButton(String operation) {
    final isSelected = _selectedOperation == operation;

    return Expanded(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          color: isSelected ? _orangeColor : _surfaceColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? _orangeColor : _borderColor,
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: isSelected
              ? const [
            BoxShadow(
              color: Color(0x44FF7A00),
              blurRadius: 14,
              offset: Offset(0, 4),
            ),
          ]
              : const [],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => _selectOperation(operation),
            child: SizedBox(
              height: 58,
              child: Center(
                child: Text(
                  operation,
                  style: TextStyle(
                    color: isSelected ? _backgroundColor : Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// يتحقق من اختيار العملية ثم يطلب من الـController حساب الناتج
  void _calculate() {
    final operation = _selectedOperation;

    if (operation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an operation first'),
        ),
      );
      return;
    }

    context.read<CalculatorController>().calculate(
      firstNumber: _firstNumberController.text,
      secondNumber: _secondNumberController.text,
      operation: operation,
    );
  }

  /// يمسح الرقمين والعملية والناتج
  void _clear() {
    _firstNumberController.clear();
    _secondNumberController.clear();

    setState(() {
      _selectedOperation = null;
    });

    context.read<CalculatorController>().clear();
  }
  /// يتخلص من متحكمي حقول الإدخال عند إغلاق الشاشة
  @override
  void dispose() {
    _firstNumberController.dispose();
    _secondNumberController.dispose();
    super.dispose();
  }

  /// يبني الواجهة الأولية للحاسبة
  /// يبني شاشة الحاسبة بتصميم داكن ولمسات برتقالية وخضراء
  @override
  Widget build(BuildContext context) {
    final calculatorController = context.watch<CalculatorController>();

    return Scaffold(
      backgroundColor: _backgroundColor,
      body: SafeArea(
        child: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF202326),
                _backgroundColor,
              ],
            ),
          ),
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: SizedBox(
                width: double.infinity,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(22, 20, 22, 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 54,
                            height: 54,
                            decoration: BoxDecoration(
                              color: _orangeColor,
                              borderRadius: BorderRadius.circular(17),
                            ),
                            child: const Icon(
                              Icons.calculate_rounded,
                              color: _backgroundColor,
                              size: 29,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'CALCULATOR',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1.1,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'SIMPLE • FAST • ACCURATE',
                                  style: TextStyle(
                                    color: _mutedColor,
                                    fontSize: 9,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF252A2D),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: _borderColor),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 7,
                                  height: 7,
                                  decoration: const BoxDecoration(
                                    color: _neonGreenColor,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 7),
                                const Text(
                                  'READY',
                                  style: TextStyle(
                                    color: _neonGreenColor,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.7,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      const Text(
                        "Let's calculate.",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Enter two numbers and select an operation.',
                        style: TextStyle(
                          color: _mutedColor,
                          fontSize: 13,
                        ),
                      ),

                      const SizedBox(height: 26),

                      _buildNumberField(
                        controller: _firstNumberController,
                        label: 'NUMBER 01',
                        hint: 'Enter first number',
                        icon: Icons.looks_one_rounded,
                      ),
                      const SizedBox(height: 18),
                      _buildNumberField(
                        controller: _secondNumberController,
                        label: 'NUMBER 02',
                        hint: 'Enter second number',
                        icon: Icons.looks_two_rounded,
                      ),

                      const SizedBox(height: 27),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'OPERATION',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.1,
                            ),
                          ),
                          Text(
                            _selectedOperation == null
                                ? 'CHOOSE ONE'
                                : 'SELECTED: $_selectedOperation',
                            style: TextStyle(
                              color: _selectedOperation == null
                                  ? _mutedColor
                                  : _orangeColor,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      Row(
                        children: [
                          _buildOperationButton('+'),
                          const SizedBox(width: 9),
                          _buildOperationButton('-'),
                          const SizedBox(width: 9),
                          _buildOperationButton('×'),
                          const SizedBox(width: 9),
                          _buildOperationButton('÷'),
                        ],
                      ),

                      const SizedBox(height: 25),

                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 58,
                              child: OutlinedButton(
                                onPressed: _clear,
                                style: OutlinedButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  foregroundColor: Colors.white,
                                  backgroundColor: _surfaceColor,
                                  side: const BorderSide(color: _borderColor),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.restart_alt_rounded,
                                      color: _mutedColor,
                                      size: 20,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'CLEAR',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.8,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: SizedBox(
                              height: 58,
                              child: ElevatedButton(
                                onPressed: _calculate,
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  foregroundColor: _backgroundColor,
                                  backgroundColor: _neonGreenColor,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '=',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'CALCULATE',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 0.6,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      Container(
                        padding: const EdgeInsets.all(21),
                        decoration: BoxDecoration(
                          color: _surfaceColor,
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(color: _borderColor),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x33000000),
                              blurRadius: 24,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: _orangeColor,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 9),
                                const Text(
                                  'RESULT',
                                  style: TextStyle(
                                    color: _mutedColor,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1.3,
                                  ),
                                ),
                                const Spacer(),
                                const Icon(
                                  Icons.bolt_rounded,
                                  color: _neonGreenColor,
                                  size: 20,
                                ),
                              ],
                            ),
                            const SizedBox(height: 18),
                            Text(
                              calculatorController.result,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: _neonGreenColor,
                                fontSize: 44,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -1.2,
                              ),
                            ),
                            if (calculatorController.errorMessage != null) ...[
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.error_outline_rounded,
                                    color: Color(0xFFFF7676),
                                    size: 18,
                                  ),
                                  const SizedBox(width: 7),
                                  Expanded(
                                    child: Text(
                                      calculatorController.errorMessage!,
                                      style: const TextStyle(
                                        color: Color(0xFFFF7676),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),
                      const Center(
                        child: Text(
                          'FAST • SIMPLE • RELIABLE',
                          style: TextStyle(
                            color: _mutedColor,
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}