import 'package:flutter/material.dart';

import '../../app/routes.dart';
import '../../app/theme.dart';
import '../../models/subject.dart';
import '../../services/attendance_service.dart';
import '../../services/student_service.dart';
import '../../services/subject_service.dart';
import '../../widgets/attendance_card.dart';
import '../../widgets/punctual_bottom_nav.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() =>
      _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final StudentService _studentService = StudentService();
  final SubjectService _subjectService = SubjectService();
  final AttendanceService _attendanceService =
      AttendanceService();

  final String _studentId = 'student_001';

  int _currentIndex = 2;

  @override
  Widget build(BuildContext context) {
    final student =
        _studentService.getStudentById(_studentId);

    final officialSubjects =
        _subjectService.getOfficialSubjects(
      department: student?.department,
      semester: student?.semester,
    );

    final extraSubjects =
        _subjectService.getExtraSubjects(_studentId);

    final allSubjects = [
      ...officialSubjects,
      ...extraSubjects,
    ];

    final overall =
        _attendanceService.getOverallAttendance(
      _studentId,
    );

    final present = _getPresentClasses(allSubjects);
    final total = _getTotalClasses(allSubjects);
    final absent = total - present;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            20,
            8,
            20,
            28,
          ),
          children: [
            _buildOverallCard(
              overall: overall,
              present: present,
              absent: absent,
              total: total,
            ),

            const SizedBox(height: 28),

            Text(
              'Subject-wise Attendance',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge,
            ),

            const SizedBox(height: 6),

            Text(
              'Your official attendance records.',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium,
            ),

            const SizedBox(height: 16),

            if (allSubjects.isEmpty)
              _buildEmptyState()
            else
              ...allSubjects.map(
                (subject) => Padding(
                  padding: const EdgeInsets.only(
                    bottom: 12,
                  ),
                  child: _buildAttendanceCard(
                    subject,
                  ),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: PunctualBottomNav(
        currentIndex: _currentIndex,
        onTap: _handleNavigation,
      ),
    );
  }

  Widget _buildOverallCard({
    required double overall,
    required int present,
    required int absent,
    required int total,
  }) {
    final Color statusColor;

    if (overall >= 75) {
      statusColor = PunctualColors.healthy;
    } else if (overall >= 60) {
      statusColor = PunctualColors.warning;
    } else {
      statusColor = PunctualColors.critical;
    }

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: PunctualColors.card,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: PunctualColors.border,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Overall Attendance',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '$present of $total classes attended',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall,
                    ),
                  ],
                ),
              ),
              Text(
                '${overall.toStringAsFixed(1)}%',
                style: TextStyle(
                  color: statusColor,
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          ClipRRect(
            borderRadius:
                BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value:
                  (overall / 100).clamp(0.0, 1.0),
              minHeight: 9,
              backgroundColor:
                  PunctualColors.progressTrack,
              valueColor:
                  AlwaysStoppedAnimation<Color>(
                statusColor,
              ),
            ),
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: _MiniStat(
                  label: 'Present',
                  value: present.toString(),
                  color: PunctualColors.healthy,
                ),
              ),
              Expanded(
                child: _MiniStat(
                  label: 'Absent',
                  value: absent.toString(),
                  color: PunctualColors.critical,
                ),
              ),
              Expanded(
                child: _MiniStat(
                  label: 'Total',
                  value: total.toString(),
                  color: PunctualColors.softHighlight,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceCard(Subject subject) {
    final percentage =
        _attendanceService.getAttendancePercentage(
      studentId: _studentId,
      subjectId: subject.id,
    );

    final present =
        _attendanceService.getPresentClasses(
      studentId: _studentId,
      subjectId: subject.id,
    );

    final total =
        _attendanceService.getTotalClasses(
      studentId: _studentId,
      subjectId: subject.id,
    );

    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.attendanceDetails,
          arguments: subject,
        );
      },
      borderRadius: BorderRadius.circular(18),
      child: AttendanceCard(
        subjectName: subject.name,
        subjectCode: subject.code,
        percentage: percentage,
        present: present,
        total: total,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: PunctualColors.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: PunctualColors.border,
        ),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.bar_chart_outlined,
            size: 48,
            color: PunctualColors.mutedText,
          ),
          const SizedBox(height: 14),
          Text(
            'No attendance available',
            style: Theme.of(context)
                .textTheme
                .titleMedium,
          ),
          const SizedBox(height: 6),
          Text(
            'Attendance records will appear here once they are added.',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodySmall,
          ),
        ],
      ),
    );
  }

  int _getPresentClasses(List<Subject> subjects) {
    var present = 0;

    for (final subject in subjects) {
      present += _attendanceService.getPresentClasses(
        studentId: _studentId,
        subjectId: subject.id,
      );
    }

    return present;
  }

  int _getTotalClasses(List<Subject> subjects) {
    var total = 0;

    for (final subject in subjects) {
      total += _attendanceService.getTotalClasses(
        studentId: _studentId,
        subjectId: subject.id,
      );
    }

    return total;
  }

  void _handleNavigation(int index) {
    if (index == _currentIndex) {
      return;
    }

    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.studentDashboard,
        );
        break;

      case 1:
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.studentSubjects,
        );
        break;

      case 2:
        break;

      case 3:
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.studentProfile,
        );
        break;
    }
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MiniStat({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 20,
            fontWeight: FontWeight.w700,
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