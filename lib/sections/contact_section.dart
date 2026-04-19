import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../core/theme/app_theme.dart';
import '../core/constants/app_constants.dart';
import '../widgets/section_header.dart';

class ContactSection extends StatefulWidget {
  const ContactSection({super.key});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  bool _visible = false;
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _companyCtrl = TextEditingController();
  final _msgCtrl = TextEditingController();
  bool _submitted = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _companyCtrl.dispose();
    _msgCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      setState(() => _submitted = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;

    return VisibilityDetector(
      key: const Key('contact-section'),
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
                    tag: 'Get In Touch',
                    title: "Let's",
                    gradientWord: 'Connect',
                    subtitle:
                        "I'm open to full-time roles, freelance projects, and exciting collaborations.")
                .animate()
                .fadeIn()
                .slideY(begin: 0.3),
          const SizedBox(height: 64),
          if (_visible)
            isMobile
                ? Column(children: [
                    _buildInfo(),
                    const SizedBox(height: 48),
                    _buildForm(),
                  ])
                : Row(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildInfo()),
                      const SizedBox(width: 48),
                      Expanded(flex: 2, child: _buildForm()),
                    ]),
        ]),
      ),
    );
  }

  Widget _buildInfo() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _ContactItem(
          icon: Icons.email_outlined,
          label: 'Email',
          value: AppConstants.email,
          onTap: () => launchUrl(Uri.parse('mailto:${AppConstants.email}')),
          delay: 100),
      _ContactItem(
          icon: Icons.phone_outlined,
          label: 'Phone',
          value: AppConstants.phone,
          onTap: () => launchUrl(Uri.parse('tel:${AppConstants.phone}')),
          delay: 200),
      _ContactItem(
          icon: Icons.link_rounded,
          label: 'LinkedIn',
          value: 'aman-chaudhary-7ba328227',
          onTap: () => launchUrl(Uri.parse(AppConstants.linkedIn)),
          delay: 300),
      _ContactItem(
          icon: Icons.location_on_outlined,
          label: 'Location',
          value: AppConstants.location,
          onTap: null,
          delay: 400),
      const SizedBox(height: 24),
      // Availability
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.successGreen.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border:
              Border.all(color: AppTheme.successGreen.withOpacity(0.2)),
        ),
        child: Row(children: [
          Container(
            width: 12,
            height: 12,
            decoration: const BoxDecoration(
                color: AppTheme.successGreen, shape: BoxShape.circle),
          )
              .animate(onPlay: (c) => c.repeat())
              .scale(
                  begin: const Offset(1, 1),
                  end: const Offset(1.5, 1.5),
                  duration: 1000.ms)
              .then()
              .scale(
                  begin: const Offset(1.5, 1.5),
                  end: const Offset(1, 1),
                  duration: 1000.ms),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              Text('Available for Hire',
                  style: AppTheme.body.copyWith(
                      color: AppTheme.successGreen,
                      fontWeight: FontWeight.w600)),
              Text(
                  'Open to full-time Flutter Developer roles at MNC & product companies',
                  style: AppTheme.bodySmall),
            ]),
          ),
        ]),
      ).animate().fadeIn(delay: 500.ms),
    ]);
  }

  Widget _buildForm() {
    if (_submitted) {
      return Container(
        padding: const EdgeInsets.all(48),
        decoration: BoxDecoration(
          color: AppTheme.cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppTheme.borderColor),
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.center,
            children: [
          ShaderMask(
            shaderCallback: (b) => AppTheme.primaryGradient.createShader(b),
            child: const Icon(Icons.check_circle_outline,
                color: Colors.white, size: 64),
          ),
          const SizedBox(height: 20),
          Text('Message Sent!', style: AppTheme.cardTitle),
          const SizedBox(height: 8),
          Text("Thanks! I'll get back to you soon.",
              style: AppTheme.body, textAlign: TextAlign.center),
        ]),
      ).animate().fadeIn().scale(begin: const Offset(0.8, 0.8));
    }

    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Form(
        key: _formKey,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          _FormField(
              controller: _nameCtrl,
              label: 'Your Name',
              hint: 'e.g. Rahul Kumar',
              delay: 100),
          const SizedBox(height: 20),
          _FormField(
              controller: _emailCtrl,
              label: 'Email Address',
              hint: 'recruiter@company.com',
              delay: 150,
              isEmail: true),
          const SizedBox(height: 20),
          _FormField(
              controller: _companyCtrl,
              label: 'Company',
              hint: 'Your Company Name',
              delay: 200,
              isRequired: false),
          const SizedBox(height: 20),
          _FormField(
              controller: _msgCtrl,
              label: 'Message',
              hint: 'Tell me about the opportunity...',
              delay: 250,
              maxLines: 4),
          const SizedBox(height: 28),
          _SubmitButton(onTap: _submit)
              .animate()
              .fadeIn(delay: 300.ms),
        ]),
      ),
    ).animate().fadeIn(delay: 200.ms).slideX(begin: 0.15);
  }
}

// ── Contact Item ───────────────────────────────────────────────────────
class _ContactItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onTap;
  final int delay;
  const _ContactItem(
      {required this.icon,
      required this.label,
      required this.value,
      required this.onTap,
      required this.delay});

  @override
  State<_ContactItem> createState() => _ContactItemState();
}

class _ContactItemState extends State<_ContactItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.onTap != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: 200.ms,
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: _hovered ? AppTheme.cardColor : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: _hovered
                  ? AppTheme.primaryCyan.withOpacity(0.3)
                  : AppTheme.borderColor,
            ),
          ),
          child: Row(children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(widget.icon, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child:
                  Column(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                Text(widget.label, style: AppTheme.bodySmall),
                Text(widget.value,
                    style: AppTheme.body.copyWith(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w500,
                        fontSize: 14)),
              ]),
            ),
            if (widget.onTap != null)
              Icon(Icons.arrow_outward_rounded,
                  color: _hovered
                      ? AppTheme.primaryCyan
                      : AppTheme.textMuted,
                  size: 16),
          ]),
        ),
      ),
    )
        .animate()
        .fadeIn(delay: Duration(milliseconds: widget.delay))
        .slideX(begin: -0.2);
  }
}

// ── Form Field ─────────────────────────────────────────────────────────
class _FormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final int delay;
  final bool isEmail;
  final bool isRequired;
  final int maxLines;

  const _FormField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.delay,
    this.isEmail = false,
    this.isRequired = true,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label,
          style: AppTheme.bodySmall
              .copyWith(color: AppTheme.textSecondary)),
      const SizedBox(height: 8),
      TextFormField(
        controller: controller,
        maxLines: maxLines,
        style: GoogleFonts.inter(
            color: AppTheme.textPrimary, fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle:
              GoogleFonts.inter(color: AppTheme.textMuted, fontSize: 14),
          filled: true,
          fillColor: AppTheme.surfaceColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppTheme.borderColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppTheme.borderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
                color: AppTheme.primaryViolet, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.redAccent),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.redAccent),
          ),
          contentPadding: const EdgeInsets.symmetric(
              horizontal: 16, vertical: 14),
        ),
        validator: isRequired
            ? (val) {
                if (val == null || val.isEmpty) return 'Required';
                if (isEmail && !RegExp(r'.+@.+\..+').hasMatch(val)) {
                  return 'Enter a valid email';
                }
                return null;
              }
            : null,
      ),
    ])
        .animate()
        .fadeIn(delay: Duration(milliseconds: delay))
        .slideY(begin: 0.1);
  }
}

// ── Submit Button ──────────────────────────────────────────────────────
class _SubmitButton extends StatefulWidget {
  final VoidCallback onTap;
  const _SubmitButton({required this.onTap});

  @override
  State<_SubmitButton> createState() => _SubmitButtonState();
}

class _SubmitButtonState extends State<_SubmitButton> {
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
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            gradient: AppTheme.primaryGradient,
            borderRadius: BorderRadius.circular(12),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                        color: AppTheme.primaryViolet.withOpacity(0.5),
                        blurRadius: 24)
                  ]
                : [
                    BoxShadow(
                        color: AppTheme.primaryViolet.withOpacity(0.2),
                        blurRadius: 12)
                  ],
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.center,
              children: [
            Text('Send Message',
                style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white)),
            const SizedBox(width: 10),
            const Icon(Icons.send_rounded, color: Colors.white, size: 18),
          ]),
        ),
      ),
    );
  }
}
