import 'package:flutter/material.dart';
import '../app/theme.dart';

class AttendanceProgressIndicator extends StatelessWidget {
  final double percentage;
  final double height;

  const AttendanceProgressIndicator({
    super.key,
    required this.percentage,
    this.height = 8,
  });

  Color _getColor() {
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
    final color = _getColor();

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: LinearProgressIndicator(
        value: (percentage / 100).clamp(0.0, 1.0),
        minHeight: height,
        backgroundColor: PunctualColors.progressTrack,
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }
}