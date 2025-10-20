import 'package:flutter/material.dart';
import 'dart:async';
import 'lock_screen.dart';
import '../constants/app_colors.dart';

class BootScreen extends StatefulWidget {
  const BootScreen({super.key});

  @override
  State<BootScreen> createState() => _BootScreenState();
}

class _BootScreenState extends State<BootScreen> {
  final List<String> _bootLogs = [
    'Initializing system...',
    'Loading kernel modules...',
    'Starting network services...',
    'Mounting file systems...',
    'Loading user interface...',
    'Starting desktop environment...',
    'System ready!',
  ];

  int _currentLogIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startBootSequence();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startBootSequence() {
    _timer = Timer.periodic(const Duration(milliseconds: 600), (timer) {
      if (_currentLogIndex < _bootLogs.length) {
        setState(() {
          _currentLogIndex++;
        });
      } else {
        timer.cancel();
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const LockScreen()),
            );
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Boot logs
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (int i = 0;
                        i < _currentLogIndex && i < _bootLogs.length;
                        i++)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.success.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                '[ OK ]',
                                style: TextStyle(
                                  color: AppColors.success,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _bootLogs[i],
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 14,
                                  fontFamily: 'monospace',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    // Loading indicator
                    if (_currentLogIndex < _bootLogs.length)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.accent,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Loading...',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 14,
                                fontFamily: 'monospace',
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
            // Progress bar
            const SizedBox(height: 20),
            Container(
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.bgPanel,
                borderRadius: BorderRadius.circular(2),
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 600),
                    width: constraints.maxWidth *
                        (_currentLogIndex / _bootLogs.length),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.accent, AppColors.accent2],
                      ),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
