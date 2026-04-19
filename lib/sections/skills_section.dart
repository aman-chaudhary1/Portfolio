import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../core/theme/app_theme.dart';
import '../core/constants/app_constants.dart';
import '../widgets/section_header.dart';

class SkillsSection extends StatefulWidget {
  const SkillsSection({super.key});

  @override
  State<SkillsSection> createState() => _SkillsSectionState();
}

class _SkillsSectionState extends State<SkillsSection> {
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;

    return VisibilityDetector(
      key: const Key('skills-section'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.15 && !_visible) {
          setState(() => _visible = true);
        }
      },
      child: Container(
        color: AppTheme.surfaceColor,
        padding: EdgeInsets.symmetric(
            vertical: 100, horizontal: isMobile ? 24 : 80),
        child: Column(children: [
          if (_visible)
            const SectionHeader(
                    tag: 'What I Know',
                    title: 'Technical',
                    gradientWord: 'Skills')
                .animate()
                .fadeIn()
                .slideY(begin: 0.3),
          const SizedBox(height: 64),
          if (_visible) ...[
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isMobile ? 1 : 2,
                crossAxisSpacing: 24,
                mainAxisSpacing: 24,
                childAspectRatio: isMobile ? 1.1 : 1.0,
              ),
              itemCount: AppConstants.skillCategories.length,
              itemBuilder: (_, i) => _SkillCategoryCard(
                category: AppConstants.skillCategories[i],
                delay: i * 100,
              ),
            ),
            const SizedBox(height: 60),
            // Tech bubbles
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: AppConstants.techStack
                  .asMap()
                  .entries
                  .map((e) => _TechBubble(e.value,
                      delay: e.key * 50))
                  .toList(),
            ).animate().fadeIn(delay: 400.ms),
          ],
        ]),
      ),
    );
  }
}

// ── Skill Category Card ────────────────────────────────────────────────
class _SkillCategoryCard extends StatelessWidget {
  final Map<String, dynamic> category;
  final int delay;
  const _SkillCategoryCard({required this.category, required this.delay});

  @override
  Widget build(BuildContext context) {
    final skills = category['skills'] as List;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Text(category['icon'] as String,
              style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 12),
          Text(category['title'] as String, style: AppTheme.cardTitle),
        ]),
        const SizedBox(height: 20),
        ...skills.map((skill) {
          final level = skill['level'] as double;
          return Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(skill['name'] as String, style: AppTheme.bodySmall),
                  Text('${(level * 100).toInt()}%',
                      style: AppTheme.bodySmall
                          .copyWith(color: AppTheme.primaryCyan)),
                ],
              ),
              const SizedBox(height: 6),
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: level),
                duration:
                    Duration(milliseconds: 1000 + delay),
                curve: Curves.easeOutCubic,
                builder: (_, val, __) => Stack(children: [
                  Container(
                    height: 6,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppTheme.borderColor,
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: val,
                    child: Container(
                      height: 6,
                      decoration: BoxDecoration(
                        gradient: AppTheme.primaryGradient,
                        borderRadius: BorderRadius.circular(100),
                        boxShadow: [
                          BoxShadow(
                              color: AppTheme.primaryViolet
                                  .withOpacity(0.4),
                              blurRadius: 8)
                        ],
                      ),
                    ),
                  ),
                ]),
              ),
            ]),
          );
        }),
      ]),
    )
        .animate()
        .fadeIn(delay: Duration(milliseconds: delay))
        .slideY(begin: 0.2);
  }
}

// ── Tech Bubble ────────────────────────────────────────────────────────
class _TechBubble extends StatefulWidget {
  final String label;
  final int delay;
  const _TechBubble(this.label, {required this.delay});

  @override
  State<_TechBubble> createState() => _TechBubbleState();
}

class _TechBubbleState extends State<_TechBubble> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: 200.ms,
        padding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          gradient: _hovered ? AppTheme.primaryGradient : null,
          color: _hovered ? null : AppTheme.cardColor,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
              color: _hovered
                  ? Colors.transparent
                  : AppTheme.borderColor),
          boxShadow: _hovered
              ? [
                  BoxShadow(
                      color: AppTheme.primaryViolet.withOpacity(0.35),
                      blurRadius: 16)
                ]
              : [],
        ),
        child: Text(
          widget.label,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: _hovered ? Colors.white : AppTheme.textSecondary,
          ),
        ),
      )
          .animate()
          .fadeIn(delay: Duration(milliseconds: widget.delay))
          .scale(begin: const Offset(0.8, 0.8)),
    );
  }
}
