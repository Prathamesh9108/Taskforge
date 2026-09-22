import 'package:flutter/material.dart';

import 'task_details_screen.dart';

class ProjectDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> project;

  const ProjectDetailsScreen({super.key, required this.project});

  @override
  State<ProjectDetailsScreen> createState() => _ProjectDetailsScreenState();
}

class _ProjectDetailsScreenState extends State<ProjectDetailsScreen> {
  late List<Map<String, dynamic>> projectTasks;

  @override
  void initState() {
    super.initState();

    projectTasks = [
      {
        'title': 'Create Login UI',
        'description': 'Design login screen',
        'priority': 'High',
        'status': 'Done',
        'dueDate': '05 Sep 2026',
      },
      {
        'title': 'Registration Screen',
        'description': 'Create registration screen',
        'priority': 'High',
        'status': 'In Progress',
        'dueDate': '06 Sep 2026',
      },
      {
        'title': 'Dashboard Design',
        'description': 'Create professional dashboard',
        'priority': 'Medium',
        'status': 'In Progress',
        'dueDate': '08 Sep 2026',
      },
      {
        'title': 'Settings Screen',
        'description': 'Create application settings',
        'priority': 'Low',
        'status': 'To Do',
        'dueDate': '10 Sep 2026',
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    final project = widget.project;

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

        title: Text(
          project['name'],
          style: const TextStyle(
            color: Color(0xFF0F172A),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),

        children: [
          // PROJECT HEADER
          Container(
            padding: const EdgeInsets.all(20),

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,

                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(14),
                      ),

                      child: const Icon(
                        Icons.folder_outlined,
                        color: Color(0xFF2563EB),
                        size: 27,
                      ),
                    ),

                    const SizedBox(width: 14),

                    Expanded(
                      child: Text(
                        project['name'],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                Text(
                  project['description'],
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF64748B),
                  ),
                ),

                const SizedBox(height: 18),

                Row(
                  children: [
                    _statBox('Tasks', '${project['tasks']}'),

                    const SizedBox(width: 10),

                    _statBox('Status', project['status']),
                  ],
                ),

                const SizedBox(height: 18),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    const Text(
                      'Project Progress',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    Text(
                      '${((project['progress'] as double) * 100).round()}%',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2563EB),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                LinearProgressIndicator(
                  value: project['progress'],
                  minHeight: 8,

                  borderRadius: BorderRadius.circular(10),

                  backgroundColor: const Color(0xFFE2E8F0),

                  valueColor: const AlwaysStoppedAnimation(Color(0xFF2563EB)),
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),

          // TASK HEADER
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Project Tasks',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ),

              TextButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Add project task coming next'),
                    ),
                  );
                },

                icon: const Icon(Icons.add, size: 18),

                label: const Text('Add Task'),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // TASKS
          ...projectTasks.map((task) => _buildTaskCard(task)),
        ],
      ),
    );
  }

  Widget _statBox(String title, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),

        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(12),
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8)),
            ),

            const SizedBox(height: 4),

            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,

              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0F172A),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskCard(Map<String, dynamic> task) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TaskDetailsScreen(task: task),
          ),
        );
      },

      borderRadius: BorderRadius.circular(16),

      child: Container(
        margin: const EdgeInsets.only(bottom: 12),

        padding: const EdgeInsets.all(16),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    task['title'],
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ),

                _priorityBadge(task['priority']),
              ],
            ),

            const SizedBox(height: 7),

            Text(
              task['description'],
              style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 14,
                  color: Color(0xFF64748B),
                ),

                const SizedBox(width: 5),

                Text(
                  task['dueDate'],
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF64748B),
                  ),
                ),

                const Spacer(),

                Text(
                  task['status'],
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2563EB),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _priorityBadge(String priority) {
    Color color;

    switch (priority) {
      case 'High':
        color = Colors.red;
        break;

      case 'Medium':
        color = Colors.orange;
        break;

      default:
        color = Colors.green;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),

      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(7),
      ),

      child: Text(
        priority,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
