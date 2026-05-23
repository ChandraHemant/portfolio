import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio_app/config/app_router.dart';
import 'package:portfolio_app/config/responsive.dart';
import 'package:portfolio_app/widgets/custom_app_bar.dart';
import 'package:portfolio_app/widgets/animated_background_bubbles.dart';

// Screens imports to render sequentially
import 'package:portfolio_app/screens/home_screen.dart';
import 'package:portfolio_app/screens/about_screen.dart';
import 'package:portfolio_app/screens/skills_screen.dart';
import 'package:portfolio_app/screens/projects_screen.dart';
import 'package:portfolio_app/screens/packages_screen.dart';
import 'package:portfolio_app/screens/contact_screen.dart';
import 'package:portfolio_app/screens/portfolio_screen.dart';

class MainLayout extends StatefulWidget {
  final Widget child;

  const MainLayout({Key? key, required this.child}) : super(key: key);

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late PageController _pageController;
  late List<ScrollController> _scrollControllers;
  bool _isControllerInitialized = false;
  bool _isProgrammaticNavigation = false;

  final List<String> _sections = [
    'Home',
    'Experience',
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

    // Initialize one ScrollController for each section to handle boundary snapping
    _scrollControllers = List.generate(7, (index) => ScrollController());

    // Add a delay for initial animations
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _animationController.forward();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize the page controller once with the correct index based on route location
    if (!_isControllerInitialized) {
      final currentIndex = _currentIndex;
      _pageController = PageController(initialPage: currentIndex);
      _isControllerInitialized = true;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    for (var controller in _scrollControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  bool _isScrolling = false;

  void _handleScrollSignal(PointerSignalEvent event) {
    if (event is PointerScrollEvent) {
      if (_isScrolling) return;

      final double dy = event.scrollDelta.dy;
      if (dy.abs() < 30) return; // Debounce very small trackpad/wheel ticks

      final int currentIndex = _currentIndex;
      final currentController = _scrollControllers[currentIndex];

      // Check if we should scroll the page internally or trigger a PageView transition
      if (dy > 0) {
        // Scroll down
        if (currentController.hasClients) {
          // If the page is not yet scrolled to the bottom (using a 15px threshold)
          if (currentController.position.pixels < currentController.position.maxScrollExtent - 15) {
            // Let the child SingleChildScrollView scroll internally; do NOT transition page
            return;
          }
        }
        
        // We are at the bottom of the page -> snap to the next page
        final int nextIndex = currentIndex + 1;
        if (nextIndex < _sections.length) {
          _isScrolling = true;
          _navigateToPage(nextIndex);
          Future.delayed(const Duration(milliseconds: 1000), () {
            _isScrolling = false;
          });
        }
      } else {
        // Scroll up
        if (currentController.hasClients) {
          // If the page is not yet scrolled to the top (using a 15px threshold)
          if (currentController.position.pixels > 15) {
            // Let the child SingleChildScrollView scroll internally; do NOT transition page
            return;
          }
        }

        // We are at the top of the page -> snap to the previous page
        final int prevIndex = currentIndex - 1;
        if (prevIndex >= 0) {
          _isScrolling = true;
          _navigateToPage(prevIndex);
          Future.delayed(const Duration(milliseconds: 1000), () {
            _isScrolling = false;
          });
        }
      }
    }
  }

  // Triggered when a nav link / action is tapped in the custom AppBar
  void _navigateToPage(int index) {
    if (_currentIndex == index) return;

    setState(() {
      _isProgrammaticNavigation = true;
    });

    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOutCubic,
    ).then((_) {
      if (mounted) {
        setState(() {
          _isProgrammaticNavigation = false;
        });
      }
    });

    final location = AppRouter.getLocationFromIndex(index);
    context.go(location);
  }

  // Triggered when user manually swipes / scrolls between pages in vertical PageView
  void _onPageChanged(int index) {
    if (_isProgrammaticNavigation) return;
    
    final location = AppRouter.getLocationFromIndex(index);
    context.go(location);
  }

  int get _currentIndex {
    final location = GoRouterState.of(context).matchedLocation;
    return AppRouter.getIndexFromLocation(location);
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _currentIndex;
    final isMobile = Responsive.isMobile(context);

    // Keep page controller synchronized with external browser URL transitions
    if (_isControllerInitialized && 
        _pageController.hasClients && 
        _pageController.page?.round() != currentIndex && 
        !_isProgrammaticNavigation) {
      _pageController.jumpToPage(currentIndex);
    }

    final List<Widget> pages = [
      HomeScreen(scrollController: _scrollControllers[0]),
      AboutScreen(scrollController: _scrollControllers[1]),
      SkillsScreen(scrollController: _scrollControllers[2]),
      ProjectsScreen(scrollController: _scrollControllers[3]),
      PackagesScreen(scrollController: _scrollControllers[4]),
      ContactScreen(scrollController: _scrollControllers[5]),
      PortfolioScreen(scrollController: _scrollControllers[6]),
    ];

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Slow floating glowing ambient gradient bubbles
          const AnimatedBackgroundBubbles(),

          // Foreground Layout
          Column(
            children: [
              // Custom app bar with floating rounded dock design and animated reveal
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, -50 * (1 - _animationController.value)),
                    child: Opacity(
                      opacity: _animationController.value,
                      child: CustomAppBar(
                        onTap: _navigateToPage,
                        selectedIndex: currentIndex,
                        sections: _sections,
                      ),
                    ),
                  );
                },
              ),

              // Main content area - dynamic vertical PageView scroll page-snapper
              Expanded(
                child: Listener(
                  onPointerSignal: _handleScrollSignal,
                  child: PageView(
                    scrollDirection: Axis.vertical,
                    controller: _pageController,
                    physics: isMobile
                        ? const ClampingScrollPhysics()
                        : const NeverScrollableScrollPhysics(), // Premium smooth snapping on desktop
                    onPageChanged: _onPageChanged,
                    children: pages,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}