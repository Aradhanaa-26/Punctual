import 'package:flutter/material.dart';

import 'routes.dart';
import 'theme.dart';

import '../screen/auth/login_screen.dart';

import '../screen/admin/admmin_dashboard.dart';
import '../screen/admin/manage_students.dart';
import '../screen/admin/manage_subjects.dart';
import '../screen/admin/manage_attendance.dart';
import '../screen/admin/admin_profile.dart';

import '../screen/student/student_dashboard.dart';
import '../screen/student/subject_screen.dart';
import '../screen/student/attendance_screen.dart';
import '../screen/student/attendance_details.dart';
import '../screen/student/extra_subjects.dart';
import '../screen/student/add_extra_subject.dart';
import '../screen/student/student_profile.dart';

import '../models/subject.dart';

class PunctualApp extends StatelessWidget {
  const PunctualApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Punctual',
      debugShowCheckedModeBanner: false,
      theme: PunctualTheme.darkTheme,
      initialRoute: AppRoutes.login,

      routes: {
        // Authentication
        AppRoutes.login: (context) =>
            const LoginScreen(),

        // Admin
        AppRoutes.adminDashboard: (context) =>
           AdminDashboard(),

        AppRoutes.manageStudents: (context) =>
            const ManageStudents(),

        AppRoutes.manageSubjects: (context) =>
            const ManageSubjects(),

        AppRoutes.manageAttendance: (context) =>
            const ManageAttendance(),

        AppRoutes.adminProfile: (context) =>
            const AdminProfile(),

        // Student
        AppRoutes.studentDashboard: (context) =>
            const StudentDashboard(),

        AppRoutes.studentSubjects: (context) =>
            const SubjectsScreen(),

        AppRoutes.studentAttendance: (context) =>
            const AttendanceScreen(),

        AppRoutes.extraSubjects: (context) =>
            const ExtraSubjectsScreen(),

        AppRoutes.addExtraSubject: (context) =>
          AddExtraSubjectScreen(),

        AppRoutes.studentProfile: (context) =>
            const StudentProfile(),
      },

      onGenerateRoute: (settings) {
        if (settings.name ==
            AppRoutes.attendanceDetails) {
          final subject =
              settings.arguments as Subject;

          return MaterialPageRoute(
            builder: (context) =>
                AttendanceDetails(
              subject: subject,
            ),
          );
        }

        return null;
      },
    );
  }
}