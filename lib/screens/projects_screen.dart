import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../models/portfolio_data.dart';
import '../widgets/project_card.dart';
import '../widgets/animated_section.dart';
import '../config/responsive.dart';

class ProjectsScreen extends StatelessWidget {
  const ProjectsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userData = PortfolioData.data;
    final projects = userData['projects'] as List<dynamic>;
    final isMobile = Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);

    return Responsive.responsiveLayout(
      mobile: _buildMobileLayout(context, projects),
      tablet: _buildTabletLayout(context, projects),
      desktop: _buildDesktopLayout(context, projects),
    );
  }

  Widget _buildMobileLayout(BuildContext context, List<dynamic> projects) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          AnimatedSection(
            id: 'projects-title-mobile',
            child: Text(
              'My Projects',
              style: Theme.of(context).textTheme.displayMedium!.copyWith(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10),
          AnimatedSection(
            id: 'projects-subtitle-mobile',
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
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: projects.length,
            itemBuilder: (context, index) {
              final project = projects[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: AnimatedSection(
                  id: 'project-mobile-$index',
                  duration: Duration(milliseconds: 1200 + (index * 200)),
                  startOffset: 50,
                  child: ProjectCard(
                    title: project['title'],
                    description: project['description'],
                    imageUrl: project['imageUrl'],
                    technologies: List<String>.from(project['technologies']),
                    url: project['url'],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildTabletLayout(BuildContext context, List<dynamic> projects) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30),
          AnimatedSection(
            id: 'projects-title-tablet',
            child: Text(
              'My Projects',
              style: Theme.of(context).textTheme.displayMedium!.copyWith(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 12),
          AnimatedSection(
            id: 'projects-subtitle-tablet',
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
            id: 'projects-description-tablet',
            duration: const Duration(milliseconds: 1100),
            child: Text(
              'Check out some of my recent work:',
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).textTheme.bodyLarge!.color,
              ),
            ),
          ),
          const SizedBox(height: 40),
          MasonryGridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,  // 2 columns for tablet view
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            itemCount: projects.length,
            itemBuilder: (context, index) {
              final project = projects[index];
              return AnimatedSection(
                id: 'project-tablet-$index',
                duration: Duration(milliseconds: 1200 + (index * 200)),
                startOffset: 50,
                child: ProjectCard(
                  title: project['title'],
                  description: project['description'],
                  imageUrl: project['imageUrl'],
                  technologies: List<String>.from(project['technologies']),
                  url: project['url'],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, List<dynamic> projects) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedSection(
            id: 'projects-title-desktop',
            child: Text(
              'My Projects',
              style: Theme.of(context).textTheme.displayLarge!.copyWith(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 15),
          AnimatedSection(
            id: 'projects-subtitle-desktop',
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
            id: 'projects-description-desktop',
            duration: const Duration(milliseconds: 1100),
            child: Text(
              'Check out some of my recent work:',
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
            crossAxisCount: 3,
            mainAxisSpacing: 30,
            crossAxisSpacing: 30,
            itemCount: projects.length,
            itemBuilder: (context, index) {
              final project = projects[index];
              return AnimatedSection(
                id: 'project-desktop-$index',
                duration: Duration(milliseconds: 1200 + (index * 200)),
                startOffset: 50,
                child: ProjectCard(
                  title: project['title'],
                  description: project['description'],
                  imageUrl: project['imageUrl'],
                  technologies: List<String>.from(project['technologies']),
                  url: project['url'],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}