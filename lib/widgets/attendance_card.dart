import 'package:flutter/material.dart';
import '../app/theme.dart';

class AttendanceCard extends StatelessWidget {
  final String subjectName;
  final String subjectCode;
  final double percentage;
  final int present;
  final int total;

  const AttendanceCard({
    super.key,
    required this.subjectName,
    required this.subjectCode,
    required this.percentage,
    required this.present,
    required this.total,
  });

  Color _getStatusColor() {
    if (percentage >= 75) {
      return PunctualColors.healthy;
    }

    if (percentage >= 60) {
      return PunctualColors.warning;
    }

    return PunctualColors.critical;
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor();

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: PunctualColors.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: PunctualColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subjectName,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subjectCode,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall,
                    ),
                  ],
                ),
              ),
              Text(
                '${percentage.toStringAsFixed(0)}%',
                style: TextStyle(
                  color: statusColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: (percentage / 100).clamp(0.0, 1.0),
              minHeight: 7,
              backgroundColor: PunctualColors.progressTrack,
              valueColor: AlwaysStoppedAnimation<Color>(
                statusColor,
              ),
            ),
          ),

          const SizedBox(height: 10),

          Text(
            '$present of $total classes attended',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}