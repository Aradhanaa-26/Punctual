class AttendanceRecord {
  final String id;
  final String studentId;
  final String subjectId;
  final DateTime date;
  final bool isPresent;

  const AttendanceRecord({
    required this.id,
    required this.studentId,
    required this.subjectId,
    required this.date,
    required this.isPresent,
  });
}