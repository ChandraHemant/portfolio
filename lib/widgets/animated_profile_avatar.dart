import 'dart:math' as math;
import 'package:flutter/material.dart';

class AnimatedProfileAvatar extends StatefulWidget {
  final String imageUrl;
  final double radius;

  const AnimatedProfileAvatar({
    Key? key,
    required this.imageUrl,
    this.radius = 100.0,
  }) : super(key: key);

  @override
  State<AnimatedProfileAvatar> createState() => _AnimatedProfileAvatarState();
}

class _AnimatedProfileAvatarState extends State<AnimatedProfileAvatar>
    with TickerProviderStateMixin {
  late final AnimationController _rotationController;
  late final AnimationController _pulseController;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    // Rotation animation
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    // Breathing pulse animation
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Harmonious gradient colors that match the dark graphite portfolio aesthetic
    final colors = [
      theme.primaryColor,
      theme.colorScheme.secondary,
      Colors.blueAccent,
      Colors.purpleAccent,
      theme.primaryColor,
    ];

    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _isHovered = true;
        });
        // Accelerate rotation on hover
        _rotationController.duration = const Duration(seconds: 3);
        if (_rotationController.isAnimating) {
          _rotationController.repeat();
        }
      },
      onExit: (_) {
        setState(() {
          _isHovered = false;
        });
        // Decelerate rotation back to standard
        _rotationController.duration = const Duration(seconds: 8);
        if (_rotationController.isAnimating) {
          _rotationController.repeat();
        }
      },
      child: AnimatedScale(
        scale: _isHovered ? 1.08 : 1.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        child: AnimatedBuilder(
          animation: Listenable.merge([_rotationController, _pulseController]),
          builder: (context, child) {
            // Pulse value goes from 0.0 to 1.0 and back
            final pulseVal = _pulseController.value;
            final glowRadius = 20.0 + (pulseVal * 20.0) + (_isHovered ? 15.0 : 0.0);
            final glowOpacity = 0.15 + (pulseVal * 0.1) + (_isHovered ? 0.15 : 0.0);

            return Container(
              width: widget.radius * 2,
              height: widget.radius * 2,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: theme.primaryColor.withOpacity(glowOpacity),
                    blurRadius: glowRadius,
                    spreadRadius: _isHovered ? 6.0 : 2.0,
                  ),
                  BoxShadow(
                    color: theme.colorScheme.secondary.withOpacity(glowOpacity * 0.7),
                    blurRadius: glowRadius * 1.5,
                    spreadRadius: _isHovered ? 3.0 : 0.0,
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Rotating gradient border
                  Transform.rotate(
                    angle: _rotationController.value * 2 * math.pi,
                    child: Container(
                      width: widget.radius * 2,
                      height: widget.radius * 2,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: SweepGradient(
                          colors: colors,
                        ),
                      ),
                    ),
                  ),
                  // Inner background to mask the sweep gradient center and form a crisp outer ring
                  Container(
                    width: (widget.radius * 2) - 8,
                    height: (widget.radius * 2) - 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDark ? const Color(0xFF09090B) : Colors.white,
                    ),
                  ),
                  // The profile photo itself
                  Container(
                    width: (widget.radius * 2) - 16,
                    height: (widget.radius * 2) - 16,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage(widget.imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Dynamic interactive shimmer glass reflection overlay on hover
                  if (_isHovered)
                    Positioned.fill(
                      child: ClipOval(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.white.withOpacity(0.0),
                                Colors.white.withOpacity(0.18),
                                Colors.white.withOpacity(0.0),
                              ],
                              stops: const [0.3, 0.5, 0.7],
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
