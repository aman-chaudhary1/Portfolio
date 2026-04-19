import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../core/theme/app_theme.dart';
import '../widgets/section_header.dart';

class AboutSection extends StatefulWidget {
  const AboutSection({super.key});

  @override
  State<AboutSection> createState() => _AboutSectionState();
}

class _AboutSectionState extends State<AboutSection> {
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;

    return VisibilityDetector(
      key: const Key('about-section'),
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
                    tag: 'Who I Am', title: 'About', gradientWord: 'Me')
                .animate()
                .fadeIn(duration: 600.ms)
                .slideY(begin: 0.3),
          const SizedBox(height: 64),
          if (_visible)
            isMobile
                ? Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLeft(),
                      const SizedBox(height: 48),
                      _buildRight(),
                    ])
                : Row(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 4, child: _buildLeft()),
                      const SizedBox(width: 64),
                      Expanded(flex: 6, child: _buildRight()),
                    ]),
        ]),
      ),
    );
  }

  Widget _buildLeft() {
    return Column(children: [
      // Avatar with animated rings
      Stack(alignment: Alignment.center, children: [
        // Rings
        ...List.generate(3, (i) {
          return Container(
            width: 130.0 + i * 32,
            height: 130.0 + i * 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppTheme.primaryViolet.withOpacity(0.25 - i * 0.06),
                width: 1,
              ),
            ),
          )
              .animate(onPlay: (c) => c.repeat())
              .scale(
                  begin: const Offset(0.92, 0.92),
                  end: const Offset(1.05, 1.05),
                  duration: Duration(seconds: 2 + i))
              .then()
              .scale(
                  begin: const Offset(1.05, 1.05),
                  end: const Offset(0.92, 0.92),
                  duration: Duration(seconds: 2 + i));
        }),
        // Avatar
        Container(
          width: 110,
          height: 110,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: AppTheme.primaryGradient,
          ),
          child: Center(
            child: Text('AC',
                style: GoogleFonts.spaceGrotesk(
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    color: Colors.white)),
          ),
        ),
      ]).animate().fadeIn(delay: 200.ms).scale(begin: const Offset(0.8, 0.8)),
      const SizedBox(height: 28),
      // Info chips
      Wrap(
        spacing: 10,
        runSpacing: 10,
        alignment: WrapAlignment.center,
        children: [
          _InfoChip(Icons.location_on_outlined, 'Noida, India'),
          _InfoChip(Icons.business_outlined, 'Hastree Technologies'),
          _InfoChip(Icons.school_outlined, 'MCA – GNIOT'),
        ],
      ).animate().fadeIn(delay: 400.ms),
    ]);
  }

  Widget _buildRight() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        'Hi, I\'m Aman Chaudhary — a passionate Flutter Developer based in Noida, India. '
        'For over 2 years and 4 months, I\'ve been the sole Flutter developer at '
        'Hastree Technologies, owning the complete lifecycle of 5 production apps — '
        'from blank screen to live on the App Store and Play Store.',
        style: AppTheme.body,
      ).animate().fadeIn(delay: 200.ms),
      const SizedBox(height: 18),
      Text(
        'I don\'t just build UIs. I architect complete solutions — Flutter frontends, '
        'Node.js backends, MongoDB databases, Firebase integrations, authentication '
        'systems with OTP, push notifications, and full deployment pipelines. '
        'I\'m a one-person engineering team who gets things shipped.',
        style: AppTheme.body,
      ).animate().fadeIn(delay: 300.ms),
      const SizedBox(height: 36),
      _HighlightCard(
          icon: Icons.rocket_launch_outlined,
          title: 'Solo Delivery',
          desc: 'Built & shipped 5 complete apps from scratch — alone',
          delay: 400),
      _HighlightCard(
          icon: Icons.store_outlined,
          title: 'Store Published',
          desc: 'App Store + Play Store deployment expertise',
          delay: 520),
      _HighlightCard(
          icon: Icons.layers_outlined,
          title: 'Full Stack',
          desc: 'Flutter + Node.js + MongoDB complete solutions',
          delay: 640),
    ]);
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoChip(this.icon, this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 14, color: AppTheme.primaryCyan),
        const SizedBox(width: 6),
        Text(label,
            style: AppTheme.bodySmall
                .copyWith(color: AppTheme.textSecondary)),
      ]),
    );
  }
}

class _HighlightCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String desc;
  final int delay;
  const _HighlightCard(
      {required this.icon,
      required this.title,
      required this.desc,
      required this.delay});

  @override
  State<_HighlightCard> createState() => _HighlightCardState();
}

class _HighlightCardState extends State<_HighlightCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: 200.ms,
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: _hovered ? AppTheme.cardColor : AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _hovered
                ? AppTheme.primaryViolet.withOpacity(0.5)
                : AppTheme.borderColor,
          ),
        ),
        child: Row(children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(widget.icon, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              Text(widget.title,
                  style: AppTheme.cardTitle.copyWith(fontSize: 16)),
              const SizedBox(height: 2),
              Text(widget.desc, style: AppTheme.bodySmall),
            ]),
          ),
        ]),
      )
          .animate()
          .fadeIn(delay: Duration(milliseconds: widget.delay))
          .slideX(begin: 0.2),
    );
  }
}
