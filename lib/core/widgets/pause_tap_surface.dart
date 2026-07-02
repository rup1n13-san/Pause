import 'package:flutter/material.dart';
import 'package:mobile/core/theme/app_theme.dart';

/// A tappable rounded surface used for both the Feeling chips and the Off-ramp
/// rows. Default look is `chip` fill + 1px `line` border; while pressed it swaps
/// to `chipA` fill + `amber` border. It is content-agnostic: pass whatever
/// [child] the call site needs (a bare label, or a Row with a trailing arrow) —
/// the arrow is intentionally NOT baked in here.
///
/// Sizing is driven by the parent: in a `Wrap` it hugs its content (chips); in a
/// stretched column it fills the width (rows). Tokens are resolved from [isDark]
/// the same way `breath_view.dart` resolves its colours.
class PauseTapSurface extends StatefulWidget {
  const PauseTapSurface({
    super.key,
    required this.onTap,
    required this.isDark,
    required this.child,
    this.padding = const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
  });

  final VoidCallback onTap;
  final bool isDark;
  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  State<PauseTapSurface> createState() => _PauseTapSurfaceState();
}

class _PauseTapSurfaceState extends State<PauseTapSurface> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed != value) setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final chip = widget.isDark ? PauseColors.chip : PauseColors.lightChip;
    final chipA = widget.isDark ? PauseColors.chipA : PauseColors.lightChipA;
    final line = widget.isDark ? PauseColors.line : PauseColors.lightLine;
    final amber = widget.isDark ? PauseColors.amber : PauseColors.lightAmber;

    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        padding: widget.padding,
        decoration: BoxDecoration(
          color: _pressed ? chipA : chip,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: _pressed ? amber : line, width: 1),
        ),
        child: widget.child,
      ),
    );
  }
}
