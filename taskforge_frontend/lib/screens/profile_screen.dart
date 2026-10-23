import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name = 'Alex Morgan';
  String email = 'alex@taskforge.io';
  String phone = '+1 (555) 234-5678';
  String role = 'Product Lead';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            tooltip: 'Edit Profile',
            icon: const Icon(Icons.edit_outlined, size: 19),
            onPressed: _openEditProfile,
          ),
          const SizedBox(width: AppTheme.space8),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 580),
          child: ListView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.space16,
              vertical: AppTheme.space14,
            ),
            children: [
              // Header Card
              Container(
                padding: const EdgeInsets.all(AppTheme.space16),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: AppTheme.radiusLg,
                  border: Border.all(color: AppTheme.cardBorder),
                  boxShadow: AppTheme.cardShadow,
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: AppTheme.primaryLight,
                      child: Text(
                        name.isNotEmpty ? name[0].toUpperCase() : 'U',
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      email,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        role,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppTheme.space16),

              // Personal Information Section
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  'INFORMATION',
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textMuted,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              const SizedBox(height: 8),

              Container(
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: AppTheme.radiusLg,
                  border: Border.all(color: AppTheme.cardBorder),
                  boxShadow: AppTheme.cardShadow,
                ),
                child: Column(
                  children: [
                    _infoTile(Icons.person_outline_rounded, 'Full Name', name),
                    const Divider(height: 1),
                    _infoTile(Icons.email_outlined, 'Email', email),
                    const Divider(height: 1),
                    _infoTile(Icons.phone_outlined, 'Phone', phone),
                    const Divider(height: 1),
                    _infoTile(Icons.badge_outlined, 'Role', role),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Edit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _openEditProfile,
                  icon: const Icon(Icons.edit_outlined, size: 16),
                  label: const Text('Edit Profile'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(0, 42),
                    shape: RoundedRectangleBorder(borderRadius: AppTheme.radiusMd),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoTile(IconData icon, String title, String value) {
    return Padding(
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
            child: Icon(icon, color: AppTheme.primary, size: 17),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 11, color: AppTheme.textMuted),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _openEditProfile() {
    final nameController = TextEditingController(text: name);
    final emailController = TextEditingController(text: email);
    final phoneController = TextEditingController(text: phone);
    final roleController = TextEditingController(text: role);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppTheme.cardBorder,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Edit Profile',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: nameController,
                  style: const TextStyle(fontSize: 13),
                  decoration: const InputDecoration(labelText: 'Full Name'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(fontSize: 13),
                  decoration: const InputDecoration(labelText: 'Email Address'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  style: const TextStyle(fontSize: 13),
                  decoration: const InputDecoration(labelText: 'Phone Number'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: roleController,
                  style: const TextStyle(fontSize: 13),
                  decoration: const InputDecoration(labelText: 'Role / Designation'),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            name = nameController.text.trim();
                            email = emailController.text.trim();
                            phone = phoneController.text.trim();
                            role = roleController.text.trim();
                          });
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primary,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Save'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
