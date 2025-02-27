import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AnimatedSection extends StatefulWidget {
  final Widget child;
  final String id;
  final Duration duration;
  final Curve curve;
  final double startOffset;
  final AnimationType animationType;
  final bool delayByIndex;
  final int index;

  const AnimatedSection({
    Key? key,
    required this.child,
    required this.id,
    this.duration = const Duration(milliseconds: 800),
    this.curve = Curves.easeOutCubic,
    this.startOffset = 60.0,
    this.animationType = AnimationType.fadeSlideUp,
    this.delayByIndex = false,
    this.index = 0,
  }) : super(key: key);

  @override
  State<AnimatedSection> createState() => _AnimatedSectionState();
}

enum AnimationType {
  fadeSlideUp,
  fadeSlideIn,
  fadeScale,
  slideFromRight,
  slideFromLeft,
  customBounce,
}

class _AnimatedSectionState extends State<AnimatedSection> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacityAnimation;
  late final Animation<Offset> _offsetAnimation;
  late final Animation<double> _scaleAnimation;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Interval(0.0, 0.6, curve: widget.curve)),
    );

    // Different offset animations based on the animation type
    switch (widget.animationType) {
      case AnimationType.fadeSlideUp:
        _offsetAnimation = Tween<Offset>(
          begin: Offset(0, widget.startOffset / 100),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));
        break;
      case AnimationType.fadeSlideIn:
        _offsetAnimation = Tween<Offset>(
          begin: Offset(0, 0.2),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));
        break;
      case AnimationType.slideFromRight:
        _offsetAnimation = Tween<Offset>(
          begin: Offset(0.3, 0),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));
        break;
      case AnimationType.slideFromLeft:
        _offsetAnimation = Tween<Offset>(
          begin: Offset(-0.3, 0),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));
        break;
      case AnimationType.customBounce:
        _offsetAnimation = Tween<Offset>(
          begin: Offset(0, 0.1),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: _controller,
          curve: Curves.elasticOut,
        ));
        break;
      default:
        _offsetAnimation = Tween<Offset>(
          begin: Offset(0, widget.startOffset / 100),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));
    }

    _scaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: widget.curve),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key(widget.id),
      onVisibilityChanged: (visibilityInfo) {
        final visiblePercentage = visibilityInfo.visibleFraction * 100;
        if (visiblePercentage > 5 && !_isVisible) {
          _isVisible = true;

          // Add delay based on index if specified
          if (widget.delayByIndex && widget.index > 0) {
            Future.delayed(Duration(milliseconds: widget.index * 100), () {
              if (mounted) _controller.forward();
            });
          } else {
            _controller.forward();
          }
        }
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          if (widget.animationType == AnimationType.fadeScale) {
            return Opacity(
              opacity: _opacityAnimation.value,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                alignment: Alignment.center,
                child: widget.child,
              ),
            );
          } else {
            return Opacity(
              opacity: _opacityAnimation.value,
              child: Transform.translate(
                offset: Offset(
                  _offsetAnimation.value.dx * MediaQuery.of(context).size.width,
                  _offsetAnimation.value.dy * MediaQuery.of(context).size.height,
                ),
                child: widget.child,
              ),
            );
          }
        },
      ),
    );
  }
}