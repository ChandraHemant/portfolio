import 'package:go_router/go_router.dart';
import 'package:portfolio_app/screens/about_screen.dart';
import 'package:portfolio_app/screens/cgcog/app_privacy_policy.dart';
import 'package:portfolio_app/screens/contact_screen.dart';
import 'package:portfolio_app/screens/home_screen.dart';
import 'package:portfolio_app/screens/packages_screen.dart';
import 'package:portfolio_app/screens/portfolio_screen.dart';
import 'package:portfolio_app/screens/projects_screen.dart';
import 'package:portfolio_app/screens/skills_screen.dart';
import 'package:portfolio_app/widgets/main_layout.dart';

class AppRouter {
  static const String home = '/';
  static const String about = '/about';
  static const String skills = '/skills';
  static const String projects = '/projects';
  static const String packages = '/packages';
  static const String contact = '/contact';
  static const String portfolio = '/portfolio';
  static const String privacy = '/app-privacy-policy';

  static final GoRouter _router = GoRouter(
    initialLocation: home,
    routes: [
      // Main app routes with navigation
      ShellRoute(
        builder: (context, state, child) {
          return MainLayout(child: child);
        },
        routes: [
          GoRoute(
            path: home,
            name: 'home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: about,
            name: 'about',
            builder: (context, state) => const AboutScreen(),
          ),
          GoRoute(
            path: skills,
            name: 'skills',
            builder: (context, state) => const SkillsScreen(),
          ),
          GoRoute(
            path: projects,
            name: 'projects',
            builder: (context, state) => const ProjectsScreen(),
          ),
          GoRoute(
            path: packages,
            name: 'packages',
            builder: (context, state) => const PackagesScreen(),
          ),
          GoRoute(
            path: contact,
            name: 'contact',
            builder: (context, state) => const ContactScreen(),
          ),
          GoRoute(
            path: portfolio,
            name: 'portfolio',
            builder: (context, state) => const PortfolioScreen(),
          ),
        ],
      ),
      // Standalone routes without navigation
      GoRoute(
        path: privacy,
        name: 'app-privacy-policy',
        builder: (context, state) => const PrivacyPolicyScreen(),
      ),
    ],
  );

  static GoRouter get router => _router;

  static int getIndexFromLocation(String location) {
    switch (location) {
      case home:
        return 0;
      case about:
        return 1;
      case skills:
        return 2;
      case projects:
        return 3;
      case packages:
        return 4;
      case contact:
        return 5;
      case portfolio:
        return 6;
      case privacy:
        return -1;
      default:
        return 0;
    }
  }

  static String getLocationFromIndex(int index) {
    switch (index) {
      case 0:
        return home;
      case 1:
        return about;
      case 2:
        return skills;
      case 3:
        return projects;
      case 4:
        return packages;
      case 5:
        return contact;
      case 6:
        return portfolio;
      default:
        return home;
    }
  }
}