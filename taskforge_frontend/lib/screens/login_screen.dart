import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'register_screen.dart';
import 'forgot_password_screen.dart';
import 'dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController =
      TextEditingController(text: 'alex@taskforge.io');
  final TextEditingController _passwordController =
      TextEditingController(text: '123456');

  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const DashboardScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
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
                      // Logo
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
                            Icons.bolt_rounded,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      const Center(
                        child: Text(
                          'Welcome to TaskForge',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.textPrimary,
                            letterSpacing: -0.3,
                          ),
                        ),
                      ),

                      const SizedBox(height: 4),

                      const Center(
                        child: Text(
                          'Sign in to access your projects and tasks',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12.5,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),
                      const Divider(height: 1),
                      const SizedBox(height: 16),

                      // Email Field
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
                        controller: _emailController,
                        style: const TextStyle(fontSize: 13),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          hintText: 'name@company.com',
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

                      const SizedBox(height: 14),

                      // Password Field
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Password',
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ForgotPasswordScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              'Forgot?',
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        style: const TextStyle(fontSize: 13),
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _login(),
                        decoration: InputDecoration(
                          hintText: 'Enter your password',
                          prefixIcon: const Icon(Icons.lock_outline, size: 17, color: AppTheme.textMuted),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                              size: 17,
                              color: AppTheme.textMuted,
                            ),
                            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      // Submit Button
                      SizedBox(
                        width: double.infinity,
                        height: 42,
                        child: ElevatedButton(
                          onPressed: _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: AppTheme.radiusMd),
                          ),
                          child: const Text(
                            'Sign In',
                            style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Footer
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Don't have an account?",
                              style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const RegisterScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                'Sign Up',
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
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
