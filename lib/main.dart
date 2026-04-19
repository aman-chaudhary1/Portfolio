import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'sections/hero_section.dart';
import 'sections/about_section.dart';
import 'sections/skills_section.dart';
import 'sections/experience_section.dart';
import 'sections/projects_section.dart';
import 'sections/education_section.dart';
import 'sections/contact_section.dart';
import 'sections/footer_section.dart';
import 'widgets/nav_bar.dart';

void main() {
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aman Chaudhary | Flutter Developer',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const PortfolioHome(),
    );
  }
}

class PortfolioHome extends StatefulWidget {
  const PortfolioHome({super.key});

  @override
  State<PortfolioHome> createState() => _PortfolioHomeState();
}

class _PortfolioHomeState extends State<PortfolioHome> {
  final ScrollController _scrollController = ScrollController();

  // Section keys for navigation
  final GlobalKey _heroKey = GlobalKey();
  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _skillsKey = GlobalKey();
  final GlobalKey _experienceKey = GlobalKey();
  final GlobalKey _projectsKey = GlobalKey();
  final GlobalKey _educationKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();

  void _scrollTo(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 750),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgColor,
      body: Stack(
        children: [
          // ── Scrollable content ──────────────────────────────────────
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                SizedBox(
                  key: _heroKey,
                  child: HeroSection(
                    onViewWork: () => _scrollTo(_projectsKey),
                    onContact: () => _scrollTo(_contactKey),
                    onAbout: () => _scrollTo(_aboutKey),
                  ),
                ),
                SizedBox(
                    key: _aboutKey, child: const AboutSection()),
                SizedBox(
                    key: _skillsKey, child: const SkillsSection()),
                SizedBox(
                    key: _experienceKey,
                    child: const ExperienceSection()),
                SizedBox(
                    key: _projectsKey, child: const ProjectsSection()),
                SizedBox(
                    key: _educationKey,
                    child: const EducationSection()),
                SizedBox(
                    key: _contactKey, child: const ContactSection()),
                const FooterSection(),
              ],
            ),
          ),

          // ── Fixed NavBar overlay ────────────────────────────────────
          NavBar(
            scrollController: _scrollController,
            onNav: _scrollTo,
            heroKey: _heroKey,
            aboutKey: _aboutKey,
            skillsKey: _skillsKey,
            experienceKey: _experienceKey,
            projectsKey: _projectsKey,
            educationKey: _educationKey,
            contactKey: _contactKey,
          ),
        ],
      ),
    );
  }
}
