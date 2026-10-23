import 'package:flutter/material.dart';
import '../Services/api_service.dart';
import '../theme/app_theme.dart';
import '../widgets/responsive_scaffold.dart';
import '../widgets/status_badge.dart';
import '../widgets/interactive_card.dart';
import '../widgets/empty_state.dart';
import 'project_details_screen.dart';
import 'create_project_screen.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  final TextEditingController searchController = TextEditingController();

  List<Map<String, dynamic>> projects = [];
  bool isLoading = true;
  String? errorMessage;

  String searchText = '';
  String selectedFilter = 'All';

  final List<String> filters = const ['All', 'Active', 'Planning', 'On Hold', 'Completed'];

  @override
  void initState() {
    super.initState();
    _loadProjects();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> _loadProjects() async {
    try {
      final data = await ApiService.getProjects();
      if (!mounted) return;

      setState(() {
        projects = data
            .map<Map<String, dynamic>>((p) => Map<String, dynamic>.from(p))
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

  Future<void> _openCreateProject() async {
    final newProject = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateProjectScreen()),
    );

    if (!mounted) return;

    if (newProject != null && newProject is Map<String, dynamic>) {
      await ApiService.createProject(newProject);
      await _loadProjects();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Project created successfully!'),
          backgroundColor: AppTheme.success,
        ),
      );
    }
  }

  Future<void> _editProject(Map<String, dynamic> project) async {
    final nameController = TextEditingController(text: project['name']?.toString() ?? '');
    final descriptionController = TextEditingController(text: project['description']?.toString() ?? '');
    String selectedStatus = project['status']?.toString() ?? 'ACTIVE';

    if (selectedStatus == 'ACTIVE') selectedStatus = 'Active';
    if (selectedStatus == 'PLANNING') selectedStatus = 'Planning';
    if (selectedStatus == 'ON_HOLD') selectedStatus = 'On Hold';
    if (selectedStatus == 'COMPLETED') selectedStatus = 'Completed';

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
                        decoration: const InputDecoration(hintText: 'Project description'),
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
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );

    if (result == true && mounted) {
      final int projectId = (project['id'] as num).toInt();
      final updatedData = {
        'name': nameController.text.trim(),
        'description': descriptionController.text.trim(),
        'status': selectedStatus.toUpperCase().replaceAll(' ', '_'),
      };

      try {
        await ApiService.updateProject(projectId, updatedData);
        await _loadProjects();

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Project updated successfully!'),
            backgroundColor: AppTheme.success,
          ),
        );
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update project: $e'),
            backgroundColor: AppTheme.danger,
          ),
        );
      }
    }
  }

  Future<void> _deleteProject(Map<String, dynamic> project) async {
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
                'Delete Project?',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          content: Text(
            'Are you sure you want to delete "${project['name']}"? Associated tasks will also be removed.',
            style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary),
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
      final int projectId = (project['id'] as num).toInt();
      try {
        await ApiService.deleteProject(projectId);
        await _loadProjects();

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Project deleted successfully'),
            backgroundColor: AppTheme.danger,
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

  List<Map<String, dynamic>> _filteredProjects() {
    return projects.where((p) {
      final name = (p['name'] ?? '').toString().toLowerCase();
      final desc = (p['description'] ?? '').toString().toLowerCase();
      final status = (p['status'] ?? '').toString().toUpperCase().replaceAll(' ', '_');

      // Filter check
      if (selectedFilter != 'All') {
        final target = selectedFilter.toUpperCase().replaceAll(' ', '_');
        if (target == 'COMPLETED' && status != 'COMPLETED' && status != 'DONE') return false;
        if (target == 'ACTIVE' && status != 'ACTIVE' && status != 'IN_PROGRESS') return false;
        if (target == 'PLANNING' && status != 'PLANNING') return false;
        if (target == 'ON_HOLD' && status != 'ON_HOLD') return false;
      }

      // Search check
      if (searchText.isNotEmpty) {
        final query = searchText.toLowerCase();
        return name.contains(query) || desc.contains(query);
      }

      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredProjects();

    return ResponsiveScaffold(
      selectedIndex: 1,
      title: 'Projects',
      subtitle: '${projects.length} total projects',
      onRefresh: _loadProjects,
      topBarActions: [
        IconButton(
          tooltip: 'Add Project',
          icon: const Icon(Icons.add_rounded, size: 22, color: AppTheme.primary),
          onPressed: _openCreateProject,
        ),
      ],
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add Project',
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        elevation: 2,
        mini: true,
        onPressed: _openCreateProject,
        child: const Icon(Icons.add, size: 20),
      ),
      body: RefreshIndicator(
        onRefresh: _loadProjects,
        color: AppTheme.primary,
        child: Column(
          children: [
            // ==========================================
            // COMPACT SEARCH & FILTER CONTROLS
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
                      onChanged: (val) => setState(() => searchText = val),
                      decoration: InputDecoration(
                        hintText: 'Search projects...',
                        prefixIcon: const Icon(Icons.search, size: 17, color: AppTheme.textMuted),
                        suffixIcon: searchText.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, size: 16, color: AppTheme.textMuted),
                                onPressed: () {
                                  searchController.clear();
                                  setState(() => searchText = '');
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

                  // Horizontal Filter Chips
                  SizedBox(
                    height: 28,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: filters.length,
                      separatorBuilder: (context, index) => const SizedBox(width: 6),
                      itemBuilder: (context, index) {
                        final filter = filters[index];
                        final isSelected = selectedFilter == filter;

                        return InkWell(
                          onTap: () => setState(() => selectedFilter = filter),
                          borderRadius: BorderRadius.circular(14),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: isSelected ? AppTheme.primary : AppTheme.background,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: isSelected ? AppTheme.primary : AppTheme.cardBorder,
                                width: 1,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                filter,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                  color: isSelected ? Colors.white : AppTheme.textSecondary,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            // ==========================================
            // PROJECT LIST
            // ==========================================
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator(color: AppTheme.primary))
                  : filtered.isEmpty
                      ? EmptyState(
                          icon: Icons.folder_open_rounded,
                          title: searchText.isEmpty ? 'No Projects Found' : 'No Matching Projects',
                          message: searchText.isEmpty
                              ? 'Start by creating your first project.'
                              : 'No projects match "$searchText".',
                          actionLabel: searchText.isEmpty ? 'Add Project' : 'Clear Search',
                          onAction: searchText.isEmpty
                              ? _openCreateProject
                              : () {
                                  searchController.clear();
                                  setState(() => searchText = '');
                                },
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppTheme.space16,
                            vertical: AppTheme.space12,
                          ),
                          itemCount: filtered.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            final project = filtered[index];
                            final progress = (project['progress'] as num?)?.toDouble() ?? 0.0;
                            final progressPct = (progress * 100).round();
                            final tasksCount = project['tasks'] ?? 0;
                            final completedCount = project['completed'] ?? 0;

                            return InteractiveCard(
                              padding: const EdgeInsets.all(AppTheme.space12),
                              borderRadius: AppTheme.radiusLg,
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProjectDetailsScreen(project: project),
                                  ),
                                );
                                _loadProjects();
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Top row: Icon + Title + Status + Actions
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 32,
                                        height: 32,
                                        decoration: BoxDecoration(
                                          color: AppTheme.primaryLight,
                                          borderRadius: AppTheme.radiusSm,
                                        ),
                                        child: const Icon(
                                          Icons.folder_rounded,
                                          color: AppTheme.primary,
                                          size: 17,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          project['name']?.toString() ?? 'Untitled Project',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            color: AppTheme.textPrimary,
                                            letterSpacing: -0.2,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      StatusBadge(
                                        status: project['status']?.toString() ?? 'Active',
                                        fontSize: 10.5,
                                      ),
                                      PopupMenuButton<String>(
                                        icon: const Icon(
                                          Icons.more_vert_rounded,
                                          size: 18,
                                          color: AppTheme.textMuted,
                                        ),
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                                        elevation: 3,
                                        shape: RoundedRectangleBorder(borderRadius: AppTheme.radiusMd),
                                        onSelected: (value) async {
                                          if (value == 'view') {
                                            await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => ProjectDetailsScreen(project: project),
                                              ),
                                            );
                                            _loadProjects();
                                          } else if (value == 'edit') {
                                            _editProject(project);
                                          } else if (value == 'delete') {
                                            _deleteProject(project);
                                          }
                                        },
                                        itemBuilder: (context) => [
                                          const PopupMenuItem(
                                            value: 'view',
                                            height: 36,
                                            child: Row(
                                              children: [
                                                Icon(Icons.visibility_outlined, size: 16, color: AppTheme.textSecondary),
                                                SizedBox(width: 8),
                                                Text('View Details', style: TextStyle(fontSize: 12.5)),
                                              ],
                                            ),
                                          ),
                                          const PopupMenuItem(
                                            value: 'edit',
                                            height: 36,
                                            child: Row(
                                              children: [
                                                Icon(Icons.edit_outlined, size: 16, color: AppTheme.textSecondary),
                                                SizedBox(width: 8),
                                                Text('Edit Project', style: TextStyle(fontSize: 12.5)),
                                              ],
                                            ),
                                          ),
                                          const PopupMenuItem(
                                            value: 'delete',
                                            height: 36,
                                            child: Row(
                                              children: [
                                                Icon(Icons.delete_outline_rounded, size: 16, color: AppTheme.danger),
                                                SizedBox(width: 8),
                                                Text('Delete', style: TextStyle(fontSize: 12.5, color: AppTheme.danger)),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),

                                  // Description
                                  if ((project['description'] ?? '').toString().isNotEmpty) ...[
                                    const SizedBox(height: 6),
                                    Text(
                                      project['description'].toString(),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppTheme.textSecondary,
                                        height: 1.35,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],

                                  const SizedBox(height: 9),

                                  // Progress Bar
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(3),
                                    child: LinearProgressIndicator(
                                      value: progress,
                                      minHeight: 4,
                                      backgroundColor: AppTheme.surfaceSubtle,
                                      valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primary),
                                    ),
                                  ),

                                  const SizedBox(height: 6),

                                  // Stats Row
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '$completedCount of $tasksCount tasks done',
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: AppTheme.textMuted,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        '$progressPct%',
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
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
            ),
          ],
        ),
      ),
    );
  }
}
