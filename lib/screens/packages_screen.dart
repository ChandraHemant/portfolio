import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/portfolio_data.dart';
import '../widgets/animated_section.dart';
import '../config/responsive.dart';

class PackagesScreen extends StatelessWidget {
  const PackagesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userData = PortfolioData.data;
    final packages = userData['packages'] as List<dynamic>;
    final isMobile = Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);

    return Responsive.responsiveLayout(
      mobile: _buildMobileLayout(context, packages),
      tablet: _buildTabletLayout(context, packages),
      desktop: _buildDesktopLayout(context, packages),
    );
  }

  Widget _buildMobileLayout(BuildContext context, List<dynamic> packages) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          AnimatedSection(
            id: 'packages-title-mobile',
            child: Text(
              'My Packages',
              style: Theme.of(context).textTheme.displayMedium!.copyWith(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10),
          AnimatedSection(
            id: 'packages-subtitle-mobile',
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
          const SizedBox(height: 20),
          AnimatedSection(
            id: 'packages-description-mobile',
            duration: const Duration(milliseconds: 1100),
            child: Text(
              'Open-source packages I\'ve published to help other developers:',
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).textTheme.bodyLarge!.color,
              ),
            ),
          ),
          const SizedBox(height: 30),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: packages.length,
            itemBuilder: (context, index) {
              final package = packages[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: AnimatedSection(
                  id: 'package-mobile-$index',
                  duration: Duration(milliseconds: 1200 + (index * 150)),
                  startOffset: 40,
                  child: _buildPackageCard(
                    context,
                    package: package,
                    isMobile: true,
                    index: index,
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

  Widget _buildTabletLayout(BuildContext context, List<dynamic> packages) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedSection(
            id: 'packages-title-tablet',
            child: Text(
              'My Packages',
              style: Theme.of(context).textTheme.displayMedium!.copyWith(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 12),
          AnimatedSection(
            id: 'packages-subtitle-tablet',
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
            id: 'packages-description-tablet',
            duration: const Duration(milliseconds: 1100),
            child: Text(
              'Open-source packages I\'ve published to help other developers:',
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
            crossAxisCount: 2,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            itemCount: packages.length,
            itemBuilder: (context, index) {
              final package = packages[index];
              return AnimatedSection(
                id: 'package-tablet-$index',
                duration: Duration(milliseconds: 1200 + (index * 150)),
                startOffset: 40,
                child: _buildPackageCard(
                  context,
                  package: package,
                  isMobile: false,
                  index: index,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, List<dynamic> packages) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedSection(
            id: 'packages-title-desktop',
            child: Text(
              'My Packages',
              style: Theme.of(context).textTheme.displayLarge!.copyWith(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 15),
          AnimatedSection(
            id: 'packages-subtitle-desktop',
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
            id: 'packages-description-desktop',
            duration: const Duration(milliseconds: 1100),
            child: Text(
              'Open-source packages I\'ve published to help other developers:',
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
            itemCount: packages.length,
            itemBuilder: (context, index) {
              final package = packages[index];
              return AnimatedSection(
                id: 'package-desktop-$index',
                duration: Duration(milliseconds: 1200 + (index * 150)),
                startOffset: 40,
                child: _buildPackageCard(
                  context,
                  package: package,
                  isMobile: false,
                  index: index,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPackageCard(
      BuildContext context, {
        required Map<String, dynamic> package,
        required bool isMobile,
        required int index,
      }) {
    // Determine what platform icon to display
    final isPubDev = package['platform'].toString().contains('pub.dev');
    final icon = isPubDev ? 'flutter' : 'php';

    // Create platform badge style based on platform
    final platformColor = isPubDev
        ? const Color(0xFF0175C2) // Flutter blue for pub.dev
        : const Color(0xFF777BB3); // PHP purple for packagist

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _launchUrl(package['url']),
        child: Container(
          padding: EdgeInsets.all(isMobile ? 16 : 24),
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
            border: Border.all(
              color: Theme.of(context).dividerColor.withOpacity(0.1),
              width: 1.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row with package name and platform badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      package['name'],
                      style: TextStyle(
                        fontSize: isMobile ? 18 : 22,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.displayMedium!.color,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: platformColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getIconData(icon),
                          color: Colors.white,
                          size: 14,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          isPubDev ? 'pub.dev' : 'packagist',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Underline that uses gradient for visual appeal
              Container(
                height: 3,
                width: 50,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).colorScheme.secondary,
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(1.5),
                ),
              ),

              // Fixed height spacer instead of flexible Spacer
              SizedBox(height: isMobile ? 12 : 20),

              // Package URL in a styled display
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Theme.of(context).primaryColor.withOpacity(0.15),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.link,
                      size: 16,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _formatUrl(package['url']),
                        style: TextStyle(
                          fontSize: 13,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 15),

              // Bottom action button with animation
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _launchUrl(package['url']),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: const Icon(Icons.open_in_new, size: 16),
                  label: const Text(
                    'View Package',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ).animate(
                  onPlay: (controller) => controller.repeat(reverse: true),
                ).tint(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  duration: Duration(milliseconds: 1500 + (index * 500)),
                  curve: Curves.easeInOut,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper function to format URL for display
  String _formatUrl(String url) {
    // Remove https:// and www. prefixes for cleaner display
    return url.replaceAll('https://', '').replaceAll('www.', '');
  }

  // Launch the package URL when clicked
  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch $url');
      }
    } catch (e) {
      print('Error launching URL: $e');
    }
  }

  // Get icon data based on platform
  IconData _getIconData(String iconName) {
    switch (iconName.toLowerCase()) {
      case 'flutter':
        return Icons.flutter_dash;
      case 'php':
        return Icons.php;
      default:
        return Icons.code;
    }
  }
}