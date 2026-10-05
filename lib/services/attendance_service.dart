import 'package:sqflite/sqflite.dart';

import '../models/attendance.dart';
import 'database_service.dart';

class AttendanceService {
  static final AttendanceService _instance =
      AttendanceService._internal();

  factory AttendanceService() {
    return _instance;
  }

  AttendanceService._internal();

  final List<AttendanceRecord> _records = [
    AttendanceRecord(
      id: 'att_001',
      studentId: 'student_001',
      subjectId: 'sub_001',
      date: DateTime(2026, 9, 1),
      isPresent: true,
    ),
    AttendanceRecord(
      id: 'att_002',
      studentId: 'student_001',
      subjectId: 'sub_001',
      date: DateTime(2026, 9, 3),
      isPresent: true,
    ),
    AttendanceRecord(
      id: 'att_003',
      studentId: 'student_001',
      subjectId: 'sub_001',
      date: DateTime(2026, 9, 5),
      isPresent: false,
    ),
    AttendanceRecord(
      id: 'att_004',
      studentId: 'student_001',
      subjectId: 'sub_001',
      date: DateTime(2026, 9, 8),
      isPresent: true,
    ),
    AttendanceRecord(
      id: 'att_005',
      studentId: 'student_001',
      subjectId: 'sub_002',
      date: DateTime(2026, 9, 2),
      isPresent: true,
    ),
    AttendanceRecord(
      id: 'att_006',
      studentId: 'student_001',
      subjectId: 'sub_002',
      date: DateTime(2026, 9, 4),
      isPresent: false,
    ),
    AttendanceRecord(
      id: 'att_007',
      studentId: 'student_001',
      subjectId: 'sub_002',
      date: DateTime(2026, 9, 6),
      isPresent: true,
    ),
    AttendanceRecord(
      id: 'att_008',
      studentId: 'student_001',
      subjectId: 'sub_003',
      date: DateTime(2026, 9, 1),
      isPresent: true,
    ),
    AttendanceRecord(
      id: 'att_009',
      studentId: 'student_001',
      subjectId: 'sub_003',
      date: DateTime(2026, 9, 4),
      isPresent: true,
    ),
    AttendanceRecord(
      id: 'att_010',
      studentId: 'student_001',
      subjectId: 'sub_003',
      date: DateTime(2026, 9, 7),
      isPresent: true,
    ),
    AttendanceRecord(
      id: 'att_011',
      studentId: 'student_001',
      subjectId: 'sub_004',
      date: DateTime(2026, 9, 2),
      isPresent: false,
    ),
    AttendanceRecord(
      id: 'att_012',
      studentId: 'student_001',
      subjectId: 'sub_004',
      date: DateTime(2026, 9, 5),
      isPresent: false,
    ),
    AttendanceRecord(
      id: 'att_013',
      studentId: 'student_001',
      subjectId: 'sub_004',
      date: DateTime(2026, 9, 9),
      isPresent: true,
    ),
  ];

  final DatabaseService _databaseService =
      DatabaseService.instance;

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    final db = await _databaseService.database;

    final existingRecords = await db.query('attendance');

    if (existingRecords.isEmpty) {
      for (final record in _records) {
        await db.insert(
          'attendance',
          _attendanceToMap(record),
        );
      }
    } else {
      _records
        ..clear()
        ..addAll(
          existingRecords.map(_attendanceFromMap),
        );
    }

    _initialized = true;
  }

  List<AttendanceRecord> getRecordsForStudent(
    String studentId,
  ) {
    return _records
        .where(
          (record) => record.studentId == studentId,
        )
        .toList();
  }

  List<AttendanceRecord> getRecordsForSubject({
    required String studentId,
    required String subjectId,
  }) {
    return _records
        .where(
          (record) =>
              record.studentId == studentId &&
              record.subjectId == subjectId,
        )
        .toList();
  }

  int getTotalClasses({
    required String studentId,
    required String subjectId,
  }) {
    return getRecordsForSubject(
      studentId: studentId,
      subjectId: subjectId,
    ).length;
  }

  int getPresentClasses({
    required String studentId,
    required String subjectId,
  }) {
    return getRecordsForSubject(
      studentId: studentId,
      subjectId: subjectId,
    ).where(
      (record) => record.isPresent,
    ).length;
  }

  int getAbsentClasses({
    required String studentId,
    required String subjectId,
  }) {
    return getRecordsForSubject(
      studentId: studentId,
      subjectId: subjectId,
    ).where(
      (record) => !record.isPresent,
    ).length;
  }

  double getAttendancePercentage({
    required String studentId,
    required String subjectId,
  }) {
    final total = getTotalClasses(
      studentId: studentId,
      subjectId: subjectId,
    );

    if (total == 0) {
      return 0;
    }

    final present = getPresentClasses(
      studentId: studentId,
      subjectId: subjectId,
    );

    return (present / total) * 100;
  }

  double getOverallAttendance(
    String studentId,
  ) {
    final records = getRecordsForStudent(studentId);

    if (records.isEmpty) {
      return 0;
    }

    final present = records.where(
      (record) => record.isPresent,
    ).length;

    return (present / records.length) * 100;
  }

  void addAttendance(
    AttendanceRecord record,
  ) {
    _records.add(record);
    _saveAttendance(record);
  }

  void updateAttendance(
    AttendanceRecord updatedRecord,
  ) {
    final index = _records.indexWhere(
      (record) => record.id == updatedRecord.id,
    );

    if (index != -1) {
      _records[index] = updatedRecord;
      _saveAttendance(updatedRecord);
    }
  }

  void removeAttendance(
    String attendanceId,
  ) {
    _records.removeWhere(
      (record) => record.id == attendanceId,
    );

    _deleteAttendance(attendanceId);
  }

  Map<String, dynamic> _attendanceToMap(
    AttendanceRecord record,
  ) {
    return {
      'id': record.id,
      'student_id': record.studentId,
      'subject_id': record.subjectId,
      'date': record.date.toIso8601String(),
      'is_present': record.isPresent ? 1 : 0,
    };
  }

  AttendanceRecord _attendanceFromMap(
    Map<String, dynamic> map,
  ) {
    return AttendanceRecord(
      id: map['id'] as String,
      studentId: map['student_id'] as String,
      subjectId: map['subject_id'] as String,
      date: DateTime.parse(map['date'] as String),
      isPresent: map['is_present'] == 1,
    );
  }

  Future<void> _saveAttendance(
    AttendanceRecord record,
  ) async {
    final db = await _databaseService.database;

    await db.insert(
      'attendance',
      _attendanceToMap(record),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> _deleteAttendance(
    String attendanceId,
  ) async {
    final db = await _databaseService.database;

    await db.delete(
      'attendance',
      where: 'id = ?',
      whereArgs: [attendanceId],
    );
  }
}