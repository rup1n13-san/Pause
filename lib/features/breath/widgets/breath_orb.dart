import 'package:flutter/material.dart';

/// The breathing orb — the single main animated element of the ritual.
///
/// It is driven imperatively by an [AnimationController] (not an implicit
/// animation) so the exact ms/curve values from the design are honoured. When
/// [scale] / [duration] / [curve] change, the orb tweens from its CURRENT scale
/// to the new [scale] over [duration] using [curve].
///
/// Purely presentational: colours are passed in so the parent owns dark/light.
/// Wrapped in a [RepaintBoundary] so per-frame scale repaints stay isolated
/// from the phase label and cycle dots.
class BreathOrb extends StatefulWidget {
  const BreathOrb({
    super.key,
    required this.scale,
    required this.duration,
    required this.curve,
    required this.orbA,
    required this.orbB,
    required this.glow,
  });

  /// Target scale for the orb container (design uses ~0.58–1.0).
  final double scale;
  final Duration duration;
  final Curve curve;

  /// Inner-orb radial gradient: [orbA] (upper-left highlight) → [orbB] (edge).
  final Color orbA;
  final Color orbB;

  /// Outer halo colour, faded to transparent.
  final Color glow;

  static const double _outer = 236;
  static const double _inner = 108;

  @override
  State<BreathOrb> createState() => _BreathOrbState();
}

class _BreathOrbState extends State<BreathOrb>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<double> _scale;

  // Tracks the live scale so a mid-flight phase change tweens from where we are.
  late double _current;

  /// Natural resting scale the orb starts from before the first phase (e.g.
  /// "Settle in") eases it to its target — so the opening move always
  /// animates instead of snapping straight to the initial target scale.
  static const double _restingScale = 1.0;

  @override
  void initState() {
    super.initState();
    _current = _restingScale;
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _scale = AlwaysStoppedAnimation(_current);
    _controller.addListener(() {
      _current = _scale.value;
    });
    _animateTo(widget.scale);
  }

  @override
  void didUpdateWidget(covariant BreathOrb oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.scale != oldWidget.scale ||
        widget.duration != oldWidget.duration ||
        widget.curve != oldWidget.curve) {
      _animateTo(widget.scale);
    }
  }

  void _animateTo(double target) {
    _scale = Tween<double>(begin: _current, end: target).animate(
      CurvedAnimation(parent: _controller, curve: widget.curve),
    );
    _controller
      ..duration = widget.duration
      ..value = 0
      ..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(scale: _scale.value, child: child);
        },
        child: SizedBox(
          width: BreathOrb._outer,
          height: BreathOrb._outer,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer glow halo.
              DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [widget.glow, widget.glow.withAlpha(0)],
                    stops: const [0.0, 1.0],
                  ),
                ),
              ),
              // Inner solid orb.
              Container(
                width: BreathOrb._inner,
                height: BreathOrb._inner,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    center: const Alignment(-0.3, -0.3),
                    radius: 0.9,
                    colors: [widget.orbA, widget.orbB],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: widget.glow,
                      blurRadius: 40,
                      spreadRadius: 4,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
