import 'package:flutter/material.dart';
import '../models/portfolio_data.dart';
import '../widgets/animated_section.dart';
import '../config/responsive.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userData = PortfolioData.data;
    final isMobile = Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);

    return Responsive.responsiveLayout(
      mobile: _buildMobileLayout(context, userData),
      tablet: _buildTabletLayout(context, userData),  // Added tablet layout
      desktop: _buildDesktopLayout(context, userData),
    );
  }

  Widget _buildMobileLayout(BuildContext context, Map<String, dynamic> userData) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          AnimatedSection(
            id: 'about-title-mobile',
            child: Text(
              'About Me',
              style: Theme.of(context).textTheme.displayMedium!.copyWith(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10),
          AnimatedSection(
            id: 'about-subtitle-mobile',
            duration: const Duration(milliseconds: 1000),
            child: Container(
              height: 4,
              width: 60,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 30),
          AnimatedSection(
            id: 'about-content-mobile',
            duration: const Duration(milliseconds: 1200),
            child: Text(
              userData['about'],
              style: const TextStyle(fontSize: 16, height: 1.6),
            ),
          ),
          const SizedBox(height: 30),
          AnimatedSection(
            id: 'about-experiences-title-mobile',
            duration: const Duration(milliseconds: 1400),
            child: Text(
              'Work Experience',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.displayMedium!.color,
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildExperienceList(context, userData['experiences'], isMobile: true),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // New tablet layout implementation
  Widget _buildTabletLayout(BuildContext context, Map<String, dynamic> userData) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tablet Header with Image
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left content column
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedSection(
                      id: 'about-title-tablet',
                      child: Text(
                        'About Me',
                        style: Theme.of(context).textTheme.displayMedium!.copyWith(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    AnimatedSection(
                      id: 'about-subtitle-tablet',
                      duration: const Duration(milliseconds: 1000),
                      child: Container(
                        height: 4,
                        width: 70,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    AnimatedSection(
                      id: 'about-content-tablet',
                      duration: const Duration(milliseconds: 1200),
                      child: Text(
                        userData['about'],
                        style: const TextStyle(fontSize: 16, height: 1.7),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 30),
              // Right image column
              Expanded(
                flex: 2,
                child: AnimatedSection(
                  id: 'about-image-tablet',
                  startOffset: 50,
                  child: Container(
                    height: 220,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      image: DecorationImage(
                        image: AssetImage(userData['avatarUrl']),
                        fit: BoxFit.cover,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          offset: const Offset(0, 10),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          AnimatedSection(
            id: 'about-experiences-title-tablet',
            duration: const Duration(milliseconds: 1400),
            child: Text(
              'Work Experience',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.displayMedium!.color,
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildExperienceList(context, userData['experiences'], isMobile: false),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, Map<String, dynamic> userData) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                flex: 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedSection(
                      id: 'about-title-desktop',
                      child: Text(
                        'About Me',
                        style: Theme.of(context).textTheme.displayLarge!.copyWith(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    AnimatedSection(
                      id: 'about-subtitle-desktop',
                      duration: const Duration(milliseconds: 1000),
                      child: Container(
                        height: 5,
                        width: 80,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(2.5),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    AnimatedSection(
                      id: 'about-content-desktop',
                      duration: const Duration(milliseconds: 1200),
                      child: Text(
                        userData['about'],
                        style: const TextStyle(fontSize: 18, height: 1.8),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 60),
              Expanded(
                flex: 4,
                child: AnimatedSection(
                  id: 'about-image-desktop',
                  startOffset: 100,
                  child: Container(
                    height: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      image: DecorationImage(
                        image: AssetImage(userData['avatarUrl']),
                        fit: BoxFit.fitHeight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.yellow.withOpacity(0.2),
                          offset: const Offset(0, 10),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 60),
          AnimatedSection(
            id: 'about-experiences-title-desktop',
            duration: const Duration(milliseconds: 1400),
            child: Text(
              'Work Experience',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.displayMedium!.color,
              ),
            ),
          ),
          const SizedBox(height: 30),
          _buildExperienceList(context, userData['experiences'], isMobile: false),
        ],
      ),
    );
  }

  Widget _buildExperienceList(BuildContext context, List<dynamic> experiences, {required bool isMobile}) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: experiences.length,
      itemBuilder: (context, index) {
        final experience = experiences[index];
        return AnimatedSection(
          id: 'experience-$index',
          duration: Duration(milliseconds: 1600 + (index * 200)),
          child: Container(
            margin: EdgeInsets.only(bottom: 20),
            padding: EdgeInsets.all(isMobile ? 20 : 30),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      experience['position'],
                      style: TextStyle(
                        fontSize: isMobile ? 18 : 22,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.displayMedium!.color,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        experience['duration'],
                        style: TextStyle(
                          fontSize: isMobile ? 12 : 14,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  experience['company'],
                  style: TextStyle(
                    fontSize: isMobile ? 16 : 18,
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  experience['description'],
                  style: TextStyle(
                    fontSize: isMobile ? 14 : 16,
                    height: 1.6,
                    color: Theme.of(context).textTheme.bodyMedium!.color,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}