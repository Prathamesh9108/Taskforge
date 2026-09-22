import 'package:flutter/material.dart';

class KanbanBoardScreen extends StatefulWidget {
  const KanbanBoardScreen({super.key});

  @override
  State<KanbanBoardScreen> createState() => _KanbanBoardScreenState();
}

class _KanbanBoardScreenState extends State<KanbanBoardScreen> {
  // =========================================================
  // TASK LIST
  // =========================================================

  final List<Map<String, dynamic>> tasks = [
    {
      'id': 1,
      'title': 'Create Login UI',
      'description': 'Design login screen',
      'priority': 'High',
      'status': 'To Do',
    },
    {
      'id': 2,
      'title': 'Dashboard Design',
      'description': 'Create dashboard UI',
      'priority': 'Medium',
      'status': 'To Do',
    },
    {
      'id': 3,
      'title': 'Registration Screen',
      'description': 'Implement registration',
      'priority': 'High',
      'status': 'In Progress',
    },
    {
      'id': 4,
      'title': 'Project Screen',
      'description': 'Design project management',
      'priority': 'Medium',
      'status': 'In Progress',
    },
    {
      'id': 5,
      'title': 'Splash Screen',
      'description': 'Create application splash',
      'priority': 'Low',
      'status': 'Done',
    },
  ];

  // =========================================================
  // BUILD
  // =========================================================

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final bool isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      // =====================================================
      // APP BAR
      // =====================================================
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },

          icon: Icon(Icons.arrow_back, color: colors.onSurface),
        ),

        title: Text(
          'Kanban Board',

          style: TextStyle(
            color: colors.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: () {
              setState(() {});

              _showMessage('Kanban board refreshed');
            },

            icon: Icon(Icons.refresh, color: colors.onSurface),
          ),
        ],
      ),

      // =====================================================
      // BODY
      // =====================================================
      body: Column(
        children: [
          // =================================================
          // PROJECT HEADER
          // =================================================

          Container(
            width: double.infinity,

            color: isDark ? const Color(0xFF1E293B) : Colors.white,

            padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),

            child: Row(
              children: [
                // PROJECT ICON
                Container(
                  width: 45,
                  height: 45,

                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF334155)
                        : const Color(0xFFEFF6FF),

                    borderRadius: BorderRadius.circular(12),
                  ),

                  child: const Icon(
                    Icons.folder_outlined,
                    color: Color(0xFF2563EB),
                  ),
                ),

                const SizedBox(width: 12),

                // PROJECT INFORMATION
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        'TaskForge Mobile App',

                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,

                          color: colors.onSurface,
                        ),
                      ),

                      const SizedBox(height: 3),

                      Text(
                        'Project Task Board',

                        style: TextStyle(
                          fontSize: 12,

                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 15),

          // =================================================
          // KANBAN BOARD
          // =================================================
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,

              padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),

              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  _buildColumn('To Do'),

                  const SizedBox(width: 12),

                  _buildColumn('In Progress'),

                  const SizedBox(width: 12),

                  _buildColumn('Done'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // COLUMN
  // =========================================================

  Widget _buildColumn(String status) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final bool isDark = theme.brightness == Brightness.dark;

    final columnTasks = tasks
        .where((task) => task['status'] == status)
        .toList();

    return DragTarget<Map<String, dynamic>>(
      onWillAcceptWithDetails: (details) {
        return true;
      },

      onAcceptWithDetails: (details) {
        setState(() {
          details.data['status'] = status;
        });

        _showMessage('Task moved to $status');
      },

      builder: (context, candidateData, rejectedData) {
        final bool isDraggingOver = candidateData.isNotEmpty;

        return Container(
          width: 285,

          constraints: const BoxConstraints(minHeight: 500),

          padding: const EdgeInsets.all(12),

          decoration: BoxDecoration(
            color: isDraggingOver
                ? (isDark ? const Color(0xFF1E3A5F) : const Color(0xFFEFF6FF))
                : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9)),

            borderRadius: BorderRadius.circular(18),

            border: Border.all(
              color: isDraggingOver
                  ? const Color(0xFF2563EB)
                  : (isDark
                        ? const Color(0xFF334155)
                        : const Color(0xFFE2E8F0)),
            ),
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // =================================================
              // COLUMN HEADER
              // =================================================

              Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,

                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _statusColor(status),
                    ),
                  ),

                  const SizedBox(width: 8),

                  Text(
                    status,

                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,

                      color: colors.onSurface,
                    ),
                  ),

                  const Spacer(),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 5,
                    ),

                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF334155) : Colors.white,

                      borderRadius: BorderRadius.circular(8),
                    ),

                    child: Text(
                      '${columnTasks.length}',

                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,

                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              // =================================================
              // TASKS
              // =================================================
              if (columnTasks.isEmpty)
                _emptyColumn()
              else
                ...columnTasks.map((task) => _buildTaskCard(task)),
            ],
          ),
        );
      },
    );
  }

  // =========================================================
  // TASK CARD
  // =========================================================

  Widget _buildTaskCard(Map<String, dynamic> task) {
    return LongPressDraggable<Map<String, dynamic>>(
      data: task,

      feedback: Material(
        color: Colors.transparent,

        child: SizedBox(
          width: 260,

          child: _taskCardContent(task, dragging: true),
        ),
      ),

      childWhenDragging: Opacity(opacity: 0.3, child: _taskCardContent(task)),

      child: GestureDetector(
        onTap: () {
          _showTaskOptions(task);
        },

        child: _taskCardContent(task),
      ),
    );
  }

  // =========================================================
  // TASK CARD CONTENT
  // =========================================================

  Widget _taskCardContent(Map<String, dynamic> task, {bool dragging = false}) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final bool isDark = theme.brightness == Brightness.dark;

    final String priority = task['priority'] ?? 'Medium';

    return Container(
      width: double.infinity,

      margin: const EdgeInsets.only(bottom: 10),

      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,

        borderRadius: BorderRadius.circular(14),

        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),

        boxShadow: dragging
            ? const [
                BoxShadow(
                  blurRadius: 10,
                  offset: Offset(0, 5),
                  color: Colors.black26,
                ),
              ]
            : null,
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          // =================================================
          // TITLE
          // =================================================

          Row(
            children: [
              Expanded(
                child: Text(
                  task['title'].toString(),

                  maxLines: 2,

                  overflow: TextOverflow.ellipsis,

                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,

                    color: colors.onSurface,
                  ),
                ),
              ),

              Icon(
                Icons.drag_indicator,
                size: 18,

                color: colors.onSurfaceVariant,
              ),
            ],
          ),

          const SizedBox(height: 7),

          // =================================================
          // DESCRIPTION
          // =================================================
          Text(
            task['description'].toString(),

            maxLines: 2,

            overflow: TextOverflow.ellipsis,

            style: TextStyle(
              fontSize: 12,

              color: colors.onSurfaceVariant,

              height: 1.4,
            ),
          ),

          const SizedBox(height: 12),

          // =================================================
          // PRIORITY
          // =================================================
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),

                decoration: BoxDecoration(
                  color: _priorityColor(priority).withOpacity(0.1),

                  borderRadius: BorderRadius.circular(6),
                ),

                child: Text(
                  priority,

                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,

                    color: _priorityColor(priority),
                  ),
                ),
              ),

              const Spacer(),

              Icon(Icons.more_horiz, size: 18, color: colors.onSurfaceVariant),
            ],
          ),
        ],
      ),
    );
  }

  // =========================================================
  // EMPTY COLUMN
  // =========================================================

  Widget _emptyColumn() {
    final colors = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,

      padding: const EdgeInsets.symmetric(vertical: 40),

      child: Column(
        children: [
          Icon(Icons.inbox_outlined, size: 35, color: colors.onSurfaceVariant),

          const SizedBox(height: 8),

          Text(
            'No tasks',

            style: TextStyle(fontSize: 12, color: colors.onSurfaceVariant),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // TASK OPTIONS
  // =========================================================

  void _showTaskOptions(Map<String, dynamic> task) {
    showModalBottomSheet(
      context: context,

      backgroundColor: Theme.of(context).colorScheme.surface,

      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),

      builder: (sheetContext) {
        final colors = Theme.of(sheetContext).colorScheme;

        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,

            children: [
              // =================================================
              // MOVE TASK
              // =================================================

              ListTile(
                leading: Icon(Icons.arrow_forward, color: colors.primary),

                title: Text(
                  'Move Task',
                  style: TextStyle(color: colors.onSurface),
                ),

                onTap: () {
                  Navigator.pop(sheetContext);

                  _moveTask(task);
                },
              ),

              // =================================================
              // TASK DETAILS
              // =================================================
              ListTile(
                leading: Icon(Icons.info_outline, color: colors.primary),

                title: Text(
                  'Task Details',
                  style: TextStyle(color: colors.onSurface),
                ),

                onTap: () {
                  Navigator.pop(sheetContext);

                  _showTaskDetails(task);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // =========================================================
  // TASK DETAILS
  // =========================================================

  void _showTaskDetails(Map<String, dynamic> task) {
    final colors = Theme.of(context).colorScheme;

    showDialog(
      context: context,

      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            task['title'].toString(),

            style: const TextStyle(fontWeight: FontWeight.bold),
          ),

          content: Column(
            mainAxisSize: MainAxisSize.min,

            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(task['description'].toString()),

              const SizedBox(height: 15),

              Text('Priority: ${task['priority']}'),

              const SizedBox(height: 8),

              Text('Status: ${task['status']}'),
            ],
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },

              child: Text('Close', style: TextStyle(color: colors.primary)),
            ),
          ],
        );
      },
    );
  }

  // =========================================================
  // MOVE TASK
  // =========================================================

  void _moveTask(Map<String, dynamic> task) {
    showModalBottomSheet(
      context: context,

      backgroundColor: Theme.of(context).colorScheme.surface,

      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),

      builder: (sheetContext) {
        final colors = Theme.of(sheetContext).colorScheme;

        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,

            children: [
              // =================================================
              // TITLE
              // =================================================

              Padding(
                padding: const EdgeInsets.all(18),

                child: Text(
                  'Move Task To',

                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,

                    color: colors.onSurface,
                  ),
                ),
              ),

              // =================================================
              // TO DO
              // =================================================
              ListTile(
                leading: const Icon(Icons.radio_button_unchecked),

                title: const Text('To Do'),

                onTap: () {
                  _changeStatus(task, 'To Do');
                },
              ),

              // =================================================
              // IN PROGRESS
              // =================================================
              ListTile(
                leading: const Icon(Icons.timelapse),

                title: const Text('In Progress'),

                onTap: () {
                  _changeStatus(task, 'In Progress');
                },
              ),

              // =================================================
              // DONE
              // =================================================
              ListTile(
                leading: const Icon(Icons.check_circle_outline),

                title: const Text('Done'),

                onTap: () {
                  _changeStatus(task, 'Done');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // =========================================================
  // CHANGE STATUS
  // =========================================================

  void _changeStatus(Map<String, dynamic> task, String status) {
    setState(() {
      task['status'] = status;
    });

    Navigator.pop(context);

    _showMessage('Task moved to $status');
  }

  // =========================================================
  // MESSAGE
  // =========================================================

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 1)),
    );
  }

  // =========================================================
  // STATUS COLOR
  // =========================================================

  Color _statusColor(String status) {
    if (status == 'To Do') {
      return Colors.grey;
    }

    if (status == 'In Progress') {
      return Colors.blue;
    }

    return Colors.green;
  }

  // =========================================================
  // PRIORITY COLOR
  // =========================================================

  Color _priorityColor(String priority) {
    if (priority == 'High') {
      return Colors.red;
    }

    if (priority == 'Low') {
      return Colors.green;
    }

    return Colors.orange;
  }
}
