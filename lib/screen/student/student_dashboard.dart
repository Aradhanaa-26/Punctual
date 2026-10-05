import 'package:flutter/material.dart';

import '../../app/routes.dart';
import '../../app/theme.dart';
import '../../models/subject.dart';
import '../../services/attendance_service.dart';
import '../../services/student_service.dart';
import '../../services/subject_service.dart';
import '../../widgets/attendance_card.dart';
import '../../widgets/punctual_bottom_nav.dart';
import '../../widgets/statistic_card.dart';
import '../../models/student.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() =>
      _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  final StudentService _studentService = StudentService();
  final SubjectService _subjectService = SubjectService();
  final AttendanceService _attendanceService =
      AttendanceService();

  final String _studentId = 'student_001';

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final student =
        _studentService.getStudentById(_studentId);

    final subjects = _subjectService.getOfficialSubjects(
      department: student?.department,
      semester: student?.semester,
    );

    final overallAttendance =
        _attendanceService.getOverallAttendance(
      _studentId,
    );

    final totalClasses = _getTotalClasses(subjects);

    final presentClasses = _getPresentClasses(subjects);

    final lowAttendanceSubjects = subjects.where((subject) {
      final percentage =
          _attendanceService.getAttendancePercentage(
        studentId: _studentId,
        subjectId: subject.id,
      );

      return percentage < 75;
    }).toList();

    return Scaffold(
      body: SafeArea(
        child: _buildHomeContent(
          student: student,
          subjects: subjects,
          overallAttendance: overallAttendance,
          totalClasses: totalClasses,
          presentClasses: presentClasses,
          lowAttendanceSubjects:
              lowAttendanceSubjects,
        ),
      ),
      bottomNavigationBar: PunctualBottomNav(
        currentIndex: _currentIndex,
        onTap: _handleNavigation,
      ),
    );
  }

  Widget _buildHomeContent({
    required Student? student,
    required List<Subject> subjects,
    required double overallAttendance,
    required int totalClasses,
    required int presentClasses,
    required List<Subject> lowAttendanceSubjects,
  }) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        20,
        20,
        20,
        28,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(student),

          const SizedBox(height: 28),

          _buildOverallCard(
            overallAttendance,
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              Expanded(
                child: StatisticCard(
                  title: 'Present',
                  value: presentClasses.toString(),
                  icon: Icons.check_circle_outline_rounded,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: StatisticCard(
                  title: 'Classes',
                  value: totalClasses.toString(),
                  icon: Icons.calendar_month_outlined,
                ),
              ),
            ],
          ),

          const SizedBox(height: 30),

          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Low Attendance',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge,
              ),
              if (lowAttendanceSubjects.isNotEmpty)
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.studentAttendance,
                    );
                  },
                  child: const Text('View all'),
                ),
            ],
          ),

          const SizedBox(height: 12),

          if (lowAttendanceSubjects.isEmpty)
            _buildHealthyAttendance()
          else
            ...lowAttendanceSubjects.map(
              (subject) {
                final percentage =
                    _attendanceService
                        .getAttendancePercentage(
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

                return Padding(
                  padding:
                      const EdgeInsets.only(bottom: 12),
                  child: AttendanceCard(
                    subjectName: subject.name,
                    subjectCode: subject.code,
                    percentage: percentage,
                    present: present,
                    total: total,
                  ),
                );
              },
            ),

          const SizedBox(height: 18),

          Text(
            'Your Subjects',
            style: Theme.of(context)
                .textTheme
                .titleLarge,
          ),

          const SizedBox(height: 12),

          ...subjects.take(4).map(
            (subject) {
              final percentage =
                  _attendanceService
                      .getAttendancePercentage(
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

              return Padding(
                padding:
                    const EdgeInsets.only(bottom: 12),
                child: AttendanceCard(
                  subjectName: subject.name,
                  subjectCode: subject.code,
                  percentage: percentage,
                  present: present,
                  total: total,
                ),
              );
            },
          ),

          const SizedBox(height: 12),

          OutlinedButton.icon(
            onPressed: () {
              Navigator.pushNamed(
                context,
                AppRoutes.studentSubjects,
              );
            },
            icon: const Icon(
              Icons.menu_book_outlined,
            ),
            label: const Text(
              'View All Subjects',
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor:
                  PunctualColors.softHighlight,
              minimumSize:
                  const Size(double.infinity, 50),
              side: const BorderSide(
                color: PunctualColors.border,
              ),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(14),
              ),
            ),
          ),

          const SizedBox(height: 24),

          _buildExtraSubjectCard(),
        ],
      ),
    );
  }

  Widget _buildHeader(Student? student) {
    final name = student?.name ?? 'Student';

    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: PunctualColors.deepAccent,
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Icon(
            Icons.person_outline_rounded,
            color: PunctualColors.softHighlight,
            size: 25,
          ),
        ),

        const SizedBox(width: 14),

        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome back,',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall,
              ),
              const SizedBox(height: 3),
              Text(
                name,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge,
              ),
            ],
          ),
        ),

        IconButton(
          onPressed: () {
            Navigator.pushNamed(
              context,
              AppRoutes.studentProfile,
            );
          },
          icon: const Icon(
            Icons.settings_outlined,
          ),
        ),
      ],
    );
  }

  Widget _buildOverallCard(double percentage) {
    final Color statusColor;

    if (percentage >= 75) {
      statusColor = PunctualColors.healthy;
    } else if (percentage >= 60) {
      statusColor = PunctualColors.warning;
    } else {
      statusColor = PunctualColors.critical;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: PunctualColors.card,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: PunctualColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
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
                    const SizedBox(height: 5),
                    Text(
                      percentage >= 75
                          ? 'You are on track'
                          : 'Attendance needs attention',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall,
                    ),
                  ],
                ),
              ),

              Text(
                '${percentage.toStringAsFixed(1)}%',
                style: TextStyle(
                  color: statusColor,
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          ClipRRect(
            borderRadius:
                BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: (percentage / 100)
                  .clamp(0.0, 1.0),
              minHeight: 9,
              backgroundColor:
                  PunctualColors.progressTrack,
              valueColor:
                  AlwaysStoppedAnimation<Color>(
                statusColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthyAttendance() {
    return Container(
      width: double.infinity,
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
          const Icon(
            Icons.check_circle_outline_rounded,
            color: PunctualColors.healthy,
            size: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'All your subjects are currently above 75%.',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExtraSubjectCard() {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.extraSubjects,
        );
      },
      borderRadius: BorderRadius.circular(18),
      child: Container(
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
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: PunctualColors.dustyRose
                    .withValues(alpha: 0.14),
                borderRadius:
                    BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.bookmark_add_outlined,
                color: PunctualColors.softRose,
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    'Extra Subjects',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Track your own additional subjects',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall,
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.chevron_right_rounded,
              color: PunctualColors.mutedText,
            ),
          ],
        ),
      ),
    );
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

  int _getPresentClasses(List<Subject> subjects) {
    var total = 0;

    for (final subject in subjects) {
      total += _attendanceService.getPresentClasses(
        studentId: _studentId,
        subjectId: subject.id,
      );
    }

    return total;
  }

  void _handleNavigation(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        break;

      case 1:
        Navigator.pushNamed(
          context,
          AppRoutes.studentSubjects,
        );
        break;

      case 2:
        Navigator.pushNamed(
          context,
          AppRoutes.studentAttendance,
        );
        break;

      case 3:
        Navigator.pushNamed(
          context,
          AppRoutes.studentProfile,
        );
        break;
    }
  }
}