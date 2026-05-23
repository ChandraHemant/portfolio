import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// A widget that reveals its child with a fade and translation animation
/// once it scrolls into the viewport.
class RevealOnScroll extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;
  final Curve curve;
  final Offset slideFrom;
  final bool fade;
  final bool scale;
  final double scaleFrom;

  const RevealOnScroll({
    Key? key,
    required this.child,
    this.duration = const Duration(milliseconds: 600),
    this.delay = Duration.zero,
    this.curve = Curves.easeOutQuart,
    this.slideFrom = const Offset(0, 30),
    this.fade = true,
    this.scale = false,
    this.scaleFrom = 0.95,
  }) : super(key: key);

  @override
  State<RevealOnScroll> createState() => _RevealOnScrollState();
}

class _RevealOnScrollState extends State<RevealOnScroll>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _opacity;
  late Animation<Offset> _slide;
  late Animation<double> _scale;
  bool _triggered = false;
  Timer? _pollTimer;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: widget.duration);

    final curved = CurvedAnimation(parent: _ctrl, curve: widget.curve);
    _opacity = curved.drive(Tween<double>(begin: 0.0, end: 1.0));
    _slide = curved.drive(Tween<Offset>(begin: widget.slideFrom, end: Offset.zero));
    _scale = curved.drive(Tween<double>(begin: widget.scaleFrom, end: 1.0));

    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _checkAndFire();

      if (!_triggered) {
        final isMobile = MediaQuery.of(context).size.width < 800;
        final interval = isMobile
            ? const Duration(milliseconds: 200)
            : const Duration(milliseconds: 100);

        _pollTimer = Timer.periodic(interval, (_) => _checkAndFire());
      }
    });
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    _ctrl.dispose();
    super.dispose();
  }

  void _checkAndFire() {
    if (_triggered || !mounted) return;
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.attached) return;
    final pos = box.localToGlobal(Offset.zero);
    final screenH = MediaQuery.of(context).size.height;
    // Trigger slightly before it hits the screen center/bottom
    if (pos.dy < screenH * 1.05) {
      _fire();
    }
  }

  void _fire() {
    if (_triggered) return;
    _triggered = true;
    _pollTimer?.cancel();
    _pollTimer = null;
    if (widget.delay == Duration.zero) {
      _ctrl.forward();
    } else {
      Future.delayed(widget.delay, () {
        if (mounted) _ctrl.forward();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, child) {
        Widget w = child!;
        if (widget.scale) {
          w = Transform.scale(scale: _scale.value, child: w);
        }
        w = Transform.translate(offset: _slide.value, child: w);
        if (widget.fade) {
          w = Opacity(opacity: _opacity.value.clamp(0.0, 1.0), child: w);
        }
        return w;
      },
      child: widget.child,
    );
  }
}
