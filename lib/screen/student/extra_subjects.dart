import 'package:flutter/material.dart';

import '../../app/routes.dart';
import '../../app/theme.dart';
import '../../models/subject.dart';
import '../../services/subject_service.dart';
import '../../widgets/subject_card.dart';

class ExtraSubjectsScreen extends StatefulWidget {
  const ExtraSubjectsScreen({super.key});

  @override
  State<ExtraSubjectsScreen> createState() =>
      _ExtraSubjectsScreenState();
}

class _ExtraSubjectsScreenState
    extends State<ExtraSubjectsScreen> {
  final SubjectService _subjectService =
      SubjectService();

  final String _studentId = 'student_001';

  @override
  Widget build(BuildContext context) {
    final extraSubjects =
        _subjectService.getExtraSubjects(_studentId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Extra Subjects'),
      ),
      body: SafeArea(
        child: extraSubjects.isEmpty
            ? _buildEmptyState()
            : ListView(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  12,
                  20,
                  28,
                ),
                children: [
                  _buildIntro(),

                  const SizedBox(height: 24),

                  Text(
                    'Your Extra Subjects',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge,
                  ),

                  const SizedBox(height: 14),

                  ...extraSubjects.map(
                    (subject) => Padding(
                      padding: const EdgeInsets.only(
                        bottom: 12,
                      ),
                      child: _buildSubjectTile(
                        subject,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  _buildAddButton(),
                ],
              ),
      ),
      floatingActionButton: extraSubjects.isNotEmpty
          ? FloatingActionButton(
              onPressed: _openAddSubject,
              backgroundColor:
                  PunctualColors.primary,
              foregroundColor:
                  PunctualColors.white,
              child: const Icon(
                Icons.add_rounded,
              ),
            )
          : null,
    );
  }

  Widget _buildIntro() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: PunctualColors.secondaryBackground,
        borderRadius: BorderRadius.circular(20),
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
              color: PunctualColors.dustyRose
                  .withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.bookmark_add_outlined,
              color: PunctualColors.softRose,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Personal Subjects',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium,
                ),
                const SizedBox(height: 5),
                Text(
                  'Add subjects that are not part of your official college list.',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectTile(Subject subject) {
    return Dismissible(
      key: ValueKey(subject.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) =>
          _confirmDelete(subject),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(
          right: 20,
        ),
        decoration: BoxDecoration(
          color: PunctualColors.critical,
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Icon(
          Icons.delete_outline_rounded,
          color: PunctualColors.white,
        ),
      ),
      child: SubjectCard(
        name: subject.name,
        code: subject.code,
        isOfficial: false,
        onTap: () {
          Navigator.pushNamed(
            context,
            AppRoutes.attendanceDetails,
            arguments: subject,
          );
        },
      ),
    );
  }

  Widget _buildAddButton() {
    return OutlinedButton.icon(
      onPressed: _openAddSubject,
      icon: const Icon(
        Icons.add_rounded,
      ),
      label: const Text(
        'Add Extra Subject',
      ),
      style: OutlinedButton.styleFrom(
        foregroundColor:
            PunctualColors.softHighlight,
        minimumSize: const Size(
          double.infinity,
          52,
        ),
        side: const BorderSide(
          color: PunctualColors.border,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        20,
        30,
        20,
        28,
      ),
      children: [
        _buildIntro(),

        const SizedBox(height: 60),

        const Icon(
          Icons.library_add_outlined,
          size: 58,
          color: PunctualColors.mutedText,
        ),

        const SizedBox(height: 18),

        Text(
          'No Extra Subjects',
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .titleLarge,
        ),

        const SizedBox(height: 8),

        Text(
          'Add a personal subject to start tracking its attendance.',
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .bodyMedium,
        ),

        const SizedBox(height: 24),

        _buildAddButton(),
      ],
    );
  }

  void _openAddSubject() {
    Navigator.pushNamed(
      context,
      AppRoutes.addExtraSubject,
    );
  }

  Future<bool> _confirmDelete(
    Subject subject,
  ) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: PunctualColors.card,
          title: const Text(
            'Delete Subject?',
          ),
          content: Text(
            'Remove "${subject.name}" from your extra subjects?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  false,
                );
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  true,
                );
              },
              child: const Text(
                'Delete',
                style: TextStyle(
                  color: PunctualColors.critical,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (result == true) {
      _subjectService.removeExtraSubject(
        studentId: _studentId,
        subjectId: subject.id,
      );

      if (mounted) {
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Extra subject removed.',
            ),
          ),
        );
      }

      return true;
    }

    return false;
  }
}