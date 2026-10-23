import 'package:flutter/material.dart';
import '../Services/api_service.dart';
import '../theme/app_theme.dart';
import '../widgets/status_badge.dart';
import '../widgets/priority_badge.dart';
import '../widgets/interactive_card.dart';
import '../widgets/empty_state.dart';
import 'task_details_screen.dart';
import 'add_task_screen.dart';

class ProjectDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> project;

  const ProjectDetailsScreen({super.key, required this.project});

  @override
  State<ProjectDetailsScreen> createState() => _ProjectDetailsScreenState();
}

class _ProjectDetailsScreenState extends State<ProjectDetailsScreen> {
  late Map<String, dynamic> currentProject;
  List<Map<String, dynamic>> projectTasks = [];
  bool isLoadingTasks = true;
  String selectedFilter = 'All';

  final List<String> taskFilters = const ['All', 'To Do', 'In Progress', 'Done'];

  @override
  void initState() {
    super.initState();
    currentProject = Map<String, dynamic>.from(widget.project);
    _loadProjectTasks();
  }

  Future<void> _loadProjectTasks() async {
    try {
      final data = await ApiService.getTasks();
      final projectId = currentProject['id'];

      final tasks = data
          .where((task) => task['project']?['id'] == projectId)
          .map<Map<String, dynamic>>((task) {
            final p = task['priority']?.toString().toUpperCase() ?? 'MEDIUM';
            final s = task['status']?.toString().toUpperCase() ?? 'TODO';
            final displayP = p == 'HIGH' ? 'High' : p == 'LOW' ? 'Low' : 'Medium';
            final displayS = (s == 'DONE' || s == 'COMPLETED')
                ? 'Done'
                : s == 'IN_PROGRESS'
                    ? 'In Progress'
                    : 'To Do';

            return {
              'id': task['id'],
              'title': task['title'] ?? '',
              'description': task['description'] ?? '',
              'priority': displayP,
              'status': displayS,
              'dueDate': task['dueDate'] ?? 'No due date',
              'project': task['project']?['name'] ?? currentProject['name'],
              'projectId': projectId,
            };
          })
          .toList();

      if (!mounted) return;

      setState(() {
        projectTasks = tasks;
        final doneCount = tasks.where((t) => t['status'] == 'Done').length;
        currentProject['tasks'] = tasks.length;
        currentProject['completed'] = doneCount;
        currentProject['progress'] = tasks.isEmpty ? 0.0 : doneCount / tasks.length;
        isLoadingTasks = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        isLoadingTasks = false;
      });
    }
  }

  Future<void> _openAddTask() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddTaskScreen(
          initialProjectId: (currentProject['id'] as num?)?.toInt(),
        ),
      ),
    );

    if (result == true && mounted) {
      _loadProjectTasks();
    }
  }

  Future<void> _editProject() async {
    final nameController = TextEditingController(text: currentProject['name']?.toString() ?? '');
    final descriptionController = TextEditingController(text: currentProject['description']?.toString() ?? '');
    String selectedStatus = currentProject['status']?.toString() ?? 'Active';

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
                    'Edit Project',
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
                        'Project Name',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: nameController,
                        style: const TextStyle(fontSize: 13),
                        decoration: const InputDecoration(hintText: 'Enter project name'),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: descriptionController,
                        maxLines: 2,
                        style: const TextStyle(fontSize: 13),
                        decoration: const InputDecoration(hintText: 'Enter project description'),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Status',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<String>(
                        initialValue: ['Active', 'Planning', 'On Hold', 'Completed'].contains(selectedStatus)
                            ? selectedStatus
                            : 'Active',
                        items: const [
                          DropdownMenuItem(value: 'Active', child: Text('Active')),
                          DropdownMenuItem(value: 'Planning', child: Text('Planning')),
                          DropdownMenuItem(value: 'On Hold', child: Text('On Hold')),
                          DropdownMenuItem(value: 'Completed', child: Text('Completed')),
                        ],
                        onChanged: (val) {
                          if (val != null) setDialogState(() => selectedStatus = val);
                        },
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
                  child: const Text('Save Changes'),
                ),
              ],
            );
          },
        );
      },
    );

    if (result == true && mounted) {
      final int projectId = (currentProject['id'] as num).toInt();
      final updatedData = {
        'name': nameController.text.trim(),
        'description': descriptionController.text.trim(),
        'status': selectedStatus.toUpperCase().replaceAll(' ', '_'),
      };

      try {
        await ApiService.updateProject(projectId, updatedData);
        if (!mounted) return;
        setState(() {
          currentProject['name'] = updatedData['name'];
          currentProject['description'] = updatedData['description'];
          currentProject['status'] = selectedStatus;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Project updated successfully!'),
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

  @override
  Widget build(BuildContext context) {
    final int totalTasks = projectTasks.length;
    final int completedTasks = projectTasks.where((t) => t['status'] == 'Done').length;

    final double progress = totalTasks == 0 ? 0.0 : (completedTasks / totalTasks).clamp(0.0, 1.0);
    final int progressPct = (progress * 100).round();

    // Filter tasks
    final filtered = projectTasks.where((t) {
      if (selectedFilter == 'To Do') return t['status'] == 'To Do';
      if (selectedFilter == 'In Progress') return t['status'] == 'In Progress';
      if (selectedFilter == 'Done') return t['status'] == 'Done';
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(currentProject['name']?.toString() ?? 'Project Details'),
        actions: [
          IconButton(
            tooltip: 'Edit Project',
            icon: const Icon(Icons.edit_outlined, size: 19),
            onPressed: _editProject,
          ),
          IconButton(
            tooltip: 'Add Task',
            icon: const Icon(Icons.add_task_rounded, size: 20, color: AppTheme.primary),
            onPressed: _openAddTask,
          ),
          const SizedBox(width: AppTheme.space8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadProjectTasks,
        color: AppTheme.primary,
        child: ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.space16,
            vertical: AppTheme.space12,
          ),
          children: [
            // ==========================================
            // 1. COMPACT PROJECT SUMMARY CARD
            // ==========================================
            Container(
              padding: const EdgeInsets.all(AppTheme.space14),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: AppTheme.radiusLg,
                border: Border.all(color: AppTheme.cardBorder),
                boxShadow: AppTheme.cardShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryLight,
                          borderRadius: AppTheme.radiusSm,
                        ),
                        child: const Icon(Icons.folder_rounded, color: AppTheme.primary, size: 18),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currentProject['name']?.toString() ?? 'Project',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.textPrimary,
                                letterSpacing: -0.2,
                              ),
                            ),
                            if ((currentProject['description'] ?? '').toString().isNotEmpty) ...[
                              const SizedBox(height: 3),
                              Text(
                                currentProject['description'].toString(),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppTheme.textSecondary,
                                  height: 1.35,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      StatusBadge(status: currentProject['status']?.toString() ?? 'Active'),
                    ],
                  ),

                  const SizedBox(height: 12),
                  const Divider(height: 1),
                  const SizedBox(height: 10),

                  // Progress Bar & Percentage
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Project Progress ($progressPct%)',
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      Text(
                        '$completedTasks of $totalTasks completed',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppTheme.textMuted,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 5,
                      backgroundColor: AppTheme.surfaceSubtle,
                      valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primary),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Mini KPI Pills Row
                  Row(
                    children: [
                      _miniKpi('Total', '$totalTasks', AppTheme.primary),
                      const SizedBox(width: 6),
                      _miniKpi('Completed', '$completedTasks', AppTheme.success),
                      const SizedBox(width: 6),
                      _miniKpi('Pending', '${totalTasks - completedTasks}', AppTheme.warning),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Action Buttons Row
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _editProject,
                          icon: const Icon(Icons.edit_outlined, size: 14),
                          label: const Text('Edit Project'),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(0, 34),
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _openAddTask,
                          icon: const Icon(Icons.add, size: 14),
                          label: const Text('Add Task'),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(0, 34),
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            backgroundColor: AppTheme.primary,
                            foregroundColor: Colors.white,
                            textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppTheme.space16),

            // ==========================================
            // 2. ASSOCIATED TASKS SECTION
            // ==========================================
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text(
                      'Tasks',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceSubtle,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${projectTasks.length}',
                        style: const TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
                // Micro Filter Tabs
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: taskFilters.map((f) {
                    final isSel = selectedFilter == f;
                    return InkWell(
                      onTap: () => setState(() => selectedFilter = f),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        margin: const EdgeInsets.only(left: 4),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: isSel ? AppTheme.primaryLight : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          f,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                            color: isSel ? AppTheme.primary : AppTheme.textMuted,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),

            const SizedBox(height: AppTheme.space8),

            // Tasks List
            if (isLoadingTasks)
              const Padding(
                padding: EdgeInsets.all(32),
                child: Center(child: CircularProgressIndicator(color: AppTheme.primary)),
              )
            else if (filtered.isEmpty)
              EmptyState(
                icon: Icons.task_alt_rounded,
                title: selectedFilter == 'All' ? 'No Tasks in Project' : 'No $selectedFilter Tasks',
                message: selectedFilter == 'All'
                    ? 'Break down this project by creating your first task.'
                    : 'No tasks currently marked as $selectedFilter.',
                actionLabel: 'Add Task',
                onAction: _openAddTask,
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filtered.length,
                separatorBuilder: (context, index) => const SizedBox(height: 6),
                itemBuilder: (context, index) {
                  final task = filtered[index];
                  final isDone = task['status'] == 'Done';

                  return InteractiveCard(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    borderRadius: AppTheme.radiusMd,
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TaskDetailsScreen(task: task),
                        ),
                      );
                      _loadProjectTasks();
                    },
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () => _toggleTaskStatus(task),
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.all(2),
                            child: Icon(
                              isDone ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                              size: 19,
                              color: isDone ? AppTheme.success : AppTheme.textMuted,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                task['title'] ?? 'Task',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: isDone ? AppTheme.textMuted : AppTheme.textPrimary,
                                  decoration: isDone ? TextDecoration.lineThrough : null,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 1),
                              Text(
                                'Due: ${task['dueDate']}',
                                style: const TextStyle(
                                  fontSize: 10.5,
                                  color: AppTheme.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        PriorityBadge(priority: task['priority'] ?? 'Medium', fontSize: 10),
                        const SizedBox(width: 6),
                        StatusBadge(status: task['status'] ?? 'To Do', fontSize: 10),
                      ],
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _miniKpi(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: AppTheme.radiusSm,
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _toggleTaskStatus(Map<String, dynamic> task) async {
    final taskId = task['id'];
    if (taskId == null) return;

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
      await ApiService.updateTask((taskId as num).toInt(), {'status': backendStatus});
      _loadProjectTasks();
    } catch (_) {}
  }
}
