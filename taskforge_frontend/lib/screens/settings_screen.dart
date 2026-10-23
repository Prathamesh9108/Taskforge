import 'package:flutter/material.dart';
import '../main.dart';
import '../theme/app_theme.dart';
import '../widgets/responsive_scaffold.dart';
import '../widgets/interactive_card.dart';
import 'login_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationsEnabled = true;
  late bool darkModeEnabled;

  @override
  void initState() {
    super.initState();
    darkModeEnabled = ThemeController.isDarkMode.value;
  }

  String userName = 'Alex Morgan';
  String userEmail = 'alex@taskforge.io';
  String currentPassword = '••••••••';

  @override
  Widget build(BuildContext context) {
    final content = SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.space16,
        vertical: AppTheme.space16,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Card
              Container(
                padding: const EdgeInsets.all(AppTheme.space16),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: AppTheme.radiusLg,
                  border: Border.all(color: AppTheme.cardBorder),
                  boxShadow: AppTheme.cardShadow,
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: AppTheme.primaryLight,
                      child: const Text(
                        'AM',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userName,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            userEmail,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    OutlinedButton(
                      onPressed: _openProfileDialog,
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(0, 30),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        textStyle: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600),
                      ),
                      child: const Text('Edit'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Section: Account
              _sectionHeader('ACCOUNT'),
              const SizedBox(height: 8),

              InteractiveCard(
                onTap: _openChangePasswordDialog,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                borderRadius: AppTheme.radiusMd,
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceSubtle,
                        borderRadius: AppTheme.radiusSm,
                      ),
                      child: const Icon(Icons.lock_outline_rounded, size: 17, color: AppTheme.textSecondary),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Password & Security',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Change account password',
                            style: TextStyle(fontSize: 11, color: AppTheme.textMuted),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: AppTheme.textMuted),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Section: Preferences
              _sectionHeader('PREFERENCES'),
              const SizedBox(height: 8),

              Container(
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: AppTheme.radiusLg,
                  border: Border.all(color: AppTheme.cardBorder),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      child: Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: AppTheme.surfaceSubtle,
                              borderRadius: AppTheme.radiusSm,
                            ),
                            child: const Icon(Icons.notifications_none_rounded, size: 18, color: AppTheme.textSecondary),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Push Notifications',
                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Task reminders and updates',
                                  style: TextStyle(fontSize: 11, color: AppTheme.textMuted),
                                ),
                              ],
                            ),
                          ),
                          Switch(
                            value: notificationsEnabled,
                            activeTrackColor: AppTheme.primary,
                            onChanged: (val) {
                              setState(() => notificationsEnabled = val);
                              _showMessage(val ? 'Notifications enabled' : 'Notifications disabled');
                            },
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      child: Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: AppTheme.surfaceSubtle,
                              borderRadius: AppTheme.radiusSm,
                            ),
                            child: const Icon(Icons.dark_mode_outlined, size: 18, color: AppTheme.textSecondary),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Dark Mode',
                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Toggle dark theme',
                                  style: TextStyle(fontSize: 11, color: AppTheme.textMuted),
                                ),
                              ],
                            ),
                          ),
                          Switch(
                            value: darkModeEnabled,
                            activeTrackColor: AppTheme.primary,
                            onChanged: (val) {
                              setState(() => darkModeEnabled = val);
                              ThemeController.isDarkMode.value = val;
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Section: System & Support
              _sectionHeader('SUPPORT & ABOUT'),
              const SizedBox(height: 8),

              InteractiveCard(
                onTap: _showHelpDialog,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                borderRadius: AppTheme.radiusMd,
                child: const Row(
                  children: [
                    Icon(Icons.help_outline_rounded, size: 18, color: AppTheme.textSecondary),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Help & Documentation',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios_rounded, size: 12, color: AppTheme.textMuted),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              InteractiveCard(
                onTap: _showAboutDialog,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                borderRadius: AppTheme.radiusMd,
                child: const Row(
                  children: [
                    Icon(Icons.info_outline_rounded, size: 18, color: AppTheme.textSecondary),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'About TaskForge (v1.0.0)',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios_rounded, size: 12, color: AppTheme.textMuted),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Logout Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _showLogoutDialog,
                  icon: const Icon(Icons.logout_rounded, size: 16, color: AppTheme.danger),
                  label: const Text('Log Out', style: TextStyle(color: AppTheme.danger)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppTheme.dangerBorder),
                    minimumSize: const Size(0, 42),
                    shape: RoundedRectangleBorder(borderRadius: AppTheme.radiusMd),
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );

    return ResponsiveScaffold(
      selectedIndex: 3,
      title: 'Settings',
      subtitle: 'Preferences & account',
      body: content,
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
          color: AppTheme.textMuted,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Future<void> _openProfileDialog() async {
    final nameCtrl = TextEditingController(text: userName);
    final emailCtrl = TextEditingController(text: userEmail);

    final res = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surface,
        shape: RoundedRectangleBorder(borderRadius: AppTheme.radiusLg),
        title: const Text('Edit Profile', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Full Name', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            TextField(controller: nameCtrl, style: const TextStyle(fontSize: 13)),
            const SizedBox(height: 12),
            const Text('Email Address', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            TextField(controller: emailCtrl, style: const TextStyle(fontSize: 13)),
          ],
        ),
        actions: [
          OutlinedButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary, foregroundColor: Colors.white),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (res == true && mounted) {
      setState(() {
        userName = nameCtrl.text.trim();
        userEmail = emailCtrl.text.trim();
      });
      _showMessage('Profile updated successfully');
    }
  }

  Future<void> _openChangePasswordDialog() async {
    final oldCtrl = TextEditingController();
    final newCtrl = TextEditingController();

    final res = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surface,
        shape: RoundedRectangleBorder(borderRadius: AppTheme.radiusLg),
        title: const Text('Change Password', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Current Password', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            TextField(controller: oldCtrl, obscureText: true, style: const TextStyle(fontSize: 13)),
            const SizedBox(height: 12),
            const Text('New Password', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            TextField(controller: newCtrl, obscureText: true, style: const TextStyle(fontSize: 13)),
          ],
        ),
        actions: [
          OutlinedButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary, foregroundColor: Colors.white),
            child: const Text('Update'),
          ),
        ],
      ),
    );

    if (res == true && mounted) {
      _showMessage('Password updated successfully');
    }
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surface,
        shape: RoundedRectangleBorder(borderRadius: AppTheme.radiusLg),
        title: const Row(
          children: [
            Icon(Icons.help_outline_rounded, color: AppTheme.primary, size: 20),
            SizedBox(width: 8),
            Text('Help & Support', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'TaskForge Quick Guide:',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
            ),
            SizedBox(height: 8),
            Text(
              '• Projects: Group related tasks and track delivery milestones.\n'
              '• Tasks: Create action items, assign priorities, and log progress.\n'
              '• Kanban: Visualize sprint lanes with smooth lane switching.\n'
              '• Offline Mode: All actions auto-sync with Spring Boot backend when online.',
              style: TextStyle(fontSize: 12, height: 1.4, color: AppTheme.textSecondary),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Done')),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surface,
        shape: RoundedRectangleBorder(borderRadius: AppTheme.radiusLg),
        title: const Text('About TaskForge', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('TaskForge Mobile Client', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
            SizedBox(height: 4),
            Text('Version 1.0.0 (Production Build)', style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
            SizedBox(height: 8),
            Text('Cross-platform Flutter application with Spring Boot REST API integration.', style: TextStyle(fontSize: 12, color: AppTheme.textMuted)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppTheme.surface,
        shape: RoundedRectangleBorder(borderRadius: AppTheme.radiusLg),
        title: const Row(
          children: [
            Icon(Icons.logout_rounded, color: AppTheme.danger, size: 20),
            SizedBox(width: 8),
            Text('Log Out?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          ],
        ),
        content: const Text('Are you sure you want to log out of TaskForge?', style: TextStyle(fontSize: 13)),
        actions: [
          OutlinedButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.danger, foregroundColor: Colors.white),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), duration: const Duration(seconds: 2)),
    );
  }
}
