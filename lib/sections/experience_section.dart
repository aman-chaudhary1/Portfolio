import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../core/theme/app_theme.dart';
import '../core/constants/app_constants.dart';
import '../widgets/section_header.dart';

class ExperienceSection extends StatefulWidget {
  const ExperienceSection({super.key});

  @override
  State<ExperienceSection> createState() => _ExperienceSectionState();
}

class _ExperienceSectionState extends State<ExperienceSection> {
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;

    return VisibilityDetector(
      key: const Key('experience-section'),
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
                    tag: 'My Journey',
                    title: 'Work',
                    gradientWord: 'Experience')
                .animate()
                .fadeIn()
                .slideY(begin: 0.3),
          const SizedBox(height: 64),
          if (_visible)
            ...AppConstants.experience.asMap().entries.map((e) =>
                _TimelineItem(
                  exp: e.value,
                  index: e.key,
                  isLast:
                      e.key == AppConstants.experience.length - 1,
                )),
        ]),
      ),
    );
  }
}

class _TimelineItem extends StatefulWidget {
  final Map<String, dynamic> exp;
  final int index;
  final bool isLast;
  const _TimelineItem(
      {required this.exp, required this.index, required this.isLast});

  @override
  State<_TimelineItem> createState() => _TimelineItemState();
}

class _TimelineItemState extends State<_TimelineItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final exp = widget.exp;
    final isCurrent = exp['isCurrent'] as bool;

    return IntrinsicHeight(
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Dot + line
        SizedBox(
          width: 40,
          child: Column(children: [
            Container(
              width: 16,
              height: 16,
              margin: const EdgeInsets.only(top: 6),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: isCurrent ? AppTheme.primaryGradient : null,
                color: isCurrent ? null : AppTheme.borderColor,
                border: Border.all(
                  color: isCurrent
                      ? AppTheme.primaryViolet
                      : AppTheme.borderColor,
                  width: 2,
                ),
                boxShadow: isCurrent
                    ? [
                        BoxShadow(
                            color: AppTheme.primaryViolet.withOpacity(0.5),
                            blurRadius: 10)
                      ]
                    : [],
              ),
            )
                .animate(onPlay: isCurrent ? (c) => c.repeat() : null)
                .then(delay: 500.ms)
                .scale(
                    begin: const Offset(1, 1),
                    end: const Offset(1.35, 1.35),
                    duration: 1000.ms)
                .then()
                .scale(
                    begin: const Offset(1.35, 1.35),
                    end: const Offset(1, 1),
                    duration: 1000.ms),
            if (!widget.isLast)
              Expanded(
                child: Container(
                  width: 2,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppTheme.primaryViolet.withOpacity(0.5),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
          ]),
        ),
      const SizedBox(width: 24),
      // Card
      Expanded(
        child: MouseRegion(
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() => _hovered = false),
          child: AnimatedContainer(
            duration: 200.ms,
            margin: const EdgeInsets.only(bottom: 32),
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: _hovered ? AppTheme.cardColor : AppTheme.surfaceColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _hovered
                    ? AppTheme.primaryViolet.withOpacity(0.4)
                    : AppTheme.borderColor,
              ),
              boxShadow: _hovered
                  ? [
                      BoxShadow(
                          color: AppTheme.primaryViolet.withOpacity(0.1),
                          blurRadius: 20)
                    ]
                  : [],
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              // Header
              Wrap(spacing: 12, runSpacing: 12,
                  alignment: WrapAlignment.spaceBetween,
                  children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(exp['role'] as String,
                      style: AppTheme.cardTitle),
                  const SizedBox(height: 4),
                  Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.business_outlined,
                        size: 14, color: AppTheme.primaryCyan),
                    const SizedBox(width: 6),
                    Text(exp['company'] as String,
                        style: AppTheme.body
                            .copyWith(color: AppTheme.primaryCyan)),
                  ]),
                ]),
                Column(crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: isCurrent
                          ? AppTheme.primaryViolet.withOpacity(0.15)
                          : AppTheme.borderColor,
                      borderRadius: BorderRadius.circular(100),
                      border: isCurrent
                          ? Border.all(
                              color: AppTheme.primaryViolet
                                  .withOpacity(0.3))
                          : null,
                    ),
                    child: Text(
                      isCurrent ? 'Current' : exp['type'] as String,
                      style: AppTheme.bodySmall.copyWith(
                        color: isCurrent
                            ? AppTheme.primaryViolet
                            : AppTheme.textMuted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(exp['period'] as String,
                      style: AppTheme.bodySmall),
                ]),
              ]),
              const SizedBox(height: 8),
              Row(children: [
                Icon(Icons.location_on_outlined,
                    size: 12, color: AppTheme.textMuted),
                const SizedBox(width: 4),
                Text(exp['location'] as String,
                    style: AppTheme.bodySmall),
              ]),
              const SizedBox(height: 18),
              // Bullet points
              ...(exp['points'] as List<String>).map((pt) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.only(top: 6, right: 10),
                    decoration: const BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Expanded(
                      child: Text(pt,
                          style: AppTheme.body.copyWith(fontSize: 14))),
                ]),
              )),
              const SizedBox(height: 14),
              // Tags
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: (exp['tags'] as List<String>)
                    .map((tag) => Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryViolet.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(
                                color: AppTheme.primaryViolet
                                    .withOpacity(0.2)),
                          ),
                          child: Text(tag,
                              style: AppTheme.bodySmall.copyWith(
                                  color: AppTheme.primaryCyan,
                                  fontWeight: FontWeight.w500)),
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
      )
  ]),
)
    .animate()
    .fadeIn(delay: Duration(milliseconds: widget.index * 200))
    .slideX(begin: -0.2);
  }
}
