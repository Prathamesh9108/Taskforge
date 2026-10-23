import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AppSidebar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;
  final VoidCallback? onQuickAddTask;
  final VoidCallback? onQuickAddProject;

  const AppSidebar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    this.onQuickAddTask,
    this.onQuickAddProject,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        border: Border(
          right: BorderSide(color: AppTheme.cardBorder, width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo & Workspace Header
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 20, 18, 16),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppTheme.primary, AppTheme.accentViolet],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: AppTheme.radiusSm,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.bolt_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'TaskForge',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.textPrimary,
                              letterSpacing: -0.3,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1.5),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryLight,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'PRO',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Text(
                        'Workspace',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppTheme.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1),
          const SizedBox(height: 10),

          // Quick Action button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onQuickAddTask,
                icon: const Icon(Icons.add, size: 15),
                label: const Text('Add Task'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  minimumSize: const Size(0, 36),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: AppTheme.radiusSm),
                ),
              ),
            ),
          ),

          const SizedBox(height: 6),

          // Section Title
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 6),
            child: Text(
              'MENU',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: AppTheme.textMuted,
                letterSpacing: 0.8,
              ),
            ),
          ),

          // Nav Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              children: [
                _SidebarNavItem(
                  isSelected: selectedIndex == 0,
                  label: 'Dashboard',
                  icon: Icons.dashboard_outlined,
                  activeIcon: Icons.dashboard_rounded,
                  onTap: () => onItemSelected(0),
                ),
                _SidebarNavItem(
                  isSelected: selectedIndex == 1,
                  label: 'Projects',
                  icon: Icons.folder_outlined,
                  activeIcon: Icons.folder_rounded,
                  onTap: () => onItemSelected(1),
                ),
                _SidebarNavItem(
                  isSelected: selectedIndex == 2,
                  label: 'Tasks',
                  icon: Icons.task_alt_outlined,
                  activeIcon: Icons.task_alt_rounded,
                  onTap: () => onItemSelected(2),
                ),
                _SidebarNavItem(
                  isSelected: selectedIndex == 3,
                  label: 'Kanban Board',
                  icon: Icons.view_kanban_outlined,
                  activeIcon: Icons.view_kanban_rounded,
                  onTap: () => onItemSelected(3),
                ),
                const SizedBox(height: 12),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Text(
                    'PREFERENCES',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textMuted,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                _SidebarNavItem(
                  isSelected: selectedIndex == 4,
                  label: 'Settings',
                  icon: Icons.settings_outlined,
                  activeIcon: Icons.settings_rounded,
                  onTap: () => onItemSelected(4),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // User Profile Card at bottom
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            color: AppTheme.surfaceSubtle.withValues(alpha: 0.4),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 15,
                  backgroundColor: AppTheme.primaryLight,
                  child: const Text(
                    'TF',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Alex Morgan',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'alex@taskforge.io',
                        style: TextStyle(
                          fontSize: 10.5,
                          color: AppTheme.textMuted,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 4),
                Container(
                  width: 7,
                  height: 7,
                  decoration: const BoxDecoration(
                    color: AppTheme.success,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarNavItem extends StatefulWidget {
  final bool isSelected;
  final String label;
  final IconData icon;
  final IconData activeIcon;
  final VoidCallback onTap;

  const _SidebarNavItem({
    required this.isSelected,
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.onTap,
  });

  @override
  State<_SidebarNavItem> createState() => _SidebarNavItemState();
}

class _SidebarNavItemState extends State<_SidebarNavItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final bgColor = widget.isSelected
        ? AppTheme.primaryLight
        : _isHovered
            ? AppTheme.surfaceSubtle
            : Colors.transparent;

    final textColor = widget.isSelected
        ? AppTheme.primary
        : _isHovered
            ? AppTheme.textPrimary
            : AppTheme.textSecondary;

    final iconColor = widget.isSelected
        ? AppTheme.primary
        : _isHovered
            ? AppTheme.primary
            : AppTheme.textSecondary;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        margin: const EdgeInsets.symmetric(vertical: 2),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: AppTheme.radiusSm,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: AppTheme.radiusSm,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Row(
                children: [
                  Icon(
                    widget.isSelected ? widget.activeIcon : widget.icon,
                    size: 18,
                    color: iconColor,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      widget.label,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: widget.isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: textColor,
                      ),
                    ),
                  ),
                  if (widget.isSelected)
                    Container(
                      width: 5,
                      height: 5,
                      decoration: const BoxDecoration(
                        color: AppTheme.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
