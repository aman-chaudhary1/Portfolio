import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../core/theme/app_theme.dart';
import '../core/constants/app_constants.dart';
import '../widgets/section_header.dart';

class ProjectsSection extends StatefulWidget {
  const ProjectsSection({super.key});

  @override
  State<ProjectsSection> createState() => _ProjectsSectionState();
}

class _ProjectsSectionState extends State<ProjectsSection> {
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;

    return VisibilityDetector(
      key: const Key('projects-section'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.1 && !_visible) {
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
                    tag: "What I've Built",
                    title: 'Key',
                    gradientWord: 'Projects')
                .animate()
                .fadeIn()
                .slideY(begin: 0.3),
          const SizedBox(height: 64),
          if (_visible) ...[
            // ── Featured Gravito Card ─────────────────────────────────
            _GravitoFeaturedCard(project: AppConstants.projects[0]),
            const SizedBox(height: 28),
            // ── Other 3 projects ──────────────────────────────────────
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isMobile ? 1 : 3,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: isMobile ? 0.85 : 0.62,
              ),
              itemCount: AppConstants.projects.length - 1,
              itemBuilder: (_, i) => _ProjectCard(
                project: AppConstants.projects[i + 1],
                delay: (i + 2) * 100,
              ),
            ),
          ],
        ]),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════
// Gravito Featured Card — with screenshots carousel + action buttons
// ═══════════════════════════════════════════════════════════════════════
class _GravitoFeaturedCard extends StatefulWidget {
  final Map<String, dynamic> project;
  const _GravitoFeaturedCard({required this.project});

  @override
  State<_GravitoFeaturedCard> createState() => _GravitoFeaturedCardState();
}

class _GravitoFeaturedCardState extends State<_GravitoFeaturedCard> {
  int _selectedScreen = 0;
  bool _hovered = false;

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.project;
    final isMobile = MediaQuery.of(context).size.width < 900;
    final screenshots = p['screenshots'] as List<String>;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: 250.ms,
        decoration: BoxDecoration(
          color: AppTheme.cardColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: _hovered
                ? const Color(0xFF22C55E).withOpacity(0.6)
                : AppTheme.borderColor,
            width: _hovered ? 1.5 : 1,
          ),
          boxShadow: _hovered
              ? [
                  BoxShadow(
                      color: const Color(0xFF22C55E).withOpacity(0.12),
                      blurRadius: 40)
                ]
              : [],
        ),
        child: isMobile
            ? _buildMobileLayout(p, screenshots)
            : _buildDesktopLayout(p, screenshots),
      ),
    ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.15);
  }

  // ── Desktop layout ─────────────────────────────────────────────────
  Widget _buildDesktopLayout(
      Map<String, dynamic> p, List<String> screenshots) {
    return Row(children: [
      // Left: phone gallery
      Padding(
        padding: const EdgeInsets.all(32),
        child: _ScreenshotGallery(
          screenshots: screenshots,
          selectedIndex: _selectedScreen,
          onSelect: (i) => setState(() => _selectedScreen = i),
        ),
      ),
      // Right: details
      Expanded(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 32, 32, 32),
          child: _GravitoDetails(
            project: p,
            onPlayStore: () => _launch(p['playStoreUrl'] as String),
            onInstagram: () => _launch(p['instagramUrl'] as String),
          ),
        ),
      ),
    ]);
  }

  // ── Mobile layout ──────────────────────────────────────────────────
  Widget _buildMobileLayout(
      Map<String, dynamic> p, List<String> screenshots) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(children: [
        _ScreenshotGallery(
          screenshots: screenshots,
          selectedIndex: _selectedScreen,
          onSelect: (i) => setState(() => _selectedScreen = i),
          compact: true,
        ),
        const SizedBox(height: 28),
        _GravitoDetails(
          project: p,
          onPlayStore: () => _launch(p['playStoreUrl'] as String),
          onInstagram: () => _launch(p['instagramUrl'] as String),
        ),
      ]),
    );
  }
}

// ── Screenshot Gallery ─────────────────────────────────────────────────
class _ScreenshotGallery extends StatelessWidget {
  final List<String> screenshots;
  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final bool compact;

  const _ScreenshotGallery({
    required this.screenshots,
    required this.selectedIndex,
    required this.onSelect,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      // Main preview
      AnimatedSwitcher(
        duration: 300.ms,
        transitionBuilder: (child, anim) =>
            FadeTransition(opacity: anim, child: child),
        child: _PhoneFrame(
          key: ValueKey(selectedIndex),
          imagePath: screenshots[selectedIndex],
          isDesktopScreen: selectedIndex >= 3,
          compact: compact,
        ),
      ),
      const SizedBox(height: 16),
      // Thumbnail row
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: screenshots.asMap().entries.map((e) {
          final isSelected = e.key == selectedIndex;
          return GestureDetector(
            onTap: () => onSelect(e.key),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: AnimatedContainer(
                duration: 200.ms,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: isSelected ? 32 : 24,
                height: isSelected ? 48 : 36,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF22C55E)
                        : AppTheme.borderColor,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.asset(
                    e.value,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: AppTheme.cardColor,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
      const SizedBox(height: 8),
      // Labels row
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('📱 User App', style: AppTheme.bodySmall.copyWith(fontSize: 11)),
          const SizedBox(width: 12),
          Container(
              width: 1, height: 10, color: AppTheme.borderColor),
          const SizedBox(width: 12),
          Text('🖥 Admin Panel', style: AppTheme.bodySmall.copyWith(fontSize: 11)),
        ],
      ),
    ]);
  }
}

// ── Phone Frame ────────────────────────────────────────────────────────
class _PhoneFrame extends StatelessWidget {
  final String imagePath;
  final bool isDesktopScreen;
  final bool compact;

  const _PhoneFrame({
    super.key,
    required this.imagePath,
    required this.isDesktopScreen,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final double w = compact ? 180.0 : 220.0;
    final double h = compact ? 320.0 : 400.0;
    final double adminW = compact ? 300.0 : 380.0;
    final double adminH = compact ? 180.0 : 220.0;

    if (isDesktopScreen) {
      // Admin panel — landscape / wide frame
      return Container(
        width: adminW,
        height: adminH,
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A28),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF3A3A4A), width: 2),
          boxShadow: [
            BoxShadow(
                color: AppTheme.primaryViolet.withOpacity(0.2),
                blurRadius: 30)
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Column(children: [
            // Browser chrome strip
            Container(
              height: 28,
              color: const Color(0xFF2A2A3A),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(children: [
                Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                        color: Color(0xFFFF5F57),
                        shape: BoxShape.circle)),
                const SizedBox(width: 4),
                Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                        color: Color(0xFFFFBD2E),
                        shape: BoxShape.circle)),
                const SizedBox(width: 4),
                Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                        color: Color(0xFF28C840),
                        shape: BoxShape.circle)),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    height: 16,
                    decoration: BoxDecoration(
                      color: const Color(0xFF3A3A4A),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Text('gravito-admin.vercel.app',
                        style: AppTheme.bodySmall.copyWith(fontSize: 8),
                        overflow: TextOverflow.ellipsis),
                  ),
                ),
              ]),
            ),
            // Screenshot content
            Expanded(
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (_, __, ___) => Container(
                  color: AppTheme.cardColor,
                  child: const Center(
                    child: Icon(Icons.dashboard_rounded,
                        color: AppTheme.textMuted, size: 40),
                  ),
                ),
              ),
            ),
          ]),
        ),
      );
    }

    // Mobile phone frame
    return Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A28),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: const Color(0xFF3A3A4A), width: 3),
        boxShadow: [
          BoxShadow(
              color: const Color(0xFF22C55E).withOpacity(0.2),
              blurRadius: 40)
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(29),
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            color: AppTheme.cardColor,
            child:
                const Center(child: Icon(Icons.phone_android_rounded,
                    color: AppTheme.textMuted, size: 40)),
          ),
        ),
      ),
    );
  }
}

// ── Gravito Details Panel ──────────────────────────────────────────────
class _GravitoDetails extends StatelessWidget {
  final Map<String, dynamic> project;
  final VoidCallback onPlayStore;
  final VoidCallback onInstagram;

  const _GravitoDetails({
    required this.project,
    required this.onPlayStore,
    required this.onInstagram,
  });

  @override
  Widget build(BuildContext context) {
    final p = project;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(children: [
          Text(p['icon'] as String,
              style: const TextStyle(fontSize: 36)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              Row(children: [
                Text(p['name'] as String,
                    style: AppTheme.cardTitle
                        .copyWith(fontSize: 26)),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF22C55E).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                        color: const Color(0xFF22C55E)
                            .withOpacity(0.4)),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min,
                      children: [
                    Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                            color: Color(0xFF22C55E),
                            shape: BoxShape.circle)),
                    const SizedBox(width: 5),
                    Text('Live on Play Store',
                        style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF22C55E))),
                  ]),
                ),
              ]),
              Text(p['subtitle'] as String,
                  style: AppTheme.body
                      .copyWith(color: AppTheme.primaryCyan)),
            ]),
          ),
        ]),
        const SizedBox(height: 14),

        // Startup story box
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF22C55E).withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: const Color(0xFF22C55E).withOpacity(0.15)),
          ),
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            Text('🌾',
                style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text('Startup Mission',
                    style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF22C55E))),
                const SizedBox(height: 4),
                Text(
                    'Built this complete ecosystem as a solo founder. '
                    '"Fresh from Gaon to Ghar" — delivering local groceries to rural India. '
                    'Currently live and serving real customers.',
                    style: AppTheme.body.copyWith(fontSize: 13)),
              ]),
            ),
          ]),
        ),
        const SizedBox(height: 16),

        Text(p['desc'] as String,
            style: AppTheme.body.copyWith(fontSize: 14)),
        const SizedBox(height: 18),

        // Bullet points
        ...(p['points'] as List<String>).map((pt) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Container(
                    width: 6,
                    height: 6,
                    margin:
                        const EdgeInsets.only(top: 6, right: 10),
                    decoration: const BoxDecoration(
                        color: Color(0xFF22C55E),
                        shape: BoxShape.circle)),
                Expanded(
                    child: Text(pt,
                        style:
                            AppTheme.body.copyWith(fontSize: 14))),
              ]),
            )),
        const SizedBox(height: 18),

        // Tech tags
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: (p['tech'] as List<String>)
              .map((t) => _TechTag(t))
              .toList(),
        ),
        const SizedBox(height: 22),

        // Action buttons
        Wrap(spacing: 12, runSpacing: 12, children: [
          _ActionBtn(
            label: '🛒  Download on Play Store',
            isPrimary: true,
            color: const Color(0xFF22C55E),
            onTap: onPlayStore,
          ),
          _ActionBtn(
            label: '📸  Follow on Instagram',
            isPrimary: false,
            color: const Color(0xFFE1306C),
            onTap: onInstagram,
          ),
        ]),
      ],
    );
  }
}

// ── Action Button ──────────────────────────────────────────────────────
class _ActionBtn extends StatefulWidget {
  final String label;
  final bool isPrimary;
  final Color color;
  final VoidCallback onTap;
  const _ActionBtn(
      {required this.label,
      required this.isPrimary,
      required this.color,
      required this.onTap});

  @override
  State<_ActionBtn> createState() => _ActionBtnState();
}

class _ActionBtnState extends State<_ActionBtn> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: 200.ms,
          padding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: widget.isPrimary
                ? (_hovered
                    ? widget.color
                    : widget.color.withOpacity(0.85))
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color:
                  widget.isPrimary ? widget.color : widget.color,
              width: 1.5,
            ),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                        color: widget.color.withOpacity(0.35),
                        blurRadius: 20)
                  ]
                : [],
          ),
          child: Text(
            widget.label,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: widget.isPrimary ? Colors.white : widget.color,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Project Card (non-featured) ────────────────────────────────────────
class _ProjectCard extends StatefulWidget {
  final Map<String, dynamic> project;
  final int delay;
  const _ProjectCard({required this.project, required this.delay});

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final p = widget.project;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: 200.ms,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppTheme.cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _hovered
                ? AppTheme.primaryCyan.withOpacity(0.4)
                : AppTheme.borderColor,
          ),
          boxShadow: _hovered
              ? [
                  BoxShadow(
                      color: AppTheme.primaryCyan.withOpacity(0.1),
                      blurRadius: 20)
                ]
              : [],
        ),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
            Text(p['icon'] as String,
                style: const TextStyle(fontSize: 32)),
            AnimatedRotation(
              turns: _hovered ? 0.05 : 0,
              duration: 200.ms,
              child: const Icon(Icons.arrow_outward_rounded,
                  color: AppTheme.textMuted, size: 18),
            ),
          ]),
          const SizedBox(height: 14),
          Text(p['name'] as String, style: AppTheme.cardTitle),
          const SizedBox(height: 4),
          Text(p['subtitle'] as String,
              style:
                  AppTheme.bodySmall.copyWith(color: AppTheme.primaryCyan)),
          const SizedBox(height: 12),
          Text(p['desc'] as String,
              style: AppTheme.body.copyWith(fontSize: 13),
              maxLines: 4,
              overflow: TextOverflow.ellipsis),
          const SizedBox(height: 20),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: (p['tech'] as List<String>)
                .take(3)
                .map((t) => _TechTag(t))
                .toList(),
          ),
        ]),
      ),
    )
        .animate()
        .fadeIn(delay: Duration(milliseconds: widget.delay))
        .scale(begin: const Offset(0.9, 0.9));
  }
}

class _TechTag extends StatelessWidget {
  final String label;
  const _TechTag(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.primaryViolet.withOpacity(0.1),
        borderRadius: BorderRadius.circular(100),
        border:
            Border.all(color: AppTheme.primaryViolet.withOpacity(0.2)),
      ),
      child: Text(label,
          style: AppTheme.bodySmall.copyWith(
              color: AppTheme.primaryCyan,
              fontSize: 12,
              fontWeight: FontWeight.w500)),
    );
  }
}
