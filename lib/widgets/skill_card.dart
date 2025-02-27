import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SkillCard extends StatefulWidget {
  final String name;
  final double level;
  final String icon;
  final bool isAnimated;
  final int index;

  const SkillCard({
    Key? key,
    required this.name,
    required this.level,
    required this.icon,
    this.isAnimated = true,
    this.index = 0,
  }) : super(key: key);

  @override
  State<SkillCard> createState() => _SkillCardState();
}

class _SkillCardState extends State<SkillCard> with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _controller;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: widget.level,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(0.2, 1.0, curve: Curves.easeOutCubic),
    ));

    // Auto start animation with a slight delay based on index
    Future.delayed(Duration(milliseconds: 500 + (widget.index * 100)), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: _isHovered
              ? Theme.of(context).primaryColor.withOpacity(0.05)
              : Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: _isHovered
                  ? Theme.of(context).primaryColor.withOpacity(0.2)
                  : Colors.black.withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
          border: Border.all(
            color: _isHovered
                ? Theme.of(context).primaryColor.withOpacity(0.3)
                : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon and name row
            Row(
              children: [
                // Animated icon container
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _isHovered
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    _getIconData(widget.icon),
                    color: _isHovered
                        ? Colors.white
                        : Theme.of(context).primaryColor,
                    size: 24,
                  ),
                ).animate(target: _isHovered ? 1 : 0)
                    .rotate(duration: 400.ms, begin: 0, end: 0.05)
                    .then(delay: 200.ms)
                    .rotate(duration: 400.ms, begin: 0.05, end: -0.05)
                    .then(delay: 200.ms)
                    .rotate(duration: 400.ms, begin: -0.05, end: 0),
                const SizedBox(width: 16),

                // Skill name with animated color
                Text(
                  widget.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _isHovered
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).textTheme.displayMedium!.color,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Animated progress bar
            LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Progress bar container
                    Container(
                      height: 10,
                      width: width,
                      decoration: BoxDecoration(
                        color: Theme.of(context).dividerColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) {
                          return Stack(
                            children: [
                              // Main progress fill
                              Container(
                                height: 10,
                                width: width * _progressAnimation.value,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Theme.of(context).primaryColor,
                                      Theme.of(context).primaryColor.withOpacity(0.8),
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Theme.of(context).primaryColor.withOpacity(0.3),
                                      blurRadius: 6,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                              ),

                              // Animated shine effect
                              if (_progressAnimation.value > 0.2)
                                Positioned(
                                  left: (width * _progressAnimation.value) - 20,
                                  child: Container(
                                    height: 10,
                                    width: 20,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.white.withOpacity(0.0),
                                          Colors.white.withOpacity(0.5),
                                          Colors.white.withOpacity(0.0),
                                        ],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                      ),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ).animate(
                                    onPlay: (controller) => controller.repeat(),
                                  ).moveX(
                                    begin: -20,
                                    end: 40,
                                    duration: 1500.ms,
                                    curve: Curves.easeInOut,
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Percentage indicator
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Proficiency',
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.7),
                          ),
                        ),
                        AnimatedBuilder(
                          animation: _controller,
                          builder: (context, child) {
                            return Text(
                              '${(_progressAnimation.value * 100).toInt()}%',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName.toLowerCase()) {
      case 'flutter':
        return Icons.flutter_dash;
      case 'dart':
        return Icons.code;
      case 'firebase':
        return Icons.whatshot;
      case 'php':
        return Icons.php;
      case 'javascript':
        return Icons.javascript;
      case 'html':
        return Icons.html;
      case 'database':
        return Icons.storage;
      case 'api':
        return Icons.api;
      case 'web':
        return Icons.web;
      case 'code':
        return Icons.code;
      default:
        return Icons.code;
    }
  }
}