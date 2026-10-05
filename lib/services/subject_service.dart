import 'package:sqflite/sqflite.dart';

import '../models/subject.dart';
import 'database_service.dart';

class SubjectService {
  static final SubjectService _instance =
      SubjectService._internal();

  factory SubjectService() {
    return _instance;
  }

  SubjectService._internal();

  final List<Subject> _officialSubjects = [
    const Subject(
      id: 'sub_001',
      name: 'Data Structures',
      code: 'CS401',
      department: 'Computer Science',
      semester: 4,
      isOfficial: true,
    ),
    const Subject(
      id: 'sub_002',
      name: 'Database Management Systems',
      code: 'CS402',
      department: 'Computer Science',
      semester: 4,
      isOfficial: true,
    ),
    const Subject(
      id: 'sub_003',
      name: 'Operating Systems',
      code: 'CS403',
      department: 'Computer Science',
      semester: 4,
      isOfficial: true,
    ),
    const Subject(
      id: 'sub_004',
      name: 'Computer Networks',
      code: 'CS404',
      department: 'Computer Science',
      semester: 4,
      isOfficial: true,
    ),
  ];

  final Map<String, List<Subject>> _extraSubjects = {};

  final DatabaseService _databaseService =
      DatabaseService.instance;

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    final db = await _databaseService.database;

    final existingSubjects = await db.query('subjects');

    if (existingSubjects.isEmpty) {
      for (final subject in _officialSubjects) {
        await db.insert(
          'subjects',
          _subjectToMap(
            subject,
            studentId: null,
          ),
        );
      }
    } else {
      _officialSubjects
        ..clear()
        ..addAll(
          existingSubjects
              .where(
                (row) => row['is_official'] == 1,
              )
              .map(_subjectFromMap),
        );

      for (final row in existingSubjects) {
        if (row['is_official'] == 0) {
          final studentId = row['student_id'] as String?;

          if (studentId != null) {
            _extraSubjects.putIfAbsent(
              studentId,
              () => [],
            );

            _extraSubjects[studentId]!.add(
              _subjectFromMap(row),
            );
          }
        }
      }
    }

    _initialized = true;
  }

  List<Subject> getOfficialSubjects({
    String? department,
    int? semester,
  }) {
    return _officialSubjects.where((subject) {
      final departmentMatches =
          department == null ||
          subject.department == department;

      final semesterMatches =
          semester == null ||
          subject.semester == semester;

      return departmentMatches && semesterMatches;
    }).toList();
  }

  List<Subject> getExtraSubjects(
    String studentId,
  ) {
    return List.unmodifiable(
      _extraSubjects[studentId] ?? [],
    );
  }

  void addOfficialSubject(
    Subject subject,
  ) {
    _officialSubjects.add(subject);

    _saveSubject(
      subject,
      studentId: null,
    );
  }

  void removeOfficialSubject(
    String subjectId,
  ) {
    _officialSubjects.removeWhere(
      (subject) => subject.id == subjectId,
    );

    _deleteSubject(subjectId);
  }

  void addExtraSubject({
    required String studentId,
    required Subject subject,
  }) {
    _extraSubjects.putIfAbsent(
      studentId,
      () => [],
    );

    _extraSubjects[studentId]!.add(subject);

    _saveSubject(
      subject,
      studentId: studentId,
    );
  }

  void removeExtraSubject({
    required String studentId,
    required String subjectId,
  }) {
    _extraSubjects[studentId]?.removeWhere(
      (subject) => subject.id == subjectId,
    );

    _deleteSubject(subjectId);
  }

  Map<String, dynamic> _subjectToMap(
    Subject subject, {
    String? studentId,
  }) {
    return {
      'id': subject.id,
      'name': subject.name,
      'code': subject.code,
      'department': subject.department,
      'semester': subject.semester,
      'is_official': subject.isOfficial ? 1 : 0,
      'student_id': studentId,
    };
  }

  Subject _subjectFromMap(
    Map<String, dynamic> map,
  ) {
    return Subject(
      id: map['id'] as String,
      name: map['name'] as String,
      code: map['code'] as String,
      department: map['department'] as String,
      semester: map['semester'] as int,
      isOfficial: map['is_official'] == 1,
    );
  }

  Future<void> _saveSubject(
    Subject subject, {
    required String? studentId,
  }) async {
    final db = await _databaseService.database;

    await db.insert(
      'subjects',
      _subjectToMap(
        subject,
        studentId: studentId,
      ),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> _deleteSubject(
    String subjectId,
  ) async {
    final db = await _databaseService.database;

    await db.delete(
      'subjects',
      where: 'id = ?',
      whereArgs: [subjectId],
    );
  }
}