import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme/app_theme.dart';

class SectionHeader extends StatelessWidget {
  final String tag;
  final String title;
  final String? gradientWord;
  final String? subtitle;

  const SectionHeader({
    super.key,
    required this.tag,
    required this.title,
    this.gradientWord,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Badge tag
        Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            gradient: AppTheme.primaryGradient,
            borderRadius: BorderRadius.circular(100),
          ),
          child: Text(
            tag.toUpperCase(),
            style: AppTheme.label.copyWith(
                color: Colors.white, letterSpacing: 2.0),
          ),
        ),
        const SizedBox(height: 16),
        // Title
        Wrap(
          alignment: WrapAlignment.center,
          children: [
            Text(
              '$title ',
              style: AppTheme.sectionTitle,
              textAlign: TextAlign.center,
            ),
            if (gradientWord != null)
              ShaderMask(
                shaderCallback: (bounds) =>
                    AppTheme.primaryGradient.createShader(bounds),
                child: Text(
                  gradientWord!,
                  style: AppTheme.sectionTitle
                      .copyWith(color: Colors.white),
                ),
              ),
          ],
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 16),
          Text(
            subtitle!,
            style: AppTheme.body,
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}
