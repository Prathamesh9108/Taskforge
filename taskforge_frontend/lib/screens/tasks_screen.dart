import 'package:flutter/material.dart';
import '../Services/api_service.dart';
import '../theme/app_theme.dart';
import '../widgets/responsive_scaffold.dart';
import '../widgets/status_badge.dart';
import '../widgets/priority_badge.dart';
import '../widgets/interactive_card.dart';
import '../widgets/empty_state.dart';
import 'task_details_screen.dart';
import 'add_task_screen.dart';
import 'kanban_board_screen.dart';

class TasksScreen extends StatefulWidget {
  final String? initialStatus;
  final bool initialKanbanView;

  const TasksScreen({
    super.key,
    this.initialStatus,
    this.initialKanbanView = false,
  });

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final TextEditingController searchController = TextEditingController();

  List<Map<String, dynamic>> allTasks = [];
  bool isLoading = true;
  String? errorMessage;

  late String selectedStatus;
  String selectedPriority = 'All';
  String selectedProject = 'All';

  final List<String> statusFilters = const ['All', 'To Do', 'In Progress', 'Done'];
  final List<String> priorityFilters = const ['All', 'High', 'Medium', 'Low'];
  List<String> projectFilters = ['All'];

  @override
  void initState() {
    super.initState();
    selectedStatus = widget.initialStatus ?? 'All';
    _loadTasks();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> _loadTasks() async {
    try {
      final data = await ApiService.getTasks();
      if (!mounted) return;

      setState(() {
        allTasks = data.map<Map<String, dynamic>>((task) {
          return {
            'id': task['id'],
            'title': task['title'] ?? 'Task',
            'description': task['description'] ?? '',
            'priority': _formatPriority(task['priority']),
            'status': _formatStatus(task['status']),
            'dueDate': task['dueDate'] ?? 'No due date',
            'project': task['project']?['name'] ?? 'General',
            'projectId': task['project']?['id'],
          };
        }).toList();

        final names = <String>{};
        for (var t in allTasks) {
          final p = t['project']?.toString();
          if (p != null && p.isNotEmpty) names.add(p);
        }
        projectFilters = ['All', ...names];

        isLoading = false;
        errorMessage = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
    }
  }

  String _formatStatus(String? status) {
    final s = (status ?? '').toUpperCase().replaceAll(' ', '_');
    if (s == 'DONE' || s == 'COMPLETED') return 'Done';
    if (s == 'IN_PROGRESS') return 'In Progress';
    return 'To Do';
  }

  String _formatPriority(String? priority) {
    final p = (priority ?? '').toUpperCase();
    if (p == 'HIGH') return 'High';
    if (p == 'LOW') return 'Low';
    return 'Medium';
  }

  Future<void> _openAddTask() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddTaskScreen(),
      ),
    );

    if (result == true && mounted) {
      _loadTasks();
    }
  }

  Future<void> _toggleTaskStatus(Map<String, dynamic> task) async {
    final int taskId = (task['id'] as num).toInt();
    final currentStatus = task['status'];
    final nextStatus = currentStatus == 'Done'
        ? 'To Do'
        : currentStatus == 'To Do'
            ? 'In Progress'
            : 'Done';

    final backendStatus = nextStatus == 'Done'
        ? 'DONE'
        : nextStatus == 'In Progress'
            ? 'IN_PROGRESS'
            : 'TODO';

    setState(() {
      task['status'] = nextStatus;
    });

    try {
      await ApiService.updateTask(taskId, {'status': backendStatus});
      _loadTasks();
    } catch (_) {}
  }

  Future<void> _editTask(Map<String, dynamic> task) async {
    final titleController = TextEditingController(text: task['title'] ?? '');
    final descriptionController = TextEditingController(text: task['description'] ?? '');
    String currentStatus = task['status'] ?? 'To Do';
    String currentPriority = task['priority'] ?? 'Medium';

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
                        maxLines: 2,
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
                                  initialValue: currentStatus,
                                  items: const [
                                    DropdownMenuItem(value: 'To Do', child: Text('To Do')),
                                    DropdownMenuItem(value: 'In Progress', child: Text('In Progress')),
                                    DropdownMenuItem(value: 'Done', child: Text('Done')),
                                  ],
                                  onChanged: (val) {
                                    if (val != null) setDialogState(() => currentStatus = val);
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
                                  initialValue: currentPriority,
                                  items: const [
                                    DropdownMenuItem(value: 'High', child: Text('High')),
                                    DropdownMenuItem(value: 'Medium', child: Text('Medium')),
                                    DropdownMenuItem(value: 'Low', child: Text('Low')),
                                  ],
                                  onChanged: (val) {
                                    if (val != null) setDialogState(() => currentPriority = val);
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
      final int taskId = (task['id'] as num).toInt();
      final backendStatus = currentStatus == 'Done'
          ? 'DONE'
          : currentStatus == 'In Progress'
              ? 'IN_PROGRESS'
              : 'TODO';

      try {
        await ApiService.updateTask(taskId, {
          'title': titleController.text.trim(),
          'description': descriptionController.text.trim(),
          'status': backendStatus,
          'priority': currentPriority.toUpperCase(),
        });
        await _loadTasks();

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Task updated successfully'),
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

  Future<void> _deleteTask(int taskId) async {
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
              Text(
                'Delete Task?',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          content: const Text(
            'Are you sure you want to delete this task? This cannot be undone.',
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
      try {
        await ApiService.deleteTask(taskId);
        await _loadTasks();

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Task deleted successfully'),
            backgroundColor: AppTheme.danger,
          ),
        );
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete: $e'), backgroundColor: AppTheme.danger),
        );
      }
    }
  }

  List<Map<String, dynamic>> _filteredTasks() {
    return allTasks.where((t) {
      final title = (t['title'] ?? '').toString().toLowerCase();
      final project = (t['project'] ?? '').toString().toLowerCase();
      final desc = (t['description'] ?? '').toString().toLowerCase();

      // Status Filter
      if (selectedStatus != 'All' && t['status'] != selectedStatus) {
        return false;
      }

      // Priority Filter
      if (selectedPriority != 'All' && t['priority'] != selectedPriority) {
        return false;
      }

      // Project Filter
      if (selectedProject != 'All' && t['project'] != selectedProject) {
        return false;
      }

      // Search
      final query = searchController.text.trim().toLowerCase();
      if (query.isNotEmpty) {
        return title.contains(query) || project.contains(query) || desc.contains(query);
      }

      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredTasks();

    return ResponsiveScaffold(
      selectedIndex: 2,
      title: 'Tasks',
      subtitle: '${allTasks.length} tasks in workspace',
      onRefresh: _loadTasks,
      topBarActions: [
        IconButton(
          tooltip: 'Switch to Kanban Board',
          icon: const Icon(Icons.view_kanban_outlined, size: 20, color: AppTheme.textSecondary),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const KanbanBoardScreen()),
            );
          },
        ),
        IconButton(
          tooltip: 'Add Task',
          icon: const Icon(Icons.add_task_rounded, size: 20, color: AppTheme.primary),
          onPressed: _openAddTask,
        ),
      ],
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add Task',
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        elevation: 2,
        mini: true,
        onPressed: _openAddTask,
        child: const Icon(Icons.add, size: 20),
      ),
      body: RefreshIndicator(
        onRefresh: _loadTasks,
        color: AppTheme.primary,
        child: Column(
          children: [
            // ==========================================
            // SEARCH & FILTER CONTROLS
            // ==========================================
            Container(
              color: AppTheme.surface,
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
              child: Column(
                children: [
                  // Search Bar
                  SizedBox(
                    height: 38,
                    child: TextField(
                      controller: searchController,
                      style: const TextStyle(fontSize: 13),
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        hintText: 'Search tasks or projects...',
                        prefixIcon: const Icon(Icons.search, size: 17, color: AppTheme.textMuted),
                        suffixIcon: searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, size: 16, color: AppTheme.textMuted),
                                onPressed: () {
                                  searchController.clear();
                                  setState(() {});
                                },
                              )
                            : null,
                        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                        fillColor: AppTheme.background,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: AppTheme.radiusMd,
                          borderSide: const BorderSide(color: AppTheme.cardBorder),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: AppTheme.radiusMd,
                          borderSide: const BorderSide(color: AppTheme.cardBorder),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: AppTheme.radiusMd,
                          borderSide: const BorderSide(color: AppTheme.primary),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Filter Chips (Status & Priority in compact row)
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        // Status Filter Chips
                        ...statusFilters.map((s) {
                          final isSel = selectedStatus == s;
                          return Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: InkWell(
                              onTap: () => setState(() => selectedStatus = s),
                              borderRadius: BorderRadius.circular(14),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: isSel ? AppTheme.primary : AppTheme.background,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: isSel ? AppTheme.primary : AppTheme.cardBorder,
                                  ),
                                ),
                                child: Text(
                                  s,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                                    color: isSel ? Colors.white : AppTheme.textSecondary,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),

                        Container(
                          height: 16,
                          width: 1,
                          color: AppTheme.divider,
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                        ),

                        // Priority Filter Chips
                        ...priorityFilters.map((p) {
                          final isSel = selectedPriority == p;
                          return Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: InkWell(
                              onTap: () => setState(() => selectedPriority = p),
                              borderRadius: BorderRadius.circular(14),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                                decoration: BoxDecoration(
                                  color: isSel ? AppTheme.surfaceSubtle : AppTheme.background,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: isSel ? AppTheme.primary : AppTheme.cardBorder,
                                  ),
                                ),
                                child: Text(
                                  p == 'All' ? 'All Priority' : p,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                                    color: isSel ? AppTheme.primary : AppTheme.textMuted,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),

                        if (projectFilters.length > 2) ...[
                          Container(
                            height: 16,
                            width: 1,
                            color: AppTheme.divider,
                            margin: const EdgeInsets.symmetric(horizontal: 6),
                          ),
                          Container(
                            height: 26,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              color: selectedProject != 'All' ? AppTheme.primaryLight : AppTheme.background,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: selectedProject != 'All' ? AppTheme.primary : AppTheme.cardBorder,
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: projectFilters.contains(selectedProject) ? selectedProject : 'All',
                                icon: const Icon(Icons.arrow_drop_down, size: 14, color: AppTheme.textMuted),
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: selectedProject != 'All' ? FontWeight.w700 : FontWeight.w500,
                                  color: selectedProject != 'All' ? AppTheme.primary : AppTheme.textSecondary,
                                ),
                                onChanged: (val) {
                                  if (val != null) setState(() => selectedProject = val);
                                },
                                items: projectFilters.map((p) {
                                  return DropdownMenuItem(
                                    value: p,
                                    child: Text(p == 'All' ? 'All Projects' : p),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            // ==========================================
            // COMPACT TASK LIST
            // ==========================================
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator(color: AppTheme.primary))
                  : filtered.isEmpty
                      ? EmptyState(
                          icon: Icons.task_alt_rounded,
                          title: 'No Tasks Found',
                          message: searchController.text.isNotEmpty
                              ? 'No tasks match "${searchController.text}".'
                              : 'Try changing your filters or add a new task.',
                          actionLabel: searchController.text.isNotEmpty ? 'Clear Search' : 'Add Task',
                          onAction: searchController.text.isNotEmpty
                              ? () {
                                  searchController.clear();
                                  setState(() {});
                                }
                              : _openAddTask,
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(
                            AppTheme.space16,
                            AppTheme.space12,
                            AppTheme.space16,
                            76,
                          ),
                          itemCount: filtered.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 8),
                          itemBuilder: (context, index) {
                            final task = filtered[index];
                            final isDone = task['status'] == 'Done';
                            final taskId = (task['id'] as num).toInt();

                            return InteractiveCard(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              borderRadius: AppTheme.radiusLg,
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TaskDetailsScreen(task: task),
                                  ),
                                );
                                _loadTasks();
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Quick toggle circle
                                  InkWell(
                                    onTap: () => _toggleTaskStatus(task),
                                    borderRadius: BorderRadius.circular(12),
                                    child: Padding(
                                      padding: const EdgeInsets.all(2),
                                      child: Icon(
                                        isDone
                                            ? Icons.check_circle_rounded
                                            : Icons.radio_button_unchecked_rounded,
                                        size: 19,
                                        color: isDone ? AppTheme.success : AppTheme.textMuted,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),

                                  // Task Title + Project Name
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          task['title'] ?? 'Task',
                                          style: TextStyle(
                                            fontSize: 13.5,
                                            fontWeight: FontWeight.w600,
                                            color: isDone ? AppTheme.textMuted : AppTheme.textPrimary,
                                            decoration: isDone ? TextDecoration.lineThrough : null,
                                            letterSpacing: -0.1,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 2),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.folder_outlined,
                                              size: 11,
                                              color: AppTheme.textMuted,
                                            ),
                                            const SizedBox(width: 3),
                                            Text(
                                              task['project'] ?? 'General',
                                              style: const TextStyle(
                                                fontSize: 11,
                                                color: AppTheme.textSecondary,
                                              ),
                                            ),
                                            if (task['dueDate'] != null && task['dueDate'] != 'No due date') ...[
                                              const SizedBox(width: 6),
                                              Text(
                                                '• ${task['dueDate']}',
                                                style: const TextStyle(
                                                  fontSize: 10.5,
                                                  color: AppTheme.textMuted,
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),

                                  // Priority Badge
                                  PriorityBadge(
                                    priority: task['priority'] ?? 'Medium',
                                    fontSize: 10,
                                  ),
                                  const SizedBox(width: 6),

                                  // Status Badge
                                  StatusBadge(
                                    status: task['status'] ?? 'To Do',
                                    fontSize: 10,
                                  ),
                                  const SizedBox(width: 4),

                                  // Edit & Delete actions
                                  PopupMenuButton<String>(
                                    icon: const Icon(
                                      Icons.more_vert,
                                      size: 17,
                                      color: AppTheme.textMuted,
                                    ),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(minWidth: 120),
                                    onSelected: (val) {
                                      if (val == 'edit') _editTask(task);
                                      if (val == 'delete') _deleteTask(taskId);
                                    },
                                    itemBuilder: (context) => [
                                      const PopupMenuItem(
                                        value: 'edit',
                                        height: 34,
                                        child: Row(
                                          children: [
                                            Icon(Icons.edit_outlined, size: 15, color: AppTheme.textSecondary),
                                            SizedBox(width: 8),
                                            Text('Edit', style: TextStyle(fontSize: 12)),
                                          ],
                                        ),
                                      ),
                                      const PopupMenuItem(
                                        value: 'delete',
                                        height: 34,
                                        child: Row(
                                          children: [
                                            Icon(Icons.delete_outline, size: 15, color: AppTheme.danger),
                                            SizedBox(width: 8),
                                            Text('Delete', style: TextStyle(fontSize: 12, color: AppTheme.danger)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
