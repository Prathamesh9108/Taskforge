import 'package:flutter/material.dart';

import 'task_details_screen.dart';
import 'add_task_screen.dart';
import '../services/api_service.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final TextEditingController searchController = TextEditingController();
  String selectedStatus = 'All';
  String selectedPriority = 'All';
  String selectedSort = 'Newest';

  List<Map<String, dynamic>> allTasks = [];
  bool isLoading = true;
  String? errorMessage;
  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    try {
      final data = await ApiService.getTasks();

      setState(() {
        allTasks = data.map<Map<String, dynamic>>((task) {
          return {
            'id': task['id'],
            'title': task['title'] ?? '',
            'description': task['description'] ?? '',
            'priority': _formatPriority(task['priority']),
            'status': _formatStatus(task['status']),
            'dueDate': task['dueDate'] ?? 'No due date',
          };
        }).toList();

        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
    }
  }

  String _formatStatus(String? status) {
    if (status == 'TODO') {
      return 'To Do';
    }

    if (status == 'IN_PROGRESS') {
      return 'In Progress';
    }

    if (status == 'DONE') {
      return 'Done';
    }

    return status ?? 'To Do';
  }

  String _formatPriority(String? priority) {
    if (priority == 'HIGH') return 'High';
    if (priority == 'MEDIUM') return 'Medium';
    if (priority == 'LOW') return 'Low';

    return priority ?? 'Low';
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get filteredTasks {
    List<Map<String, dynamic>> result = List.from(allTasks);

    // SEARCH
    final search = searchController.text.toLowerCase().trim();

    if (search.isNotEmpty) {
      result = result.where((task) {
        return task['title'].toString().toLowerCase().contains(search) ||
            task['description'].toString().toLowerCase().contains(search);
      }).toList();
    }

    // STATUS FILTER
    if (selectedStatus != 'All') {
      result = result
          .where((task) => task['status'] == selectedStatus)
          .toList();
    }

    // PRIORITY FILTER
    if (selectedPriority != 'All') {
      result = result
          .where((task) => task['priority'] == selectedPriority)
          .toList();
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final tasks = filteredTasks;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        title: const Text(
          'Tasks',
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: [
          IconButton(
            onPressed: _showFilterSheet,
            icon: const Icon(Icons.filter_list, color: Color(0xFF334155)),
          ),
        ],
      ),

      body: Column(
        children: [
          // SEARCH
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),

            child: TextField(
              controller: searchController,

              onChanged: (_) {
                setState(() {});
              },

              decoration: InputDecoration(
                hintText: 'Search tasks...',

                prefixIcon: const Icon(Icons.search),

                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          searchController.clear();
                          setState(() {});
                        },
                        icon: const Icon(Icons.clear),
                      )
                    : null,

                filled: true,

                fillColor: Colors.white,

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),

                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),

                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),

                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),

                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),

                  borderSide: const BorderSide(color: Color(0xFF2563EB)),
                ),
              ),
            ),
          ),

          // FILTER CHIPS
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,

            padding: const EdgeInsets.symmetric(horizontal: 16),

            child: Row(
              children: [
                _filterChip('All', selectedStatus == 'All', () {
                  setState(() {
                    selectedStatus = 'All';
                  });
                }),

                _filterChip('To Do', selectedStatus == 'To Do', () {
                  setState(() {
                    selectedStatus = 'To Do';
                  });
                }),

                _filterChip('In Progress', selectedStatus == 'In Progress', () {
                  setState(() {
                    selectedStatus = 'In Progress';
                  });
                }),

                _filterChip('Done', selectedStatus == 'Done', () {
                  setState(() {
                    selectedStatus = 'Done';
                  });
                }),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // RESULT COUNT + SORT
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),

            child: Row(
              children: [
                Text(
                  '${tasks.length} task${tasks.length == 1 ? '' : 's'}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF64748B),
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const Spacer(),

                PopupMenuButton<String>(
                  initialValue: selectedSort,

                  onSelected: (value) {
                    setState(() {
                      selectedSort = value;
                    });
                  },

                  itemBuilder: (context) {
                    return const [
                      PopupMenuItem(value: 'Newest', child: Text('Newest')),
                      PopupMenuItem(value: 'Oldest', child: Text('Oldest')),
                      PopupMenuItem(value: 'Priority', child: Text('Priority')),
                    ];
                  },

                  child: Row(
                    children: [
                      const Icon(
                        Icons.sort,
                        size: 18,
                        color: Color(0xFF475569),
                      ),

                      const SizedBox(width: 5),

                      Text(
                        selectedSort,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF475569),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 5),

          // TASK LIST
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : errorMessage != null
                ? Center(
                    child: Text(
                      'Failed to load tasks',
                      style: const TextStyle(color: Colors.red),
                    ),
                  )
                : tasks.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 90),
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      return _buildTaskCard(tasks[index]);
                    },
                  ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTaskScreen()),
          );

          if (result == true) {
            await _loadTasks();
          }
        },
        backgroundColor: const Color(0xFF2563EB),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _filterChip(String title, bool selected, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),

      child: ChoiceChip(
        label: Text(title),

        selected: selected,

        onSelected: (_) {
          onTap();
        },

        selectedColor: const Color(0xFFDBEAFE),

        labelStyle: TextStyle(
          color: selected ? const Color(0xFF1D4ED8) : const Color(0xFF475569),

          fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
        ),

        backgroundColor: Colors.white,

        side: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
    );
  }

  Widget _buildTaskCard(Map<String, dynamic> task) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TaskDetailsScreen(task: task),
          ),
        );
      },

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
              maxLines: 2,
              overflow: TextOverflow.ellipsis,

              style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
            ),

            const SizedBox(height: 14),

            Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 15,
                  color: const Color(0xFF64748B),
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

                _statusBadge(task['status']),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _priorityBadge(String priority) {
    Color color;

    if (priority == 'High') {
      color = Colors.red;
    } else if (priority == 'Medium') {
      color = Colors.orange;
    } else {
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

  Widget _statusBadge(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),

      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(7),
      ),

      child: Text(
        status,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: Color(0xFF475569),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          const Icon(Icons.task_alt, size: 60, color: Color(0xFFCBD5E1)),

          const SizedBox(height: 15),

          const Text(
            'No tasks found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            'Try changing your search or filters.',
            style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
          ),
        ],
      ),
    );
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,

      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),

      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: const EdgeInsets.all(20),

              child: Column(
                mainAxisSize: MainAxisSize.min,

                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  const Text(
                    'Filter Tasks',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Status',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),

                  const SizedBox(height: 8),

                  Wrap(
                    spacing: 8,

                    children: ['All', 'To Do', 'In Progress', 'Done'].map((
                      status,
                    ) {
                      return ChoiceChip(
                        label: Text(status),

                        selected: selectedStatus == status,

                        onSelected: (_) {
                          setState(() {
                            selectedStatus = status;
                          });

                          setSheetState(() {});
                        },
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Priority',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),

                  const SizedBox(height: 8),

                  Wrap(
                    spacing: 8,

                    children: ['All', 'High', 'Medium', 'Low'].map((priority) {
                      return ChoiceChip(
                        label: Text(priority),

                        selected: selectedPriority == priority,

                        onSelected: (_) {
                          setState(() {
                            selectedPriority = priority;
                          });

                          setSheetState(() {});
                        },
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 25),

                  SizedBox(
                    width: double.infinity,
                    height: 50,

                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },

                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),

                      child: const Text('Apply Filters'),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Center(
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          selectedStatus = 'All';
                          selectedPriority = 'All';
                        });

                        Navigator.pop(context);
                      },

                      child: const Text('Clear Filters'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
