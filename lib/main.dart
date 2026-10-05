import 'package:flutter/material.dart';

import 'app/app.dart';
import 'services/student_service.dart';
import 'services/subject_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await StudentService().initialize();
  await SubjectService().initialize();

  runApp(const PunctualApp());
}