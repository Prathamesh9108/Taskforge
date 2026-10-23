import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Compact, Linear/Asana inspired status badge
class StatusBadge extends StatelessWidget {
  final String status;
  final bool showDot;
  final double fontSize;

  const StatusBadge({
    super.key,
    required this.status,
    this.showDot = true,
    this.fontSize = 11,
  });

  @override
  Widget build(BuildContext context) {
    final config = AppTheme.getStatusConfig(status);
    final displayLabel = _formatStatusLabel(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: config.bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: config.border, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showDot) ...[
            Container(
              width: 5.5,
              height: 5.5,
              decoration: BoxDecoration(
                color: config.text,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4.5),
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

  String _formatStatusLabel(String raw) {
    final s = raw.toUpperCase().replaceAll(' ', '_');
    if (s == 'DONE' || s == 'COMPLETED') return 'Done';
    if (s == 'IN_PROGRESS') return 'In Progress';
    if (s == 'TODO' || s == 'TO_DO') return 'To Do';
    if (s == 'PLANNING') return 'Planning';
    if (s == 'ACTIVE') return 'Active';
    if (s == 'ON_HOLD') return 'On Hold';
    return raw;
  }
}
