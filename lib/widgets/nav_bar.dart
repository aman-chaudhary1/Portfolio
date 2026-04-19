import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme/app_theme.dart';

class NavBar extends StatefulWidget {
  final ScrollController scrollController;
  final Function(GlobalKey) onNav;
  final GlobalKey heroKey;
  final GlobalKey aboutKey;
  final GlobalKey skillsKey;
  final GlobalKey experienceKey;
  final GlobalKey projectsKey;
  final GlobalKey educationKey;
  final GlobalKey contactKey;

  const NavBar({
    super.key,
    required this.scrollController,
    required this.onNav,
    required this.heroKey,
    required this.aboutKey,
    required this.skillsKey,
    required this.experienceKey,
    required this.projectsKey,
    required this.educationKey,
    required this.contactKey,
  });

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final scrolled = widget.scrollController.offset > 50;
    if (scrolled != _isScrolled) setState(() => _isScrolled = scrolled);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 900;

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: 72,
        decoration: BoxDecoration(
          color: _isScrolled
              ? AppTheme.surfaceColor.withOpacity(0.95)
              : AppTheme.bgColor.withOpacity(0.0),
          border: _isScrolled
              ? Border(
                  bottom:
                      BorderSide(color: AppTheme.borderColor, width: 1))
              : null,
        ),
        padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 20 : 60),
        child: Row(
          children: [
            // Logo
            GestureDetector(
              onTap: () => widget.onNav(widget.heroKey),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '< ',
                        style: GoogleFonts.firaCode(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryViolet,
                        ),
                      ),
                      TextSpan(
                        text: 'AC',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      TextSpan(
                        text: ' />',
                        style: GoogleFonts.firaCode(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryCyan,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Spacer(),
            if (!isMobile) ...[
              _NavLink('About', () => widget.onNav(widget.aboutKey)),
              _NavLink('Skills', () => widget.onNav(widget.skillsKey)),
              _NavLink('Experience',
                  () => widget.onNav(widget.experienceKey)),
              _NavLink('Projects',
                  () => widget.onNav(widget.projectsKey)),
              _NavLink('Education',
                  () => widget.onNav(widget.educationKey)),
              _NavLink('Contact',
                  () => widget.onNav(widget.contactKey)),
              const SizedBox(width: 24),
              _HireButton(() => widget.onNav(widget.contactKey)),
            ] else
              _MobileMenu(
                onNav: widget.onNav,
                aboutKey: widget.aboutKey,
                skillsKey: widget.skillsKey,
                experienceKey: widget.experienceKey,
                projectsKey: widget.projectsKey,
                educationKey: widget.educationKey,
                contactKey: widget.contactKey,
              ),
          ],
        ),
      ),
    );
  }
}

// ── NavLink ────────────────────────────────────────────────────────────
class _NavLink extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _NavLink(this.label, this.onTap);

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
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
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Text(
            widget.label,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color:
                  _hovered ? AppTheme.primaryCyan : AppTheme.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Hire Button ────────────────────────────────────────────────────────
class _HireButton extends StatefulWidget {
  final VoidCallback onTap;
  const _HireButton(this.onTap);

  @override
  State<_HireButton> createState() => _HireButtonState();
}

class _HireButtonState extends State<_HireButton> {
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
          duration: const Duration(milliseconds: 200),
          padding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            gradient: AppTheme.primaryGradient,
            borderRadius: BorderRadius.circular(100),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                        color: AppTheme.primaryViolet.withOpacity(0.5),
                        blurRadius: 20)
                  ]
                : [],
          ),
          child: Text(
            'Hire Me',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Mobile Menu ────────────────────────────────────────────────────────
class _MobileMenu extends StatelessWidget {
  final Function(GlobalKey) onNav;
  final GlobalKey aboutKey, skillsKey, experienceKey, projectsKey,
      educationKey, contactKey;

  const _MobileMenu({
    required this.onNav,
    required this.aboutKey,
    required this.skillsKey,
    required this.experienceKey,
    required this.projectsKey,
    required this.educationKey,
    required this.contactKey,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.menu_rounded, color: AppTheme.textPrimary),
      color: AppTheme.cardColor,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      itemBuilder: (_) => ['About', 'Skills', 'Experience', 'Projects',
              'Education', 'Contact']
          .map((l) => PopupMenuItem(
                value: l,
                child: Text(l,
                    style: GoogleFonts.inter(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w500)),
              ))
          .toList(),
      onSelected: (v) {
        switch (v) {
          case 'About':
            onNav(aboutKey);
            break;
          case 'Skills':
            onNav(skillsKey);
            break;
          case 'Experience':
            onNav(experienceKey);
            break;
          case 'Projects':
            onNav(projectsKey);
            break;
          case 'Education':
            onNav(educationKey);
            break;
          case 'Contact':
            onNav(contactKey);
            break;
        }
      },
    );
  }
}
