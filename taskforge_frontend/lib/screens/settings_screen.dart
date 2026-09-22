import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationsEnabled = true;
  bool darkModeEnabled = false;

  // Local profile information
  String userName = 'TaskForge User';
  String userEmail = 'user@example.com';

  // Local password for demo/frontend use
  String currentPassword = '123456';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkModeEnabled
          ? const Color(0xFF0F172A)
          : const Color(0xFFF8FAFC),

      // =====================================================
      // APP BAR
      // =====================================================
      appBar: AppBar(
        backgroundColor: darkModeEnabled
            ? const Color(0xFF1E293B)
            : Colors.white,
        elevation: 0,

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: darkModeEnabled ? Colors.white : const Color(0xFF0F172A),
          ),
        ),

        title: Text(
          'Settings',
          style: TextStyle(
            color: darkModeEnabled ? Colors.white : const Color(0xFF0F172A),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // =====================================================
      // BODY
      // =====================================================
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // =================================================
            // ACCOUNT
            // =================================================

            _sectionTitle('Account'),

            const SizedBox(height: 12),

            // PROFILE
            _settingsCard(
              icon: Icons.person_outline,
              title: 'Profile',
              subtitle: '$userName\n$userEmail',
              onTap: _openProfileDialog,
            ),

            const SizedBox(height: 12),

            // CHANGE PASSWORD
            _settingsCard(
              icon: Icons.lock_outline,
              title: 'Change Password',
              subtitle: 'Update your password',
              onTap: _openChangePasswordDialog,
            ),

            const SizedBox(height: 25),

            // =================================================
            // PREFERENCES
            // =================================================
            _sectionTitle('Preferences'),

            const SizedBox(height: 12),

            // NOTIFICATIONS
            _switchCard(
              icon: Icons.notifications_outlined,
              title: 'Notifications',
              subtitle: notificationsEnabled
                  ? 'Notifications enabled'
                  : 'Notifications disabled',
              value: notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  notificationsEnabled = value;
                });

                _showMessage(
                  value ? 'Notifications enabled' : 'Notifications disabled',
                );
              },
            ),

            const SizedBox(height: 12),

            // DARK MODE
            _switchCard(
              icon: Icons.dark_mode_outlined,
              title: 'Dark Mode',
              subtitle: darkModeEnabled ? 'Dark mode enabled' : 'Light mode',
              value: darkModeEnabled,
              onChanged: (value) {
                setState(() {
                  darkModeEnabled = value;
                });

                _showMessage(
                  value ? 'Dark mode enabled' : 'Light mode enabled',
                );
              },
            ),

            const SizedBox(height: 25),

            // =================================================
            // ABOUT
            // =================================================
            _sectionTitle('About'),

            const SizedBox(height: 12),

            // ABOUT TASKFORGE
            _settingsCard(
              icon: Icons.info_outline,
              title: 'About TaskForge',
              subtitle: 'Version 1.0.0',
              onTap: _showAboutDialog,
            ),

            const SizedBox(height: 12),

            // HELP
            _settingsCard(
              icon: Icons.help_outline,
              title: 'Help & Support',
              subtitle: 'Get help and support',
              onTap: _showHelpDialog,
            ),

            const SizedBox(height: 25),

            // =================================================
            // LOGOUT
            // =================================================
            SizedBox(
              width: double.infinity,

              child: ElevatedButton.icon(
                onPressed: _showLogoutDialog,

                icon: const Icon(Icons.logout),

                label: const Text(
                  'Logout',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // SECTION TITLE
  // =========================================================

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: darkModeEnabled ? Colors.white : const Color(0xFF0F172A),
      ),
    );
  }

  // =========================================================
  // SETTINGS CARD
  // =========================================================

  Widget _settingsCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,

      borderRadius: BorderRadius.circular(16),

      child: Container(
        padding: const EdgeInsets.all(16),

        decoration: BoxDecoration(
          color: darkModeEnabled ? const Color(0xFF1E293B) : Colors.white,

          borderRadius: BorderRadius.circular(16),

          border: Border.all(
            color: darkModeEnabled
                ? const Color(0xFF334155)
                : const Color(0xFFE2E8F0),
          ),
        ),

        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,

              decoration: BoxDecoration(
                color: darkModeEnabled
                    ? const Color(0xFF334155)
                    : const Color(0xFFF1F5F9),

                borderRadius: BorderRadius.circular(10),
              ),

              child: Icon(
                icon,
                size: 20,
                color: darkModeEnabled ? Colors.white : const Color(0xFF475569),
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    title,

                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: darkModeEnabled
                          ? Colors.white
                          : const Color(0xFF0F172A),
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    subtitle,

                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,

                    style: TextStyle(
                      fontSize: 12,
                      color: darkModeEnabled
                          ? const Color(0xFFCBD5E1)
                          : const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),

            Icon(
              Icons.arrow_forward_ios,
              size: 15,
              color: darkModeEnabled
                  ? const Color(0xFF94A3B8)
                  : const Color(0xFF94A3B8),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // SWITCH CARD
  // =========================================================

  Widget _switchCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: darkModeEnabled ? const Color(0xFF1E293B) : Colors.white,

        borderRadius: BorderRadius.circular(16),

        border: Border.all(
          color: darkModeEnabled
              ? const Color(0xFF334155)
              : const Color(0xFFE2E8F0),
        ),
      ),

      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,

            decoration: BoxDecoration(
              color: darkModeEnabled
                  ? const Color(0xFF334155)
                  : const Color(0xFFF1F5F9),

              borderRadius: BorderRadius.circular(10),
            ),

            child: Icon(
              icon,
              size: 20,
              color: darkModeEnabled ? Colors.white : const Color(0xFF475569),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  title,

                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: darkModeEnabled
                        ? Colors.white
                        : const Color(0xFF0F172A),
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  subtitle,

                  style: TextStyle(
                    fontSize: 12,
                    color: darkModeEnabled
                        ? const Color(0xFFCBD5E1)
                        : const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),

          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF2563EB),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // PROFILE DIALOG
  // =========================================================

  Future<void> _openProfileDialog() async {
    final nameController = TextEditingController(text: userName);

    final emailController = TextEditingController(text: userEmail);

    final formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,

      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),

          title: const Text(
            'Edit Profile',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),

          content: Form(
            key: formKey,

            child: Column(
              mainAxisSize: MainAxisSize.min,

              children: [
                TextFormField(
                  controller: nameController,

                  decoration: InputDecoration(
                    labelText: 'Name',
                    prefixIcon: const Icon(Icons.person_outline),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),

                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Enter your name';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 15),

                TextFormField(
                  controller: emailController,

                  keyboardType: TextInputType.emailAddress,

                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: const Icon(Icons.email_outlined),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),

                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Enter your email';
                    }

                    if (!value.contains('@')) {
                      return 'Enter a valid email';
                    }

                    return null;
                  },
                ),
              ],
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },

              child: const Text('Cancel'),
            ),

            ElevatedButton.icon(
              onPressed: () {
                if (!formKey.currentState!.validate()) {
                  return;
                }

                setState(() {
                  userName = nameController.text.trim();

                  userEmail = emailController.text.trim();
                });

                Navigator.pop(dialogContext);

                _showMessage('Profile updated successfully!');
              },

              icon: const Icon(Icons.save_outlined),

              label: const Text('Save'),
            ),
          ],
        );
      },
    );

    nameController.dispose();
    emailController.dispose();
  }

  // =========================================================
  // CHANGE PASSWORD
  // =========================================================

  Future<void> _openChangePasswordDialog() async {
    final currentController = TextEditingController();

    final newController = TextEditingController();

    final confirmController = TextEditingController();

    final formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,

      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),

          title: const Text(
            'Change Password',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),

          content: Form(
            key: formKey,

            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,

                children: [
                  TextFormField(
                    controller: currentController,

                    obscureText: true,

                    decoration: InputDecoration(
                      labelText: 'Current Password',

                      prefixIcon: const Icon(Icons.lock_outline),

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),

                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter current password';
                      }

                      if (value != currentPassword) {
                        return 'Current password is incorrect';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 15),

                  TextFormField(
                    controller: newController,

                    obscureText: true,

                    decoration: InputDecoration(
                      labelText: 'New Password',

                      prefixIcon: const Icon(Icons.lock_reset),

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),

                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter new password';
                      }

                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 15),

                  TextFormField(
                    controller: confirmController,

                    obscureText: true,

                    decoration: InputDecoration(
                      labelText: 'Confirm Password',

                      prefixIcon: const Icon(Icons.lock_outline),

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),

                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Confirm your password';
                      }

                      if (value != newController.text) {
                        return 'Passwords do not match';
                      }

                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },

              child: const Text('Cancel'),
            ),

            ElevatedButton(
              onPressed: () {
                if (!formKey.currentState!.validate()) {
                  return;
                }

                setState(() {
                  currentPassword = newController.text;
                });

                Navigator.pop(dialogContext);

                _showMessage('Password changed successfully!');
              },

              child: const Text('Update Password'),
            ),
          ],
        );
      },
    );

    currentController.dispose();
    newController.dispose();
    confirmController.dispose();
  }

  // =========================================================
  // ABOUT TASKFORGE
  // =========================================================

  void _showAboutDialog() {
    showDialog(
      context: context,

      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),

          title: const Row(
            children: [
              Icon(Icons.task_alt, color: Color(0xFF2563EB)),

              SizedBox(width: 10),

              Text('TaskForge', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),

          content: const Column(
            mainAxisSize: MainAxisSize.min,

            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                'TaskForge is a task and project '
                'management application built with Flutter.',
              ),

              SizedBox(height: 15),

              Text(
                'Version: 1.0.0',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),

              SizedBox(height: 5),

              Text('Flutter Frontend Project'),
            ],
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },

              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  // =========================================================
  // HELP & SUPPORT
  // =========================================================

  void _showHelpDialog() {
    showDialog(
      context: context,

      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),

          title: const Row(
            children: [
              Icon(Icons.help_outline, color: Color(0xFF2563EB)),

              SizedBox(width: 10),

              Text(
                'Help & Support',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),

          content: const Column(
            mainAxisSize: MainAxisSize.min,

            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                'TaskForge Help',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 10),

              Text(
                '• Create and manage tasks\n'
                '• Create and manage projects\n'
                '• Edit and delete projects\n'
                '• Track task progress\n'
                '• Manage your profile\n'
                '• Change your password\n'
                '• Enable or disable notifications',
              ),
            ],
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },

              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  // =========================================================
  // LOGOUT
  // =========================================================

  void _showLogoutDialog() {
    showDialog(
      context: context,

      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),

          title: const Row(
            children: [
              Icon(Icons.logout, color: Colors.red),

              SizedBox(width: 10),

              Text('Logout?', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),

          content: const Text('Are you sure you want to logout?'),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },

              child: const Text('Cancel'),
            ),

            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(dialogContext);

                // Return to the first screen.
                // This will normally be your Login/Splash
                // depending on how main.dart is configured.
                Navigator.of(context).popUntil((route) => route.isFirst);
              },

              icon: const Icon(Icons.logout),

              label: const Text('Logout'),

              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        );
      },
    );
  }

  // =========================================================
  // SNACKBAR
  // =========================================================

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }
}
