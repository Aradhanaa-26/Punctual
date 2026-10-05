import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../models/subject.dart';
import '../../services/subject_service.dart';

class ManageSubjects extends StatefulWidget {
  const ManageSubjects({super.key});

  @override
  State<ManageSubjects> createState() => _ManageSubjectsState();
}

class _ManageSubjectsState extends State<ManageSubjects> {
  final SubjectService _subjectService = SubjectService();

  void _showSubjectForm() {
    final nameController = TextEditingController();
    final codeController = TextEditingController();
    final departmentController = TextEditingController();
    final semesterController = TextEditingController();

    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: PunctualColors.card,
          title: const Text('Add Subject'),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Subject Name',
                      hintText: 'e.g. Data Structures',
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty) {
                        return 'Enter subject name';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 14),

                  TextFormField(
                    controller: codeController,
                    decoration: const InputDecoration(
                      labelText: 'Subject Code',
                      hintText: 'e.g. CS401',
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty) {
                        return 'Enter subject code';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 14),

                  TextFormField(
                    controller: departmentController,
                    decoration: const InputDecoration(
                      labelText: 'Department',
                      hintText: 'e.g. Computer Science',
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty) {
                        return 'Enter department';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 14),

                  TextFormField(
                    controller: semesterController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Semester',
                      hintText: 'e.g. 4',
                    ),
                    validator: (value) {
                      final semester =
                          int.tryParse(value ?? '');

                      if (semester == null ||
                          semester < 1 ||
                          semester > 8) {
                        return 'Enter semester 1-8';
                      }

                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (!formKey.currentState!.validate()) {
                  return;
                }

                final subject = Subject(
                  id: 'sub_${DateTime.now().millisecondsSinceEpoch}',
                  name: nameController.text.trim(),
                  code: codeController.text.trim(),
                  department:
                      departmentController.text.trim(),
                  semester:
                      int.parse(semesterController.text.trim()),
                  isOfficial: true,
                );

                setState(() {
                  _subjectService.addOfficialSubject(subject);
                });

                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Subject added successfully',
                    ),
                  ),
                );
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _deleteSubject(Subject subject) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: PunctualColors.card,
          title: const Text('Delete Subject'),
          content: Text(
            'Are you sure you want to delete ${subject.name}?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _subjectService.removeOfficialSubject(
                    subject.id,
                  );
                });

                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Subject deleted successfully',
                    ),
                  ),
                );
              },
              child: const Text(
                'Delete',
                style: TextStyle(
                  color: PunctualColors.critical,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final subjects = _subjectService.getOfficialSubjects();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Subjects'),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: PunctualColors.primary,
        foregroundColor: PunctualColors.white,
        onPressed: _showSubjectForm,
        child: const Icon(
          Icons.add_rounded,
        ),
      ),
      body: subjects.isEmpty
          ? _buildEmptyState()
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: subjects.length,
              separatorBuilder: (_, _) {
                return const SizedBox(height: 12);
              },
              itemBuilder: (context, index) {
                final subject = subjects[index];

                return _SubjectManagementCard(
                  subject: subject,
                  onDelete: () {
                    _deleteSubject(subject);
                  },
                );
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.menu_book_outlined,
              size: 64,
              color: PunctualColors.mutedText,
            ),
            const SizedBox(height: 16),
            Text(
              'No subjects found',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Add an official subject to get started.',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _SubjectManagementCard extends StatelessWidget {
  final Subject subject;
  final VoidCallback onDelete;

  const _SubjectManagementCard({
    required this.subject,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: PunctualColors.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: PunctualColors.border,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: PunctualColors.deepAccent,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.menu_book_outlined,
              color: PunctualColors.softHighlight,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  subject.name,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium,
                ),

                const SizedBox(height: 4),

                Text(
                  subject.code,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall,
                ),

                const SizedBox(height: 4),

                Text(
                  '${subject.department} • Semester ${subject.semester}',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall,
                ),
              ],
            ),
          ),

          PopupMenuButton<String>(
            icon: const Icon(
              Icons.more_vert_rounded,
              color: PunctualColors.secondaryText,
            ),
            onSelected: (value) {
              if (value == 'delete') {
                onDelete();
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 'delete',
                child: Text('Delete'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}