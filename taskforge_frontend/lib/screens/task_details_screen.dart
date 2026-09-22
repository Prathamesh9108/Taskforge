import 'package:flutter/material.dart';

class TaskDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> task;

  const TaskDetailsScreen({super.key, required this.task});

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  // =====================================================
  // TASK DATA
  // =====================================================

  late Map<String, dynamic> task;

  // =====================================================
  // COMMENTS DATA
  // LOCAL ONLY
  // =====================================================

  final List<Map<String, String>> comments = [
    {
      'name': 'John Doe',
      'comment': 'Task is progressing well.',
      'time': '10 minutes ago',
    },
    {
      'name': 'Sarah',
      'comment': 'I have completed my part.',
      'time': '1 hour ago',
    },
    {
      'name': 'Mike',
      'comment': 'Please review the task once completed.',
      'time': '2 hours ago',
    },
  ];

  // =====================================================
  // ACTIVITY DATA
  // LOCAL ONLY
  // =====================================================

  final List<Map<String, dynamic>> activities = [
    {
      'title': 'Task created',
      'description': 'Task was created',
      'time': 'Today, 9:30 AM',
      'icon': Icons.add_task,
    },
    {
      'title': 'Status changed',
      'description': 'Task moved to In Progress',
      'time': 'Today, 10:15 AM',
      'icon': Icons.timelapse,
    },
    {
      'title': 'Description updated',
      'description': 'Task description was updated',
      'time': 'Today, 10:30 AM',
      'icon': Icons.edit,
    },
  ];

  @override
  void initState() {
    super.initState();

    task = Map<String, dynamic>.from(widget.task);
  }

  @override
  Widget build(BuildContext context) {
    final String priority = task['priority'] ?? 'Medium';

    final String status = task['status'] ?? 'To Do';

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),

      // =================================================
      // APP BAR
      // =================================================
      appBar: AppBar(
        backgroundColor: Colors.white,

        elevation: 0,

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context, task);
          },

          icon: const Icon(Icons.arrow_back, color: Color(0xFF0F172A)),
        ),

        title: const Text(
          'Task Details',

          style: TextStyle(
            color: Color(0xFF0F172A),
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: [
          IconButton(
            onPressed: _showMenu,

            icon: const Icon(Icons.more_vert, color: Color(0xFF0F172A)),
          ),
        ],
      ),

      // =================================================
      // BODY
      // =================================================
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // =================================================
            // TASK HEADER
            // =================================================

            Container(
              width: double.infinity,

              padding: const EdgeInsets.all(22),

              decoration: BoxDecoration(
                color: Colors.white,

                borderRadius: BorderRadius.circular(20),

                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  // Task title
                  Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,

                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF6FF),

                          borderRadius: BorderRadius.circular(14),
                        ),

                        child: const Icon(
                          Icons.task_alt,

                          color: Color(0xFF2563EB),

                          size: 28,
                        ),
                      ),

                      const SizedBox(width: 14),

                      Expanded(
                        child: Text(
                          task['title'] ?? 'Task',

                          style: const TextStyle(
                            fontSize: 22,

                            fontWeight: FontWeight.bold,

                            color: Color(0xFF0F172A),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Description
                  Text(
                    task['description'] ?? 'No description available.',

                    style: const TextStyle(
                      fontSize: 14,

                      height: 1.5,

                      color: Color(0xFF64748B),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Priority + Status
                  Row(
                    children: [
                      _badge(text: priority, color: _priorityColor(priority)),

                      const SizedBox(width: 8),

                      _badge(text: status, color: _statusColor(status)),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // =================================================
            // TASK INFORMATION
            // =================================================
            const Text(
              'Task Information',

              style: TextStyle(
                fontSize: 20,

                fontWeight: FontWeight.bold,

                color: Color(0xFF0F172A),
              ),
            ),

            const SizedBox(height: 12),

            Container(
              width: double.infinity,

              padding: const EdgeInsets.all(18),

              decoration: BoxDecoration(
                color: Colors.white,

                borderRadius: BorderRadius.circular(18),

                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),

              child: Column(
                children: [
                  _infoRow(
                    Icons.folder_outlined,
                    'Project',
                    task['project'] ?? 'Not assigned',
                  ),

                  const Divider(height: 25),

                  _infoRow(
                    Icons.person_outline,
                    'Assignee',

                    task['assignee']?.toString().isNotEmpty == true
                        ? task['assignee']
                        : 'Not assigned',
                  ),

                  const Divider(height: 25),

                  _infoRow(Icons.flag_outlined, 'Priority', priority),

                  const Divider(height: 25),

                  _infoRow(Icons.timelapse_outlined, 'Status', status),

                  const Divider(height: 25),

                  _infoRow(
                    Icons.calendar_today_outlined,
                    'Due Date',
                    task['dueDate'] ?? 'Not set',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // =================================================
            // ACTIONS
            // =================================================
            const Text(
              'Actions',

              style: TextStyle(
                fontSize: 20,

                fontWeight: FontWeight.bold,

                color: Color(0xFF0F172A),
              ),
            ),

            const SizedBox(height: 12),

            // Edit Task
            _actionButton(
              icon: Icons.edit_outlined,

              title: 'Edit Task',

              subtitle: 'Update task information',

              onTap: _editTask,
            ),

            const SizedBox(height: 12),

            // Delete Task
            _actionButton(
              icon: Icons.delete_outline,

              title: 'Delete Task',

              subtitle: 'Remove this task',

              iconColor: Colors.red,

              onTap: _deleteTask,
            ),

            // =================================================
            // COMMENTS SECTION
            // =================================================
            const SizedBox(height: 25),

            const Text(
              'Comments',

              style: TextStyle(
                fontSize: 20,

                fontWeight: FontWeight.bold,

                color: Color(0xFF0F172A),
              ),
            ),

            const SizedBox(height: 12),

            // Comment input + comment list
            _buildComments(),

            // =================================================
            // ACTIVITY SECTION
            // =================================================
            const SizedBox(height: 25),

            const Text(
              'Activity',

              style: TextStyle(
                fontSize: 20,

                fontWeight: FontWeight.bold,

                color: Color(0xFF0F172A),
              ),
            ),

            const SizedBox(height: 12),

            _buildActivity(),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // =====================================================
  // BADGE
  // =====================================================

  Widget _badge({required String text, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),

      decoration: BoxDecoration(
        color: color.withOpacity(0.1),

        borderRadius: BorderRadius.circular(8),
      ),

      child: Text(
        text,

        style: TextStyle(
          fontSize: 12,

          fontWeight: FontWeight.w600,

          color: color,
        ),
      ),
    );
  }

  // =====================================================
  // INFO ROW
  // =====================================================

  Widget _infoRow(IconData icon, String title, String value) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,

          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),

            borderRadius: BorderRadius.circular(10),
          ),

          child: Icon(icon, size: 21, color: const Color(0xFF475569)),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                title,

                style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
              ),

              const SizedBox(height: 3),

              Text(
                value,

                style: const TextStyle(
                  fontSize: 14,

                  fontWeight: FontWeight.w600,

                  color: Color(0xFF0F172A),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // =====================================================
  // ACTION BUTTON
  // =====================================================

  Widget _actionButton({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,

    Color iconColor = const Color(0xFF2563EB),
  }) {
    return InkWell(
      onTap: onTap,

      borderRadius: BorderRadius.circular(16),

      child: Container(
        width: double.infinity,

        padding: const EdgeInsets.all(16),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(16),

          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),

        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,

              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),

                borderRadius: BorderRadius.circular(12),
              ),

              child: Icon(icon, color: iconColor),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    title,

                    style: const TextStyle(
                      fontSize: 15,

                      fontWeight: FontWeight.w600,

                      color: Color(0xFF0F172A),
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    subtitle,

                    style: const TextStyle(
                      fontSize: 12,

                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.arrow_forward_ios,

              size: 15,

              color: Color(0xFF94A3B8),
            ),
          ],
        ),
      ),
    );
  }

  // =====================================================
  // COMMENTS
  // =====================================================

  Widget _buildComments() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        // =================================================
        // COMMENT INPUT
        // =================================================

        _buildCommentInput(),

        const SizedBox(height: 15),

        // =================================================
        // NO COMMENTS
        // =================================================
        if (comments.isEmpty)
          Container(
            width: double.infinity,

            padding: const EdgeInsets.all(20),

            decoration: BoxDecoration(
              color: Colors.white,

              borderRadius: BorderRadius.circular(16),

              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),

            child: const Center(
              child: Text(
                'No comments yet.',

                style: TextStyle(color: Color(0xFF64748B), fontSize: 14),
              ),
            ),
          )
        // =================================================
        // COMMENTS LIST
        // =================================================
        else
          Container(
            width: double.infinity,

            padding: const EdgeInsets.all(16),

            decoration: BoxDecoration(
              color: Colors.white,

              borderRadius: BorderRadius.circular(18),

              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),

            child: Column(
              children: [
                ...comments.asMap().entries.map((entry) {
                  final int index = entry.key;

                  final comment = entry.value;

                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: index == comments.length - 1 ? 0 : 18,
                    ),

                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        // =================================
                        // AVATAR
                        // =================================

                        CircleAvatar(
                          radius: 21,

                          backgroundColor: const Color(0xFFEFF6FF),

                          child: Text(
                            comment['name']!.substring(0, 1).toUpperCase(),

                            style: const TextStyle(
                              color: Color(0xFF2563EB),

                              fontWeight: FontWeight.bold,

                              fontSize: 16,
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        // =================================
                        // COMMENT CONTENT
                        // =================================
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      comment['name']!,

                                      style: const TextStyle(
                                        fontSize: 14,

                                        fontWeight: FontWeight.w600,

                                        color: Color(0xFF0F172A),
                                      ),
                                    ),
                                  ),

                                  Text(
                                    comment['time']!,

                                    style: const TextStyle(
                                      fontSize: 11,

                                      color: Color(0xFF94A3B8),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 5),

                              Text(
                                comment['comment']!,

                                style: const TextStyle(
                                  fontSize: 13,

                                  height: 1.4,

                                  color: Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
      ],
    );
  }

  // =====================================================
  // COMMENT INPUT
  // =====================================================

  Widget _buildCommentInput() {
    final controller = TextEditingController();

    return Container(
      padding: const EdgeInsets.all(12),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(16),

        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),

      child: Row(
        children: [
          // ===============================================
          // TEXT FIELD
          // ===============================================

          Expanded(
            child: TextField(
              controller: controller,

              maxLines: null,

              decoration: const InputDecoration(
                hintText: 'Write a comment...',

                border: InputBorder.none,

                contentPadding: EdgeInsets.symmetric(
                  horizontal: 4,
                  vertical: 8,
                ),
              ),
            ),
          ),

          // ===============================================
          // SEND BUTTON
          // ===============================================
          IconButton(
            onPressed: () {
              // Don't add empty comment
              if (controller.text.trim().isEmpty) {
                return;
              }

              // Add comment locally
              setState(() {
                comments.insert(0, {
                  'name': 'You',

                  'comment': controller.text.trim(),

                  'time': 'Just now',
                });

                // Add activity
                activities.insert(0, {
                  'title': 'Comment added',

                  'description': 'You added a comment',

                  'time': 'Just now',
                });
              });

              // Clear input
              controller.clear();

              // Show success message
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Comment added successfully!'),

                  duration: Duration(seconds: 2),
                ),
              );
            },

            icon: const Icon(Icons.send, color: Color(0xFF2563EB)),
          ),
        ],
      ),
    );
  }

  // =====================================================
  // ACTIVITY
  // =====================================================

  Widget _buildActivity() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(18),

        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),

      child: Column(
        children: [
          ...activities.asMap().entries.map((entry) {
            final int index = entry.key;

            final activity = entry.value;

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                // =================================
                // TIMELINE
                // =================================

                Column(
                  children: [
                    Container(
                      width: 12,
                      height: 12,

                      decoration: const BoxDecoration(
                        color: Color(0xFF2563EB),

                        shape: BoxShape.circle,
                      ),
                    ),

                    if (index != activities.length - 1)
                      Container(
                        width: 2,

                        height: 55,

                        color: const Color(0xFFE2E8F0),
                      ),
                  ],
                ),

                const SizedBox(width: 14),

                // =================================
                // ACTIVITY CONTENT
                // =================================
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 18),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Text(
                          activity['title']!,

                          style: const TextStyle(
                            fontSize: 14,

                            fontWeight: FontWeight.w600,

                            color: Color(0xFF0F172A),
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          activity['description']!,

                          style: const TextStyle(
                            fontSize: 12,

                            color: Color(0xFF64748B),
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          activity['time']!,

                          style: const TextStyle(
                            fontSize: 11,

                            color: Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  // =====================================================
  // PRIORITY COLOR
  // =====================================================

  Color _priorityColor(String priority) {
    if (priority == 'High') {
      return Colors.red;
    }

    if (priority == 'Low') {
      return Colors.green;
    }

    return Colors.orange;
  }

  // =====================================================
  // STATUS COLOR
  // =====================================================

  Color _statusColor(String status) {
    if (status == 'Done') {
      return Colors.green;
    }

    if (status == 'In Progress') {
      return Colors.blue;
    }

    return Colors.grey;
  }

  // =====================================================
  // EDIT TASK
  // =====================================================

  void _editTask() {
    final titleController = TextEditingController(text: task['title']);

    final descriptionController = TextEditingController(
      text: task['description'],
    );

    showDialog(
      context: context,

      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Task'),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),

          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,

              children: [
                TextField(
                  controller: titleController,

                  decoration: const InputDecoration(labelText: 'Task Title'),
                ),

                const SizedBox(height: 15),

                TextField(
                  controller: descriptionController,

                  maxLines: 4,

                  decoration: const InputDecoration(labelText: 'Description'),
                ),
              ],
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },

              child: const Text('Cancel'),
            ),

            ElevatedButton(
              onPressed: () {
                if (titleController.text.trim().isEmpty) {
                  return;
                }

                setState(() {
                  task['title'] = titleController.text.trim();

                  task['description'] = descriptionController.text.trim();

                  // Add activity
                  activities.insert(0, {
                    'title': 'Task updated',

                    'description': 'Task information was updated',

                    'time': 'Just now',
                  });
                });

                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Task updated successfully!'),

                    backgroundColor: Colors.green,
                  ),
                );
              },

              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  // =====================================================
  // DELETE TASK
  // =====================================================

  void _deleteTask() {
    showDialog(
      context: context,

      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Task?'),

          content: const Text(
            'Are you sure you want to delete '
            'this task?',
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },

              child: const Text('Cancel'),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);

                Navigator.pop(context, 'delete');
              },

              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,

                foregroundColor: Colors.white,
              ),

              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  // =====================================================
  // THREE DOT MENU
  // =====================================================

  void _showMenu() {
    showModalBottomSheet(
      context: context,

      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),

      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,

            children: [
              // Edit
              ListTile(
                leading: const Icon(Icons.edit_outlined),

                title: const Text('Edit Task'),

                onTap: () {
                  Navigator.pop(context);

                  _editTask();
                },
              ),

              // Delete
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.red),

                title: const Text(
                  'Delete Task',

                  style: TextStyle(color: Colors.red),
                ),

                onTap: () {
                  Navigator.pop(context);

                  _deleteTask();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
