import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../models/portfolio_data.dart';
import '../widgets/skill_card.dart';
import '../widgets/animated_section.dart';
import '../config/responsive.dart';

class SkillsScreen extends StatelessWidget {
  const SkillsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userData = PortfolioData.data;
    final skills = userData['skills'] as List<dynamic>;
    final isMobile = Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);

    return Responsive.responsiveLayout(
      mobile: _buildMobileLayout(context, skills),
      tablet: _buildTabletLayout(context, skills),  // Added tablet layout
      desktop: _buildDesktopLayout(context, skills),
    );
  }

  Widget _buildMobileLayout(BuildContext context, List<dynamic> skills) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          AnimatedSection(
            id: 'skills-title-mobile',
            child: Text(
              'My Skills',
              style: Theme.of(context).textTheme.displayMedium!.copyWith(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10),
          AnimatedSection(
            id: 'skills-subtitle-mobile',
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
          MasonryGridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 1,
            mainAxisSpacing: 15,
            crossAxisSpacing: 15,
            itemCount: skills.length,
            itemBuilder: (context, index) {
              final skill = skills[index];
              return AnimatedSection(
                id: 'skill-mobile-$index',
                duration: Duration(milliseconds: 1200 + (index * 100)),
                startOffset: 50,
                child: SkillCard(
                  name: skill['name'],
                  level: skill['level'],
                  icon: skill['icon'],
                ),
              );
            },
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // New tablet layout
  Widget _buildTabletLayout(BuildContext context, List<dynamic> skills) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedSection(
            id: 'skills-title-tablet',
            child: Text(
              'My Skills',
              style: Theme.of(context).textTheme.displayMedium!.copyWith(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 12),
          AnimatedSection(
            id: 'skills-subtitle-tablet',
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
          const SizedBox(height: 20),
          AnimatedSection(
            id: 'skills-description-tablet',
            duration: const Duration(milliseconds: 1100),
            child: Text(
              'Here are my technical skills and proficiency levels:',
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).textTheme.bodyLarge!.color,
              ),
            ),
          ),
          const SizedBox(height: 30),
          MasonryGridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,  // Use 2 columns for tablet
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            itemCount: skills.length,
            itemBuilder: (context, index) {
              final skill = skills[index];
              return AnimatedSection(
                id: 'skill-tablet-$index',
                duration: Duration(milliseconds: 1200 + (index * 100)),
                startOffset: 50,
                child: SkillCard(
                  name: skill['name'],
                  level: skill['level'],
                  icon: skill['icon'],
                  index: index,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, List<dynamic> skills) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedSection(
            id: 'skills-title-desktop',
            child: Text(
              'My Skills',
              style: Theme.of(context).textTheme.displayLarge!.copyWith(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 15),
          AnimatedSection(
            id: 'skills-subtitle-desktop',
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
          const SizedBox(height: 20),
          AnimatedSection(
            id: 'skills-description-desktop',
            duration: const Duration(milliseconds: 1100),
            child: Text(
              'Here are my technical skills and proficiency levels:',
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).textTheme.bodyLarge!.color,
              ),
            ),
          ),
          const SizedBox(height: 40),
          MasonryGridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 30,
            crossAxisSpacing: 30,
            itemCount: skills.length,
            itemBuilder: (context, index) {
              final skill = skills[index];
              return AnimatedSection(
                id: 'skill-desktop-$index',
                duration: Duration(milliseconds: 1200 + (index * 100)),
                startOffset: 50,
                child: SkillCard(
                  name: skill['name'],
                  level: skill['level'],
                  icon: skill['icon'],
                  index: index,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}