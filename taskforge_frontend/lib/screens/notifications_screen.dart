import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/interactive_card.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<Map<String, dynamic>> notifications = [
    {
      'title': 'New task assigned',
      'message': 'You were assigned "Create Login UI".',
      'time': '5 min ago',
      'icon': Icons.assignment_outlined,
      'read': false,
    },
    {
      'title': 'Task status updated',
      'message': '"Dashboard Design" was moved to In Progress.',
      'time': '20 min ago',
      'icon': Icons.timelapse_rounded,
      'read': false,
    },
    {
      'title': 'New comment',
      'message': 'Alex commented on "Registration Screen".',
      'time': '1 hour ago',
      'icon': Icons.chat_bubble_outline_rounded,
      'read': true,
    },
    {
      'title': 'Task completed',
      'message': '"Splash Screen" was marked as Done.',
      'time': '2 hours ago',
      'icon': Icons.check_circle_outline_rounded,
      'read': true,
    },
  ];

  void _markAllAsRead() {
    setState(() {
      for (var n in notifications) {
        n['read'] = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final unreadCount = notifications.where((n) => n['read'] == false).length;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          if (unreadCount > 0)
            TextButton(
              onPressed: _markAllAsRead,
              child: const Text('Mark all read'),
            ),
          const SizedBox(width: AppTheme.space8),
        ],
      ),
      body: notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.notifications_none_rounded, size: 40, color: AppTheme.textMuted.withValues(alpha: 0.5)),
                  const SizedBox(height: 8),
                  const Text('No notifications', style: TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.space16,
                vertical: AppTheme.space12,
              ),
              itemCount: notifications.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final n = notifications[index];
                final isUnread = n['read'] == false;

                return InteractiveCard(
                  padding: const EdgeInsets.all(AppTheme.space12),
                  borderRadius: AppTheme.radiusMd,
                  backgroundColor: isUnread ? AppTheme.surface : AppTheme.surfaceSubtle.withValues(alpha: 0.4),
                  onTap: () {
                    setState(() => n['read'] = true);
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: isUnread ? AppTheme.primaryLight : AppTheme.surfaceSubtle,
                          borderRadius: AppTheme.radiusSm,
                        ),
                        child: Icon(
                          n['icon'] as IconData,
                          size: 16,
                          color: isUnread ? AppTheme.primary : AppTheme.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  n['title'] as String,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: isUnread ? FontWeight.w700 : FontWeight.w600,
                                    color: AppTheme.textPrimary,
                                  ),
                                ),
                                Text(
                                  n['time'] as String,
                                  style: const TextStyle(fontSize: 10.5, color: AppTheme.textMuted),
                                ),
                              ],
                            ),
                            const SizedBox(height: 3),
                            Text(
                              n['message'] as String,
                              style: TextStyle(
                                fontSize: 12,
                                color: isUnread ? AppTheme.textSecondary : AppTheme.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isUnread) ...[
                        const SizedBox(width: 6),
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: AppTheme.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
    );
  }
}
