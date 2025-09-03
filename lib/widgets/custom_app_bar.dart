import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:portfolio_app/config/responsive.dart';
import 'package:portfolio_app/providers/theme_provider.dart';
import 'package:provider/provider.dart';

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
    final isMobile = Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : (isTablet ? 30 : 50),
        vertical: isMobile ? 12 : 20,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.95),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: isMobile
          ? _buildMobileAppBar(context, themeProvider)
          : _buildDesktopAppBar(context, themeProvider, isTablet),
    );
  }

  Widget _buildMobileAppBar(BuildContext context, ThemeProvider themeProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Logo/Name
        GestureDetector(
          onTap: () => onTap(0), // Navigate to home
          child: Text(
            'HC',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          )
              .animate()
              .fadeIn(duration: 600.ms)
              .scale(begin: const Offset(0.8, 0.8)),
        ),

        Row(
          children: [
            // Theme toggle
            IconButton(
              onPressed: themeProvider.toggleTheme,
              icon: Icon(
                themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                color: Theme.of(context).primaryColor,
              ),
              tooltip: 'Toggle Theme',
            ),

            // Menu button
            PopupMenuButton<int>(
              onSelected: onTap,
              itemBuilder: (context) => List.generate(
                sections.length,
                    (index) => PopupMenuItem<int>(
                  value: index,
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: selectedIndex == index
                              ? Theme.of(context).primaryColor
                              : Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        sections[index],
                        style: TextStyle(
                          color: selectedIndex == index
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).textTheme.bodyLarge!.color,
                          fontWeight: selectedIndex == index
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              icon: Icon(
                Icons.menu_rounded,
                color: Theme.of(context).primaryColor,
                size: 28,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 8,
              offset: const Offset(0, 50),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDesktopAppBar(
      BuildContext context, ThemeProvider themeProvider, bool isTablet) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Logo/Name
        GestureDetector(
          onTap: () => onTap(0), // Navigate to home
          child: Text(
            'Hemant Chandra',
            style: TextStyle(
              fontSize: isTablet ? 20 : 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          )
              .animate()
              .fadeIn(duration: 600.ms)
              .scale(begin: const Offset(0.8, 0.8)),
        ),

        // Navigation items
        Row(
          children: [
            ...List.generate(sections.length, (index) {
              final isSelected = selectedIndex == index;
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: isTablet ? 8 : 12),
                child: GestureDetector(
                  onTap: () => onTap(index),
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: EdgeInsets.symmetric(
                        horizontal: isTablet ? 12 : 16,
                        vertical: isTablet ? 6 : 8,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Theme.of(context).primaryColor.withOpacity(0.1)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: isSelected
                              ? Theme.of(context).primaryColor.withOpacity(0.3)
                              : Colors.transparent,
                          width: 1.5,
                        ),
                      ),
                      child: Text(
                        sections[index],
                        style: TextStyle(
                          fontSize: isTablet ? 14 : 16,
                          color: isSelected
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).textTheme.bodyLarge!.color,
                          fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),
              )
                  .animate()
                  .fadeIn(delay: Duration(milliseconds: 100 * index), duration: 500.ms)
                  .slideX(begin: 0.3, end: 0);
            }),

            const SizedBox(width: 16),

            // Theme toggle
            Tooltip(
              message: 'Toggle Theme',
              child: GestureDetector(
                onTap: themeProvider.toggleTheme,
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Theme.of(context).primaryColor.withOpacity(0.2),
                        width: 1.5,
                      ),
                    ),
                    child: Icon(
                      themeProvider.isDarkMode
                          ? Icons.light_mode_rounded
                          : Icons.dark_mode_rounded,
                      color: Theme.of(context).primaryColor,
                      size: isTablet ? 20 : 22,
                    ),
                  ),
                ),
              )
                  .animate()
                  .fadeIn(delay: 800.ms, duration: 500.ms)
                  .scale(begin: const Offset(0.8, 0.8)),
            ),
          ],
        ),
      ],
    );
  }
}