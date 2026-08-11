import 'package:flutter/material.dart';

/// A calm text-only link: no ripple, no underline — the label simply brightens
/// from [color] to [pressedColor] while held. Used for the small navigation
/// links in the loop (Home's "patterns →" / "your substitutes", Feeling's
/// "← back"). Nunito, since it is UI chrome not an emotional line.
class PauseTextLink extends StatefulWidget {
  const PauseTextLink({
    super.key,
    required this.text,
    required this.onTap,
    required this.color,
    required this.pressedColor,
    this.fontSize = 12,
    this.fontWeight = FontWeight.w400,
  });

  final String text;
  final VoidCallback onTap;
  final Color color;
  final Color pressedColor;
  final double fontSize;
  final FontWeight fontWeight;

  @override
  State<PauseTextLink> createState() => _PauseTextLinkState();
}

class _PauseTextLinkState extends State<PauseTextLink> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed != value) setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      behavior: HitTestBehavior.opaque,
      child: AnimatedDefaultTextStyle(
        duration: const Duration(milliseconds: 120),
        style: TextStyle(
          fontFamily: 'Nunito',
          fontWeight: widget.fontWeight,
          fontSize: widget.fontSize,
          color: _pressed ? widget.pressedColor : widget.color,
        ),
        child: Text(widget.text),
      ),
    );
  }
}
