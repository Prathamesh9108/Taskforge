import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'interactive_card.dart';

/// Compact, clean KPI statistic card
class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color accentColor;
  final String? subtitle;
  final String? badgeText;
  final Color? badgeColor;
  final VoidCallback? onTap;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.accentColor,
    this.subtitle,
    this.badgeText,
    this.badgeColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InteractiveCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      borderRadius: AppTheme.radiusLg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.1),
                  borderRadius: AppTheme.radiusSm,
                ),
                child: Icon(
                  icon,
                  color: accentColor,
                  size: 16,
                ),
              ),
              if (badgeText != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                  decoration: BoxDecoration(
                    color: (badgeColor ?? accentColor).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    badgeText!,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: badgeColor ?? accentColor,
                      height: 1.1,
                    ),
                  ),
                )
              else if (onTap != null)
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 10,
                  color: AppTheme.textMuted,
                ),
            ],
          ),
          const SizedBox(height: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textPrimary,
                  letterSpacing: -0.4,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.textSecondary,
                        letterSpacing: -0.1,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(width: 4),
                    Text(
                      subtitle!,
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppTheme.textMuted,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
