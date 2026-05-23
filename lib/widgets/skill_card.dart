import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
      duration: const Duration(milliseconds: 1000),
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: widget.level,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutQuart,
    ));

    Future.delayed(Duration(milliseconds: 200 + (widget.index * 60)), () {
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final cardBg = isDark 
        ? Colors.white.withOpacity(0.04) 
        : Colors.black.withOpacity(0.03);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: _isHovered
              ? theme.primaryColor.withOpacity(0.06)
              : cardBg,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            if (_isHovered)
              BoxShadow(
                color: theme.primaryColor.withOpacity(0.12),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
          ],
          border: Border.all(
            color: _isHovered
                ? theme.primaryColor.withOpacity(0.3)
                : (isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.08)),
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: _isHovered
                        ? theme.primaryColor
                        : theme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getIconData(widget.icon),
                    color: _isHovered
                        ? Colors.white
                        : theme.primaryColor,
                    size: 20,
                  ),
                ).animate(target: _isHovered ? 1 : 0)
                 .rotate(duration: 300.ms, begin: 0, end: 0.05)
                 .then()
                 .rotate(duration: 300.ms, begin: 0.05, end: 0),
                const SizedBox(width: 16),
                
                Text(
                  widget.name,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 18),
            
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Custom progress bar indicator
                Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Row(
                        children: [
                          Expanded(
                            flex: (_progressAnimation.value * 1000).toInt(),
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    theme.primaryColor,
                                    theme.colorScheme.secondary,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: ((1.0 - _progressAnimation.value) * 1000).toInt(),
                            child: const SizedBox(),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                
                const SizedBox(height: 10),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Proficiency',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: isDark ? Colors.white.withOpacity(0.5) : Colors.black.withOpacity(0.5),
                      ),
                    ),
                    AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return Text(
                          '${(_progressAnimation.value * 100).toInt()}%',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: theme.primaryColor,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate()
     .fadeIn(duration: 400.ms, delay: Duration(milliseconds: widget.index * 50))
     .slideY(begin: 0.1, end: 0, duration: 400.ms, curve: Curves.easeOutQuad);
  }

  IconData _getIconData(String iconName) {
    switch (iconName.toLowerCase()) {
      case 'flutter':
        return Icons.flutter_dash_rounded;
      case 'dart':
        return Icons.code_rounded;
      case 'firebase':
        return Icons.whatshot_rounded;
      case 'php':
        return Icons.terminal_rounded;
      case 'javascript':
        return Icons.javascript_rounded;
      case 'html':
        return Icons.html_rounded;
      case 'database':
        return Icons.storage_rounded;
      case 'api':
        return Icons.api_rounded;
      case 'web':
        return Icons.language_rounded;
      case 'code':
        return Icons.code_rounded;
      default:
        return Icons.star_rounded;
    }
  }
}