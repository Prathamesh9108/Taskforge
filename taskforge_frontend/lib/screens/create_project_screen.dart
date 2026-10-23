import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CreateProjectScreen extends StatefulWidget {
  const CreateProjectScreen({super.key});

  @override
  State<CreateProjectScreen> createState() => _CreateProjectScreenState();
}

class _CreateProjectScreenState extends State<CreateProjectScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();

  String selectedStatus = 'Active';
  String selectedPriority = 'Medium';

  DateTime? startDate = DateTime.now();
  DateTime? endDate = DateTime.now().add(const Duration(days: 30));
  bool isSubmitting = false;

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectStartDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: startDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (date != null) setState(() => startDate = date);
  }

  Future<void> _selectEndDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: endDate ?? (startDate ?? DateTime.now()),
      firstDate: startDate ?? DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (date != null) setState(() => endDate = date);
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Select date';
    final d = date.day.toString().padLeft(2, '0');
    final m = date.month.toString().padLeft(2, '0');
    return '$d/$m/${date.year}';
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    if (startDate != null && endDate != null && endDate!.isBefore(startDate!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('End date cannot be before start date'),
          backgroundColor: AppTheme.danger,
        ),
      );
      return;
    }

    final project = {
      'id': DateTime.now().millisecondsSinceEpoch,
      'name': nameController.text.trim(),
      'description': descriptionController.text.trim(),
      'status': selectedStatus.toUpperCase().replaceAll(' ', '_'),
      'priority': selectedPriority.toUpperCase(),
      'startDate': _formatDate(startDate),
      'endDate': _formatDate(endDate),
      'progress': 0.0,
      'tasks': 0,
      'completed': 0,
    };

    Navigator.pop(context, project);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('New Project'),
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
                            child: const Icon(Icons.create_new_folder_rounded, color: AppTheme.primary, size: 20),
                          ),
                          const SizedBox(width: 10),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Project Details',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Define project scope and roadmap status',
                                style: TextStyle(fontSize: 11.5, color: AppTheme.textMuted),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),
                      const Divider(height: 1),
                      const SizedBox(height: 14),

                      // Project Name
                      _fieldLabel('Project Name *'),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: nameController,
                        style: const TextStyle(fontSize: 13),
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          hintText: 'e.g. Mobile App Redesign',
                          prefixIcon: Icon(Icons.folder_outlined, size: 17, color: AppTheme.textMuted),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter a project name';
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
                          hintText: 'Briefly describe objectives, deliverables, and goals...',
                        ),
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
                                    DropdownMenuItem(value: 'Active', child: Text('Active')),
                                    DropdownMenuItem(value: 'Planning', child: Text('Planning')),
                                    DropdownMenuItem(value: 'On Hold', child: Text('On Hold')),
                                    DropdownMenuItem(value: 'Completed', child: Text('Completed')),
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

                      // Dates
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _fieldLabel('Start Date'),
                                const SizedBox(height: 6),
                                InkWell(
                                  onTap: _selectStartDate,
                                  borderRadius: AppTheme.radiusMd,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                    decoration: BoxDecoration(
                                      color: AppTheme.surface,
                                      borderRadius: AppTheme.radiusMd,
                                      border: Border.all(color: AppTheme.cardBorder),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.calendar_today_outlined, size: 15, color: AppTheme.textMuted),
                                        const SizedBox(width: 8),
                                        Text(_formatDate(startDate), style: const TextStyle(fontSize: 12.5)),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _fieldLabel('Target End Date'),
                                const SizedBox(height: 6),
                                InkWell(
                                  onTap: _selectEndDate,
                                  borderRadius: AppTheme.radiusMd,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                    decoration: BoxDecoration(
                                      color: AppTheme.surface,
                                      borderRadius: AppTheme.radiusMd,
                                      border: Border.all(color: AppTheme.cardBorder),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.event_available_outlined, size: 15, color: AppTheme.textMuted),
                                        const SizedBox(width: 8),
                                        Text(_formatDate(endDate), style: const TextStyle(fontSize: 12.5)),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Save and Cancel buttons
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
                              onPressed: isSubmitting ? null : _submit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primary,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Create Project'),
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
