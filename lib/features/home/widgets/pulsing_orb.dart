import 'package:flutter/material.dart';
import 'package:mobile/core/theme/app_theme.dart';

/// A self-looping ambient orb — same layered radial-gradient construction as
/// `BreathOrb`, but a different animation lifecycle: instead of tweening once to
/// an externally-set target, it pulses forever on its own (scale 1.0 ↔ 1.045,
/// glow opacity 0.55 ↔ 0.85) with an internal [AnimationController..repeat].
///
/// Used on Home (large, tappable, "tap" label) and on the Resolution "Yes"
/// screen (small, faster [period], no label). Purely presentational: colours are
/// passed in so the parent owns dark/light, exactly like [BreathOrb].
///
/// Note on [period]: a single controller drives BOTH the scale and glow pulse.
/// The design describes Resolution's glow as "faster" (4s vs Home's 7s); driving
/// the whole pulse at that period achieves the intended feel with one controller
/// — a second controller purely to desync a 4.5% scale move would be complexity
/// for an imperceptible difference.
class PulsingOrb extends StatefulWidget {
  const PulsingOrb({
    super.key,
    required this.outerSize,
    required this.innerSize,
    required this.orbA,
    required this.orbB,
    required this.glow,
    this.period = const Duration(seconds: 7),
    this.label,
    this.labelColor,
    this.onTap,
  });

  /// Halo (outer) diameter and inner solid-orb diameter, in logical px.
  final double outerSize;
  final double innerSize;

  /// Inner-orb radial gradient: [orbA] (upper-left highlight) → [orbB] (edge).
  final Color orbA;
  final Color orbB;

  /// Outer halo colour, faded to transparent.
  final Color glow;

  /// One full breathe of the pulse (both scale and glow), reversing.
  final Duration period;

  /// Optional centred label inside the inner orb (Home shows "tap").
  final String? label;
  final Color? labelColor;

  /// If non-null, the orb becomes the tap target (Home's CTA).
  final VoidCallback? onTap;

  @override
  State<PulsingOrb> createState() => _PulsingOrbState();
}

class _PulsingOrbState extends State<PulsingOrb>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _glowOpacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.period)
      ..repeat(reverse: true);
    final curved = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _scale = Tween<double>(begin: 1.0, end: 1.045).animate(curved);
    _glowOpacity = Tween<double>(begin: 0.55, end: 0.85).animate(curved);
  }

  @override
  void didUpdateWidget(covariant PulsingOrb oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.period != oldWidget.period) {
      _controller.duration = widget.period;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // The inner orb is static across the pulse, so it is built once and passed
    // as the AnimatedBuilder `child` — only the transform + halo opacity rebuild
    // per frame.
    final label = widget.label;
    final innerOrb = Container(
      width: widget.innerSize,
      height: widget.innerSize,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          center: const Alignment(-0.3, -0.3),
          radius: 0.9,
          colors: [widget.orbA, widget.orbB],
        ),
        boxShadow: [
          BoxShadow(color: widget.glow, blurRadius: 40, spreadRadius: 4),
        ],
      ),
      child: label == null
          ? null
          : Text(
              label,
              style: PauseTextStyles.label(color: widget.labelColor!),
            ),
    );

    return RepaintBoundary(
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: _scale.value,
              child: SizedBox(
                width: widget.outerSize,
                height: widget.outerSize,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Opacity(
                      opacity: _glowOpacity.value,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [widget.glow, widget.glow.withAlpha(0)],
                          ),
                        ),
                      ),
                    ),
                    child!,
                  ],
                ),
              ),
            );
          },
          child: innerOrb,
        ),
      ),
    );
  }
}
