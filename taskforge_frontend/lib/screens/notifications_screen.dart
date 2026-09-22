import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<Map<String, dynamic>> notifications = [
    {
      'title': 'New task assigned',
      'message': 'You have been assigned the task "Create Login UI".',
      'time': '5 min ago',
      'icon': Icons.assignment_outlined,
      'read': false,
    },
    {
      'title': 'Task status updated',
      'message': '"Dashboard Design" was moved to In Progress.',
      'time': '20 min ago',
      'icon': Icons.update_outlined,
      'read': false,
    },
    {
      'title': 'New comment',
      'message': 'Rahul commented on "Registration Screen".',
      'time': '1 hour ago',
      'icon': Icons.comment_outlined,
      'read': true,
    },
    {
      'title': 'Task completed',
      'message': '"Splash Screen" has been completed.',
      'time': '2 hours ago',
      'icon': Icons.check_circle_outline,
      'read': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final unreadCount = notifications
        .where((notification) => notification['read'] == false)
        .length;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0F172A)),
        ),

        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: [
          if (unreadCount > 0)
            TextButton(
              onPressed: _markAllAsRead,
              child: const Text(
                'Mark all read',
                style: TextStyle(color: Color(0xFF2563EB), fontSize: 12),
              ),
            ),
        ],
      ),

      body: notifications.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                return _buildNotification(notifications[index]);
              },
            ),
    );
  }

  Widget _buildNotification(Map<String, dynamic> notification) {
    final bool isUnread = notification['read'] == false;

    return GestureDetector(
      onTap: () {
        setState(() {
          notification['read'] = true;
        });
      },

      child: Container(
        margin: const EdgeInsets.only(bottom: 12),

        padding: const EdgeInsets.all(15),

        decoration: BoxDecoration(
          color: isUnread ? const Color(0xFFEFF6FF) : Colors.white,

          borderRadius: BorderRadius.circular(16),

          border: Border.all(
            color: isUnread ? const Color(0xFFBFDBFE) : const Color(0xFFE2E8F0),
          ),
        ),

        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Container(
              width: 45,
              height: 45,

              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(12),
              ),

              child: Icon(
                notification['icon'],
                color: const Color(0xFF2563EB),
                size: 22,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification['title'],
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: isUnread
                                ? FontWeight.bold
                                : FontWeight.w600,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                      ),

                      if (isUnread)
                        Container(
                          width: 8,
                          height: 8,

                          decoration: const BoxDecoration(
                            color: Color(0xFF2563EB),
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 5),

                  Text(
                    notification['message'],
                    style: const TextStyle(
                      fontSize: 12,
                      height: 1.4,
                      color: Color(0xFF64748B),
                    ),
                  ),

                  const SizedBox(height: 7),

                  Text(
                    notification['time'],
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Container(
            width: 75,
            height: 75,

            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(20),
            ),

            child: const Icon(
              Icons.notifications_none,
              size: 38,
              color: Color(0xFF2563EB),
            ),
          ),

          const SizedBox(height: 15),

          const Text(
            'No Notifications',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            'You are all caught up!',
            style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
          ),
        ],
      ),
    );
  }

  void _markAllAsRead() {
    setState(() {
      for (final notification in notifications) {
        notification['read'] = true;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All notifications marked as read')),
    );
  }
}
