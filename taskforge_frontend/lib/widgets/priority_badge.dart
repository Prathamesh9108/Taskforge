import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Compact priority indicator badge
class PriorityBadge extends StatelessWidget {
  final String priority;
  final bool showIcon;
  final double fontSize;

  const PriorityBadge({
    super.key,
    required this.priority,
    this.showIcon = true,
    this.fontSize = 11,
  });

  @override
  Widget build(BuildContext context) {
    final config = AppTheme.getPriorityConfig(priority);
    final displayLabel = _formatPriority(priority);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2.5),
      decoration: BoxDecoration(
        color: config.bg,
        borderRadius: AppTheme.radiusXs,
        border: Border.all(color: config.border, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon) ...[
            Icon(
              config.icon,
              size: 11,
              color: config.text,
            ),
            const SizedBox(width: 3.5),
          ],
          Text(
            displayLabel,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: config.text,
              letterSpacing: 0.1,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }

  String _formatPriority(String raw) {
    final p = raw.toUpperCase();
    if (p == 'HIGH') return 'High';
    if (p == 'LOW') return 'Low';
    return 'Medium';
  }
}
