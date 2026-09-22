import 'package:flutter/material.dart';

class CreateProjectScreen extends StatefulWidget {
  const CreateProjectScreen({super.key});

  @override
  State<CreateProjectScreen> createState() => _CreateProjectScreenState();
}

class _CreateProjectScreenState extends State<CreateProjectScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();

  String selectedStatus = 'Planning';
  String selectedPriority = 'Medium';

  DateTime? startDate;
  DateTime? endDate;

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectStartDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );

    if (date != null) {
      setState(() {
        startDate = date;
      });
    }
  }

  Future<void> _selectEndDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: startDate ?? DateTime.now(),
      firstDate: startDate ?? DateTime(2020),
      lastDate: DateTime(2035),
    );

    if (date != null) {
      setState(() {
        endDate = date;
      });
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) {
      return 'Select date';
    }

    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  void _createProject() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (startDate != null && endDate != null && endDate!.isBefore(startDate!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('End date cannot be before start date')),
      );
      return;
    }

    final project = {
      'id': DateTime.now().millisecondsSinceEpoch,
      'name': nameController.text.trim(),
      'description': descriptionController.text.trim(),
      'status': selectedStatus,
      'priority': selectedPriority,
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

        title: const Text(
          'Create Project',
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Form(
        key: _formKey,

        child: ListView(
          padding: const EdgeInsets.all(20),

          children: [
            // PROJECT ICON
            Center(
              child: Container(
                width: 80,
                height: 80,

                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(22),
                ),

                child: const Icon(
                  Icons.folder_outlined,
                  size: 40,
                  color: Color(0xFF2563EB),
                ),
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              'Project Information',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),

            const SizedBox(height: 15),

            // PROJECT NAME
            TextFormField(
              controller: nameController,

              decoration: InputDecoration(
                labelText: 'Project Name',
                hintText: 'Enter project name',
                prefixIcon: const Icon(Icons.folder_outlined),

                filled: true,
                fillColor: Colors.white,

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),

              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter project name';
                }

                if (value.trim().length < 3) {
                  return 'Project name must be at least 3 characters';
                }

                return null;
              },
            ),

            const SizedBox(height: 16),

            // DESCRIPTION
            TextFormField(
              controller: descriptionController,

              maxLines: 4,

              decoration: InputDecoration(
                labelText: 'Description',
                hintText: 'Describe your project',

                alignLabelWithHint: true,

                prefixIcon: const Padding(
                  padding: EdgeInsets.only(bottom: 65),
                  child: Icon(Icons.description_outlined),
                ),

                filled: true,
                fillColor: Colors.white,

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),

              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter project description';
                }

                return null;
              },
            ),

            const SizedBox(height: 25),

            const Text(
              'Project Settings',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),

            const SizedBox(height: 15),

            // STATUS
            DropdownButtonFormField<String>(
              value: selectedStatus,

              decoration: InputDecoration(
                labelText: 'Status',
                prefixIcon: const Icon(Icons.flag_outlined),

                filled: true,
                fillColor: Colors.white,

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),

              items: const [
                DropdownMenuItem(value: 'Planning', child: Text('Planning')),
                DropdownMenuItem(
                  value: 'In Progress',
                  child: Text('In Progress'),
                ),
                DropdownMenuItem(value: 'On Hold', child: Text('On Hold')),
                DropdownMenuItem(value: 'Completed', child: Text('Completed')),
              ],

              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedStatus = value;
                  });
                }
              },
            ),

            const SizedBox(height: 16),

            // PRIORITY
            DropdownButtonFormField<String>(
              value: selectedPriority,

              decoration: InputDecoration(
                labelText: 'Priority',
                prefixIcon: const Icon(Icons.priority_high),

                filled: true,
                fillColor: Colors.white,

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),

              items: const [
                DropdownMenuItem(value: 'Low', child: Text('Low')),
                DropdownMenuItem(value: 'Medium', child: Text('Medium')),
                DropdownMenuItem(value: 'High', child: Text('High')),
              ],

              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedPriority = value;
                  });
                }
              },
            ),

            const SizedBox(height: 25),

            const Text(
              'Project Dates',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),

            const SizedBox(height: 15),

            // START DATE
            _dateButton(
              title: 'Start Date',
              date: startDate,
              icon: Icons.calendar_today_outlined,
              onTap: _selectStartDate,
            ),

            const SizedBox(height: 12),

            // END DATE
            _dateButton(
              title: 'End Date',
              date: endDate,
              icon: Icons.event_outlined,
              onTap: _selectEndDate,
            ),

            const SizedBox(height: 30),

            // CREATE BUTTON
            SizedBox(
              height: 54,

              child: ElevatedButton.icon(
                onPressed: _createProject,

                icon: const Icon(Icons.add),

                label: const Text(
                  'Create Project',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),

                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),

                  foregroundColor: Colors.white,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  Widget _dateButton({
    required String title,
    required DateTime? date,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,

      borderRadius: BorderRadius.circular(14),

      child: Container(
        padding: const EdgeInsets.all(16),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(14),

          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),

        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF2563EB)),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF94A3B8),
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    _formatDate(date),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: date == null
                          ? const Color(0xFF94A3B8)
                          : const Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
            ),

            const Icon(Icons.chevron_right, color: Color(0xFF94A3B8)),
          ],
        ),
      ),
    );
  }
}
