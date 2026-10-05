import 'package:flutter/material.dart';

import '../../app/routes.dart';
import '../../app/theme.dart';
import '../../models/subject.dart';
import '../../services/attendance_service.dart';
import '../../services/student_service.dart';
import '../../services/subject_service.dart';
import '../../widgets/attendance_card.dart';
import '../../widgets/punctual_bottom_nav.dart';
import '../../widgets/subject_card.dart';

class SubjectsScreen extends StatefulWidget {
  const SubjectsScreen({super.key});

  @override
  State<SubjectsScreen> createState() => _SubjectsScreenState();
}

class _SubjectsScreenState extends State<SubjectsScreen> {
  final StudentService _studentService = StudentService();
  final SubjectService _subjectService = SubjectService();
  final AttendanceService _attendanceService =
      AttendanceService();

  final String _studentId = 'student_001';

  int _currentIndex = 1;

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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Subjects'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                AppRoutes.extraSubjects,
              );
            },
            icon: const Icon(
              Icons.bookmark_add_outlined,
            ),
          ),
        ],
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
            Text(
              'Official Subjects',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge,
            ),

            const SizedBox(height: 6),

            Text(
              'Subjects managed by your college.',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium,
            ),

            const SizedBox(height: 16),

            if (officialSubjects.isEmpty)
              _buildEmptyCard(
                icon: Icons.menu_book_outlined,
                title: 'No official subjects',
                message:
                    'Your official subjects will appear here.',
              )
            else
              ...officialSubjects.map(
                (subject) => Padding(
                  padding: const EdgeInsets.only(
                    bottom: 12,
                  ),
                  child: SubjectCard(
                    name: subject.name,
                    code: subject.code,
                    isOfficial: true,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.attendanceDetails,
                        arguments: subject,
                      );
                    },
                  ),
                ),
              ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Extra Subjects',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.extraSubjects,
                    );
                  },
                  child: const Text('Manage'),
                ),
              ],
            ),

            const SizedBox(height: 6),

            Text(
              'Subjects you added yourself.',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium,
            ),

            const SizedBox(height: 16),

            if (extraSubjects.isEmpty)
              _buildAddExtraSubjectCard()
            else
              ...extraSubjects.map(
                (subject) => Padding(
                  padding: const EdgeInsets.only(
                    bottom: 12,
                  ),
                  child: _buildExtraSubject(
                    subject,
                  ),
                ),
              ),

            const SizedBox(height: 12),

            _buildAttendanceSummary(
              officialSubjects,
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

  Widget _buildExtraSubject(Subject subject) {
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

    return Column(
      children: [
        SubjectCard(
          name: subject.name,
          code: subject.code,
          isOfficial: false,
          onTap: () {
            Navigator.pushNamed(
              context,
              AppRoutes.attendanceDetails,
              arguments: subject,
            );
          },
        ),
        const SizedBox(height: 8),
        AttendanceCard(
          subjectName: subject.name,
          subjectCode: subject.code,
          percentage: percentage,
          present: present,
          total: total,
        ),
      ],
    );
  }

  Widget _buildAttendanceSummary(
    List<Subject> subjects,
  ) {
    if (subjects.isEmpty) {
      return const SizedBox.shrink();
    }

    var totalClasses = 0;
    var totalPresent = 0;

    for (final subject in subjects) {
      totalClasses +=
          _attendanceService.getTotalClasses(
        studentId: _studentId,
        subjectId: subject.id,
      );

      totalPresent +=
          _attendanceService.getPresentClasses(
        studentId: _studentId,
        subjectId: subject.id,
      );
    }

    final percentage = totalClasses == 0
        ? 0.0
        : (totalPresent / totalClasses) * 100;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: PunctualColors.secondaryBackground,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: PunctualColors.border,
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.bar_chart_rounded,
            color: PunctualColors.softHighlight,
            size: 28,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Subject Summary',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  '$totalPresent of $totalClasses classes attended',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall,
                ),
              ],
            ),
          ),
          Text(
            '${percentage.toStringAsFixed(0)}%',
            style: const TextStyle(
              color: PunctualColors.softHighlight,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddExtraSubjectCard() {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.addExtraSubject,
        );
      },
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(20),
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
              Icons.add_circle_outline_rounded,
              color: PunctualColors.softHighlight,
              size: 34,
            ),
            const SizedBox(height: 10),
            Text(
              'Add an Extra Subject',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium,
            ),
            const SizedBox(height: 5),
            Text(
              'Track attendance for your own additional subjects.',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyCard({
    required IconData icon,
    required String title,
    required String message,
  }) {
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
          Icon(
            icon,
            size: 40,
            color: PunctualColors.mutedText,
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .titleMedium,
          ),
          const SizedBox(height: 6),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodySmall,
          ),
        ],
      ),
    );
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
        break;

      case 2:
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.studentAttendance,
        );
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