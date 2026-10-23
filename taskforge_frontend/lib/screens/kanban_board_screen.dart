import 'package:flutter/material.dart';
import '../Services/api_service.dart';
import '../theme/app_theme.dart';
import '../widgets/responsive_scaffold.dart';
import '../widgets/priority_badge.dart';
import '../widgets/interactive_card.dart';
import 'task_details_screen.dart';
import 'add_task_screen.dart';
import 'tasks_screen.dart';

class KanbanBoardScreen extends StatefulWidget {
  const KanbanBoardScreen({super.key});

  @override
  State<KanbanBoardScreen> createState() => _KanbanBoardScreenState();
}

class _KanbanBoardScreenState extends State<KanbanBoardScreen>
    with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> tasks = [];
  bool isLoading = true;
  String searchQuery = '';
  String filterPriority = 'All';

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadTasks();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadTasks() async {
    try {
      final data = await ApiService.getTasks();
      if (!mounted) return;
      setState(() {
        tasks = data.map<Map<String, dynamic>>((t) {
          final s = t['status']?.toString().toUpperCase() ?? 'TODO';
          final displayStatus = (s == 'DONE' || s == 'COMPLETED')
              ? 'Done'
              : s == 'IN_PROGRESS'
                  ? 'In Progress'
                  : 'To Do';
          final p = t['priority']?.toString().toUpperCase() ?? 'MEDIUM';
          final displayPriority =
              p == 'HIGH' ? 'High' : p == 'LOW' ? 'Low' : 'Medium';
          return {
            'id': t['id'],
            'title': t['title'] ?? 'Task',
            'description': t['description'] ?? '',
            'status': displayStatus,
            'priority': displayPriority,
            'dueDate': t['dueDate'] ?? 'No due date',
            'project': t['project']?['name'] ?? 'General',
            'projectId': t['project']?['id'],
          };
        }).toList();
        isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => isLoading = false);
    }
  }

  void _updateTaskStatus(Map<String, dynamic> task, String newStatus) {
    final taskId = task['id'];
    if (taskId != null) {
      final backendStatus = newStatus == 'Done'
          ? 'DONE'
          : newStatus == 'In Progress'
              ? 'IN_PROGRESS'
              : 'TODO';

      setState(() {
        task['status'] = newStatus;
      });

      ApiService.updateTask((taskId as num).toInt(), {
        'status': backendStatus,
      });
    }
  }

  Future<void> _openAddTask({String? status}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddTaskScreen(initialStatus: status),
      ),
    );
    if (result == true && mounted) {
      _loadTasks();
    }
  }

  List<Map<String, dynamic>> _filteredTasks(String laneStatus) {
    return tasks.where((t) {
      if (t['status'] != laneStatus) return false;
      if (filterPriority != 'All' && t['priority'] != filterPriority) return false;
      if (searchQuery.isNotEmpty) {
        final q = searchQuery.toLowerCase();
        final title = (t['title'] ?? '').toString().toLowerCase();
        final project = (t['project'] ?? '').toString().toLowerCase();
        return title.contains(q) || project.contains(q);
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final todoTasks = _filteredTasks('To Do');
    final inProgressTasks = _filteredTasks('In Progress');
    final doneTasks = _filteredTasks('Done');

    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return ResponsiveScaffold(
      selectedIndex: 2,
      title: 'Kanban Board',
      subtitle: '${tasks.length} total tasks',
      onRefresh: _loadTasks,
      topBarActions: [
        IconButton(
          tooltip: 'Switch to List View',
          icon: const Icon(Icons.format_list_bulleted_rounded, size: 20, color: AppTheme.textSecondary),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const TasksScreen()),
            );
          },
        ),
        IconButton(
          tooltip: 'Add Task',
          icon: const Icon(Icons.add_task_rounded, size: 20, color: AppTheme.primary),
          onPressed: () => _openAddTask(),
        ),
      ],
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add Task',
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        elevation: 2,
        mini: true,
        onPressed: () => _openAddTask(),
        child: const Icon(Icons.add, size: 20),
      ),
      body: RefreshIndicator(
        onRefresh: _loadTasks,
        color: AppTheme.primary,
        child: isLoading
            ? const Center(child: CircularProgressIndicator(color: AppTheme.primary))
            : Column(
                children: [
                  // Filter bar
                  Container(
                    color: AppTheme.surface,
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 36,
                            child: TextField(
                              onChanged: (val) => setState(() => searchQuery = val),
                              style: const TextStyle(fontSize: 12.5),
                              decoration: InputDecoration(
                                hintText: 'Search tasks...',
                                prefixIcon: const Icon(Icons.search, size: 16, color: AppTheme.textMuted),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                                fillColor: AppTheme.background,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: AppTheme.radiusSm,
                                  borderSide: const BorderSide(color: AppTheme.cardBorder),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: AppTheme.radiusSm,
                                  borderSide: const BorderSide(color: AppTheme.cardBorder),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Priority dropdown
                        Container(
                          height: 36,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: AppTheme.background,
                            borderRadius: AppTheme.radiusSm,
                            border: Border.all(color: AppTheme.cardBorder),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: filterPriority,
                              style: const TextStyle(fontSize: 12, color: AppTheme.textPrimary),
                              icon: const Icon(Icons.keyboard_arrow_down, size: 16, color: AppTheme.textMuted),
                              items: const [
                                DropdownMenuItem(value: 'All', child: Text('All')),
                                DropdownMenuItem(value: 'High', child: Text('High')),
                                DropdownMenuItem(value: 'Medium', child: Text('Medium')),
                                DropdownMenuItem(value: 'Low', child: Text('Low')),
                              ],
                              onChanged: (val) {
                                if (val != null) setState(() => filterPriority = val);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // If mobile, render tab bar for smooth navigation between lanes
                  if (isMobile) ...[
                    Container(
                      color: AppTheme.surface,
                      child: TabBar(
                        controller: _tabController,
                        indicatorColor: AppTheme.primary,
                        indicatorWeight: 2.5,
                        labelColor: AppTheme.primary,
                        unselectedLabelColor: AppTheme.textSecondary,
                        labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                        unselectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                        tabs: [
                          Tab(text: 'To Do (${todoTasks.length})'),
                          Tab(text: 'In Progress (${inProgressTasks.length})'),
                          Tab(text: 'Done (${doneTasks.length})'),
                        ],
                      ),
                    ),
                  ],

                  const Divider(height: 1),

                  // Content: TabBarView on mobile, multi-column row on tablet/desktop
                  Expanded(
                    child: isMobile
                        ? TabBarView(
                            controller: _tabController,
                            children: [
                              _buildLaneList('To Do', todoTasks, const Color(0xFF64748B)),
                              _buildLaneList('In Progress', inProgressTasks, AppTheme.primary),
                              _buildLaneList('Done', doneTasks, AppTheme.success),
                            ],
                          )
                        : Padding(
                            padding: const EdgeInsets.all(AppTheme.space16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(child: _buildDesktopLane('To Do', todoTasks, const Color(0xFF64748B))),
                                const SizedBox(width: 12),
                                Expanded(child: _buildDesktopLane('In Progress', inProgressTasks, AppTheme.primary)),
                                const SizedBox(width: 12),
                                Expanded(child: _buildDesktopLane('Done', doneTasks, AppTheme.success)),
                              ],
                            ),
                          ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildLaneList(String title, List<Map<String, dynamic>> laneTasks, Color accentColor) {
    if (laneTasks.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.inbox_rounded, size: 40, color: AppTheme.textMuted.withValues(alpha: 0.5)),
              const SizedBox(height: 8),
              Text(
                'No tasks in $title',
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textSecondary),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () => _openAddTask(status: title),
                icon: const Icon(Icons.add, size: 14),
                label: const Text('Add Task'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(0, 32),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(AppTheme.space14),
      itemCount: laneTasks.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) => _buildCard(laneTasks[index]),
    );
  }

  Widget _buildDesktopLane(String title, List<Map<String, dynamic>> laneTasks, Color accentColor) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceSubtle.withValues(alpha: 0.6),
        borderRadius: AppTheme.radiusLg,
        border: Border.all(color: AppTheme.cardBorder),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(width: 7, height: 7, decoration: BoxDecoration(color: accentColor, shape: BoxShape.circle)),
                  const SizedBox(width: 6),
                  Text(
                    title,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                    decoration: BoxDecoration(
                      color: AppTheme.surface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppTheme.cardBorder),
                    ),
                    child: Text(
                      '${laneTasks.length}',
                      style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: AppTheme.textSecondary),
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () => _openAddTask(status: title),
                borderRadius: AppTheme.radiusSm,
                child: const Padding(
                  padding: EdgeInsets.all(3),
                  child: Icon(Icons.add, size: 16, color: AppTheme.textSecondary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: laneTasks.isEmpty
                ? Center(
                    child: Text('No tasks', style: TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                  )
                : ListView.separated(
                    itemCount: laneTasks.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 8),
                    itemBuilder: (context, index) => _buildCard(laneTasks[index]),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(Map<String, dynamic> task) {
    return InteractiveCard(
      padding: const EdgeInsets.all(12),
      borderRadius: AppTheme.radiusMd,
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TaskDetailsScreen(task: task),
          ),
        );
        _loadTasks();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PriorityBadge(priority: task['priority'] ?? 'Medium', fontSize: 10),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_horiz, size: 16, color: AppTheme.textMuted),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 110),
                onSelected: (newStatus) => _updateTaskStatus(task, newStatus),
                itemBuilder: (context) => [
                  if (task['status'] != 'To Do')
                    const PopupMenuItem(value: 'To Do', height: 32, child: Text('Move to To Do', style: TextStyle(fontSize: 12))),
                  if (task['status'] != 'In Progress')
                    const PopupMenuItem(value: 'In Progress', height: 32, child: Text('Move to In Progress', style: TextStyle(fontSize: 12))),
                  if (task['status'] != 'Done')
                    const PopupMenuItem(value: 'Done', height: 32, child: Text('Move to Done', style: TextStyle(fontSize: 12))),
                ],
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            task['title'] ?? 'Task',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
              letterSpacing: -0.1,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.folder_outlined, size: 11, color: AppTheme.textMuted),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  task['project'] ?? 'General',
                  style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (task['dueDate'] != null && task['dueDate'] != 'No due date') ...[
                const SizedBox(width: 4),
                Text(
                  task['dueDate'],
                  style: const TextStyle(fontSize: 10.5, color: AppTheme.textMuted),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
