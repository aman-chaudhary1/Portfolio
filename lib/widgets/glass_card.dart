import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

/// Glass-morphism styled card
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final double borderRadius;
  final Color? borderColor;
  final bool showGradientBorder;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.width,
    this.height,
    this.borderRadius = 20,
    this.borderColor,
    this.showGradientBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    if (showGradientBorder) {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          gradient: AppTheme.primaryGradient,
        ),
        child: Padding(
          padding: const EdgeInsets.all(1.5),
          child: Container(
            decoration: BoxDecoration(
              gradient: AppTheme.cardGradient,
              borderRadius: BorderRadius.circular(borderRadius - 1.5),
            ),
            padding: padding ?? const EdgeInsets.all(24),
            child: child,
          ),
        ),
      );
    }

    return Container(
      width: width,
      height: height,
      padding: padding ?? const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppTheme.cardGradient,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: borderColor ?? AppTheme.borderColor,
          width: 1,
        ),
      ),
      child: child,
    );
  }
}
