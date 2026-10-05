import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../models/student.dart';
import '../../services/student_service.dart';

class ManageStudents extends StatefulWidget {
  const ManageStudents({super.key});

  @override
  State<ManageStudents> createState() => _ManageStudentsState();
}

class _ManageStudentsState extends State<ManageStudents> {
  final StudentService _studentService = StudentService();

  void _showStudentForm({Student? student}) {
    final nameController = TextEditingController(
      text: student?.name ?? '',
    );

    final registerController = TextEditingController(
      text: student?.registerNumber ?? '',
    );

    final departmentController = TextEditingController(
      text: student?.department ?? '',
    );

    final semesterController = TextEditingController(
      text: student?.semester.toString() ?? '',
    );

    final usernameController = TextEditingController(
      text: student?.username ?? '',
    );

    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: PunctualColors.card,
          title: Text(
            student == null
                ? 'Add Student'
                : 'Edit Student',
          ),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Student Name',
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty) {
                        return 'Enter student name';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 14),

                  TextFormField(
                    controller: registerController,
                    decoration: const InputDecoration(
                      labelText: 'Register Number',
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty) {
                        return 'Enter register number';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 14),

                  TextFormField(
                    controller: departmentController,
                    decoration: const InputDecoration(
                      labelText: 'Department',
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

                  const SizedBox(height: 14),

                  TextFormField(
                    controller: usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty) {
                        return 'Enter username';
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

                final newStudent = Student(
                  id: student?.id ??
                      'student_${DateTime.now().millisecondsSinceEpoch}',
                  name: nameController.text.trim(),
                  registerNumber:
                      registerController.text.trim(),
                  department:
                      departmentController.text.trim(),
                  semester:
                      int.parse(semesterController.text.trim()),
                  username:
                      usernameController.text.trim(),
                );

                setState(() {
                  if (student == null) {
                    _studentService.addStudent(newStudent);
                  } else {
                    _studentService.updateStudent(newStudent);
                  }
                });

                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      student == null
                          ? 'Student added successfully'
                          : 'Student updated successfully',
                    ),
                  ),
                );
              },
              child: Text(
                student == null ? 'Add' : 'Save',
              ),
            ),
          ],
        );
      },
    );
  }

  void _deleteStudent(Student student) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: PunctualColors.card,
          title: const Text('Delete Student'),
          content: Text(
            'Are you sure you want to delete ${student.name}?',
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
                  _studentService.removeStudent(student.id);
                });

                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Student deleted successfully',
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
    final students = _studentService.getStudents();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Students'),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: PunctualColors.primary,
        foregroundColor: PunctualColors.white,
        onPressed: () {
          _showStudentForm();
        },
        child: const Icon(
          Icons.add_rounded,
        ),
      ),
      body: students.isEmpty
          ? _buildEmptyState()
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: students.length,
              separatorBuilder: (_, _) {
                return const SizedBox(height: 12);
              },
              itemBuilder: (context, index) {
                final student = students[index];

                return _StudentCard(
                  student: student,
                  onEdit: () {
                    _showStudentForm(
                      student: student,
                    );
                  },
                  onDelete: () {
                    _deleteStudent(student);
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
              Icons.people_outline_rounded,
              size: 64,
              color: PunctualColors.mutedText,
            ),
            const SizedBox(height: 16),
            Text(
              'No students found',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Add a student to get started.',
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

class _StudentCard extends StatelessWidget {
  final Student student;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _StudentCard({
    required this.student,
    required this.onEdit,
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
              Icons.person_outline_rounded,
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
                  student.name,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium,
                ),

                const SizedBox(height: 4),

                Text(
                  student.registerNumber,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall,
                ),

                const SizedBox(height: 4),

                Text(
                  '${student.department} • Semester ${student.semester}',
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
              if (value == 'edit') {
                onEdit();
              }

              if (value == 'delete') {
                onDelete();
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 'edit',
                child: Text('Edit'),
              ),
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