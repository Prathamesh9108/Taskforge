import 'package:flutter/material.dart';
import '../Services/api_service.dart';
import '../theme/app_theme.dart';

class AddTaskScreen extends StatefulWidget {
  final int? initialProjectId;
  final String? initialStatus;

  const AddTaskScreen({
    super.key,
    this.initialProjectId,
    this.initialStatus,
  });

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  List<dynamic> projects = [];
  int? selectedProjectId;
  bool isLoadingProjects = true;
  String selectedPriority = 'Medium';
  String selectedStatus = 'To Do';

  DateTime? selectedDate = DateTime.now().add(const Duration(days: 3));
  bool isCreating = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialStatus != null) {
      selectedStatus = widget.initialStatus!;
    }
    _loadProjects();
  }

  Future<void> _loadProjects() async {
    try {
      final data = await ApiService.getProjects();
      if (!mounted) return;

      setState(() {
        projects = data;
        if (widget.initialProjectId != null &&
            projects.any((p) => (p['id'] as num).toInt() == widget.initialProjectId)) {
          selectedProjectId = widget.initialProjectId;
        } else if (projects.isNotEmpty) {
          selectedProjectId = (projects.first['id'] as num).toInt();
        }
        isLoadingProjects = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => isLoadingProjects = false);
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDueDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime(2035),
    );
    if (date != null) setState(() => selectedDate = date);
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Select due date';
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '${date.year}-$m-$d';
  }

  Future<void> _saveTask() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isCreating = true);

    final backendStatus = selectedStatus == 'Done'
        ? 'DONE'
        : selectedStatus == 'In Progress'
            ? 'IN_PROGRESS'
            : 'TODO';

    final taskPayload = {
      'title': titleController.text.trim(),
      'description': descriptionController.text.trim(),
      'priority': selectedPriority.toUpperCase(),
      'status': backendStatus,
      'dueDate': _formatDate(selectedDate),
      'project': selectedProjectId != null ? {'id': selectedProjectId} : null,
    };

    try {
      await ApiService.createTask(taskPayload);
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      setState(() => isCreating = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create task: $e'), backgroundColor: AppTheme.danger),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Add Task'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 580),
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.space16,
                vertical: AppTheme.space16,
              ),
              children: [
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
                      // Header
                      Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: AppTheme.primaryLight,
                              borderRadius: AppTheme.radiusSm,
                            ),
                            child: const Icon(Icons.add_task_rounded, color: AppTheme.primary, size: 20),
                          ),
                          const SizedBox(width: 10),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Task Details',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Assign to project and set priority',
                                style: TextStyle(fontSize: 11.5, color: AppTheme.textMuted),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),
                      const Divider(height: 1),
                      const SizedBox(height: 14),

                      // Task Title
                      _fieldLabel('Task Title *'),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: titleController,
                        style: const TextStyle(fontSize: 13),
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          hintText: 'e.g. Design Login Screen',
                          prefixIcon: Icon(Icons.task_alt, size: 17, color: AppTheme.textMuted),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter task title';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 14),

                      // Description
                      _fieldLabel('Description'),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: descriptionController,
                        maxLines: 3,
                        style: const TextStyle(fontSize: 13),
                        decoration: const InputDecoration(
                          hintText: 'Provide details, context, and requirements...',
                        ),
                      ),

                      const SizedBox(height: 14),

                      // Project Selector
                      _fieldLabel('Project'),
                      const SizedBox(height: 6),
                      if (isLoadingProjects)
                        Container(
                          height: 42,
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceSubtle,
                            borderRadius: AppTheme.radiusMd,
                          ),
                          child: const Text('Loading projects...', style: TextStyle(fontSize: 12.5, color: AppTheme.textMuted)),
                        )
                      else if (projects.isEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceSubtle,
                            borderRadius: AppTheme.radiusMd,
                          ),
                          child: const Text('No projects available. A general task will be created.', style: TextStyle(fontSize: 12.5, color: AppTheme.textMuted)),
                        )
                      else
                        DropdownButtonFormField<int>(
                          initialValue: selectedProjectId,
                          style: const TextStyle(fontSize: 13, color: AppTheme.textPrimary),
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.folder_outlined, size: 17, color: AppTheme.textMuted),
                          ),
                          items: projects.map<DropdownMenuItem<int>>((p) {
                            final id = (p['id'] as num).toInt();
                            final name = p['name']?.toString() ?? 'Project #$id';
                            return DropdownMenuItem<int>(
                              value: id,
                              child: Text(name, overflow: TextOverflow.ellipsis),
                            );
                          }).toList(),
                          onChanged: (val) {
                            setState(() => selectedProjectId = val);
                          },
                        ),

                      const SizedBox(height: 14),

                      // Status & Priority
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _fieldLabel('Status'),
                                const SizedBox(height: 6),
                                DropdownButtonFormField<String>(
                                  initialValue: selectedStatus,
                                  style: const TextStyle(fontSize: 13, color: AppTheme.textPrimary),
                                  items: const [
                                    DropdownMenuItem(value: 'To Do', child: Text('To Do')),
                                    DropdownMenuItem(value: 'In Progress', child: Text('In Progress')),
                                    DropdownMenuItem(value: 'Done', child: Text('Done')),
                                  ],
                                  onChanged: (val) {
                                    if (val != null) setState(() => selectedStatus = val);
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _fieldLabel('Priority'),
                                const SizedBox(height: 6),
                                DropdownButtonFormField<String>(
                                  initialValue: selectedPriority,
                                  style: const TextStyle(fontSize: 13, color: AppTheme.textPrimary),
                                  items: const [
                                    DropdownMenuItem(value: 'High', child: Text('High')),
                                    DropdownMenuItem(value: 'Medium', child: Text('Medium')),
                                    DropdownMenuItem(value: 'Low', child: Text('Low')),
                                  ],
                                  onChanged: (val) {
                                    if (val != null) setState(() => selectedPriority = val);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      // Due Date
                      _fieldLabel('Due Date'),
                      const SizedBox(height: 6),
                      InkWell(
                        onTap: _selectDueDate,
                        borderRadius: AppTheme.radiusMd,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
                          decoration: BoxDecoration(
                            color: AppTheme.surface,
                            borderRadius: AppTheme.radiusMd,
                            border: Border.all(color: AppTheme.cardBorder),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_month_outlined, size: 16, color: AppTheme.textMuted),
                              const SizedBox(width: 8),
                              Text(_formatDate(selectedDate), style: const TextStyle(fontSize: 12.5)),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: isCreating ? null : _saveTask,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primary,
                                foregroundColor: Colors.white,
                              ),
                              child: isCreating
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text('Create Task'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _fieldLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 12.5,
        fontWeight: FontWeight.w600,
        color: AppTheme.textPrimary,
      ),
    );
  }
}
