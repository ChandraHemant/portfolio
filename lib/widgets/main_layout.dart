import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio_app/config/app_router.dart';
import 'package:portfolio_app/widgets/custom_app_bar.dart';

class MainLayout extends StatefulWidget {
  final Widget child;

  const MainLayout({Key? key, required this.child}) : super(key: key);

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  final List<String> _sections = [
    'Home',
    'About',
    'Skills',
    'Projects',
    'Packages',
    'Contact',
    'My Resume'
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // Add a delay for initial animations
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _navigateToPage(int index) {
    final location = AppRouter.getLocationFromIndex(index);
    context.go(location);
  }

  int get _currentIndex {
    final location = GoRouterState.of(context).matchedLocation;
    return AppRouter.getIndexFromLocation(location);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Custom app bar with animated reveal
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, -50 * (1 - _animationController.value)),
                child: Opacity(
                  opacity: _animationController.value,
                  child: CustomAppBar(
                    onTap: _navigateToPage,
                    selectedIndex: _currentIndex,
                    sections: _sections,
                  ),
                ),
              );
            },
          ),

          // Main content area
          Expanded(
            child: widget.child,
          ),
        ],
      ),
    );
  }
}