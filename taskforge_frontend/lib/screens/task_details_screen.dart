import 'package:flutter/material.dart';
import '../Services/api_service.dart';
import '../theme/app_theme.dart';
import '../widgets/status_badge.dart';
import '../widgets/priority_badge.dart';

class TaskDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> task;

  const TaskDetailsScreen({super.key, required this.task});

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  late Map<String, dynamic> task;
  bool isUpdating = false;

  final List<Map<String, dynamic>> activities = [
    {
      'title': 'Task created',
      'time': 'Earlier today',
      'icon': Icons.add_task_rounded,
    },
  ];

  @override
  void initState() {
    super.initState();
    task = Map<String, dynamic>.from(widget.task);
  }

  String _backendStatus(String s) {
    if (s == 'Done' || s == 'Completed') return 'DONE';
    if (s == 'In Progress') return 'IN_PROGRESS';
    return 'TODO';
  }

  String _backendPriority(String p) {
    return p.toUpperCase();
  }

  Future<void> _updateQuickStatus(String newStatus) async {
    final taskId = task['id'];
    if (taskId == null) return;

    setState(() {
      task['status'] = newStatus;
      activities.insert(0, {
        'title': 'Moved to $newStatus',
        'time': 'Just now',
        'icon': Icons.sync_alt_rounded,
      });
    });

    try {
      await ApiService.updateTask(
        (taskId as num).toInt(),
        {'status': _backendStatus(newStatus)},
      );
    } catch (_) {}
  }

  Future<void> _updateQuickPriority(String newPriority) async {
    final taskId = task['id'];
    if (taskId == null) return;

    setState(() {
      task['priority'] = newPriority;
      activities.insert(0, {
        'title': 'Priority set to $newPriority',
        'time': 'Just now',
        'icon': Icons.flag_rounded,
      });
    });

    try {
      await ApiService.updateTask(
        (taskId as num).toInt(),
        {'priority': _backendPriority(newPriority)},
      );
    } catch (_) {}
  }

  Future<void> _editTask() async {
    final titleController = TextEditingController(text: task['title'] ?? '');
    final descriptionController = TextEditingController(text: task['description'] ?? '');
    String selectedStatus = task['status'] ?? 'To Do';
    String selectedPriority = task['priority'] ?? 'Medium';

    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: AppTheme.surface,
              shape: RoundedRectangleBorder(borderRadius: AppTheme.radiusLg),
              title: const Row(
                children: [
                  Icon(Icons.edit_note_rounded, color: AppTheme.primary, size: 22),
                  SizedBox(width: 8),
                  Text(
                    'Edit Task',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ],
              ),
              content: SizedBox(
                width: 400,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Task Title',
                        style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: titleController,
                        style: const TextStyle(fontSize: 13),
                        decoration: const InputDecoration(hintText: 'Enter title'),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Description',
                        style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: descriptionController,
                        maxLines: 3,
                        style: const TextStyle(fontSize: 13),
                        decoration: const InputDecoration(hintText: 'Enter description'),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Status',
                                  style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 6),
                                DropdownButtonFormField<String>(
                                  initialValue: selectedStatus,
                                  items: const [
                                    DropdownMenuItem(value: 'To Do', child: Text('To Do')),
                                    DropdownMenuItem(value: 'In Progress', child: Text('In Progress')),
                                    DropdownMenuItem(value: 'Done', child: Text('Done')),
                                  ],
                                  onChanged: (val) {
                                    if (val != null) setDialogState(() => selectedStatus = val);
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Priority',
                                  style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 6),
                                DropdownButtonFormField<String>(
                                  initialValue: selectedPriority,
                                  items: const [
                                    DropdownMenuItem(value: 'High', child: Text('High')),
                                    DropdownMenuItem(value: 'Medium', child: Text('Medium')),
                                    DropdownMenuItem(value: 'Low', child: Text('Low')),
                                  ],
                                  onChanged: (val) {
                                    if (val != null) setDialogState(() => selectedPriority = val);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                OutlinedButton(
                  onPressed: () => Navigator.pop(dialogContext, false),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(dialogContext, true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );

    if (result == true && mounted) {
      final taskId = task['id'];
      if (taskId == null) return;

      try {
        final updatedPayload = {
          'title': titleController.text.trim(),
          'description': descriptionController.text.trim(),
          'status': _backendStatus(selectedStatus),
          'priority': _backendPriority(selectedPriority),
        };

        await ApiService.updateTask((taskId as num).toInt(), updatedPayload);

        if (!mounted) return;
        setState(() {
          task['title'] = updatedPayload['title'];
          task['description'] = updatedPayload['description'];
          task['status'] = selectedStatus;
          task['priority'] = selectedPriority;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Task updated successfully!'),
            backgroundColor: AppTheme.success,
          ),
        );
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed: $e'), backgroundColor: AppTheme.danger),
        );
      }
    }
  }

  Future<void> _deleteTask() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppTheme.surface,
          shape: RoundedRectangleBorder(borderRadius: AppTheme.radiusLg),
          title: const Row(
            children: [
              Icon(Icons.delete_outline_rounded, color: AppTheme.danger, size: 22),
              SizedBox(width: 8),
              Text('Delete Task?'),
            ],
          ),
          content: const Text(
            'Are you sure you want to delete this task? This action cannot be undone.',
            style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
          ),
          actions: [
            OutlinedButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.danger,
                foregroundColor: Colors.white,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed == true && mounted) {
      final taskId = task['id'];
      if (taskId != null) {
        await ApiService.deleteTask((taskId as num).toInt());
      }
      if (!mounted) return;
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final priority = task['priority'] ?? 'Medium';
    final status = task['status'] ?? 'To Do';
    final projectName = task['project'] ?? 'General';
    final dueDate = task['dueDate'] ?? 'No due date';
    final description = (task['description'] ?? '').toString();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Task Details'),
        actions: [
          IconButton(
            tooltip: 'Edit Task',
            icon: const Icon(Icons.edit_outlined, size: 19),
            onPressed: _editTask,
          ),
          IconButton(
            tooltip: 'Delete Task',
            icon: const Icon(Icons.delete_outline_rounded, size: 20, color: AppTheme.danger),
            onPressed: _deleteTask,
          ),
          const SizedBox(width: AppTheme.space8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.space16,
          vertical: AppTheme.space14,
        ),
        children: [
          // ==========================================
          // 1. MAIN CARD (Title, Project, Status, Priority)
          // ==========================================
          Container(
            padding: const EdgeInsets.all(AppTheme.space16),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: AppTheme.radiusLg,
              border: Border.all(color: AppTheme.cardBorder),
              boxShadow: AppTheme.cardShadow,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Badges
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    PriorityBadge(priority: priority),
                    StatusBadge(status: status),
                  ],
                ),
                const SizedBox(height: 12),

                // Title
                Text(
                  task['title'] ?? 'Task',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                    letterSpacing: -0.3,
                  ),
                ),

                const SizedBox(height: 10),

                // Meta row: Project & Due Date
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceSubtle,
                        borderRadius: AppTheme.radiusSm,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.folder_outlined, size: 13, color: AppTheme.textSecondary),
                          const SizedBox(width: 4),
                          Text(
                            projectName,
                            style: const TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.event_outlined, size: 13, color: AppTheme.textMuted),
                        const SizedBox(width: 4),
                        Text(
                          dueDate,
                          style: const TextStyle(
                            fontSize: 11.5,
                            color: AppTheme.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 14),
                const Divider(height: 1),
                const SizedBox(height: 12),

                // Quick Status Segmented Selector
                const Text(
                  'CHANGE STATUS',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textMuted,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: ['To Do', 'In Progress', 'Done'].map((st) {
                    final isSel = status == st;
                    return Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        child: InkWell(
                          onTap: () => _updateQuickStatus(st),
                          borderRadius: AppTheme.radiusSm,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            decoration: BoxDecoration(
                              color: isSel ? AppTheme.primaryLight : AppTheme.background,
                              borderRadius: AppTheme.radiusSm,
                              border: Border.all(
                                color: isSel ? AppTheme.primary : AppTheme.cardBorder,
                                width: 1,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                st,
                                style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                                  color: isSel ? AppTheme.primary : AppTheme.textSecondary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 12),

                // Quick Priority Selector
                const Text(
                  'CHANGE PRIORITY',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textMuted,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: ['Low', 'Medium', 'High'].map((pr) {
                    final isSel = priority == pr;
                    return Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        child: InkWell(
                          onTap: () => _updateQuickPriority(pr),
                          borderRadius: AppTheme.radiusSm,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            decoration: BoxDecoration(
                              color: isSel ? AppTheme.surfaceSubtle : AppTheme.background,
                              borderRadius: AppTheme.radiusSm,
                              border: Border.all(
                                color: isSel ? AppTheme.primary : AppTheme.cardBorder,
                                width: 1,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                pr,
                                style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                                  color: isSel ? AppTheme.primary : AppTheme.textSecondary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppTheme.space14),

          // ==========================================
          // 2. DESCRIPTION CARD
          // ==========================================
          Container(
            padding: const EdgeInsets.all(AppTheme.space16),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: AppTheme.radiusLg,
              border: Border.all(color: AppTheme.cardBorder),
              boxShadow: AppTheme.cardShadow,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.notes_rounded, size: 15, color: AppTheme.textSecondary),
                    SizedBox(width: 6),
                    Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  description.isNotEmpty ? description : 'No description provided.',
                  style: TextStyle(
                    fontSize: 12.5,
                    color: description.isNotEmpty ? AppTheme.textSecondary : AppTheme.textMuted,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppTheme.space14),

          // ==========================================
          // 3. ACTIVITY LOG
          // ==========================================
          Container(
            padding: const EdgeInsets.all(AppTheme.space16),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: AppTheme.radiusLg,
              border: Border.all(color: AppTheme.cardBorder),
              boxShadow: AppTheme.cardShadow,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.history_rounded, size: 15, color: AppTheme.textSecondary),
                    SizedBox(width: 6),
                    Text(
                      'Activity Log',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ...activities.map((a) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryLight,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(a['icon'] as IconData, size: 12, color: AppTheme.primary),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            a['title'] as String,
                            style: const TextStyle(fontSize: 12, color: AppTheme.textPrimary),
                          ),
                        ),
                        Text(
                          a['time'] as String,
                          style: const TextStyle(fontSize: 10.5, color: AppTheme.textMuted),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
