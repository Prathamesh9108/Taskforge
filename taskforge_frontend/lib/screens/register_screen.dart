import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'dashboard_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _register() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account created successfully! Welcome to TaskForge.'),
          backgroundColor: AppTheme.success,
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Create Account'),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
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
                      const Text(
                        'Get started with TaskForge',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.textPrimary,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Manage projects and collaborate with your team',
                        style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                      ),
                      const SizedBox(height: 16),
                      const Divider(height: 1),
                      const SizedBox(height: 14),

                      // Full Name
                      _label('Full Name'),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _nameController,
                        style: const TextStyle(fontSize: 13),
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          hintText: 'Alex Morgan',
                          prefixIcon: Icon(Icons.person_outline, size: 17, color: AppTheme.textMuted),
                        ),
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) return 'Please enter your name';
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      // Email
                      _label('Email Address'),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _emailController,
                        style: const TextStyle(fontSize: 13),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          hintText: 'alex@company.com',
                          prefixIcon: Icon(Icons.email_outlined, size: 17, color: AppTheme.textMuted),
                        ),
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) return 'Please enter your email';
                          if (!val.contains('@')) return 'Please enter a valid email';
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      // Password
                      _label('Password'),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        style: const TextStyle(fontSize: 13),
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          hintText: 'At least 6 characters',
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
                        validator: (val) {
                          if (val == null || val.length < 6) return 'Password must be at least 6 characters';
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      // Confirm Password
                      _label('Confirm Password'),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: _obscureConfirmPassword,
                        style: const TextStyle(fontSize: 13),
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _register(),
                        decoration: InputDecoration(
                          hintText: 'Re-enter your password',
                          prefixIcon: const Icon(Icons.lock_outline, size: 17, color: AppTheme.textMuted),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirmPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                              size: 17,
                              color: AppTheme.textMuted,
                            ),
                            onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                          ),
                        ),
                        validator: (val) {
                          if (val != _passwordController.text) return 'Passwords do not match';
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Submit Button
                      SizedBox(
                        width: double.infinity,
                        height: 42,
                        child: ElevatedButton(
                          onPressed: _register,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: AppTheme.radiusMd),
                          ),
                          child: const Text('Create Account', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600)),
                        ),
                      ),
                      const SizedBox(height: 14),

                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Already have an account?', style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Sign In', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
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

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12.5,
        fontWeight: FontWeight.w600,
        color: AppTheme.textPrimary,
      ),
    );
  }
}
