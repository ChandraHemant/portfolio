import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/theme_provider.dart';
import '../config/responsive.dart';

class CustomAppBar extends StatefulWidget {
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
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isMobile = Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);

    return SafeArea(
      child: Container(
        height: 80,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 20 : (isTablet ? 40 : 50)
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Logo/Brand with hover animation
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => widget.onTap(0), // Navigate to Home
                  child: Row(
                    children: [
                      Container(
                        width: 80,
                        height: 40,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Theme.of(context).primaryColor,
                              Theme.of(context).colorScheme.secondary,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).primaryColor.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            'HTKC',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ).animate(
                        onPlay: (controller) => controller.repeat(reverse: true),
                      ).shimmer(
                        duration: 2000.ms,
                        curve: Curves.easeInOut,
                      ),
                      const SizedBox(width: 12),
                    ],
                  ),
                ),
              ),
              const Spacer(),

              // Show desktop navigation on desktop and tablet, but not on mobile
              if (!isMobile) ...[
                // Desktop/Tablet navigation with indicator
                Row(
                  children: List.generate(
                    widget.sections.length,
                        (index) => _buildNavItem(
                        context,
                        widget.sections[index],
                        index,
                        // Use smaller text and padding for tablet
                        isTablet: isTablet
                    ),
                  ),
                ),
                const SizedBox(width: 20),
              ],

              // Theme toggle button with animation
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    themeProvider.toggleTheme();
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: themeProvider.isDarkMode
                          ? Colors.amber.withOpacity(0.1)
                          : Colors.blueGrey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                      color: themeProvider.isDarkMode ? Colors.amber : Colors.blueGrey,
                      size: 22,
                    ),
                  ),
                ),
              ).animate(
                onPlay: (controller) => controller.repeat(reverse: true),
              ).scale(
                begin: const Offset(1.0, 1.0),
                end: const Offset(1.1, 1.1),
                duration: 2000.ms,
                curve: Curves.easeInOut,
              ),

              // Show mobile menu button only on mobile
              if (isMobile) ...[
                const SizedBox(width: 15),
                // Mobile menu button
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      _showMobileMenu(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.menu,
                        color: Theme.of(context).primaryColor,
                        size: 22,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, String title, int index, {bool isTablet = false}) {
    final isSelected = widget.selectedIndex == index;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isTablet ? 3 : 5),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => widget.onTap(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: EdgeInsets.symmetric(
                horizontal: isTablet ? 12 : 16,
                vertical: isTablet ? 8 : 10
            ),
            decoration: BoxDecoration(
              color: isSelected ? Theme.of(context).primaryColor.withOpacity(0.1) : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).textTheme.bodyLarge!.color,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    fontSize: isTablet ? 13 : 16,
                  ),
                ),
                const SizedBox(height: 5),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 3,
                  width: isSelected ? 30 : 0,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(1.5),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showMobileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.6,
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Bottom sheet handle/indicator
                  Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 10),
                    child: Container(
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(2.5),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Menu title
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Text(
                          'Navigation',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        const Spacer(),
                        // Close button
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close_rounded),
                          color: Theme.of(context).textTheme.bodyLarge!.color,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                  const Divider(),

                  // Menu items
                  Expanded(
                    child: ListView.builder(
                      itemCount: widget.sections.length,
                      itemBuilder: (context, index) {
                        final isSelected = widget.selectedIndex == index;

                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                          leading: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Theme.of(context).primaryColor
                                  : Theme.of(context).primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              _getSectionIcon(index),
                              color: isSelected ? Colors.white : Theme.of(context).primaryColor,
                              size: 22,
                            ),
                          ),
                          title: Text(
                            widget.sections[index],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                              color: isSelected
                                  ? Theme.of(context).primaryColor
                                  : Theme.of(context).textTheme.bodyLarge!.color,
                            ),
                          ),
                          onTap: () {
                            widget.onTap(index);
                            Navigator.pop(context);
                          },
                          minLeadingWidth: 10,
                          trailing: isSelected
                              ? Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Theme.of(context).primaryColor,
                            size: 16,
                          )
                              : null,
                        ).animate().fadeIn(duration: 300.ms, delay: Duration(milliseconds: 100 * index));
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  IconData _getSectionIcon(int index) {
    switch (index) {
      case 0:
        return Icons.home_rounded;
      case 1:
        return Icons.person_rounded;
      case 2:
        return Icons.code_rounded;
      case 3:
        return Icons.work_rounded;
      case 4:
        return Icons.widgets_rounded; // New icon for Packages section
      case 5:
        return Icons.mail_rounded;
      case 6:
        return Icons.download;
      default:
        return Icons.home_rounded;
    }
  }
}