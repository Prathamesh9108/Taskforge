import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? message;
  final String? description;
  final String? actionLabel;
  final VoidCallback? onAction;
  final bool compact;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.message,
    this.description,
    this.actionLabel,
    this.onAction,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final displayText = message ?? description ?? '';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(compact ? 20 : 28),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: AppTheme.radiusLg,
        border: Border.all(color: AppTheme.cardBorder),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: compact ? 40 : 48,
            height: compact ? 40 : 48,
            decoration: BoxDecoration(
              color: AppTheme.primaryLight,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: compact ? 20 : 24,
              color: AppTheme.primary,
            ),
          ),
          SizedBox(height: compact ? 10 : 14),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: compact ? 14 : 15,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
              letterSpacing: -0.2,
            ),
          ),
          if (displayText.isNotEmpty) ...[
            const SizedBox(height: 4),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 320),
              child: Text(
                displayText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: compact ? 11.5 : 12.5,
                  color: AppTheme.textSecondary,
                  height: 1.35,
                ),
              ),
            ),
          ],
          if (actionLabel != null && onAction != null) ...[
            SizedBox(height: compact ? 12 : 16),
            ElevatedButton.icon(
              onPressed: onAction,
              icon: const Icon(Icons.add, size: 15),
              label: Text(actionLabel!),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size(0, 34),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: AppTheme.radiusSm),
                textStyle: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
