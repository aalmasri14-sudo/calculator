import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controllers/calculator_controller.dart';
import 'views/calculator_view.dart';

/// يبدأ التطبيق ويوفر الـController لبقية الشاشات
void main() {
  runApp(
    ChangeNotifierProvider<CalculatorController>(
      create: (_) => CalculatorController(),
      child: const CalculatorApp(),
    ),
  );
}

/// يمثل التطبيق ويحدد الثيم والشاشة الرئيسية
class CalculatorApp extends StatelessWidget {
  /// ينشئ التطبيق الرئيسي
  const CalculatorApp({super.key});

  /// يبني التطبيق ويعرض شاشة الحاسبة
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF111315),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF7A00),
          brightness: Brightness.dark,
        ),
      ),
      home: const CalculatorView(),
    );
  }
}