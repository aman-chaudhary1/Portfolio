import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme/app_theme.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Container(
      color: AppTheme.bgColor,
      padding: EdgeInsets.symmetric(
          vertical: 40, horizontal: isMobile ? 24 : 80),
      child: Column(children: [
        Container(height: 1, color: AppTheme.borderColor),
        const SizedBox(height: 32),
        isMobile
            ? Column(children: [
                _Brand(),
                const SizedBox(height: 20),
                _Links(),
                const SizedBox(height: 20),
                _Copyright(),
              ])
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(child: _Brand()),
                  const SizedBox(width: 20),
                  _Links(),
                  const SizedBox(width: 20),
                  Flexible(child: _Copyright()),
                ]),
      ]),
    );
  }
}

class _Brand extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      RichText(
        text: TextSpan(children: [
          TextSpan(
              text: '< ',
              style: GoogleFonts.firaCode(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryViolet)),
          TextSpan(
              text: 'AC',
              style: GoogleFonts.spaceGrotesk(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textPrimary)),
          TextSpan(
              text: ' />',
              style: GoogleFonts.firaCode(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryCyan)),
        ]),
      ),
      const SizedBox(height: 4),
      Text('Flutter Developer · Full Stack Mobile App Developer',
          style: AppTheme.bodySmall),
    ]);
  }
}

class _Links extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 24,
      children: ['About', 'Skills', 'Projects', 'Contact']
          .map((l) => Text(l,
              style: AppTheme.bodySmall
                  .copyWith(color: AppTheme.textSecondary)))
          .toList(),
    );
  }
}

class _Copyright extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      '© 2025 Aman Chaudhary · Built with Flutter ❤️',
      style: AppTheme.bodySmall,
    );
  }
}
