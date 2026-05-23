import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio_app/config/responsive.dart';
import 'package:portfolio_app/config/theme.dart';
import 'package:portfolio_app/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CustomAppBar extends StatelessWidget {
  final Function(int) onTap;
  final int selectedIndex;
  final List<String> sections;

  const CustomAppBar({
    Key? key,
    required this.onTap,
    required this.selectedIndex,
    required this.sections,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = Theme.of(context);
    final isDark = themeProvider.isDarkMode;
    final isMobile = Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);

    // The first 6 sections will be center nav pills (Home, About, Skills, Projects, Packages, Contact)
    // Index 6 (Resume) is built as the prominent dark action button on the far right
    final navSections = sections.take(6).toList();

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: EdgeInsets.only(
          top: 12,
          left: isMobile ? 12 : 24,
          right: isMobile ? 12 : 24,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(40),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 12 : 20,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: isDark 
                    ? const Color(0xFF18181B).withOpacity(0.65) // Modern dark zinc glass
                    : Colors.white.withOpacity(0.85), // Sleek light glass
                borderRadius: BorderRadius.circular(40),
                border: Border.all(
                  color: isDark 
                      ? Colors.white.withOpacity(0.08) 
                      : Colors.black.withOpacity(0.08),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
                    blurRadius: 24,
                    spreadRadius: 2,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Left Side Logo / Branding (Initials Avatar + Developer Name + Tech Subtitle)
                  GestureDetector(
                    onTap: () => onTap(0),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Row(
                        children: [
                          // Gradient Initials Circle Avatar ( AP / HC shape in reference )
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  theme.primaryColor,
                                  theme.colorScheme.secondary,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: theme.primaryColor.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'HC',
                              style: GoogleFonts.plusJakartaSans(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          if (!isMobile)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Hemant Chandra',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    color: isDark ? Colors.white : Colors.black,
                                    letterSpacing: -0.2,
                                  ),
                                ),
                                const SizedBox(height: 1),
                                Text(
                                  'Flutter • Node.js • GIS',
                                  style: GoogleFonts.inter(
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w600,
                                    color: isDark 
                                        ? Colors.white.withOpacity(0.5) 
                                        : Colors.black.withOpacity(0.5),
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ).animate().fadeIn(duration: 500.ms).slideX(begin: -0.15, end: 0),

                  // Center/Right Navigation Section
                  Row(
                    children: [
                      if (!isMobile)
                        Row(
                          children: List.generate(navSections.length, (index) {
                            final isSelected = selectedIndex == index;
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 2),
                              child: GestureDetector(
                                onTap: () => onTap(index),
                                child: MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? theme.primaryColor // Vivid blue selected pill
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      navSections[index],
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 13,
                                        fontWeight: isSelected
                                            ? FontWeight.w700
                                            : FontWeight.w600,
                                        color: isSelected
                                            ? Colors.white
                                            : (isDark
                                                ? Colors.white.withOpacity(0.7)
                                                : Colors.black.withOpacity(0.65)),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ).animate().fadeIn(duration: 500.ms),

                      const SizedBox(width: 8),

                      // Theme mode toggle icon
                      GestureDetector(
                        onTap: themeProvider.toggleTheme,
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isDark 
                                  ? Colors.white.withOpacity(0.04) 
                                  : Colors.black.withOpacity(0.04),
                            ),
                            child: Icon(
                              isDark
                                  ? Icons.light_mode_rounded
                                  : Icons.dark_mode_rounded,
                              color: theme.primaryColor,
                              size: 16,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 8),

                      // Prominent dark slate "Resume" CTA pill button
                      GestureDetector(
                        onTap: () => onTap(6), // Smooth scroll directly to PDF Resume screen
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: selectedIndex == 6
                                  ? theme.primaryColor
                                  : (isDark 
                                      ? Colors.white.withOpacity(0.12) 
                                      : const Color(0xFF0F172A)), // Deep premium dark slate
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                if (selectedIndex != 6)
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.15),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                              ],
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.download_rounded,
                                  color: Colors.white,
                                  size: 14,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Resume',
                                  style: GoogleFonts.plusJakartaSans(
                                    color: Colors.white,
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ).animate().fadeIn(duration: 500.ms).scale(begin: const Offset(0.9, 0.9)),

                      if (isMobile) ...[
                        const SizedBox(width: 6),
                        // Mobile dropdown navigation
                        PopupMenuButton<int>(
                          onSelected: onTap,
                          icon: Icon(
                            Icons.menu_rounded,
                            color: isDark ? Colors.white : Colors.black,
                            size: 22,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(
                              color: theme.dividerColor.withOpacity(0.4),
                              width: 1.5,
                            ),
                          ),
                          color: isDark ? const Color(0xFF18181B) : Colors.white,
                          elevation: 4,
                          offset: const Offset(0, 48),
                          itemBuilder: (context) => List.generate(
                            sections.length,
                            (index) => PopupMenuItem<int>(
                              value: index,
                              child: Row(
                                children: [
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: selectedIndex == index
                                          ? theme.primaryColor
                                          : Colors.transparent,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    sections[index],
                                    style: GoogleFonts.plusJakartaSans(
                                      color: selectedIndex == index
                                          ? theme.primaryColor
                                          : (isDark ? Colors.white : Colors.black),
                                      fontWeight: selectedIndex == index
                                          ? FontWeight.w700
                                          : FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}