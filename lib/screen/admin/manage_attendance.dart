import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../models/attendance.dart';
import '../../models/student.dart';
import '../../models/subject.dart';
import '../../services/attendance_service.dart';
import '../../services/student_service.dart';
import '../../services/subject_service.dart';

class ManageAttendance extends StatefulWidget {
  const ManageAttendance({super.key});

  @override
  State<ManageAttendance> createState() => _ManageAttendanceState();
}

class _ManageAttendanceState extends State<ManageAttendance> {
  final StudentService _studentService = StudentService();
  final SubjectService _subjectService = SubjectService();
  final AttendanceService _attendanceService =
      AttendanceService();

  Student? _selectedStudent;
  Subject? _selectedSubject;

  @override
  Widget build(BuildContext context) {
    final students = _studentService.getStudents();
    final subjects = _subjectService.getOfficialSubjects();

    final records = _selectedStudent == null
        ? <AttendanceRecord>[]
        : _selectedSubject == null
            ? _attendanceService.getRecordsForStudent(
                _selectedStudent!.id,
              )
            : _attendanceService.getRecordsForSubject(
                studentId: _selectedStudent!.id,
                subjectId: _selectedSubject!.id,
              );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Attendance'),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: PunctualColors.primary,
        foregroundColor: PunctualColors.white,
        onPressed: students.isEmpty || subjects.isEmpty
            ? null
            : () {
                _showAttendanceForm(
                  students: students,
                  subjects: subjects,
                );
              },
        child: const Icon(
          Icons.add_rounded,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildFilters(
              students: students,
              subjects: subjects,
            ),
            Expanded(
              child: records.isEmpty
                  ? _buildEmptyState()
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(
                        20,
                        8,
                        20,
                        100,
                      ),
                      itemCount: records.length,
                      separatorBuilder: (_, _) {
                        return const SizedBox(height: 12);
                      },
                      itemBuilder: (context, index) {
                        final record = records[index];

                        return _AttendanceRecordCard(
                          record: record,
                          subject: _findSubject(
                            subjects,
                            record.subjectId,
                          ),
                          onEdit: () {
                            _showAttendanceForm(
                              students: students,
                              subjects: subjects,
                              record: record,
                            );
                          },
                          onDelete: () {
                            _deleteAttendance(record);
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters({
    required List<Student> students,
    required List<Subject> subjects,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        20,
        16,
        20,
        16,
      ),
      decoration: const BoxDecoration(
        color: PunctualColors.secondaryBackground,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filter Attendance',
            style: Theme.of(context)
                .textTheme
                .titleMedium,
          ),

          const SizedBox(height: 12),

          DropdownButtonFormField<Student>(
            initialValue: _selectedStudent,
            decoration: const InputDecoration(
              labelText: 'Student',
              prefixIcon: Icon(
                Icons.person_outline_rounded,
              ),
            ),
            items: students.map((student) {
              return DropdownMenuItem<Student>(
                value: student,
                child: Text(
                  '${student.name} • ${student.registerNumber}',
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
            onChanged: (student) {
              setState(() {
                _selectedStudent = student;
                _selectedSubject = null;
              });
            },
          ),

          const SizedBox(height: 12),

          DropdownButtonFormField<Subject>(
            initialValue: _selectedSubject,
            decoration: const InputDecoration(
              labelText: 'Subject',
              prefixIcon: Icon(
                Icons.menu_book_outlined,
              ),
            ),
            items: subjects.map((subject) {
              return DropdownMenuItem<Subject>(
                value: subject,
                child: Text(
                  '${subject.name} • ${subject.code}',
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
            onChanged: _selectedStudent == null
                ? null
                : (subject) {
                    setState(() {
                      _selectedSubject = subject;
                    });
                  },
          ),
        ],
      ),
    );
  }

  void _showAttendanceForm({
    required List<Student> students,
    required List<Subject> subjects,
    AttendanceRecord? record,
  }) {
    Student? selectedStudent = record == null
        ? _selectedStudent
        : _findStudent(
            students,
            record.studentId,
          );

    Subject? selectedSubject = record == null
        ? _selectedSubject
        : _findSubject(
            subjects,
            record.subjectId,
          );

    DateTime selectedDate =
        record?.date ?? DateTime.now();

    bool isPresent = record?.isPresent ?? true;

    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (
            context,
            setDialogState,
          ) {
            return AlertDialog(
              backgroundColor: PunctualColors.card,
              title: Text(
                record == null
                    ? 'Mark Attendance'
                    : 'Edit Attendance',
              ),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DropdownButtonFormField<Student>(
                        initialValue: selectedStudent,
                        decoration: const InputDecoration(
                          labelText: 'Student',
                        ),
                        items: students.map((student) {
                          return DropdownMenuItem<Student>(
                            value: student,
                            child: Text(
                              '${student.name} • ${student.registerNumber}',
                              overflow:
                                  TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                        onChanged: (student) {
                          setDialogState(() {
                            selectedStudent = student;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Select a student';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 14),

                      DropdownButtonFormField<Subject>(
                        initialValue: selectedSubject,
                        decoration: const InputDecoration(
                          labelText: 'Subject',
                        ),
                        items: subjects.map((subject) {
                          return DropdownMenuItem<Subject>(
                            value: subject,
                            child: Text(
                              '${subject.name} • ${subject.code}',
                              overflow:
                                  TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                        onChanged: (subject) {
                          setDialogState(() {
                            selectedSubject = subject;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Select a subject';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 14),

                      InkWell(
                        borderRadius:
                            BorderRadius.circular(14),
                        onTap: () async {
                          final pickedDate =
                              await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate:
                                DateTime(2020),
                            lastDate:
                                DateTime(2100),
                            builder: (
                              context,
                              child,
                            ) {
                              return Theme(
                                data: Theme.of(context),
                                child: child!,
                              );
                            },
                          );

                          if (pickedDate != null) {
                            setDialogState(() {
                              selectedDate = pickedDate;
                            });
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          padding:
                              const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: PunctualColors.card,
                            borderRadius:
                                BorderRadius.circular(14),
                            border: Border.all(
                              color: PunctualColors.border,
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons
                                    .calendar_today_outlined,
                                color: PunctualColors
                                    .secondaryText,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Date: ${_formatDate(selectedDate)}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge,
                                ),
                              ),
                              const Icon(
                                Icons
                                    .chevron_right_rounded,
                                color: PunctualColors
                                    .mutedText,
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      Container(
                        padding:
                            const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: PunctualColors
                              .secondaryBackground,
                          borderRadius:
                              BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Attendance Status',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium,
                              ),
                            ),
                            Switch(
                              value: isPresent,
                              activeThumbColor:
                                  PunctualColors.healthy,
                              onChanged: (value) {
                                setDialogState(() {
                                  isPresent = value;
                                });
                              },
                            ),
                            Text(
                              isPresent
                                  ? 'Present'
                                  : 'Absent',
                              style: TextStyle(
                                color: isPresent
                                    ? PunctualColors.healthy
                                    : PunctualColors.critical,
                                fontWeight:
                                    FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
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
                    if (!formKey.currentState!
                        .validate()) {
                      return;
                    }

                    final attendance =
                        AttendanceRecord(
                      id: record?.id ??
                          'att_${DateTime.now().millisecondsSinceEpoch}',
                      studentId: selectedStudent!.id,
                      subjectId: selectedSubject!.id,
                      date: selectedDate,
                      isPresent: isPresent,
                    );

                    setState(() {
                      if (record == null) {
                        _attendanceService
                            .addAttendance(attendance);
                      } else {
                        _attendanceService
                            .updateAttendance(attendance);
                      }

                      _selectedStudent =
                          selectedStudent;
                      _selectedSubject =
                          selectedSubject;
                    });

                    Navigator.pop(dialogContext);

                    ScaffoldMessenger.of(context)
                        .showSnackBar(
                      SnackBar(
                        content: Text(
                          record == null
                              ? 'Attendance added successfully'
                              : 'Attendance updated successfully',
                        ),
                      ),
                    );
                  },
                  child: Text(
                    record == null ? 'Save' : 'Update',
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _deleteAttendance(AttendanceRecord record) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: PunctualColors.card,
          title: const Text('Delete Attendance'),
          content: const Text(
            'Are you sure you want to delete this attendance record?',
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
                  _attendanceService.removeAttendance(
                    record.id,
                  );
                });

                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(context)
                    .showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Attendance deleted successfully',
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

  Student? _findStudent(
    List<Student> students,
    String studentId,
  ) {
    for (final student in students) {
      if (student.id == studentId) {
        return student;
      }
    }

    return null;
  }

  Subject? _findSubject(
    List<Subject> subjects,
    String subjectId,
  ) {
    for (final subject in subjects) {
      if (subject.id == subjectId) {
        return subject;
      }
    }

    return null;
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.fact_check_outlined,
              size: 64,
              color: PunctualColors.mutedText,
            ),
            const SizedBox(height: 16),
            Text(
              _selectedStudent == null
                  ? 'Select a student'
                  : 'No attendance records',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              _selectedStudent == null
                  ? 'Choose a student to view attendance.'
                  : 'Add an attendance record using the + button.',
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

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }
}

class _AttendanceRecordCard extends StatelessWidget {
  final AttendanceRecord record;
  final Subject? subject;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _AttendanceRecordCard({
    required this.record,
    required this.subject,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = record.isPresent
        ? PunctualColors.healthy
        : PunctualColors.critical;

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
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: statusColor.withValues(
                alpha: 0.12,
              ),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              record.isPresent
                  ? Icons.check_rounded
                  : Icons.close_rounded,
              color: statusColor,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  subject?.name ?? 'Unknown Subject',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  subject?.code ?? '',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall,
                ),
                const SizedBox(height: 4),
                Text(
                  _formatDate(record.date),
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall,
                ),
              ],
            ),
          ),

          Column(
            crossAxisAlignment:
                CrossAxisAlignment.end,
            children: [
              Text(
                record.isPresent
                    ? 'Present'
                    : 'Absent',
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
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
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }
}