import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../models/subject.dart';
import '../../services/subject_service.dart';
import '../../widgets/app_button.dart';

class AddExtraSubjectScreen extends StatefulWidget {
  const AddExtraSubjectScreen({super.key});

  @override
  State<AddExtraSubjectScreen> createState() =>
      _AddExtraSubjectScreenState();
}

class _AddExtraSubjectScreenState
    extends State<AddExtraSubjectScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _codeController = TextEditingController();

  final SubjectService _subjectService =
      SubjectService();

  final String _studentId = 'student_001';

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Extra Subject'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            20,
            12,
            20,
            30,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                _buildHeader(),

                const SizedBox(height: 28),

                Text(
                  'Subject Information',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge,
                ),

                const SizedBox(height: 16),

                TextFormField(
                  controller: _nameController,
                  textCapitalization:
                      TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Subject Name',
                    hintText:
                        'e.g. Digital Marketing',
                    prefixIcon: Icon(
                      Icons.menu_book_outlined,
                    ),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return 'Enter the subject name';
                    }

                    if (value.trim().length < 2) {
                      return 'Subject name is too short';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 16),

                TextFormField(
                  controller: _codeController,
                  textCapitalization:
                      TextCapitalization.characters,
                  decoration: const InputDecoration(
                    labelText: 'Subject Code',
                    hintText:
                        'e.g. DM101',
                    prefixIcon: Icon(
                      Icons.tag_rounded,
                    ),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return 'Enter the subject code';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 28),

                _buildInfoCard(),

                const SizedBox(height: 28),

                AppButton(
                  label: 'Add Subject',
                  icon: Icons.add_rounded,
                  onPressed: _addSubject,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: PunctualColors.secondaryBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: PunctualColors.border,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: PunctualColors.dustyRose
                  .withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(17),
            ),
            child: const Icon(
              Icons.bookmark_add_outlined,
              color: PunctualColors.softRose,
              size: 28,
            ),
          ),

          const SizedBox(height: 14),

          Text(
            'Create a Personal Subject',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .titleLarge,
          ),

          const SizedBox(height: 7),

          Text(
            'Add a subject that you want to track separately from your official college subjects.',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: PunctualColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: PunctualColors.border,
        ),
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: PunctualColors.softHighlight,
            size: 22,
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              'Extra subjects are personal to you. They are not managed or verified by the college administrator.',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall,
            ),
          ),
        ],
      ),
    );
  }

  void _addSubject() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final name = _nameController.text.trim();
    final code = _codeController.text.trim();

    final subject = Subject(
      id: 'extra_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      code: code,
      department: 'Personal',
      semester: 0,
      isOfficial: false,
    );

    _subjectService.addExtraSubject(
      studentId: _studentId,
      subject: subject,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Extra subject added successfully.',
        ),
      ),
    );

    Navigator.pop(context);
  }
}