import 'package:flutter/material.dart';
import '../app/theme.dart';

class SubjectCard extends StatelessWidget {
  final String name;
  final String code;
  final bool isOfficial;
  final VoidCallback? onTap;

  const SubjectCard({
    super.key,
    required this.name,
    required this.code,
    required this.isOfficial,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: PunctualColors.card,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: PunctualColors.border,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: isOfficial
                    ? PunctualColors.deepAccent
                    : PunctualColors.dustyRose.withValues(
                        alpha: 0.15,
                      ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                isOfficial
                    ? Icons.menu_book_outlined
                    : Icons.bookmark_add_outlined,
                color: isOfficial
                    ? PunctualColors.softHighlight
                    : PunctualColors.softRose,
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    code,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall,
                  ),
                ],
              ),
            ),

            if (isOfficial)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: PunctualColors.deepAccent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Official',
                  style: TextStyle(
                    color: PunctualColors.softHighlight,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            else
              const Icon(
                Icons.chevron_right_rounded,
                color: PunctualColors.mutedText,
              ),
          ],
        ),
      ),
    );
  }
}