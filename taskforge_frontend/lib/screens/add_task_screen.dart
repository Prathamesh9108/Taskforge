import 'package:flutter/material.dart';

import '../services/api_service.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController assigneeController = TextEditingController();

  String selectedProject = 'TaskForge Mobile App';
  String selectedPriority = 'Medium';
  String selectedStatus = 'To Do';

  DateTime? selectedDate;

  bool isCreating = false;

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    assigneeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),

      // --------------------------------------------------
      // APP BAR
      // --------------------------------------------------
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
          'Add Task',
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // --------------------------------------------------
      // BODY
      // --------------------------------------------------
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --------------------------------------------------
              // TASK INFORMATION
              // --------------------------------------------------
              const Text(
                'Task Information',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                'Add the basic details of your task.',
                style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
              ),

              const SizedBox(height: 20),

              _fieldLabel('Task Title'),

              const SizedBox(height: 8),

              TextFormField(
                controller: titleController,
                textInputAction: TextInputAction.next,
                decoration: _inputDecoration(
                  hint: 'Enter task title',
                  icon: Icons.task_alt_outlined,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter task title';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 18),

              _fieldLabel('Description'),

              const SizedBox(height: 8),

              TextFormField(
                controller: descriptionController,
                maxLines: 5,
                decoration: _inputDecoration(
                  hint: 'Enter task description',
                  icon: Icons.description_outlined,
                ),
              ),

              const SizedBox(height: 25),

              // --------------------------------------------------
              // PROJECT & ASSIGNMENT
              // --------------------------------------------------
              const Text(
                'Project & Assignment',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),

              const SizedBox(height: 20),

              _fieldLabel('Project'),

              const SizedBox(height: 8),

              DropdownButtonFormField<String>(
                value: selectedProject,
                decoration: _inputDecoration(
                  hint: 'Select project',
                  icon: Icons.folder_outlined,
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'TaskForge Mobile App',
                    child: Text('TaskForge Mobile App'),
                  ),
                  DropdownMenuItem(
                    value: 'Website Development',
                    child: Text('Website Development'),
                  ),
                  DropdownMenuItem(
                    value: 'College Project',
                    child: Text('College Project'),
                  ),
                  DropdownMenuItem(
                    value: 'Portfolio Website',
                    child: Text('Portfolio Website'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedProject = value;
                    });
                  }
                },
              ),

              const SizedBox(height: 18),

              _fieldLabel('Assignee'),

              const SizedBox(height: 8),

              TextFormField(
                controller: assigneeController,
                decoration: _inputDecoration(
                  hint: 'Enter assignee name',
                  icon: Icons.person_outline,
                ),
              ),

              const SizedBox(height: 25),

              // --------------------------------------------------
              // TASK SETTINGS
              // --------------------------------------------------
              const Text(
                'Task Settings',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),

              const SizedBox(height: 20),

              _fieldLabel('Priority'),

              const SizedBox(height: 8),

              DropdownButtonFormField<String>(
                value: selectedPriority,
                decoration: _inputDecoration(
                  hint: 'Select priority',
                  icon: Icons.flag_outlined,
                ),
                items: const [
                  DropdownMenuItem(value: 'High', child: Text('High')),
                  DropdownMenuItem(value: 'Medium', child: Text('Medium')),
                  DropdownMenuItem(value: 'Low', child: Text('Low')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedPriority = value;
                    });
                  }
                },
              ),

              const SizedBox(height: 18),

              _fieldLabel('Status'),

              const SizedBox(height: 8),

              DropdownButtonFormField<String>(
                value: selectedStatus,
                decoration: _inputDecoration(
                  hint: 'Select status',
                  icon: Icons.timelapse_outlined,
                ),
                items: const [
                  DropdownMenuItem(value: 'To Do', child: Text('To Do')),
                  DropdownMenuItem(
                    value: 'In Progress',
                    child: Text('In Progress'),
                  ),
                  DropdownMenuItem(value: 'Done', child: Text('Done')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedStatus = value;
                    });
                  }
                },
              ),

              const SizedBox(height: 18),

              // --------------------------------------------------
              // DUE DATE
              // --------------------------------------------------
              _fieldLabel('Due Date'),

              const SizedBox(height: 8),

              InkWell(
                onTap: _selectDate,
                borderRadius: BorderRadius.circular(14),
                child: InputDecorator(
                  decoration: _inputDecoration(
                    hint: 'Select due date',
                    icon: Icons.calendar_today_outlined,
                  ),
                  child: Text(
                    selectedDate == null
                        ? 'Select due date'
                        : _formatDate(selectedDate!),
                    style: TextStyle(
                      fontSize: 14,
                      color: selectedDate == null
                          ? const Color(0xFF94A3B8)
                          : const Color(0xFF0F172A),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 35),

              // --------------------------------------------------
              // CREATE TASK BUTTON
              // --------------------------------------------------
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  onPressed: isCreating ? null : _createTask,
                  icon: isCreating
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.add_task),
                  label: Text(
                    isCreating ? 'Creating...' : 'Create Task',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.blue.shade300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // --------------------------------------------------
  // FIELD LABEL
  // --------------------------------------------------
  Widget _fieldLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Color(0xFF334155),
      ),
    );
  }

  // --------------------------------------------------
  // INPUT DECORATION
  // --------------------------------------------------
  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: const Color(0xFF64748B)),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
        borderSide: const BorderSide(color: Color(0xFF2563EB), width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
    );
  }

  // --------------------------------------------------
  // DATE PICKER
  // --------------------------------------------------
  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2035),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFF2563EB)),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  // --------------------------------------------------
  // FORMAT DATE
  // --------------------------------------------------
  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  // --------------------------------------------------
  // CREATE TASK - API
  // --------------------------------------------------
  Future<void> _createTask() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (selectedDate == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a due date')));
      return;
    }

    final newTask = {
      'title': titleController.text.trim(),
      'description': descriptionController.text.trim(),
      'priority': selectedPriority.toUpperCase(),
      'status': _getBackendStatus(selectedStatus),
    };

    setState(() {
      isCreating = true;
    });

    try {
      await ApiService.createTask(newTask);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task created successfully')),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isCreating = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to create task: $e')));
    }
  }

  // --------------------------------------------------
  // CONVERT STATUS FOR BACKEND
  // --------------------------------------------------
  String _getBackendStatus(String status) {
    switch (status) {
      case 'To Do':
        return 'TODO';

      case 'In Progress':
        return 'IN_PROGRESS';

      case 'Done':
        return 'DONE';

      default:
        return 'TODO';
    }
  }
}
