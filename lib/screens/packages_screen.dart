import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:portfolio_app/config/responsive.dart';
import 'package:portfolio_app/models/portfolio_data.dart';
import 'package:portfolio_app/widgets/reveal_on_scroll.dart';

class PackagesScreen extends StatelessWidget {
  final ScrollController? scrollController;
  const PackagesScreen({Key? key, this.scrollController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userData = PortfolioData.data;
    final packages = userData['packages'] as List<dynamic>;
    final isMobile = Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: SingleChildScrollView(
          controller: scrollController,
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 20 : (isTablet ? 40 : 100),
            vertical: 40,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Title
              Text(
                'My Packages',
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
                  gradient: LinearGradient(
                    colors: [Theme.of(context).primaryColor, Theme.of(context).colorScheme.secondary],
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ).animate().fadeIn(duration: 500.ms, delay: 100.ms),

              const SizedBox(height: 20),

              Text(
                'Open-source utilities, packages, and frameworks I have published to help the global developer community.',
                style: GoogleFonts.inter(
                  fontSize: isMobile ? 14 : 16,
                  height: 1.6,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white.withOpacity(0.6)
                      : Colors.black.withOpacity(0.6),
                ),
              ).animate().fadeIn(duration: 500.ms, delay: 200.ms),

              const SizedBox(height: 40),

              // Responsive Packages Grid
              MasonryGridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: isMobile ? 1 : (isTablet ? 2 : 3),
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                itemCount: packages.length,
                itemBuilder: (context, index) {
                  final package = packages[index];
                  return RevealOnScroll(
                    duration: const Duration(milliseconds: 500),
                    delay: Duration(milliseconds: index * 60),
                    slideFrom: const Offset(0, 20),
                    child: _PackageCard(package: package, index: index),
                  );
                },
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class _PackageCard extends StatefulWidget {
  final Map<String, dynamic> package;
  final int index;

  const _PackageCard({
    Key? key,
    required this.package,
    required this.index,
  }) : super(key: key);

  @override
  State<_PackageCard> createState() => _PackageCardState();
}

class _PackageCardState extends State<_PackageCard> with SingleTickerProviderStateMixin {
  bool _hovered = false;
  late AnimationController _ctrl;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 1.03).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch $url');
      }
    } catch (e) {
      debugPrint('Error launching URL: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isPubDev = widget.package['platform'].toString().contains('pub.dev');

    final platformColor = isPubDev
        ? const Color(0xFF0175C2) // Pub.dev blue
        : const Color(0xFF8892BF); // Packagist purpleish blue

    final cardBg = isDark 
        ? Colors.white.withOpacity(0.04) 
        : Colors.black.withOpacity(0.03);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        setState(() => _hovered = true);
        _ctrl.forward();
      },
      onExit: (_) {
        setState(() => _hovered = false);
        _ctrl.reverse();
      },
      child: ScaleTransition(
        scale: _scaleAnim,
        child: GestureDetector(
          onTap: () => _launchUrl(widget.package['url']),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: _hovered ? theme.primaryColor.withOpacity(0.05) : cardBg,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _hovered
                    ? theme.primaryColor.withOpacity(0.3)
                    : (isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.08)),
                width: 1.5,
              ),
              boxShadow: [
                if (_hovered)
                  BoxShadow(
                    color: theme.primaryColor.withOpacity(0.12),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Badge & Platform Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        widget.package['name'],
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: platformColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: platformColor.withOpacity(0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isPubDev ? Icons.flutter_dash_rounded : Icons.terminal_rounded,
                            color: platformColor,
                            size: 13,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            isPubDev ? 'pub.dev' : 'packagist',
                            style: GoogleFonts.plusJakartaSans(
                              color: platformColor,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                Container(
                  height: 3,
                  width: 45,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [theme.primaryColor, theme.colorScheme.secondary],
                    ),
                    borderRadius: BorderRadius.circular(1.5),
                  ),
                ),

                const SizedBox(height: 20),

                // Clean url indicator
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: theme.primaryColor.withOpacity(0.04),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: theme.primaryColor.withOpacity(0.1),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.link_rounded,
                        size: 15,
                        color: theme.primaryColor,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          widget.package['url']
                              .toString()
                              .replaceAll('https://', '')
                              .replaceAll('www.', ''),
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: theme.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Action Call Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _launchUrl(widget.package['url']),
                    icon: const Icon(Icons.open_in_new_rounded, size: 14),
                    label: const Text('View Package'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: _hovered ? theme.primaryColor : Colors.transparent,
                      foregroundColor: _hovered ? Colors.white : theme.primaryColor,
                      elevation: 0,
                      side: BorderSide(
                        color: _hovered ? Colors.transparent : theme.primaryColor.withOpacity(0.3),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}