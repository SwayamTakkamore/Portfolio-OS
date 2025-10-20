import 'package:flutter/material.dart';
import 'desktop_screen.dart';
import '../constants/app_colors.dart';

class LockScreen extends StatefulWidget {
  const LockScreen({super.key});

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  int _step = 1;
  String _enteredUsername = '';
  String _error = '';

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_step == 1) {
      final username = _usernameController.text.trim();
      if (username.isEmpty) {
        setState(() => _error = 'Please enter username');
        return;
      }
      setState(() {
        _enteredUsername = username;
        _step = 2;
        _error = '';
      });
    } else {
      final password = _passwordController.text;
      if (_enteredUsername.toLowerCase() == 'void' && password == 'voidroot') {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const DesktopScreen()),
        );
      } else {
        setState(() => _error = 'Invalid credentials');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.bgPrimary,
              AppColors.bgPrimary.withOpacity(0.8),
              AppColors.accent.withOpacity(0.1),
            ],
          ),
        ),
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _step == 1 ? _buildUsernameStep() : _buildPasswordStep(),
          ),
        ),
      ),
    );
  }

  Widget _buildUsernameStep() {
    return Container(
      key: const ValueKey('username'),
      width: 400,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.bgPanel.withOpacity(0.9),
            AppColors.bgPanel.withOpacity(0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.accent.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 30,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [AppColors.accent, AppColors.accent2],
              ),
            ),
            child: const Icon(
              Icons.person,
              size: 40,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Enter Username',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _usernameController,
            autofocus: true,
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.bgPrimary.withOpacity(0.5),
              hintText: 'Username',
              hintStyle: TextStyle(color: AppColors.textSecondary),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              prefixIcon:
                  const Icon(Icons.person_outline, color: AppColors.accent),
            ),
            onSubmitted: (_) => _handleSubmit(),
          ),
          if (_error.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              _error,
              style: const TextStyle(color: AppColors.error),
            ),
          ],
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _handleSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Continue',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordStep() {
    return Container(
      key: const ValueKey('password'),
      width: 400,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.bgPanel.withOpacity(0.9),
            AppColors.bgPanel.withOpacity(0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.accent.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 30,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [AppColors.accent, AppColors.accent2],
              ),
            ),
            child: const Icon(
              Icons.lock,
              size: 40,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Welcome, $_enteredUsername',
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _passwordController,
            autofocus: true,
            obscureText: true,
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.bgPrimary.withOpacity(0.5),
              hintText: 'Password',
              hintStyle: TextStyle(color: AppColors.textSecondary),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              prefixIcon:
                  const Icon(Icons.lock_outline, color: AppColors.accent),
            ),
            onSubmitted: (_) => _handleSubmit(),
          ),
          if (_error.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              _error,
              style: const TextStyle(color: AppColors.error),
            ),
          ],
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _handleSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Login',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
