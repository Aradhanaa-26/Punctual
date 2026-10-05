import 'package:flutter/material.dart';

import '../../app/routes.dart';
import '../../app/theme.dart';
import '../../services/student_service.dart';
import '../../widgets/punctual_bottom_nav.dart';
import '../../models/student.dart';

class StudentProfile extends StatefulWidget {
  const StudentProfile({super.key});

  @override
  State<StudentProfile> createState() =>
      _StudentProfileState();
}

class _StudentProfileState
    extends State<StudentProfile> {
  final StudentService _studentService =
      StudentService();

  final String _studentId = 'student_001';

  int _currentIndex = 3;

  @override
  Widget build(BuildContext context) {
    final student =
        _studentService.getStudentById(_studentId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            20,
            12,
            20,
            28,
          ),
          children: [
            _buildProfileHeader(student),

            const SizedBox(height: 28),

            Text(
              'Student Information',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge,
            ),

            const SizedBox(height: 14),

            _InfoTile(
              icon: Icons.person_outline_rounded,
              label: 'Name',
              value: student?.name ?? 'Student',
            ),

            _InfoTile(
              icon: Icons.badge_outlined,
              label: 'Register Number',
              value:
                  student?.registerNumber ?? '-',
            ),

            _InfoTile(
              icon: Icons.school_outlined,
              label: 'Department',
              value:
                  student?.department ?? '-',
            ),

            _InfoTile(
              icon: Icons.layers_outlined,
              label: 'Semester',
              value: student == null
                  ? '-'
                  : 'Semester ${student.semester}',
            ),

            _InfoTile(
              icon: Icons.alternate_email_rounded,
              label: 'Username',
              value:
                  student?.username ?? '-',
            ),

            const SizedBox(height: 24),

            Text(
              'Account',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge,
            ),

            const SizedBox(height: 14),

            _ActionTile(
              icon: Icons.settings_outlined,
              title: 'Settings',
              subtitle:
                  'Manage application preferences',
              onTap: _showSettingsMessage,
            ),

            _ActionTile(
              icon: Icons.info_outline_rounded,
              title: 'About Punctual',
              subtitle:
                  'Attendance tracking application',
              onTap: _showAboutDialog,
            ),

            _ActionTile(
              icon: Icons.logout_rounded,
              title: 'Logout',
              subtitle:
                  'Sign out of your account',
              iconColor: PunctualColors.critical,
              onTap: _logout,
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

  Widget _buildProfileHeader(Student? student) {
    final name = student?.name ?? 'Student';
    final registerNumber =
        student?.registerNumber ?? '';

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
          Container(
            width: 82,
            height: 82,
            decoration: BoxDecoration(
              color: PunctualColors.deepAccent,
              shape: BoxShape.circle,
              border: Border.all(
                color: PunctualColors.highlight,
                width: 1.5,
              ),
            ),
            child: const Icon(
              Icons.person_rounded,
              color: PunctualColors.softHighlight,
              size: 42,
            ),
          ),

          const SizedBox(height: 16),

          Text(
            name,
            style: Theme.of(context)
                .textTheme
                .headlineMedium,
          ),

          const SizedBox(height: 5),

          Text(
            registerNumber,
            style: Theme.of(context)
                .textTheme
                .bodyMedium,
          ),

          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: PunctualColors.deepAccent,
              borderRadius:
                  BorderRadius.circular(10),
            ),
            child: const Text(
              'Student',
              style: TextStyle(
                color:
                    PunctualColors.softHighlight,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSettingsMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Settings will be available soon.',
        ),
      ),
    );
  }

  void _showAboutDialog() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: PunctualColors.card,
          title: const Text('About Punctual'),
          content: const Text(
            'Punctual is a student attendance tracking application designed to make attendance simple, clear, and organized.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _logout() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: PunctualColors.card,
          title: const Text('Logout?'),
          content: const Text(
            'Are you sure you want to log out?',
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
                Navigator.pop(dialogContext);

                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.login,
                  (route) => false,
                );
              },
              child: const Text(
                'Logout',
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
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.studentAttendance,
        );
        break;

      case 3:
        break;
    }
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: PunctualColors.card,
        borderRadius: BorderRadius.circular(16),
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
              color: PunctualColors.deepAccent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: PunctualColors.softHighlight,
              size: 21,
            ),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall,
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color? iconColor;

  const _ActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: PunctualColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: PunctualColors.border,
        ),
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 5,
        ),
        leading: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: PunctualColors.deepAccent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: iconColor ??
                PunctualColors.softHighlight,
          ),
        ),
        title: Text(
          title,
          style: Theme.of(context)
              .textTheme
              .titleMedium,
        ),
        subtitle: Text(
          subtitle,
          style: Theme.of(context)
              .textTheme
              .bodySmall,
        ),
        trailing: const Icon(
          Icons.chevron_right_rounded,
          color: PunctualColors.mutedText,
        ),
        onTap: onTap,
      ),
    );
  }
}