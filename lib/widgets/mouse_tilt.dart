import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'dart:math' as math;

/// A performant 3D tilt widget.
/// On touch/mobile devices it is a simple passthrough.
/// Only activates on desktop where a mouse pointer is available.
class MouseTilt extends StatefulWidget {
  final Widget child;
  final double maxTiltX;
  final double maxTiltY;
  final double depth;

  const MouseTilt({
    Key? key,
    required this.child,
    this.maxTiltX = 8.0,
    this.maxTiltY = 8.0,
    this.depth = 12.0,
  }) : super(key: key);

  @override
  State<MouseTilt> createState() => _MouseTiltState();
}

class _MouseTiltState extends State<MouseTilt>
    with SingleTickerProviderStateMixin {
  final _tilt = ValueNotifier<Offset>(Offset.zero);
  double _targetX = 0, _targetY = 0;
  double _curX = 0, _curY = 0;
  Ticker? _ticker;
  bool _isDesktop = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final w = MediaQuery.of(context).size.width;
    final wasDesktop = _isDesktop;
    _isDesktop = w >= 900; // threshold for desktop/tablet distinction

    if (_isDesktop && _ticker == null) {
      _ticker = createTicker(_onTick)..start();
    } else if (!_isDesktop && _ticker != null) {
      _ticker?.dispose();
      _ticker = null;
      _tilt.value = Offset.zero;
    }

    if (wasDesktop != _isDesktop && !_isDesktop) {
      _targetX = _targetY = _curX = _curY = 0;
    }
  }

  @override
  void dispose() {
    _ticker?.dispose();
    _tilt.dispose();
    super.dispose();
  }

  void _onTick(Duration _) {
    const speed = 0.12;
    final nx = _curX + (_targetX - _curX) * speed;
    final ny = _curY + (_targetY - _curY) * speed;
    if ((nx - _curX).abs() > 0.001 || (ny - _curY).abs() > 0.001) {
      _curX = nx;
      _curY = ny;
      _tilt.value = Offset(_curX, _curY);
    }
  }

  void _onHover(PointerHoverEvent e) {
    if (!_isDesktop) return;
    final size = context.size;
    if (size == null) return;
    _targetX = (e.localPosition.dx / size.width) * 2 - 1;
    _targetY = (e.localPosition.dy / size.height) * 2 - 1;
  }

  void _onExit(PointerExitEvent _) {
    _targetX = 0;
    _targetY = 0;
  }

  @override
  Widget build(BuildContext context) {
    if (!_isDesktop) return widget.child;

    return MouseRegion(
      onHover: _onHover,
      onExit: _onExit,
      child: ValueListenableBuilder<Offset>(
        valueListenable: _tilt,
        builder: (_, tilt, child) {
          final rx = tilt.dy * (widget.maxTiltX * math.pi / 180);
          final ry = -tilt.dx * (widget.maxTiltY * math.pi / 180);
          final tx = -tilt.dx * widget.depth;
          final ty = -tilt.dy * widget.depth;

          final m = Matrix4.identity();
          m.setEntry(3, 2, 0.0008);
          m.rotateX(rx);
          m.rotateY(ry);
          m.storage[12] = tx;
          m.storage[13] = ty;

          return Transform(
            transform: m,
            alignment: FractionalOffset.center,
            child: child,
          );
        },
        child: widget.child,
      ),
    );
  }
}
