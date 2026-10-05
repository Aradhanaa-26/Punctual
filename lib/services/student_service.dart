import 'package:sqflite/sqflite.dart';
import '../models/student.dart';
import 'database_service.dart';

class StudentService {
  static final StudentService _instance = StudentService._internal();

  factory StudentService() {
    return _instance;
  }

  StudentService._internal();

  final List<Student> _students = [
    const Student(
      id: 'student_001',
      name: 'Aradhanaa',
      registerNumber: '23DCS001',
      department: 'Computer Science',
      semester: 4,
      username: 'student01',
    ),
    const Student(
      id: 'student_002',
      name: 'Student Two',
      registerNumber: '23DCS002',
      department: 'Computer Science',
      semester: 4,
      username: 'student02',
    ),
    const Student(
      id: 'student_003',
      name: 'Student Three',
      registerNumber: '23DCS003',
      department: 'Computer Science',
      semester: 4,
      username: 'student03',
    ),
  ];

  final DatabaseService _databaseService = DatabaseService.instance;

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    final db = await _databaseService.database;

    final existingStudents = await db.query('students');

    if (existingStudents.isEmpty) {
      for (final student in _students) {
        await db.insert(
          'students',
          _studentToMap(student),
        );
      }
    } else {
      _students
        ..clear()
        ..addAll(
          existingStudents.map(_studentFromMap),
        );
    }

    _initialized = true;
  }

  List<Student> getStudents() {
    return List.unmodifiable(_students);
  }

  Student? getStudentById(String id) {
    for (final student in _students) {
      if (student.id == id) {
        return student;
      }
    }

    return null;
  }

  void addStudent(Student student) {
    _students.add(student);

    _saveStudent(student);
  }

  void updateStudent(Student updatedStudent) {
    final index = _students.indexWhere(
      (student) => student.id == updatedStudent.id,
    );

    if (index != -1) {
      _students[index] = updatedStudent;

      _saveStudent(updatedStudent);
    }
  }

  void removeStudent(String studentId) {
    _students.removeWhere(
      (student) => student.id == studentId,
    );

    _deleteStudent(studentId);
  }

  Map<String, dynamic> _studentToMap(Student student) {
    return {
      'id': student.id,
      'name': student.name,
      'register_number': student.registerNumber,
      'department': student.department,
      'semester': student.semester,
      'username': student.username,
    };
  }

  Student _studentFromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'] as String,
      name: map['name'] as String,
      registerNumber: map['register_number'] as String,
      department: map['department'] as String,
      semester: map['semester'] as int,
      username: map['username'] as String,
    );
  }

  Future<void> _saveStudent(Student student) async {
    final db = await _databaseService.database;

    await db.insert(
      'students',
      _studentToMap(student),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> _deleteStudent(String studentId) async {
    final db = await _databaseService.database;

    await db.delete(
      'students',
      where: 'id = ?',
      whereArgs: [studentId],
    );
  }
}