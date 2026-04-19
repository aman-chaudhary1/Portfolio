class AppConstants {
  // ── Personal Info ────────────────────────────────────────────────────
  static const String name = 'Aman Chaudhary';
  static const String title = 'Flutter Developer';
  static const String email = 'amanchaudhary4510@gmail.com';
  static const String phone = '+91-6398679181';
  static const String linkedIn = 'https://linkedin.com/in/aman-chaudhary-7ba328227';
  static const String location = 'Noida, Uttar Pradesh, India';

  // ── Typing Words (Hero) ──────────────────────────────────────────────
  static const List<String> typingWords = [
    'Flutter Apps',
    'Android & iOS Apps',
    'Flutter Web',
    'Full Stack Solutions',
    'Backend APIs',
  ];

  // ── Experience ───────────────────────────────────────────────────────
  static const List<Map<String, dynamic>> experience = [
    {
      'role': 'Flutter Developer',
      'company': 'Hastree Technologies Pvt Ltd',
      'period': 'Dec 2023 – Present',
      'location': 'Noida, India',
      'type': 'Full Time',
      'isCurrent': true,
      'points': [
        'Developed and maintained 5+ production Flutter applications using REST APIs and Firebase as the sole Flutter developer',
        'Improved app performance and load time by ~30% through UI optimization and GetX state management',
        'Integrated authentication, real-time database, push notifications, and third-party services',
        'Collaborated with backend teams, QA, and product managers to deliver scalable mobile features',
        'Owned full app lifecycle — from architecture to App Store & Play Store deployment',
      ],
      'tags': ['Flutter', 'GetX', 'Firebase', 'REST API', 'Android', 'iOS', 'Play Store', 'App Store'],
    },
    {
      'role': 'Flutter Developer Intern',
      'company': 'Vdokart',
      'period': 'Sep 2023 – Dec 2023',
      'location': 'Remote',
      'type': 'Internship',
      'isCurrent': false,
      'points': [
        'Built an e-commerce Flutter application with Firebase Authentication, Firestore, and GetX',
        'Implemented product listing, cart, and order workflows following clean architecture',
      ],
      'tags': ['Flutter', 'Firebase', 'GetX', 'E-commerce', 'Clean Architecture'],
    },
  ];

  // ── Projects ─────────────────────────────────────────────────────────
  static const List<Map<String, dynamic>> projects = [
    {
      'name': 'Gravito',
      'subtitle': 'Multi-Vendor Grocery Startup — Live on Play Store',
      'icon': '🛒',
      'isFeatured': true,
      'desc':
          'A complete multi-vendor grocery ecosystem built from scratch as a startup — designed to serve rural India with the tagline "Fresh from Gaon to Ghar". '
          'Includes a customer app (Android), shopkeeper panel, admin dashboard (Flutter Web), and Node.js + MongoDB backend APIs — all developed solo. '
          'Live on Google Play Store and actively running in rural areas.',
      'tech': ['Flutter', 'Node.js', 'MongoDB', 'REST API', 'GetX', 'Firebase'],
      'points': [
        'Built & launched as a personal startup for rural grocery delivery',
        'Customer App, Shopkeeper Panel & Admin Dashboard (Flutter Web)',
        'Complete order/product/coupon/notification management system',
        'Live on Google Play Store — real users in rural areas',
        'Backend: Node.js + MongoDB REST APIs with Auth & OTP',
      ],
      'playStoreUrl': 'https://play.google.com/store/apps/details?id=com.gravito.app',
      'instagramUrl': 'https://www.instagram.com/gravitomultigrocery',
      'screenshots': [
        'assets/images/gravito_splash.png',
        'assets/images/gravito_home.png',
        'assets/images/gravito_profile.png',
        'assets/images/gravito_admin_dashboard.png',
        'assets/images/gravito_admin_subcategory.png',
      ],
    },
    {
      'name': 'Cyan Melon Music',
      'subtitle': 'Teacher–Student Music Learning App',
      'icon': '🎵',
      'isFeatured': false,
      'desc':
          'A platform connecting music teachers and students. Features class management, student access control, and content delivery with a beautiful, scalable UI.',
      'tech': ['Flutter', 'Dart', 'REST APIs'],
      'points': [
        'Integrated backend APIs for class & content',
        'Clean UI with scalable API-driven architecture',
      ],
    },
    {
      'name': 'I Am Healthy',
      'subtitle': 'AI Health App – International Client',
      'icon': '💚',
      'isFeatured': false,
      'desc':
          'An AI-powered health application for an international client using Flutter, Firebase, and Google Gemini AI for personalized health insights.',
      'tech': ['Flutter', 'Firebase', 'Gemini AI'],
      'points': [
        'Gemini AI powered health recommendations',
        'Firebase backend integration',
      ],
    },
    {
      'name': 'NapNotes',
      'subtitle': 'Medical – Anesthesia Workflow App',
      'icon': '🏥',
      'isFeatured': false,
      'desc':
          'A specialized medical application for anesthesia workflow management. Deployed and live on both Google Play Store and Apple App Store.',
      'tech': ['Flutter', 'Firebase'],
      'points': [
        'Live on Play Store & App Store',
        'Medical-grade workflow management',
      ],
    },
  ];

  // ── Skills ───────────────────────────────────────────────────────────
  static const List<Map<String, dynamic>> skillCategories = [
    {
      'title': 'Mobile & Web',
      'icon': '📱',
      'skills': [
        {'name': 'Flutter', 'level': 0.95},
        {'name': 'Dart', 'level': 0.92},
        {'name': 'Flutter Web', 'level': 0.85},
        {'name': 'Android / iOS Deployment', 'level': 0.90},
      ],
    },
    {
      'title': 'Backend',
      'icon': '⚙️',
      'skills': [
        {'name': 'Node.js', 'level': 0.80},
        {'name': 'MongoDB', 'level': 0.78},
        {'name': 'REST APIs', 'level': 0.88},
        {'name': 'Auth & OTP Verification', 'level': 0.85},
      ],
    },
    {
      'title': 'Cloud & Firebase',
      'icon': '☁️',
      'skills': [
        {'name': 'Firebase Auth', 'level': 0.90},
        {'name': 'Firestore', 'level': 0.85},
        {'name': 'Firebase Storage', 'level': 0.82},
        {'name': 'Git / GitHub / GitLab', 'level': 0.85},
      ],
    },
    {
      'title': 'Architecture',
      'icon': '🏗️',
      'skills': [
        {'name': 'GetX State Management', 'level': 0.90},
        {'name': 'Provider', 'level': 0.85},
        {'name': 'Clean Architecture', 'level': 0.82},
        {'name': 'MVC Pattern', 'level': 0.80},
      ],
    },
  ];

  // ── Tech Bubbles ─────────────────────────────────────────────────────
  static const List<String> techStack = [
    'Flutter',
    'Dart',
    'Node.js',
    'MongoDB',
    'Firebase',
    'GetX',
    'REST API',
    'Git',
    'Android',
    'iOS',
    'Web',
    'Clean Arch',
  ];

  // ── Education ────────────────────────────────────────────────────────
  static const List<Map<String, String>> education = [
    {
      'degree': 'MCA – Master of Computer Applications',
      'institution': 'Greater Noida Institute of Technology, Greater Noida',
      'period': '2021–2023',
      'score': '72.56%',
    },
    {
      'degree': 'BCA – Bachelor of Computer Applications',
      'institution': 'CSJM University, Kanpur',
      'period': '2018–2021',
      'score': '60.01%',
    },
  ];

  // ── Achievements ─────────────────────────────────────────────────────
  static const List<Map<String, dynamic>> achievements = [
    {
      'title': 'JAVA Certification',
      'org': 'IIT Bombay',
      'type': 'cert',
      'tier': 'gold',
    },
    {
      'title': 'Soft Skills Certification',
      'org': 'TCS NQT',
      'type': 'cert',
      'tier': 'silver',
    },
    {
      'title': 'Python Basics Certification',
      'org': 'SOFTPRO India',
      'type': 'cert',
      'tier': 'blue',
    },
    {
      'title': '🥇 1st Place – Coding Hackathon',
      'org': 'GNIOT',
      'type': 'hackathon',
      'tier': 'gold',
    },
    {
      'title': '🥈 2nd Place – Smash Code',
      'org': 'Lloyd University',
      'type': 'hackathon',
      'tier': 'silver',
    },
    {
      'title': '4th Place – Blind Coding',
      'org': 'IMS Ghaziabad',
      'type': 'hackathon',
      'tier': 'bronze',
    },
  ];
}
