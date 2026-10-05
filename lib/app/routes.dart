class AppRoutes {
  // Authentication
  static const login = '/';

  // Admin
  static const adminDashboard = '/admin';
  static const manageStudents = '/admin/students';
  static const manageSubjects = '/admin/subjects';
  static const manageAttendance = '/admin/attendance';
  static const adminProfile = '/admin/profile';

  // Student
  static const studentDashboard = '/student';
  static const studentSubjects = '/student/subjects';
  static const studentAttendance = '/student/attendance';
  static const attendanceDetails =
      '/student/attendance-details';

  static const extraSubjects =
      '/student/extra-subjects';
  static const addExtraSubject =
      '/student/add-extra-subject';

  static const studentProfile =
      '/student/profile';
}