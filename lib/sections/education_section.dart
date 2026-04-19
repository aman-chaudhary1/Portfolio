import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../core/theme/app_theme.dart';
import '../core/constants/app_constants.dart';
import '../widgets/section_header.dart';

class EducationSection extends StatefulWidget {
  const EducationSection({super.key});

  @override
  State<EducationSection> createState() => _EducationSectionState();
}

class _EducationSectionState extends State<EducationSection> {
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;

    return VisibilityDetector(
      key: const Key('education-section'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.15 && !_visible) {
          setState(() => _visible = true);
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: 100, horizontal: isMobile ? 24 : 80),
        child: Column(children: [
          if (_visible)
            const SectionHeader(
                    tag: 'My Background',
                    title: 'Education &',
                    gradientWord: 'Achievements')
                .animate()
                .fadeIn()
                .slideY(begin: 0.3),
          const SizedBox(height: 64),
          if (_visible)
            isMobile
                ? Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildEdu(),
                      const SizedBox(height: 48),
                      _buildAchievements(),
                    ])
                : Row(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildEdu()),
                      const SizedBox(width: 40),
                      Expanded(child: _buildAchievements()),
                    ]),
        ]),
      ),
    );
  }

  Widget _buildEdu() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        ShaderMask(
          shaderCallback: (b) => AppTheme.primaryGradient.createShader(b),
          child: const Icon(Icons.school_outlined,
              color: Colors.white, size: 24),
        ),
        const SizedBox(width: 12),
        Text('Education', style: AppTheme.cardTitle),
      ]).animate().fadeIn(delay: 100.ms),
      const SizedBox(height: 24),
      ...AppConstants.education.asMap().entries.map(
          (e) => _EduCard(edu: e.value, delay: (e.key + 1) * 150)),
    ]);
  }

  Widget _buildAchievements() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        ShaderMask(
          shaderCallback: (b) => AppTheme.primaryGradient.createShader(b),
          child: const Icon(Icons.emoji_events_outlined,
              color: Colors.white, size: 24),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Text('Certifications & Achievements',
              style: AppTheme.cardTitle),
        ),
      ]).animate().fadeIn(delay: 100.ms),
      const SizedBox(height: 24),
      ...AppConstants.achievements.asMap().entries.map(
          (e) => _AchievCard(ach: e.value, delay: (e.key + 1) * 80)),
    ]);
  }
}

// ── Education Card ─────────────────────────────────────────────────────
class _EduCard extends StatefulWidget {
  final Map<String, String> edu;
  final int delay;
  const _EduCard({required this.edu, required this.delay});

  @override
  State<_EduCard> createState() => _EduCardState();
}

class _EduCardState extends State<_EduCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: 200.ms,
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: _hovered ? AppTheme.cardColor : AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _hovered
                ? AppTheme.primaryViolet.withOpacity(0.4)
                : AppTheme.borderColor,
          ),
        ),
        child: Row(children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.school_outlined,
                color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              Text(widget.edu['degree']!,
                  style: AppTheme.cardTitle.copyWith(fontSize: 14)),
              const SizedBox(height: 4),
              Text(widget.edu['institution']!, style: AppTheme.bodySmall),
              const SizedBox(height: 8),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                Row(children: [
                  Icon(Icons.calendar_today_outlined,
                      size: 12, color: AppTheme.textMuted),
                  const SizedBox(width: 4),
                  Text(widget.edu['period']!, style: AppTheme.bodySmall),
                ]),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryCyan.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                        color: AppTheme.primaryCyan.withOpacity(0.3)),
                  ),
                  child: Text(widget.edu['score']!,
                      style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.primaryCyan)),
                ),
              ]),
            ]),
          ),
        ]),
      ),
    )
        .animate()
        .fadeIn(delay: Duration(milliseconds: widget.delay))
        .slideX(begin: -0.2);
  }
}

// ── Achievement Card ───────────────────────────────────────────────────
class _AchievCard extends StatefulWidget {
  final Map<String, dynamic> ach;
  final int delay;
  const _AchievCard({required this.ach, required this.delay});

  @override
  State<_AchievCard> createState() => _AchievCardState();
}

class _AchievCardState extends State<_AchievCard> {
  bool _hovered = false;

  Color get _tierColor {
    switch (widget.ach['tier'] as String) {
      case 'gold':
        return const Color(0xFFF59E0B);
      case 'silver':
        return const Color(0xFF94A3B8);
      case 'bronze':
        return const Color(0xFFB45309);
      default:
        return AppTheme.primaryCyan;
    }
  }

  IconData get _icon => widget.ach['type'] == 'hackathon'
      ? Icons.emoji_events_rounded
      : Icons.verified_outlined;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: 200.ms,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _hovered ? AppTheme.cardColor : AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _hovered
                ? _tierColor.withOpacity(0.4)
                : AppTheme.borderColor,
          ),
        ),
        child: Row(children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _tierColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: _tierColor.withOpacity(0.3)),
            ),
            child: Icon(_icon, color: _tierColor, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              Text(widget.ach['title'] as String,
                  style: AppTheme.body.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                      fontSize: 14)),
              Text(widget.ach['org'] as String,
                  style: AppTheme.bodySmall),
            ]),
          ),
        ]),
      ),
    )
        .animate()
        .fadeIn(delay: Duration(milliseconds: widget.delay))
        .slideX(begin: 0.2);
  }
}
