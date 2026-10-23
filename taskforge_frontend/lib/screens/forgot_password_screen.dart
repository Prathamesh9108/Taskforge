import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  void sendResetLink() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Reset instructions sent to your email.'),
        backgroundColor: AppTheme.success,
      ),
    );

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Reset Password'),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Container(
                padding: const EdgeInsets.all(AppTheme.space20),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: AppTheme.radiusLg,
                  border: Border.all(color: AppTheme.cardBorder),
                  boxShadow: AppTheme.cardShadow,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [AppTheme.primary, AppTheme.accentViolet],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: AppTheme.radiusMd,
                          ),
                          child: const Icon(
                            Icons.lock_reset_rounded,
                            size: 26,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Center(
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.textPrimary,
                            letterSpacing: -0.3,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Center(
                        child: Text(
                          'Enter your registered email and we will send password reset instructions.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Email Address',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: emailController,
                        style: const TextStyle(fontSize: 13),
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          hintText: 'alex@company.com',
                          prefixIcon: Icon(Icons.email_outlined, size: 17, color: AppTheme.textMuted),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!value.contains('@')) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 42,
                        child: ElevatedButton(
                          onPressed: sendResetLink,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: AppTheme.radiusMd),
                          ),
                          child: const Text('Send Reset Link', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600)),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Center(
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Back to Sign In', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
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
