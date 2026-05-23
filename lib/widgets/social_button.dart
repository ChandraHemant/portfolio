import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SocialButton extends StatefulWidget {
  final String name;
  final String url;
  final String icon;
  final int index;

  const SocialButton({
    Key? key,
    required this.name,
    required this.url,
    required this.icon,
    this.index = 0,
  }) : super(key: key);

  @override
  State<SocialButton> createState() => _SocialButtonState();
}

class _SocialButtonState extends State<SocialButton> with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 180),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.04,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _launchUrl() async {
    final Uri uri = Uri.parse(widget.url);
    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch ${widget.url}');
      }
    } catch (e) {
      debugPrint('Error launching URL: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final baseBg = isDark 
        ? Colors.white.withOpacity(0.04) 
        : Colors.black.withOpacity(0.03);
    
    final hoverBg = theme.primaryColor;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: MouseRegion(
            onEnter: (_) {
              setState(() => _isHovered = true);
              _controller.forward();
            },
            onExit: (_) {
              setState(() => _isHovered = false);
              _controller.reverse();
            },
            child: GestureDetector(
              onTap: _launchUrl,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: _isHovered ? hoverBg : baseBg,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: _isHovered
                          ? theme.primaryColor.withOpacity(0.3)
                          : Colors.black.withOpacity(0.02),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                  border: Border.all(
                    color: _isHovered
                        ? Colors.transparent
                        : (isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.08)),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getIconData(widget.icon),
                      color: _isHovered
                          ? Colors.white
                          : theme.primaryColor,
                      size: 18,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      widget.name,
                      style: GoogleFonts.plusJakartaSans(
                        color: _isHovered
                            ? Colors.white
                            : (isDark ? Colors.white.withOpacity(0.8) : Colors.black.withOpacity(0.8)),
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName.toLowerCase()) {
      case 'linkedin':
        return Icons.link;
      case 'github':
        return Icons.code_rounded;
      case 'twitter':
        return Icons.flutter_dash_rounded;
      case 'flutter':
        return Icons.flutter_dash_rounded;
      case 'php':
        return Icons.terminal_rounded;
      case 'web':
        return Icons.language_rounded;
      default:
        return Icons.link_rounded;
    }
  }
}