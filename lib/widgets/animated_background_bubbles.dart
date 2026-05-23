import 'dart:math' as math;
import 'package:flutter/material.dart';

class AnimatedBackgroundBubbles extends StatefulWidget {
  const AnimatedBackgroundBubbles({Key? key}) : super(key: key);

  @override
  State<AnimatedBackgroundBubbles> createState() => _AnimatedBackgroundBubblesState();
}

class _AnimatedBackgroundBubblesState extends State<AnimatedBackgroundBubbles>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final List<BubbleModel> _bubbles = [];

  @override
  void initState() {
    super.initState();
    // 25 second continuous loop
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 25),
    )..repeat();

    // Bubble 1: Top-Left Ambient Blue Glow
    _bubbles.add(BubbleModel(
      baseX: 0.1,
      baseY: 0.15,
      radius: 350,
      gradientColors: [
        const Color(0xFF1E3A8A).withOpacity(0.2), // Indigo Blue
        const Color(0xFF1E3A8A).withOpacity(0.0),
      ],
      amplitudeX: 80,
      amplitudeY: 60,
      speedX: 0.8,
      speedY: 0.6,
    ));

    // Bubble 2: Bottom-Right Warm Pink Glow
    _bubbles.add(BubbleModel(
      baseX: 0.85,
      baseY: 0.75,
      radius: 450,
      gradientColors: [
        const Color(0xFFEC4899).withOpacity(0.18), // Vibrant Pink
        const Color(0xFFEC4899).withOpacity(0.0),
      ],
      amplitudeX: 90,
      amplitudeY: 100,
      speedX: 0.5,
      speedY: 0.7,
    ));

    // Bubble 3: Bottom-Left Amber/Orange Glow
    _bubbles.add(BubbleModel(
      baseX: 0.15,
      baseY: 0.8,
      radius: 300,
      gradientColors: [
        const Color(0xFFF59E0B).withOpacity(0.15), // Amber
        const Color(0xFFF59E0B).withOpacity(0.0),
      ],
      amplitudeX: 70,
      amplitudeY: 80,
      speedX: 0.7,
      speedY: 0.5,
    ));

    // Bubble 4: Middle-Right Royal Purple Glow
    _bubbles.add(BubbleModel(
      baseX: 0.75,
      baseY: 0.35,
      radius: 380,
      gradientColors: [
        const Color(0xFF8B5CF6).withOpacity(0.15), // Purple
        const Color(0xFF8B5CF6).withOpacity(0.0),
      ],
      amplitudeX: 60,
      amplitudeY: 70,
      speedX: 0.9,
      speedY: 0.4,
    ));

    // Bubble 5: Top-Right Bright Magenta Glow
    _bubbles.add(BubbleModel(
      baseX: 0.82,
      baseY: 0.12,
      radius: 200,
      gradientColors: [
        const Color(0xFFD946EF).withOpacity(0.14), // Magenta
        const Color(0xFFD946EF).withOpacity(0.0),
      ],
      amplitudeX: 40,
      amplitudeY: 50,
      speedX: 1.2,
      speedY: 0.9,
    ));

    // Bubble 6: Middle-Left Soft Cyan/Teal Glow
    _bubbles.add(BubbleModel(
      baseX: 0.05,
      baseY: 0.45,
      radius: 280,
      gradientColors: [
        const Color(0xFF06B6D4).withOpacity(0.15), // Cyan
        const Color(0xFF06B6D4).withOpacity(0.0),
      ],
      amplitudeX: 50,
      amplitudeY: 60,
      speedX: 0.6,
      speedY: 0.8,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Stack(
      children: [
        // Solid theme-aligned baseline background
        Container(
          color: isDark ? const Color(0xFF09090B) : const Color(0xFFF9F9FB),
        ),
        // Ambient animated floating glowing circles
        ..._bubbles.map((bubble) {
          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              // Calculate dynamic multi-axis Lissajous movement
              final progress = _controller.value * 2 * math.pi;
              final dx = math.sin(progress * bubble.speedX) * bubble.amplitudeX;
              final dy = math.cos(progress * bubble.speedY) * bubble.amplitudeY;

              // Center the positions correctly
              final posX = (bubble.baseX * size.width) + dx - (bubble.radius / 2);
              final posY = (bubble.baseY * size.height) + dy - (bubble.radius / 2);

              return Positioned(
                left: posX,
                top: posY,
                child: Container(
                  width: bubble.radius,
                  height: bubble.radius,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: bubble.gradientColors,
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ],
    );
  }
}

class BubbleModel {
  final double baseX;
  final double baseY;
  final double radius;
  final List<Color> gradientColors;
  final double amplitudeX;
  final double amplitudeY;
  final double speedX;
  final double speedY;

  BubbleModel({
    required this.baseX,
    required this.baseY,
    required this.radius,
    required this.gradientColors,
    required this.amplitudeX,
    required this.amplitudeY,
    required this.speedX,
    required this.speedY,
  });
}
