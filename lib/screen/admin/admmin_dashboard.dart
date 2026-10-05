import 'package:flutter/material.dart';

import '../../app/routes.dart';
import '../../app/theme.dart';
import '../../services/student_service.dart';
import '../../services/subject_service.dart';
import '../../services/attendance_service.dart';
import '../../widgets/statistic_card.dart';
import '../../widgets/app_button.dart';

class AdminDashboard extends StatelessWidget {
  AdminDashboard({super.key});

  final StudentService _studentService = StudentService();
  final SubjectService _subjectService = SubjectService();
  final AttendanceService _attendanceService = AttendanceService();

  @override
  Widget build(BuildContext context) {
    final students = _studentService.getStudents();
    final subjects = _subjectService.getOfficialSubjects();

    double totalAttendance = 0;

    if (students.isNotEmpty) {
      for (final student in students) {
        totalAttendance +=
            _attendanceService.getOverallAttendance(student.id);
      }

      totalAttendance /= students.length;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                AppRoutes.adminProfile,
              );
            },
            icon: const Icon(
              Icons.person_outline_rounded,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good evening',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium,
              ),

              const SizedBox(height: 4),

              Text(
                'Admin Dashboard',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium,
              ),

              const SizedBox(height: 8),

              Text(
                'Manage students, subjects and attendance.',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium,
              ),

              const SizedBox(height: 28),

              Row(
                children: [
                  Expanded(
                    child: StatisticCard(
                      title: 'Students',
                      value: students.length.toString(),
                      icon: Icons.people_outline_rounded,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: StatisticCard(
                      title: 'Subjects',
                      value: subjects.length.toString(),
                      icon: Icons.menu_book_outlined,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              StatisticCard(
                title: 'Average Attendance',
                value:
                    '${totalAttendance.toStringAsFixed(1)}%',
                icon: Icons.bar_chart_rounded,
              ),

              const SizedBox(height: 30),

              Text(
                'Management',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge,
              ),

              const SizedBox(height: 14),

              _ManagementTile(
                icon: Icons.people_outline_rounded,
                title: 'Manage Students',
                subtitle: 'Add, edit and remove students',
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.manageStudents,
                  );
                },
              ),

              const SizedBox(height: 12),

              _ManagementTile(
                icon: Icons.menu_book_outlined,
                title: 'Manage Subjects',
                subtitle: 'Manage official subjects',
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.manageSubjects,
                  );
                },
              ),

              const SizedBox(height: 12),

              _ManagementTile(
                icon: Icons.fact_check_outlined,
                title: 'Manage Attendance',
                subtitle: 'Record student attendance',
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.manageAttendance,
                  );
                },
              ),

              const SizedBox(height: 30),

              AppButton(
                label: 'View Students',
                icon: Icons.arrow_forward_rounded,
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.manageStudents,
                  );
                },
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _ManagementTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ManagementTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
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
              child: Icon(
                icon,
                color: PunctualColors.softHighlight,
                size: 23,
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
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
}