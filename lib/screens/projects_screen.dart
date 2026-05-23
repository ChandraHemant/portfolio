import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:portfolio_app/config/responsive.dart';
import 'package:portfolio_app/config/theme.dart';
import 'package:portfolio_app/models/portfolio_data.dart';
import 'package:portfolio_app/widgets/project_card.dart';
import 'package:portfolio_app/widgets/reveal_on_scroll.dart';
import 'package:portfolio_app/widgets/mouse_tilt.dart';

class ProjectsScreen extends StatefulWidget {
  final ScrollController? scrollController;
  const ProjectsScreen({Key? key, this.scrollController}) : super(key: key);

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  String _filter = 'All';

  static const _filters = [
    'All', 'Flutter', 'GIS', 'Next.js', 'AI/ML', 'Government', 'Laravel',
  ];

  // Cases for the case studies section
  static final _cases = [
    {
      'title': 'Global E-Commerce Scaling',
      'client': 'RetailX',
      'challenge': 'The client\'s legacy monolithic architecture was crashing under heavy traffic during holiday sales, resulting in millions of dollars in lost revenue. They needed a highly scalable, zero-downtime microservices architecture.',
      'solution': 'We migrated their entire backend to a Node.js and Go-based microservices architecture deployed on Kubernetes. We implemented aggressive Redis caching, PostgreSQL read replicas, and a brand new Next.js frontend.',
      'result': '300% increase in checkout speed, 99.999% uptime during Black Friday, and a 45% increase in conversion rates.',
      'color': AppColors.accentPurple,
    },
    {
      'title': 'AI-Powered Health Analytics',
      'client': 'MedTech Innovators',
      'challenge': 'They required a secure, HIPAA-compliant mobile application that could analyze patient data in real-time and predict potential health risks using complex machine learning models.',
      'solution': 'We built a secure Flutter application with end-to-end encryption. The backend leveraged Python for ML processing, deployed securely on AWS GovCloud. Real-time data was managed via WebSocket connections.',
      'result': 'Successfully launched in 50+ hospitals. The predictive model achieved a 92% accuracy rate in early detection of anomalies.',
      'color': AppColors.accentCyan,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final userData = PortfolioData.data;
    final allProjects = userData['projects'] as List<dynamic>;
    final isMobile = Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);

    // Apply category filtering logic
    final filteredProjects = _filter == 'All'
        ? allProjects
        : allProjects.where((p) {
            final category = (p['category'] ?? '').toString().toLowerCase();
            return category.contains(_filter.toLowerCase());
          }).toList();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: SingleChildScrollView(
          controller: widget.scrollController,
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 20 : (isTablet ? 40 : 100),
            vertical: 40,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Title
              Text(
                'Projects & Case Studies',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: isMobile ? 32 : 44,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1.0,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                ),
              ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.1, end: 0),

              const SizedBox(height: 10),

              Container(
                height: 4,
                width: 60,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: AppColors.premiumGrad,
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ).animate().fadeIn(duration: 500.ms, delay: 100.ms),

              const SizedBox(height: 20),

              Text(
                'A showcases of government geo-intelligence platforms, microservice APIs, and consumer mobile apps shipped.',
                style: GoogleFonts.inter(
                  fontSize: isMobile ? 14 : 16,
                  height: 1.6,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white.withOpacity(0.6)
                      : Colors.black.withOpacity(0.6),
                ),
              ).animate().fadeIn(duration: 500.ms, delay: 200.ms),

              const SizedBox(height: 32),

              // Filter Tabs bar
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: _filters.map((f) {
                    final active = _filter == f;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () => setState(() => _filter = f),
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                            decoration: BoxDecoration(
                              color: active
                                  ? Theme.of(context).primaryColor.withOpacity(0.12)
                                  : (Theme.of(context).brightness == Brightness.dark
                                      ? Colors.white.withOpacity(0.04)
                                      : Colors.black.withOpacity(0.03)),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: active
                                    ? Theme.of(context).primaryColor
                                    : Colors.transparent,
                                width: 1.5,
                              ),
                            ),
                            child: Text(
                              f,
                              style: GoogleFonts.plusJakartaSans(
                                color: active
                                    ? Theme.of(context).primaryColor
                                    : (Theme.of(context).brightness == Brightness.dark
                                        ? Colors.white.withOpacity(0.6)
                                        : Colors.black.withOpacity(0.6)),
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ).animate().fadeIn(duration: 500.ms, delay: 300.ms),

              const SizedBox(height: 40),

              // Projects Grid
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: MasonryGridView.count(
                  key: ValueKey(_filter),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: isMobile ? 1 : (isTablet ? 2 : 3),
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  itemCount: filteredProjects.length,
                  itemBuilder: (context, index) {
                    final p = filteredProjects[index];
                    return RevealOnScroll(
                      duration: const Duration(milliseconds: 400),
                      delay: Duration(milliseconds: 50 * (index % (isTablet ? 2 : 3))),
                      slideFrom: const Offset(0, 20),
                      child: ProjectCard(
                        title: p['title'],
                        description: p['description'] ?? p['desc'],
                        technologies: List<String>.from(p['technologies']),
                        url: p['url'],
                        year: p['year'],
                        color: p['color'],
                        icon: p['icon'],
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 32),

              Center(
                child: Text(
                  '${allProjects.length} products shipped · and counting...',
                  style: GoogleFonts.plusJakartaSans(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white.withOpacity(0.4)
                        : Colors.black.withOpacity(0.4),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}