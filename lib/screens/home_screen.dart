import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio_app/config/app_router.dart';
import 'package:portfolio_app/config/responsive.dart';
import 'package:portfolio_app/models/portfolio_data.dart';
import 'package:portfolio_app/widgets/animated_profile_avatar.dart';


class HomeScreen extends StatelessWidget {
  final ScrollController? scrollController;
  const HomeScreen({Key? key, this.scrollController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userData = PortfolioData.data;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Background subtle ambient glows
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).primaryColor.withOpacity(0.08),
              ),
            ).animate(onPlay: (c) => c.repeat(reverse: true))
             .scale(begin: const Offset(1, 1), end: const Offset(1.2, 1.2), duration: 4000.ms, curve: Curves.easeInOut),
          ),
          Positioned(
            bottom: -50,
            left: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.secondary.withOpacity(0.06),
              ),
            ).animate(onPlay: (c) => c.repeat(reverse: true))
             .scale(begin: const Offset(1, 1), end: const Offset(1.15, 1.15), duration: 3500.ms, curve: Curves.easeInOut),
          ),

          // Main Layout
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                controller: scrollController,
                child: Responsive.responsiveLayout(
                  mobile: _buildContent(context, userData, isMobile: true, isTablet: false),
                  tablet: _buildContent(context, userData, isMobile: false, isTablet: true),
                  desktop: _buildContent(context, userData, isMobile: false, isTablet: false),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(
    BuildContext context, 
    Map<String, dynamic> userData, 
    {required bool isMobile, required bool isTablet}
  ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final avatar = AnimatedProfileAvatar(
      imageUrl: userData['avatarUrl'],
      radius: isMobile ? 120 : 220,
    ).animate()
     .fadeIn(duration: 800.ms, curve: Curves.easeOut)
     .scale(begin: const Offset(0.9, 0.9), duration: 800.ms, curve: Curves.elasticOut);

    final introSubtitle = Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: theme.primaryColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: theme.primaryColor.withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.bolt_rounded,
            color: theme.primaryColor,
            size: 16,
          ),
          const SizedBox(width: 6),
          Text(
            userData['title'].toUpperCase(),
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: theme.primaryColor,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    ).animate()
     .fadeIn(duration: 500.ms, delay: 100.ms)
     .slideY(begin: 0.2, end: 0);

    final titleHeader = Text(
      userData['name'],
      style: GoogleFonts.plusJakartaSans(
        fontSize: isMobile ? 36 : (isTablet ? 48 : 64),
        fontWeight: FontWeight.w800,
        letterSpacing: -1.5,
        color: isDark ? Colors.white : Colors.black,
      ),
      textAlign: isMobile ? TextAlign.center : TextAlign.start,
    ).animate()
     .fadeIn(duration: 600.ms, delay: 200.ms)
     .slideY(begin: 0.15, end: 0);

    final aboutText = Text(
      userData['about'],
      style: GoogleFonts.inter(
        fontSize: isMobile ? 15 : 17,
        height: 1.75,
        color: isDark ? Colors.white.withOpacity(0.65) : Colors.black.withOpacity(0.65),
      ),
      textAlign: isMobile ? TextAlign.center : TextAlign.start,
    ).animate()
     .fadeIn(duration: 600.ms, delay: 300.ms)
     .slideY(begin: 0.1, end: 0);

    final ctas = Wrap(
      spacing: 12,
      runSpacing: 12,
      alignment: isMobile ? WrapAlignment.center : WrapAlignment.start,
      children: [
        ElevatedButton.icon(
          onPressed: () => context.go(AppRouter.projects),
          icon: const Icon(Icons.arrow_forward_rounded, size: 18),
          label: const Text('Explore Work'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 18),
          ),
        ),
        OutlinedButton.icon(
          onPressed: () => context.go(AppRouter.packages),
          icon: const Icon(Icons.widgets_outlined, size: 18),
          label: const Text('Open Source'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 18),
          ),
        ),
        OutlinedButton.icon(
          onPressed: () => context.go(AppRouter.contact),
          icon: const Icon(Icons.mail_outline_rounded, size: 18),
          label: const Text('Get In Touch'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 18),
          ),
        ),
      ],
    ).animate()
     .fadeIn(duration: 600.ms, delay: 450.ms)
     .scale(begin: const Offset(0.96, 0.96));

    if (isMobile) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            avatar,
            const SizedBox(height: 32),
            introSubtitle,
            const SizedBox(height: 16),
            titleHeader,
            const SizedBox(height: 16),
            aboutText,
            const SizedBox(height: 32),
            ctas,
          ],
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 40 : 100, 
        vertical: 60
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                introSubtitle,
                const SizedBox(height: 20),
                titleHeader,
                const SizedBox(height: 20),
                aboutText,
                const SizedBox(height: 36),
                ctas,
              ],
            ),
          ),
          const SizedBox(width: 40),
          Expanded(
            flex: 4,
            child: Center(child: avatar),
          ),
        ],
      ),
    );
  }
}