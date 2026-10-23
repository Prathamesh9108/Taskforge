import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../screens/notifications_screen.dart';

/// Compact, mobile-first Top Bar with proper SafeArea and clean SaaS header design
class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final Widget? leading;
  final List<Widget>? actions;
  final ValueChanged<String>? onSearch;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onQuickCreate;
  final bool showSearch;
  final bool showBrand;

  const AppTopBar({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.actions,
    this.onSearch,
    this.onNotificationTap,
    this.onQuickCreate,
    this.showSearch = false,
    this.showBrand = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(54);

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 850;

    return SafeArea(
      bottom: false,
      child: Container(
        height: preferredSize.height,
        decoration: const BoxDecoration(
          color: AppTheme.surface,
          border: Border(
            bottom: BorderSide(color: AppTheme.cardBorder, width: 1),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: AppTheme.space14),
        child: Row(
          children: [
            if (leading != null) ...[
              leading!,
              const SizedBox(width: AppTheme.space8),
            ] else if (showBrand) ...[
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppTheme.primary, AppTheme.accentViolet],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x204F46E5),
                      blurRadius: 4,
                      offset: Offset(0, 1.5),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(Icons.bolt_rounded, color: Colors.white, size: 17),
                ),
              ),
              const SizedBox(width: AppTheme.space10),
            ],
            // Title + Subtitle
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                      letterSpacing: -0.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 1),
                    Text(
                      subtitle!,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppTheme.textSecondary,
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),

            // Desktop Search Field
            if (isDesktop && showSearch) ...[
              Container(
                width: 220,
                height: 34,
                margin: const EdgeInsets.only(right: AppTheme.space12),
                child: TextField(
                  onChanged: onSearch,
                  style: const TextStyle(fontSize: 12.5),
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    prefixIcon: const Icon(Icons.search, size: 16, color: AppTheme.textMuted),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                    fillColor: AppTheme.surfaceSubtle,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: AppTheme.radiusSm,
                      borderSide: const BorderSide(color: AppTheme.cardBorder),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: AppTheme.radiusSm,
                      borderSide: const BorderSide(color: AppTheme.cardBorder),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: AppTheme.radiusSm,
                      borderSide: const BorderSide(color: AppTheme.primary),
                    ),
                  ),
                ),
              ),
            ],

            // Quick Create button
            if (onQuickCreate != null) ...[
              ElevatedButton.icon(
                onPressed: onQuickCreate,
                icon: const Icon(Icons.add, size: 15),
                label: Text(isDesktop ? 'New' : ''),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  minimumSize: const Size(0, 32),
                  padding: EdgeInsets.symmetric(
                    horizontal: isDesktop ? 12 : 8,
                    vertical: 6,
                  ),
                  shape: RoundedRectangleBorder(borderRadius: AppTheme.radiusSm),
                ),
              ),
              const SizedBox(width: AppTheme.space8),
            ],

            // Notification Bell with unread dot
            IconButton(
              tooltip: 'Notifications',
              padding: const EdgeInsets.all(AppTheme.space8),
              constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
              onPressed: onNotificationTap ??
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const NotificationsScreen()),
                    );
                  },
              icon: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(
                    Icons.notifications_none_rounded,
                    color: AppTheme.textSecondary,
                    size: 20,
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: AppTheme.danger,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            if (actions != null) ...?actions,
          ],
        ),
      ),
    );
  }
}
