import 'package:flutter/material.dart';

/// A single-digit label that transitions between values with a synchronized
/// downward double-slide: the outgoing value slides down and fades out while
/// the incoming value slides down from above and fades in, at the same time.
///
/// Driven imperatively by an [AnimationController] (not an implicit
/// animation) — the same convention as `BreathOrb` — because a stock
/// `AnimatedSwitcher` mirrors the same tween for enter/exit, which would
/// slide the outgoing value *up*, not down. Here both values move in the
/// same direction at once.
class SlidingCountdownNumber extends StatefulWidget {
  const SlidingCountdownNumber({
    super.key,
    required this.value,
    required this.style,
  });

  final int value;
  final TextStyle style;

  @override
  State<SlidingCountdownNumber> createState() => _SlidingCountdownNumberState();
}

class _SlidingCountdownNumberState extends State<SlidingCountdownNumber>
    with SingleTickerProviderStateMixin {
  static const _duration = Duration(milliseconds: 400);

  late final AnimationController _controller;
  late final CurvedAnimation _progress;
  int? _previousValue;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _duration);
    _progress = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
  }

  @override
  void didUpdateWidget(covariant SlidingCountdownNumber oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _previousValue = oldWidget.value;
      _controller
        ..value = 0
        ..forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Every value here is a single digit (1-8) — size the slot off one glyph
    // so the slide has a fixed, stable line height to clip against.
    final metrics = TextPainter(
      text: TextSpan(text: '0', style: widget.style),
      textDirection: TextDirection.ltr,
    )..layout();

    return RepaintBoundary(
      child: SizedBox(
        width: metrics.width,
        height: metrics.height,
        child: AnimatedBuilder(
          animation: _progress,
          builder: (context, child) {
            final t = _progress.value;
            final previous = _previousValue;
            if (previous == null || t >= 1) {
              return Text('${widget.value}', style: widget.style);
            }
            final h = metrics.height;
            return Stack(
              clipBehavior: Clip.hardEdge,
              children: [
                Positioned(
                  top: h * t,
                  child: Opacity(
                    opacity: 1 - t,
                    child: Text('$previous', style: widget.style),
                  ),
                ),
                Positioned(
                  top: -h * (1 - t),
                  child: Opacity(
                    opacity: t,
                    child: Text('${widget.value}', style: widget.style),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
