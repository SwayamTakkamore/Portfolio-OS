import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/ui_provider.dart';
import 'screens/start_screen.dart';
import 'constants/app_colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UIProvider(),
      child: MaterialApp(
        title: 'Portfolio OS',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: const ColorScheme.dark(
            primary: AppColors.accent,
            secondary: AppColors.accent2,
            surface: AppColors.bgPanel,
          ),
          useMaterial3: true,
        ),
        home: const StartScreen(),
      ),
    );
  }
}
