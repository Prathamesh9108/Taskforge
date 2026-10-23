import 'package:flutter/material.dart';
import '../Services/api_service.dart';
import '../theme/app_theme.dart';
import '../widgets/responsive_scaffold.dart';
import '../widgets/stat_card.dart';
import '../widgets/status_badge.dart';
import '../widgets/priority_badge.dart';
import '../widgets/interactive_card.dart';
import '../widgets/empty_state.dart';
import 'projects_screen.dart';
import 'tasks_screen.dart';
import 'project_details_screen.dart';
import 'task_details_screen.dart';
import 'create_project_screen.dart';
import 'add_task_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool isLoading = true;
  List<Map<String, dynamic>> projects = [];
  List<Map<String, dynamic>> allTasks = [];

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    try {
      final projectsData = await ApiService.getProjects();
      final tasksData = await ApiService.getTasks();

      if (!mounted) return;

      setState(() {
        projects = projectsData
            .map<Map<String, dynamic>>((p) => Map<String, dynamic>.from(p))
            .toList();

        allTasks = tasksData.map<Map<String, dynamic>>((task) {
          return {
            'id': task['id'],
            'title': task['title'] ?? 'Untitled Task',
            'description': task['description'] ?? '',
            'priority': _formatPriority(task['priority']),
            'status': _formatStatus(task['status']),
            'dueDate': task['dueDate'] ?? 'No due date',
            'project': task['project']?['name'] ?? 'General',
            'projectId': task['project']?['id'],
          };
        }).toList();

        isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    }
  }

  String _formatStatus(String? status) {
    if (status == 'TODO' || status == 'To Do') return 'To Do';
    if (status == 'IN_PROGRESS' || status == 'In Progress') return 'In Progress';
    if (status == 'DONE' || status == 'Done' || status == 'Completed') return 'Done';
    return status ?? 'To Do';
  }

  String _formatPriority(String? priority) {
    final p = priority?.toUpperCase();
    if (p == 'HIGH') return 'High';
    if (p == 'LOW') return 'Low';
    return 'Medium';
  }

  bool _isCompleted(String? status) {
    final s = status?.toLowerCase() ?? '';
    return s == 'completed' || s == 'done';
  }

  bool _isInProgress(String? status) {
    final s = status?.toLowerCase() ?? '';
    return s == 'in progress' || s == 'in_progress';
  }

  String _getFormattedDate() {
    final now = DateTime.now();
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final dayName = days[now.weekday - 1];
    final monthName = months[now.month - 1];
    return '$dayName, $monthName ${now.day}';
  }

  void _navigateToTasks(String filter) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TasksScreen(
          initialStatus: filter,
        ),
      ),
    );
    _loadDashboardData();
  }

  void _navigateToProjects() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProjectsScreen(),
      ),
    );
    _loadDashboardData();
  }

  Future<void> _openCreateProject() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateProjectScreen()),
    );
    if (result != null && result is Map<String, dynamic>) {
      await ApiService.createProject(result);
      _loadDashboardData();
    }
  }

  Future<void> _openAddTask() async {
    final created = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddTaskScreen()),
    );
    if (created == true) {
      _loadDashboardData();
    }
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
      _loadDashboardData();
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 850;
    final totalProjects = projects.length;
    final totalTasks = allTasks.length;
    final completedTasks = allTasks.where((t) => _isCompleted(t['status'])).length;
    final inProgressTasks = allTasks.where((t) => _isInProgress(t['status'])).length;
    final pendingTasks = totalTasks - completedTasks;

    final overallVelocity = totalTasks > 0 ? (completedTasks / totalTasks) : 0.0;
    final overallVelocityPct = (overallVelocity * 100).round();

    final recentProjects = projects.take(3).toList();
    final recentTasks = allTasks.take(4).toList();

    return ResponsiveScaffold(
      selectedIndex: 0,
      title: 'Workspace',
      subtitle: _getFormattedDate(),
      onRefresh: _loadDashboardData,
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
        onRefresh: _loadDashboardData,
        color: AppTheme.primary,
        child: isLoading
            ? const Center(child: CircularProgressIndicator(color: AppTheme.primary))
            : SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.space16,
                  vertical: AppTheme.space12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ==========================================
                    // 1. COMPACT WELCOME HEADER
                    // ==========================================
                    _buildCompactHeader(context),

                    const SizedBox(height: AppTheme.space12),

                    // ==========================================
                    // 2. 4 COMPACT SUMMARY CARDS (2-COLUMN GRID)
                    // ==========================================
                    _buildKpiGrid(
                      isDesktop: isDesktop,
                      totalProjects: totalProjects,
                      totalTasks: totalTasks,
                      completedTasks: completedTasks,
                      pendingTasks: pendingTasks,
                    ),

                    const SizedBox(height: AppTheme.space16),

                    // ==========================================
                    // 3. PROJECT PROGRESS OVERVIEW (THIN PROGRESS BAR)
                    // ==========================================
                    _buildProgressSection(
                      overallVelocity: overallVelocity,
                      overallVelocityPct: overallVelocityPct,
                      completedCount: completedTasks,
                      inProgressCount: inProgressTasks,
                      totalCount: totalTasks,
                    ),

                    const SizedBox(height: AppTheme.space16),

                    // ==========================================
                    // 4. RECENT PROJECTS SECTION
                    // ==========================================
                    _buildRecentProjectsSection(recentProjects),

                    const SizedBox(height: AppTheme.space16),

                    // ==========================================
                    // 5. RECENT TASKS SECTION
                    // ==========================================
                    _buildRecentTasksSection(recentTasks),

                    const SizedBox(height: AppTheme.space20),
                  ],
                ),
              ),
      ),
    );
  }

  // ============================================================
  // COMPACT WELCOME HEADER WITH QUICK ACTIONS
  // ============================================================
  Widget _buildCompactHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.space14,
        vertical: AppTheme.space12,
      ),
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
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Text(
                          'Welcome back, Alex',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textPrimary,
                            letterSpacing: -0.2,
                          ),
                        ),
                        SizedBox(width: 4),
                        Text('👋', style: TextStyle(fontSize: 14)),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${projects.length} projects • ${allTasks.length} tasks in workspace',
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _openCreateProject,
                  icon: const Icon(Icons.add_rounded, size: 14),
                  label: const Text('New Project'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 32),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    side: const BorderSide(color: AppTheme.primaryBorder),
                    foregroundColor: AppTheme.primary,
                    textStyle: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(width: AppTheme.space8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _openAddTask,
                  icon: const Icon(Icons.add_task_rounded, size: 14),
                  label: const Text('Add Task'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(0, 32),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    backgroundColor: AppTheme.primary,
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // 4 COMPACT SUMMARY CARDS (RESPONSIVE GRID)
  // ============================================================
  Widget _buildKpiGrid({
    required bool isDesktop,
    required int totalProjects,
    required int totalTasks,
    required int completedTasks,
    required int pendingTasks,
  }) {
    final columns = isDesktop ? 4 : 2;

    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            mainAxisExtent: isDesktop ? 96.0 : 98.0,
          ),
          children: [
            StatCard(
              title: 'Total Projects',
              value: '$totalProjects',
              icon: Icons.folder_outlined,
              accentColor: AppTheme.primary,
              onTap: _navigateToProjects,
            ),
            StatCard(
              title: 'Total Tasks',
              value: '$totalTasks',
              icon: Icons.task_alt_outlined,
              accentColor: const Color(0xFF0284C7),
              onTap: () => _navigateToTasks('All'),
            ),
            StatCard(
              title: 'Completed',
              value: '$completedTasks',
              icon: Icons.check_circle_outline,
              accentColor: AppTheme.success,
              onTap: () => _navigateToTasks('Done'),
            ),
            StatCard(
              title: 'Pending',
              value: '$pendingTasks',
              icon: Icons.pending_actions_outlined,
              accentColor: AppTheme.warning,
              onTap: () => _navigateToTasks('In Progress'),
            ),
          ],
        );
  }

  // ============================================================
  // PROJECT PROGRESS SECTION (THIN PROGRESS BAR & DISTRIBUTION)
  // ============================================================
  Widget _buildProgressSection({
    required double overallVelocity,
    required int overallVelocityPct,
    required int completedCount,
    required int inProgressCount,
    required int totalCount,
  }) {
    final todoCount = (totalCount - completedCount - inProgressCount).clamp(0, totalCount);

    return Container(
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.trending_up_rounded, size: 16, color: AppTheme.primary),
                  SizedBox(width: 6),
                  Text(
                    'Workspace Progress',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.primaryLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$overallVelocityPct%',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: SizedBox(
              height: 6,
              child: totalCount == 0
                  ? Container(color: AppTheme.surfaceSubtle)
                  : Row(
                      children: [
                        if (completedCount > 0)
                          Expanded(
                            flex: completedCount,
                            child: Container(color: AppTheme.success),
                          ),
                        if (inProgressCount > 0)
                          Expanded(
                            flex: inProgressCount,
                            child: Container(color: AppTheme.primary),
                          ),
                        if (todoCount > 0)
                          Expanded(
                            flex: todoCount,
                            child: Container(color: AppTheme.cardBorder),
                          ),
                      ],
                    ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _metricPill('To Do', todoCount, AppTheme.textMuted),
              _metricPill('In Progress', inProgressCount, AppTheme.primary),
              _metricPill('Done', completedCount, AppTheme.success),
            ],
          ),
        ],
      ),
    );
  }

  Widget _metricPill(String label, int count, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '$label: $count',
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // RECENT PROJECTS SECTION
  // ============================================================
  Widget _buildRecentProjectsSection(List<Map<String, dynamic>> recentList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Projects',
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
                letterSpacing: -0.2,
              ),
            ),
            InkWell(
              onTap: _navigateToProjects,
              borderRadius: AppTheme.radiusSm,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                child: Text(
                  'View All',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primary,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppTheme.space8),
        if (recentList.isEmpty)
          const EmptyState(
            icon: Icons.folder_open_rounded,
            title: 'No Projects Yet',
            message: 'Create a project to start organizing tasks.',
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: recentList.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final project = recentList[index];
              final progress = (project['progress'] as num?)?.toDouble() ?? 0.0;
              final progressPct = (progress * 100).round();

              return InteractiveCard(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                borderRadius: AppTheme.radiusMd,
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProjectDetailsScreen(project: project),
                    ),
                  );
                  _loadDashboardData();
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryLight,
                            borderRadius: AppTheme.radiusSm,
                          ),
                          child: const Icon(
                            Icons.folder_rounded,
                            color: AppTheme.primary,
                            size: 15,
                          ),
                        ),
                        const SizedBox(width: 9),
                        Expanded(
                          child: Text(
                            project['name']?.toString() ?? 'Project',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        StatusBadge(
                          status: project['status']?.toString() ?? 'Active',
                          fontSize: 10.5,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 4,
                        backgroundColor: AppTheme.surfaceSubtle,
                        valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primary),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${project['completed'] ?? 0} of ${project['tasks'] ?? 0} tasks done',
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppTheme.textMuted,
                          ),
                        ),
                        Text(
                          '$progressPct%',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }

  // ============================================================
  // RECENT TASKS SECTION
  // ============================================================
  Widget _buildRecentTasksSection(List<Map<String, dynamic>> tasksList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Tasks',
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
                letterSpacing: -0.2,
              ),
            ),
            InkWell(
              onTap: () => _navigateToTasks('All'),
              borderRadius: AppTheme.radiusSm,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                child: Text(
                  'View All',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primary,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppTheme.space8),
        if (tasksList.isEmpty)
          const EmptyState(
            icon: Icons.task_alt_rounded,
            title: 'No Tasks Found',
            message: 'All caught up! Tap + to create a task.',
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: tasksList.length,
            separatorBuilder: (context, index) => const SizedBox(height: 6),
            itemBuilder: (context, index) {
              final task = tasksList[index];
              final isDone = _isCompleted(task['status']);

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
                  _loadDashboardData();
                },
                child: Row(
                  children: [
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
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            task['title'] ?? 'Untitled',
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
                            task['project'] ?? 'General',
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppTheme.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    PriorityBadge(
                      priority: task['priority'] ?? 'Medium',
                      fontSize: 10,
                    ),
                    const SizedBox(width: 6),
                    StatusBadge(
                      status: task['status'] ?? 'To Do',
                      fontSize: 10,
                    ),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }
}
