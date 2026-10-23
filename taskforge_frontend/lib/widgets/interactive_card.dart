import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// A platform-adaptive card widget that provides:
/// - Subtle hover border and elevation transitions on Desktop/Web (150ms).
/// - Material InkWell tap and ripple feedback on Android/iOS.
/// - Minimalist 1px border with compact 10-14px border radius.
class InteractiveCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final Border? customBorder;

  const InteractiveCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(AppTheme.space16),
    this.borderRadius,
    this.backgroundColor,
    this.customBorder,
  });

  @override
  State<InteractiveCard> createState() => _InteractiveCardState();
}

class _InteractiveCardState extends State<InteractiveCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final radius = widget.borderRadius ?? AppTheme.radiusLg;
    final bgColor = widget.backgroundColor ?? AppTheme.surface;

    return MouseRegion(
      cursor: widget.onTap != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: radius,
          border: widget.customBorder ??
              Border.all(
                color: _isHovered && widget.onTap != null
                    ? AppTheme.cardBorderHover
                    : AppTheme.cardBorder,
                width: 1,
              ),
          boxShadow: _isHovered && widget.onTap != null
              ? AppTheme.hoverShadow
              : AppTheme.cardShadow,
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: radius,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: radius,
            splashColor: AppTheme.primaryLight.withValues(alpha: 0.6),
            highlightColor: AppTheme.surfaceSubtle.withValues(alpha: 0.6),
            child: Padding(
              padding: widget.padding,
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}
