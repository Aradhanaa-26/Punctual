import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../models/attendance.dart';
import '../../models/subject.dart';
import '../../services/attendance_service.dart';
import '../../widgets/progress_indicator.dart';

class AttendanceDetails extends StatefulWidget {
  final Subject subject;

  const AttendanceDetails({
    super.key,
    required this.subject,
  });

  @override
  State<AttendanceDetails> createState() =>
      _AttendanceDetailsState();
}

class _AttendanceDetailsState
    extends State<AttendanceDetails> {
  final AttendanceService _attendanceService =
      AttendanceService();

  static const String _studentId = 'student_001';

  double get percentage {
    return _attendanceService.getAttendancePercentage(
      studentId: _studentId,
      subjectId: widget.subject.id,
    );
  }

  int get presentClasses {
    return _attendanceService.getPresentClasses(
      studentId: _studentId,
      subjectId: widget.subject.id,
    );
  }

  int get absentClasses {
    return _attendanceService.getAbsentClasses(
      studentId: _studentId,
      subjectId: widget.subject.id,
    );
  }

  int get totalClasses {
    return _attendanceService.getTotalClasses(
      studentId: _studentId,
      subjectId: widget.subject.id,
    );
  }

  List<AttendanceRecord> get records {
    final result = _attendanceService.getRecordsForSubject(
      studentId: _studentId,
      subjectId: widget.subject.id,
    );

    result.sort(
      (a, b) => b.date.compareTo(a.date),
    );

    return result;
  }

  Future<void> _markAttendance() async {
    DateTime selectedDate = DateTime.now();
    bool isPresent = true;

    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Mark Attendance'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(
                      Icons.calendar_today_outlined,
                    ),
                    title: const Text('Date'),
                    subtitle: Text(
                      '${selectedDate.day.toString().padLeft(2, '0')}/'
                      '${selectedDate.month.toString().padLeft(2, '0')}/'
                      '${selectedDate.year}',
                    ),
                    onTap: () async {
                      final picked =
                          await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate:
                            DateTime(2020),
                        lastDate:
                            DateTime.now(),
                      );

                      if (picked != null) {
                        setDialogState(() {
                          selectedDate = picked;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Attendance Status',
                      style: TextStyle(
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  RadioGroup<bool>(
  groupValue: isPresent,
  onChanged: (value) {
    if (value != null) {
      setDialogState(() {
        isPresent = value;
      });
    }
  },
  child: Column(
    children: [
      RadioListTile<bool>(
        contentPadding: EdgeInsets.zero,
        title: const Text('Present'),
        value: true,
      ),
      RadioListTile<bool>(
        contentPadding: EdgeInsets.zero,
        title: const Text('Absent'),
        value: false,
      ),
    ],
  ),
),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(
                      dialogContext,
                      false,
                    );
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(
                      dialogContext,
                      true,
                    );
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );

    if (result != true || !mounted) {
      return;
    }

    final existingRecords =
        _attendanceService.getRecordsForSubject(
      studentId: _studentId,
      subjectId: widget.subject.id,
    );

    final alreadyMarked =
        existingRecords.any(
      (record) =>
          record.date.year == selectedDate.year &&
          record.date.month == selectedDate.month &&
          record.date.day == selectedDate.day,
    );

    if (alreadyMarked) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Attendance is already marked for this date.',
          ),
        ),
      );

      return;
    }

    final attendance = AttendanceRecord(
      id: 'extra_att_${DateTime.now().millisecondsSinceEpoch}',
      studentId: _studentId,
      subjectId: widget.subject.id,
      date: selectedDate,
      isPresent: isPresent,
    );

    _attendanceService.addAttendance(
      attendance,
    );

    if (!mounted) {
      return;
    }

    setState(() {});

    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(
          isPresent
              ? 'Attendance marked Present.'
              : 'Attendance marked Absent.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final subject = widget.subject;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Attendance Details',
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Container(
              padding:
                  const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color:
                    PunctualColors.card,
                borderRadius:
                    BorderRadius.circular(20),
                border: Border.all(
                  color:
                      PunctualColors.border,
                ),
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration:
                            BoxDecoration(
                          color:
                              PunctualColors.primary
                                  .withValues(alpha: 0.18),
                          borderRadius:
                              BorderRadius.circular(
                            14,
                          ),
                        ),
                        child: const Icon(
                          Icons.menu_book_outlined,
                          color:
                              PunctualColors.highlight,
                        ),
                      ),
                      const SizedBox(
                        width: 14,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                          children: [
                            Text(
                              subject.name,
                              style:
                                  Theme.of(
                                context,
                              ).textTheme.titleLarge,
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              subject.code,
                              style:
                                  Theme.of(
                                context,
                              ).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration:
                        BoxDecoration(
                      color: subject.isOfficial
                          ? PunctualColors.primary
                              .withValues(alpha: 0.16)
                          : PunctualColors.dustyRose
                              .withValues(alpha: 0.16),
                      borderRadius:
                          BorderRadius.circular(
                        20,
                      ),
                    ),
                    child: Text(
                      subject.isOfficial
                          ? 'Official Subject'
                          : 'Extra Subject',
                      style: TextStyle(
                        color: subject.isOfficial
                            ? PunctualColors
                                .softHighlight
                            : PunctualColors
                                .softRose,
                        fontWeight:
                            FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Container(
              padding:
                  const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color:
                    PunctualColors.card,
                borderRadius:
                    BorderRadius.circular(20),
                border: Border.all(
                  color:
                      PunctualColors.border,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    '${percentage.toStringAsFixed(1)}%',
                    style: Theme.of(context)
                        .textTheme
                        .displaySmall
                        ?.copyWith(
                          fontWeight:
                              FontWeight.w700,
                        ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  AttendanceProgressIndicator(
                    percentage: percentage,
                    height: 9,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: _SummaryItem(
                          label: 'Present',
                          value:
                              presentClasses
                                  .toString(),
                        ),
                      ),
                      Expanded(
                        child: _SummaryItem(
                          label: 'Absent',
                          value:
                              absentClasses
                                  .toString(),
                        ),
                      ),
                      Expanded(
                        child: _SummaryItem(
                          label: 'Total',
                          value:
                              totalClasses
                                  .toString(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            if (!subject.isOfficial) ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed:
                      _markAttendance,
                  icon: const Icon(
                    Icons.add_task,
                  ),
                  label: const Text(
                    'Mark Attendance',
                  ),
                ),
              ),
            ],

            const SizedBox(height: 24),

            Text(
              'Attendance History',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(
                    fontWeight:
                        FontWeight.w700,
                  ),
            ),

            const SizedBox(height: 12),

            if (records.isEmpty)
              Container(
                padding:
                    const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color:
                      PunctualColors.card,
                  borderRadius:
                      BorderRadius.circular(
                    18,
                  ),
                  border: Border.all(
                    color:
                        PunctualColors.border,
                  ),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.event_busy_outlined,
                      size: 40,
                      color:
                          PunctualColors.secondaryText,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      subject.isOfficial
                          ? 'No attendance records available.'
                          : 'No attendance marked yet.',
                      textAlign:
                          TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium,
                    ),
                  ],
                ),
              )
            else
              ...records.map(
                (record) =>
                    _AttendanceHistoryTile(
                  record: record,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryItem({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(
                fontWeight:
                    FontWeight.w700,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context)
              .textTheme
              .bodySmall,
        ),
      ],
    );
  }
}

class _AttendanceHistoryTile
    extends StatelessWidget {
  final AttendanceRecord record;

  const _AttendanceHistoryTile({
    required this.record,
  });

  @override
  Widget build(BuildContext context) {
    final date = record.date;

    return Container(
      margin:
          const EdgeInsets.only(bottom: 10),
      padding:
          const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: PunctualColors.card,
        borderRadius:
            BorderRadius.circular(16),
        border: Border.all(
          color: PunctualColors.border,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: record.isPresent
                  ? PunctualColors.healthy
                      .withValues(alpha: 0.15)
                  : PunctualColors.critical
                      .withValues(alpha: 0.15),
              borderRadius:
                  BorderRadius.circular(12),
            ),
            child: Icon(
              record.isPresent
                  ? Icons.check
                  : Icons.close,
              color: record.isPresent
                  ? PunctualColors.healthy
                  : PunctualColors.critical,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  '${date.day.toString().padLeft(2, '0')}/'
                  '${date.month.toString().padLeft(2, '0')}/'
                  '${date.year}',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(
                        fontWeight:
                            FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 3),
                Text(
                  record.isPresent
                      ? 'Present'
                      : 'Absent',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}