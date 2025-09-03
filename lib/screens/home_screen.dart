import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio_app/config/app_router.dart';
import 'package:portfolio_app/config/responsive.dart';
import 'package:portfolio_app/models/portfolio_data.dart';
import 'package:portfolio_app/widgets/animated_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userData = PortfolioData.data;

    return Responsive.responsiveLayout(
      mobile: _buildMobileHomeLayout(context, userData),
      tablet: _buildTabletHomeLayout(context, userData),
      desktop: _buildDesktopHomeLayout(context, userData),
    );
  }

  Widget _buildMobileHomeLayout(BuildContext context, Map<String, dynamic> userData) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),

            // Profile image with animated border
            AnimatedSection(
              id: 'home-profile-mobile',
              animationType: AnimationType.fadeScale,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).primaryColor.withOpacity(0.2),
                      blurRadius: 30,
                      spreadRadius: 5,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Animated outer ring
                    Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).primaryColor,
                            Theme.of(context).colorScheme.secondary,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    )
                        .animate(
                      onPlay: (controller) =>
                          controller.repeat(reverse: true),
                    )
                        .scale(
                      begin: const Offset(1.0, 1.0),
                      end: const Offset(1.05, 1.05),
                      duration: 3000.ms,
                      curve: Curves.easeInOut,
                    ),

                    // Image
                    CircleAvatar(
                      radius: 75,
                      backgroundImage: AssetImage(userData['avatarUrl']),
                      backgroundColor: CupertinoColors.systemYellow,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Name with typing animation
            AnimatedSection(
              id: 'home-title-mobile',
              startOffset: 50,
              duration: const Duration(milliseconds: 1000),
              animationType: AnimationType.fadeSlideUp,
              child: Text(
                userData['name'],
                style: Theme.of(context).textTheme.displayMedium!.copyWith(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 12),

            // Role with emphasized primary color
            AnimatedSection(
              id: 'home-subtitle-mobile',
              startOffset: 50,
              duration: const Duration(milliseconds: 1200),
              animationType: AnimationType.fadeSlideUp,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.code,
                    color: Theme.of(context).primaryColor,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    userData['title'],
                    style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Description text with improved typography
            AnimatedSection(
              id: 'home-description-mobile',
              startOffset: 0,
              duration: const Duration(milliseconds: 1400),
              animationType: AnimationType.fadeSlideUp,
              child: Text(
                userData['about'],
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.7,
                  letterSpacing: 0.3,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 40),

            // Updated CTA row with two buttons
            AnimatedSection(
              id: 'home-cta-mobile',
              duration: const Duration(milliseconds: 1600),
              animationType: AnimationType.customBounce,
              child: Column(
                children: [
                  ElevatedButton.icon(
                    onPressed: () => context.go(AppRouter.projects),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    icon: Icon(Icons.work_rounded, size: 20, color: isDark ? Colors.black : Colors.white,),
                    label: const Text(
                      'See My Work',
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                      .animate(
                    onPlay: (controller) =>
                        controller.repeat(reverse: true),
                  )
                      .tint(
                    color: Theme.of(context).primaryColor.withOpacity(0.2),
                    duration: 2000.ms,
                    curve: Curves.easeInOut,
                  ),

                  const SizedBox(height: 15),

                  // New Packages button
                  OutlinedButton.icon(
                    onPressed: () => context.go(AppRouter.packages),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 16),
                      side: BorderSide(
                          color: Theme.of(context).primaryColor, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    icon: const Icon(Icons.widgets_rounded, size: 20),
                    label: const Text(
                      'My Packages',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // Contact button
                  OutlinedButton.icon(
                    onPressed: () => context.go(AppRouter.contact),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 16),
                      side: BorderSide(
                          color: Theme.of(context).colorScheme.secondary,
                          width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    icon: Icon(Icons.send_rounded, size: 20, color: Theme.of(context).colorScheme.secondary,),
                    label: Text(
                      'Contact Me',
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildTabletHomeLayout(BuildContext context, Map<String, dynamic> userData) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SingleChildScrollView(
      child: Container(
        constraints: const BoxConstraints(minHeight: 500),
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
        child: Row(
          children: [
            // Left column with text content
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated intro greeting
                  AnimatedSection(
                    id: 'home-greeting-tablet',
                    duration: const Duration(milliseconds: 800),
                    animationType: AnimationType.fadeSlideIn,
                    child: Row(
                      children: [
                        Container(
                          width: 30,
                          height: 2,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Hello, I am',
                          style: TextStyle(
                            fontSize: 22,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Name with large display
                  AnimatedSection(
                    id: 'home-name-tablet',
                    duration: const Duration(milliseconds: 1000),
                    animationType: AnimationType.fadeSlideIn,
                    child: Text(
                      userData['name'],
                      style: Theme.of(context).textTheme.displayLarge!.copyWith(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                        height: 1.1,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Title with accent color
                  AnimatedSection(
                    id: 'home-title-tablet',
                    duration: const Duration(milliseconds: 1200),
                    animationType: AnimationType.fadeSlideIn,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 7),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color:
                          Theme.of(context).primaryColor.withOpacity(0.3),
                          width: 1.5,
                        ),
                      ),
                      child: Text(
                        userData['title'],
                        style: TextStyle(
                          fontSize: 18,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // About text with improved readability
                  AnimatedSection(
                    id: 'home-about-tablet',
                    duration: const Duration(milliseconds: 1400),
                    animationType: AnimationType.fadeSlideIn,
                    child: SizedBox(
                      width: double.infinity,
                      child: Text(
                        userData['about'],
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.7,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Call-to-action buttons
                  AnimatedSection(
                    id: 'home-cta-tablet',
                    duration: const Duration(milliseconds: 1600),
                    animationType: AnimationType.fadeSlideIn,
                    child: Row(
                      children: [
                        // Primary CTA
                        ElevatedButton.icon(
                          onPressed: () => context.go(AppRouter.projects),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          icon: Icon(Icons.visibility, size: 18, color: isDark ? Colors.black : Colors.white,),
                          label: const Text(
                            'See My Work',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                        )
                            .animate(
                          onPlay: (controller) =>
                              controller.repeat(reverse: true),
                        )
                            .tint(
                          color: Theme.of(context)
                              .primaryColor
                              .withOpacity(0.2),
                          duration: 2000.ms,
                          curve: Curves.easeInOut,
                        ),

                        const SizedBox(width: 16),

                        // New Packages CTA
                        OutlinedButton.icon(
                          onPressed: () => context.go(AppRouter.packages),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
                            side: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          icon: const Icon(Icons.widgets_rounded, size: 18),
                          label: Text(
                            'My Packages',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),

                        const SizedBox(width: 16),

                        // Contact button
                        OutlinedButton.icon(
                          onPressed: () => context.go(AppRouter.contact),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 16),
                            side: BorderSide(
                                color: Theme.of(context).colorScheme.secondary,
                                width: 2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          icon: Icon(Icons.send_rounded, size: 18, color: Theme.of(context).colorScheme.secondary,),
                          label: Text(
                            'Contact Me',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Right column with profile image
            Expanded(
              flex: 2,
              child: Center(
                child: AnimatedSection(
                  id: 'home-profile-tablet',
                  startOffset: 80,
                  animationType: AnimationType.fadeScale,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color:
                          Theme.of(context).primaryColor.withOpacity(0.25),
                          blurRadius: 40,
                          spreadRadius: 4,
                          offset: const Offset(0, 15),
                        ),
                      ],
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Animated gradient border
                        Container(
                          width: 250,
                          height: 250,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                Theme.of(context).primaryColor,
                                Theme.of(context).colorScheme.secondary,
                                Theme.of(context).primaryColor.withOpacity(0.8),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                        )
                            .animate(
                          onPlay: (controller) =>
                              controller.repeat(reverse: true),
                        )
                            .scale(
                          begin: const Offset(1.0, 1.0),
                          end: const Offset(1.05, 1.05),
                          duration: 3000.ms,
                          curve: Curves.easeInOut,
                        ),

                        // White inner circle
                        Container(
                          width: 230,
                          height: 230,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).scaffoldBackgroundColor,
                          ),
                        ),

                        // Profile image
                        CircleAvatar(
                          radius: 110,
                          backgroundImage: AssetImage(userData['avatarUrl']),
                          backgroundColor: CupertinoColors.systemYellow,
                        ),

                        // Floating particles animation
                        Positioned(
                          right: 30,
                          top: 50,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          )
                              .animate(
                            onPlay: (controller) =>
                                controller.repeat(reverse: true),
                          )
                              .moveY(
                            begin: 0,
                            end: 15,
                            duration: 2000.ms,
                            curve: Curves.easeInOut,
                          )
                              .fadeIn(duration: 500.ms)
                              .fadeOut(delay: 1500.ms),
                        ),

                        Positioned(
                          left: 40,
                          bottom: 60,
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).primaryColor,
                            ),
                          )
                              .animate(
                            onPlay: (controller) =>
                                controller.repeat(reverse: true),
                          )
                              .moveY(
                            begin: 0,
                            end: -20,
                            duration: 2500.ms,
                            curve: Curves.easeInOut,
                          )
                              .fadeIn(duration: 500.ms)
                              .fadeOut(delay: 2000.ms),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopHomeLayout(BuildContext context, Map<String, dynamic> userData) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // Updated desktop layout with Packages navigation
    return SingleChildScrollView(
      child: Container(
        constraints: const BoxConstraints(minHeight: 600),
        padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 60),
        child: Row(
          children: [
            // Left column with text content
            Expanded(
              flex: 6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated intro greeting
                  AnimatedSection(
                    id: 'home-greeting-desktop',
                    duration: const Duration(milliseconds: 800),
                    animationType: AnimationType.fadeSlideIn,
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 2,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Hello, I am',
                          style: TextStyle(
                            fontSize: 24,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 15),

                  // Name with large display
                  AnimatedSection(
                    id: 'home-name-desktop',
                    duration: const Duration(milliseconds: 1000),
                    animationType: AnimationType.fadeSlideIn,
                    child: Text(
                      userData['name'],
                      style: Theme.of(context).textTheme.displayLarge!.copyWith(
                        fontSize: 65,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                        height: 1.1,
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // Title with accent color
                  AnimatedSection(
                    id: 'home-title-desktop',
                    duration: const Duration(milliseconds: 1200),
                    animationType: AnimationType.fadeSlideIn,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color:
                          Theme.of(context).primaryColor.withOpacity(0.3),
                          width: 1.5,
                        ),
                      ),
                      child: Text(
                        userData['title'],
                        style: TextStyle(
                          fontSize: 22,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // About text with improved readability
                  AnimatedSection(
                    id: 'home-about-desktop',
                    duration: const Duration(milliseconds: 1400),
                    animationType: AnimationType.fadeSlideIn,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: Text(
                        userData['about'],
                        style: const TextStyle(
                          fontSize: 18,
                          height: 1.7,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Call-to-action buttons
                  AnimatedSection(
                    id: 'home-cta-desktop',
                    duration: const Duration(milliseconds: 1600),
                    animationType: AnimationType.fadeSlideIn,
                    child: Row(
                      children: [
                        // Primary CTA - Projects
                        ElevatedButton.icon(
                          onPressed: () => context.go(AppRouter.projects),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          icon: Icon(Icons.visibility, size: 20, color: isDark ? Colors.black : Colors.white,),
                          label: const Text(
                            'See My Work',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        )
                            .animate(
                          onPlay: (controller) =>
                              controller.repeat(reverse: true),
                        )
                            .tint(
                          color: Theme.of(context)
                              .primaryColor
                              .withOpacity(0.2),
                          duration: 2000.ms,
                          curve: Curves.easeInOut,
                        ),

                        const SizedBox(width: 20),

                        // Packages CTA
                        OutlinedButton.icon(
                          onPressed: () => context.go(AppRouter.packages),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 18),
                            side: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          icon: const Icon(Icons.widgets_rounded, size: 20),
                          label: Text(
                            'My Packages',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),

                        const SizedBox(width: 20),

                        // Contact CTA
                        OutlinedButton.icon(
                          onPressed: () => context.go(AppRouter.contact),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 18),
                            side: BorderSide(
                                color: Theme.of(context).colorScheme.secondary,
                                width: 2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          icon: Icon(Icons.send_rounded, size: 20, color: Theme.of(context).colorScheme.secondary,),
                          label: Text(
                            'Contact Me',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Right column with profile image
            Expanded(
              flex: 4,
              child: Center(
                child: AnimatedSection(
                  id: 'home-profile-desktop',
                  startOffset: 100,
                  animationType: AnimationType.fadeScale,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color:
                          Theme.of(context).primaryColor.withOpacity(0.25),
                          blurRadius: 50,
                          spreadRadius: 5,
                          offset: const Offset(0, 15),
                        ),
                      ],
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Animated gradient border
                        Container(
                          width: 350,
                          height: 350,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                Theme.of(context).primaryColor,
                                Theme.of(context).colorScheme.secondary,
                                Theme.of(context).primaryColor.withOpacity(0.8),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                        )
                            .animate(
                          onPlay: (controller) =>
                              controller.repeat(reverse: true),
                        )
                            .scale(
                          begin: const Offset(1.0, 1.0),
                          end: const Offset(1.05, 1.05),
                          duration: 3000.ms,
                          curve: Curves.easeInOut,
                        ),

                        // White inner circle
                        Container(
                          width: 320,
                          height: 320,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).scaffoldBackgroundColor,
                          ),
                        ),

                        // Profile image
                        CircleAvatar(
                          radius: 150,
                          backgroundImage: AssetImage(userData['avatarUrl']),
                          backgroundColor: CupertinoColors.systemYellow,
                        ),

                        // Floating particles animation
                        Positioned(
                          right: 30,
                          top: 50,
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          )
                              .animate()
                              .animate(
                            onPlay: (controller) =>
                                controller.repeat(reverse: true),
                          )
                              .moveY(
                            begin: 0,
                            end: 20,
                            duration: 2000.ms,
                            curve: Curves.easeInOut,
                          )
                              .fadeIn(duration: 500.ms)
                              .fadeOut(delay: 1500.ms),
                        ),

                        Positioned(
                          left: 40,
                          bottom: 60,
                          child: Container(
                            width: 15,
                            height: 15,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).primaryColor,
                            ),
                          )
                              .animate(
                            onPlay: (controller) =>
                                controller.repeat(reverse: true),
                          )
                              .moveY(
                            begin: 0,
                            end: -30,
                            duration: 2500.ms,
                            curve: Curves.easeInOut,
                          )
                              .fadeIn(duration: 500.ms)
                              .fadeOut(delay: 2000.ms),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}