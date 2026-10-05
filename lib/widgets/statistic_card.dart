import 'package:flutter/material.dart';
import '../app/theme.dart';

class StatisticCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const StatisticCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: PunctualColors.deepAccent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: PunctualColors.softHighlight,
              size: 21,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}