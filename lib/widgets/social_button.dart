import 'package:flutter/material.dart';
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
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
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
      print('Error launching URL: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
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
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                decoration: BoxDecoration(
                  color: _isHovered
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).colorScheme.background,
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: [
                    BoxShadow(
                      color: _isHovered
                          ? Theme.of(context).primaryColor.withOpacity(0.4)
                          : Colors.black.withOpacity(0.07),
                      blurRadius: 12,
                      offset: const Offset(0, 5),
                      spreadRadius: _isHovered ? 0 : -2,
                    ),
                  ],
                  border: Border.all(
                    color: _isHovered
                        ? Colors.transparent
                        : Theme.of(context).dividerColor.withOpacity(0.3),
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
                          : Theme.of(context).primaryColor,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.name,
                      style: TextStyle(
                        color: _isHovered
                            ? Colors.white
                            : Theme.of(context).textTheme.bodyLarge!.color,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ).animate(delay: Duration(milliseconds: widget.index * 100))
              .fadeIn(duration: 400.ms)
              .slide(begin: const Offset(0, 0.2), duration: 400.ms),
        );
      },
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName.toLowerCase()) {
      case 'linkedin':
        return Icons.attach_file;
      case 'github':
        return Icons.code;
      case 'twitter':
        return Icons.flutter_dash;
      case 'flutter':
        return Icons.flutter_dash;
      case 'php':
        return Icons.php;
      case 'web':
        return Icons.language;
      default:
        return Icons.link;
    }
  }
}