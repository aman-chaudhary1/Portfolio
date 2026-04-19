import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math' as math;
import '../core/theme/app_theme.dart';
import '../core/constants/app_constants.dart';

class HeroSection extends StatefulWidget {
  final VoidCallback onViewWork;
  final VoidCallback onContact;
  final VoidCallback onAbout;

  const HeroSection({
    super.key,
    required this.onViewWork,
    required this.onContact,
    required this.onAbout,
  });

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection>
    with TickerProviderStateMixin {
  late AnimationController _particleCtrl;
  late AnimationController _floatCtrl;

  @override
  void initState() {
    super.initState();
    _particleCtrl = AnimationController(
        vsync: this, duration: const Duration(seconds: 15))
      ..repeat();
    _floatCtrl = AnimationController(
        vsync: this, duration: const Duration(seconds: 3))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _particleCtrl.dispose();
    _floatCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 900;

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: size.height),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0A0A0F), Color(0xFF0D0D1A), Color(0xFF0A0A12)],
        ),
      ),
      child: Stack(
        children: [
          // Particle background
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _particleCtrl,
              builder: (_, __) => CustomPaint(
                painter: _ParticlePainter(_particleCtrl.value),
              ),
            ),
          ),
          // Violet glow top-left
          Positioned(
            top: -150,
            left: -150,
            child: Container(
              width: 600,
              height: 600,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  AppTheme.primaryViolet.withOpacity(0.12),
                  Colors.transparent,
                ]),
              ),
            ),
          ),
          // Cyan glow bottom-right
          Positioned(
            bottom: -100,
            right: -100,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  AppTheme.primaryCyan.withOpacity(0.08),
                  Colors.transparent,
                ]),
              ),
            ),
          ),
          // Main content
          Padding(
            padding: EdgeInsets.only(
              top: 100,
              bottom: 80,
              left: isMobile ? 24 : 80,
              right: isMobile ? 24 : 80,
            ),
            child: isMobile
                ? Column(children: [
                    _HeroContent(
                        onViewWork: widget.onViewWork,
                        onContact: widget.onContact),
                    const SizedBox(height: 60),
                    SizedBox(
                        height: 520,
                        child: _ProfileImage(floatCtrl: _floatCtrl)),
                  ])
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                          flex: 6,
                          child: _HeroContent(
                              onViewWork: widget.onViewWork,
                              onContact: widget.onContact)),
                      const SizedBox(width: 40),
                      Expanded(
                          flex: 4,
                          child: _ProfileImage(floatCtrl: _floatCtrl)),
                    ],
                  ),
          ),
          // Scroll indicator
          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: Center(
              child: AnimatedBuilder(
                animation: _floatCtrl,
                builder: (_, __) => Transform.translate(
                  offset: Offset(0, _floatCtrl.value * 6),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Text('Scroll Down', style: AppTheme.bodySmall.copyWith(fontSize: 12)),
                    const SizedBox(height: 6),
                    const Icon(Icons.keyboard_arrow_down_rounded,
                        color: AppTheme.textMuted, size: 22),
                  ]),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Hero Content ──────────────────────────────────────────────────────
class _HeroContent extends StatelessWidget {
  final VoidCallback onViewWork;
  final VoidCallback onContact;

  const _HeroContent({required this.onViewWork, required this.onContact});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Available badge
        Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppTheme.successGreen.withOpacity(0.1),
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
                color: AppTheme.successGreen.withOpacity(0.3)),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                  color: AppTheme.successGreen, shape: BoxShape.circle),
            )
                .animate(onPlay: (c) => c.repeat())
                .scale(
                    begin: const Offset(1, 1),
                    end: const Offset(1.6, 1.6),
                    duration: 1000.ms)
                .then()
                .scale(
                    begin: const Offset(1.6, 1.6),
                    end: const Offset(1, 1),
                    duration: 1000.ms),
            const SizedBox(width: 8),
            Text('Available for Opportunities',
                style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.successGreen)),
          ]),
        ).animate().fadeIn(delay: 200.ms).slideY(begin: -0.3),
        const SizedBox(height: 24),
        // Name
        Text('Aman',
                style: AppTheme.heroName
                    .copyWith(fontSize: isMobile ? 48 : 72))
            .animate()
            .fadeIn(delay: 300.ms)
            .slideY(begin: 0.3),
        ShaderMask(
          shaderCallback: (b) => AppTheme.primaryGradient.createShader(b),
          child: Text('Chaudhary',
              style: AppTheme.heroName.copyWith(
                  fontSize: isMobile ? 48 : 72, color: Colors.white)),
        ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.3),
        const SizedBox(height: 20),
        // Typing animation
        Row(children: [
          Text('I Build  ',
              style: GoogleFonts.spaceGrotesk(
                  fontSize: isMobile ? 20 : 26,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textSecondary)),
          AnimatedTextKit(
            repeatForever: true,
            animatedTexts: AppConstants.typingWords
                .map((w) => TyperAnimatedText(w,
                    textStyle: GoogleFonts.spaceGrotesk(
                      fontSize: isMobile ? 20 : 26,
                      fontWeight: FontWeight.w700,
                      foreground: Paint()
                        ..shader = AppTheme.primaryGradient
                            .createShader(const Rect.fromLTWH(0, 0, 300, 50)),
                    ),
                    speed: const Duration(milliseconds: 80)))
                .toList(),
          ),
        ]).animate().fadeIn(delay: 500.ms),
        const SizedBox(height: 24),
        // Description
        Text(
          'Flutter Developer with 2+ years of experience crafting production-grade '
          'Android, iOS & Web applications. Full-stack capable with Node.js + MongoDB. '
          'Shipped 5 live apps to App Store & Play Store — solo.',
          style: AppTheme.body.copyWith(fontSize: isMobile ? 14 : 16),
        ).animate().fadeIn(delay: 600.ms),
        const SizedBox(height: 36),
        // Stats
        _StatsRow().animate().fadeIn(delay: 700.ms),
        const SizedBox(height: 36),
        // Buttons
        Wrap(spacing: 16, runSpacing: 16, children: [
          _GradientBtn(
              label: 'View My Work',
              icon: Icons.arrow_forward_rounded,
              onTap: onViewWork),
          _GhostBtn(
              label: "Let's Talk",
              icon: Icons.chat_bubble_outline_rounded,
              onTap: onContact),
        ]).animate().fadeIn(delay: 800.ms),
        const SizedBox(height: 32),
        // Social chips
        Wrap(spacing: 12, runSpacing: 12, children: [
          _SocialChip(
              icon: Icons.email_outlined,
              label: 'Email',
              url: 'mailto:${AppConstants.email}'),
          _SocialChip(
              icon: Icons.phone_outlined,
              label: 'Call',
              url: 'tel:${AppConstants.phone}'),
          _SocialChip(
              icon: Icons.link_rounded,
              label: 'LinkedIn',
              url: AppConstants.linkedIn),
        ]).animate().fadeIn(delay: 900.ms),
      ],
    );
  }
}

// ── Stats Row ─────────────────────────────────────────────────────────
class _StatsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      _StatItem('5', 'Apps Shipped'),
      _StatDiv(),
      _StatItem('2+', 'Years Exp'),
      _StatDiv(),
      _StatItem('3', 'Platforms'),
    ]);
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  const _StatItem(this.value, this.label);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ShaderMask(
        shaderCallback: (b) => AppTheme.primaryGradient.createShader(b),
        child: Text(value,
            style: GoogleFonts.spaceGrotesk(
                fontSize: 36,
                fontWeight: FontWeight.w800,
                color: Colors.white)),
      ),
      Text(label, style: AppTheme.bodySmall),
    ]);
  }
}

class _StatDiv extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 1,
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            AppTheme.borderColor,
            Colors.transparent
          ],
        ),
      ),
    );
  }
}

// ── Gradient Button ────────────────────────────────────────────────────
class _GradientBtn extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const _GradientBtn(
      {required this.label, required this.icon, required this.onTap});

  @override
  State<_GradientBtn> createState() => _GradientBtnState();
}

class _GradientBtnState extends State<_GradientBtn> {
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
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          decoration: BoxDecoration(
            gradient: AppTheme.primaryGradient,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryViolet
                    .withOpacity(_hovered ? 0.5 : 0.2),
                blurRadius: _hovered ? 24 : 12,
              )
            ],
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Text(widget.label,
                style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white)),
            const SizedBox(width: 8),
            Icon(widget.icon, color: Colors.white, size: 18),
          ]),
        ),
      ),
    );
  }
}

// ── Ghost Button ───────────────────────────────────────────────────────
class _GhostBtn extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const _GhostBtn(
      {required this.label, required this.icon, required this.onTap});

  @override
  State<_GhostBtn> createState() => _GhostBtnState();
}

class _GhostBtnState extends State<_GhostBtn> {
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
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          decoration: BoxDecoration(
            color: _hovered ? AppTheme.borderColor : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _hovered ? AppTheme.primaryCyan : AppTheme.borderColor,
              width: 1.5,
            ),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Text(widget.label,
                style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary)),
            const SizedBox(width: 8),
            Icon(widget.icon, color: AppTheme.textSecondary, size: 18),
          ]),
        ),
      ),
    );
  }
}

// ── Social Chip ────────────────────────────────────────────────────────
class _SocialChip extends StatefulWidget {
  final IconData icon;
  final String label;
  final String url;
  const _SocialChip(
      {required this.icon, required this.label, required this.url});

  @override
  State<_SocialChip> createState() => _SocialChipState();
}

class _SocialChipState extends State<_SocialChip> {
  bool _hovered = false;

  Future<void> _launch() async {
    final uri = Uri.parse(widget.url);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: _launch,
        child: AnimatedContainer(
          duration: 200.ms,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: _hovered ? AppTheme.borderColor : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppTheme.borderColor),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(widget.icon, color: AppTheme.textMuted, size: 16),
            const SizedBox(width: 6),
            Text(widget.label, style: AppTheme.bodySmall),
          ]),
        ),
      ),
    );
  }
}

// ── Developer Photo / Profile Widget ───────────────────────────────────
class _ProfileImage extends StatelessWidget {
  final AnimationController floatCtrl;
  const _ProfileImage({required this.floatCtrl});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: floatCtrl,
      builder: (_, child) => Transform.translate(
        offset: Offset(0, -15 + floatCtrl.value * 15),
        child: child,
      ),
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // Background Glow
          Container(
            width: 320,
            height: 320,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryViolet.withOpacity(0.25),
                  blurRadius: 100,
                  spreadRadius: 20,
                )
              ],
            ),
          ),
          // Main Image Frame
          Container(
            width: 350,
            height: 480,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.primaryViolet.withOpacity(0.1),
                  AppTheme.primaryCyan.withOpacity(0.05),
                ],
              ),
              border: Border.all(
                color: AppTheme.borderColor.withOpacity(0.5),
                width: 1.5,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: Image.asset(
                'assets/images/aman.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.person_rounded,
                        size: 80, color: AppTheme.textMuted),
                    const SizedBox(height: 12),
                    Text('Aman Chaudhary', style: AppTheme.bodySmall),
                  ],
                ),
              ),
            ),
          ),
          // Decorative border overlay for depth
          Container(
            width: 350,
            height: 480,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 1,
              ),
            ),
          ),
          // Floating badges
          Positioned(
            right: -25,
            top: 40,
            child: const _FloatBadge('🤖', 'Android')
                .animate().fadeIn(delay: 600.ms).slideX(begin: 0.3),
          ),
          Positioned(
            left: -25,
            top: 120,
            child: const _FloatBadge('🍎', 'iOS')
                .animate().fadeIn(delay: 800.ms).slideX(begin: -0.3),
          ),
          Positioned(
            right: -25,
            bottom: 140,
            child: const _FloatBadge('🌐', 'Flutter Web')
                .animate().fadeIn(delay: 1000.ms).slideX(begin: 0.3),
          ),
          Positioned(
            left: -25,
            bottom: 60,
            child: const _FloatBadge('⚙️', 'Backend')
                .animate().fadeIn(delay: 1200.ms).slideX(begin: -0.3),
          ),
        ],
      ),
    );
  }
}

// ── Float Badge ────────────────────────────────────────────────────────
class _FloatBadge extends StatelessWidget {
  final String emoji;
  final String label;
  const _FloatBadge(this.emoji, this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: AppTheme.borderColor),
        boxShadow: [
          BoxShadow(
              color: AppTheme.primaryViolet.withOpacity(0.15),
              blurRadius: 10)
        ],
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Text(emoji, style: const TextStyle(fontSize: 13)),
        const SizedBox(width: 5),
        Text(label,
            style: AppTheme.bodySmall
                .copyWith(fontSize: 11, color: AppTheme.textPrimary)),
      ]),
    );
  }
}

// ── Particle Painter ───────────────────────────────────────────────────
class _ParticlePainter extends CustomPainter {
  final double progress;
  static final List<_Particle> _pts = _generate();

  _ParticlePainter(this.progress);

  static List<_Particle> _generate() {
    final rand = math.Random(42);
    return List.generate(70, (i) {
      final isViolet = i % 3 == 0;
      final isCyan = i % 3 == 1;
      return _Particle(
        x: rand.nextDouble(),
        y: rand.nextDouble(),
        r: rand.nextDouble() * 1.8 + 0.4,
        speed: rand.nextDouble() * 0.2 + 0.05,
        opacity: rand.nextDouble() * 0.4 + 0.1,
        color: isViolet
            ? AppTheme.primaryViolet
            : isCyan
                ? AppTheme.primaryCyan
                : Colors.white,
      );
    });
  }

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in _pts) {
      final dy = (p.y + progress * p.speed) % 1.0;
      canvas.drawCircle(
        Offset(p.x * size.width, dy * size.height),
        p.r,
        Paint()
          ..color = p.color.withOpacity(p.opacity)
          ..style = PaintingStyle.fill,
      );
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter old) => old.progress != progress;
}

class _Particle {
  final double x, y, r, speed, opacity;
  final Color color;
  const _Particle(
      {required this.x,
      required this.y,
      required this.r,
      required this.speed,
      required this.opacity,
      required this.color});
}
