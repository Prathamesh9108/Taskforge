import 'package:flutter/material.dart';

import '../Services/api_service.dart';
import 'project_details_screen.dart';
import 'create_project_screen.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  final TextEditingController searchController = TextEditingController();

  // =========================================================
  // PROJECT LIST
  // =========================================================

  List<Map<String, dynamic>> projects = [];

  bool isLoading = true;
  String? errorMessage;

  String searchText = '';

  // =========================================================
  // INIT STATE
  // =========================================================

  @override
  void initState() {
    super.initState();
    _loadProjects();
  }

  // =========================================================
  // LOAD PROJECTS FROM SPRING BOOT API
  // =========================================================

  Future<void> _loadProjects() async {
    try {
      final data = await ApiService.getProjects();

      if (!mounted) return;

      setState(() {
        projects = data
            .map<Map<String, dynamic>>(
              (project) => Map<String, dynamic>.from(project),
            )
            .toList();

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

  // =========================================================
  // DISPOSE
  // =========================================================

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // =========================================================
  // EDIT PROJECT
  // =========================================================

  Future<void> _editProject(Map<String, dynamic> project) async {
    final nameController = TextEditingController(
      text: project['name']?.toString() ?? '',
    );

    final descriptionController = TextEditingController(
      text: project['description']?.toString() ?? '',
    );

    String selectedStatus = project['status']?.toString() ?? 'ACTIVE';

    if (selectedStatus == 'ACTIVE') {
      selectedStatus = 'Active';
    } else if (selectedStatus == 'PLANNING') {
      selectedStatus = 'Planning';
    } else if (selectedStatus == 'ON_HOLD') {
      selectedStatus = 'On Hold';
    } else if (selectedStatus == 'COMPLETED') {
      selectedStatus = 'Completed';
    }

    if (![
      'Active',
      'Planning',
      'On Hold',
      'Completed',
    ].contains(selectedStatus)) {
      selectedStatus = 'Active';
    }

    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: const Row(
                children: [
                  Icon(Icons.edit_outlined, color: Color(0xFF2563EB)),
                  SizedBox(width: 10),
                  Text(
                    'Edit Project',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        labelText: 'Project Name',
                        hintText: 'Enter project name',
                        prefixIcon: const Icon(Icons.folder_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    TextField(
                      controller: descriptionController,
                      maxLines: 3,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        hintText: 'Enter project description',
                        prefixIcon: const Icon(Icons.description_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    DropdownButtonFormField<String>(
                      value: selectedStatus,
                      decoration: InputDecoration(
                        labelText: 'Status',
                        prefixIcon: const Icon(Icons.flag_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'Active',
                          child: Text('Active'),
                        ),
                        DropdownMenuItem(
                          value: 'Planning',
                          child: Text('Planning'),
                        ),
                        DropdownMenuItem(
                          value: 'On Hold',
                          child: Text('On Hold'),
                        ),
                        DropdownMenuItem(
                          value: 'Completed',
                          child: Text('Completed'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() {
                            selectedStatus = value;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext, false);
                  },
                  child: const Text('Cancel'),
                ),

                ElevatedButton.icon(
                  onPressed: () {
                    final name = nameController.text.trim();

                    final description = descriptionController.text.trim();

                    if (name.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Project name cannot be empty.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    setState(() {
                      project['name'] = name;
                      project['description'] = description;
                      project['status'] = selectedStatus;
                    });

                    Navigator.pop(dialogContext, true);
                  },
                  icon: const Icon(Icons.save_outlined),
                  label: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );

    nameController.dispose();
    descriptionController.dispose();

    if (!mounted) return;

    if (result == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Project updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  // =========================================================
  // DELETE PROJECT
  // =========================================================

  Future<void> _deleteProject(Map<String, dynamic> project) async {
    final projectName = project['name']?.toString() ?? 'Project';

    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Row(
            children: [
              Icon(Icons.delete_outline, color: Colors.red),
              SizedBox(width: 10),
              Text(
                'Delete Project?',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: Text(
            'Are you sure you want to delete\n'
            '"$projectName"?\n\n'
            'This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Cancel'),
            ),

            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              icon: const Icon(Icons.delete_outline),
              label: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (!mounted) return;

    if (shouldDelete == true) {
      setState(() {
        projects.remove(project);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Project deleted successfully!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // =========================================================
  // CREATE PROJECT
  // =========================================================

  Future<void> _openCreateProject() async {
    final newProject = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateProjectScreen()),
    );

    if (!mounted) return;

    if (newProject != null && newProject is Map<String, dynamic>) {
      setState(() {
        projects.add(newProject);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Project created successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  // =========================================================
  // BUILD
  // =========================================================

  @override
  Widget build(BuildContext context) {
    final filteredProjects = projects.where((project) {
      final name = project['name']?.toString().toLowerCase() ?? '';

      return name.contains(searchText.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),

      // =====================================================
      // APP BAR
      // =====================================================
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
          'Projects',
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // =====================================================
      // BODY
      // =====================================================
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search projects',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchText.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          searchController.clear();

                          setState(() {
                            searchText = '';
                          });
                        },
                        icon: const Icon(Icons.clear),
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                    color: Color(0xFF2563EB),
                    width: 2,
                  ),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${filteredProjects.length} Projects',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),

                TextButton.icon(
                  onPressed: _openCreateProject,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('New Project'),
                ),
              ],
            ),
          ),

          // =================================================
          // PROJECT LIST
          // =================================================
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : errorMessage != null
                ? _errorProjects()
                : filteredProjects.isEmpty
                ? _emptyProjects()
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 5, 20, 90),
                    itemCount: filteredProjects.length,
                    itemBuilder: (context, index) {
                      final project = filteredProjects[index];

                      return _projectCard(project);
                    },
                  ),
          ),
        ],
      ),

      // =====================================================
      // CREATE BUTTON
      // =====================================================
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openCreateProject,
        backgroundColor: const Color(0xFF2563EB),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Create Project'),
      ),
    );
  }

  // =========================================================
  // PROJECT CARD
  // =========================================================

  Widget _projectCard(Map<String, dynamic> project) {
    final int tasks = (project['tasks'] as num?)?.toInt() ?? 0;

    final int completed = (project['completed'] as num?)?.toInt() ?? 0;

    final double progress = tasks == 0
        ? 0.0
        : (completed / tasks).clamp(0.0, 1.0).toDouble();

    final String status = project['status']?.toString() ?? 'Active';

    final bool isCompleted = status.toLowerCase() == 'completed';

    final String displayStatus = status == 'ACTIVE' ? 'Active' : status;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProjectDetailsScreen(project: project),
          ),
        );
      },
      borderRadius: BorderRadius.circular(18),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                    size: 28,
                  ),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        project['name']?.toString() ?? 'Unnamed Project',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        project['description']?.toString() ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),

                PopupMenuButton<String>(
                  tooltip: 'Project options',
                  onSelected: (value) {
                    if (value == 'edit') {
                      _editProject(project);
                    } else if (value == 'delete') {
                      _deleteProject(project);
                    }
                  },
                  itemBuilder: (context) {
                    return const [
                      PopupMenuItem<String>(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit_outlined, color: Color(0xFF2563EB)),
                            SizedBox(width: 10),
                            Text('Edit Project'),
                          ],
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete_outline, color: Colors.red),
                            SizedBox(width: 10),
                            Text('Delete Project'),
                          ],
                        ),
                      ),
                    ];
                  },
                ),
              ],
            ),

            const SizedBox(height: 18),

            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? Colors.green.withOpacity(0.1)
                        : const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    displayStatus,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isCompleted
                          ? Colors.green
                          : const Color(0xFF2563EB),
                    ),
                  ),
                ),

                const Spacer(),

                Text(
                  '$completed / $tasks tasks',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 7,
                backgroundColor: const Color(0xFFE2E8F0),
              ),
            ),

            const SizedBox(height: 7),

            Text(
              '${(progress * 100).round()}% completed',
              style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Icon(
                  Icons.priority_high,
                  size: 15,
                  color: _priorityColor(project['priority']?.toString()),
                ),

                const SizedBox(width: 4),

                Text(
                  project['priority']?.toString() ?? 'Medium',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: _priorityColor(project['priority']?.toString()),
                  ),
                ),

                const Spacer(),

                if (project['endDate'] != null)
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        size: 14,
                        color: Color(0xFF64748B),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        project['endDate'].toString(),
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // PRIORITY COLOR
  // =========================================================

  Color _priorityColor(String? priority) {
    switch (priority) {
      case 'High':
        return Colors.red;
      case 'Medium':
        return Colors.orange;
      case 'Low':
        return Colors.green;
      default:
        return const Color(0xFF64748B);
    }
  }

  // =========================================================
  // ERROR
  // =========================================================

  Widget _errorProjects() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 70, color: Colors.red),

            const SizedBox(height: 15),

            const Text(
              'Failed to load projects',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            Text(
              errorMessage ?? 'Unknown error',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF64748B)),
            ),

            const SizedBox(height: 18),

            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  isLoading = true;
                  errorMessage = null;
                });

                _loadProjects();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // EMPTY PROJECTS
  // =========================================================

  Widget _emptyProjects() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.folder_off_outlined,
              size: 70,
              color: Color(0xFF94A3B8),
            ),

            const SizedBox(height: 15),

            const Text(
              'No projects found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              'Create a new project to get started.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF64748B)),
            ),

            const SizedBox(height: 18),

            ElevatedButton.icon(
              onPressed: _openCreateProject,
              icon: const Icon(Icons.add),
              label: const Text('Create Project'),
            ),
          ],
        ),
      ),
    );
  }
}
