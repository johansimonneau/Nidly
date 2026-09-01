import 'package:flutter/material.dart';

import '../models/candidature_status.dart';

class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.status});

  final CandidatureStatus status;

  /// Darkens a swatch for use as text on its own pale tint — keeps every
  /// status readable, including light hues like the sunshine yellow that
  /// would otherwise be too washed out at normal lightness.
  static Color _readableOn(Color swatch) {
    final hsl = HSLColor.fromColor(swatch);
    return hsl.withLightness((hsl.lightness * 0.6).clamp(0.0, 1.0)).toColor();
  }

  @override
  Widget build(BuildContext context) {
    final textColor = _readableOn(status.color);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: status.color.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.label,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }
}
