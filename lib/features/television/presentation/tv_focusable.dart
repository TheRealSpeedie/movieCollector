import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';

class TvFocusable extends StatefulWidget {
  const TvFocusable({
    super.key,
    required this.child,
    required this.onSelect,
    this.autofocus = false,
    this.borderRadius = 14,
  });

  final Widget child;
  final VoidCallback? onSelect;
  final bool autofocus;
  final double borderRadius;

  @override
  State<TvFocusable> createState() => _TvFocusableState();
}

class _TvFocusableState extends State<TvFocusable> {
  bool _focused = false;

  void _onFocusChange(bool focused) {
    setState(() => _focused = focused);
    if (focused) {
      Scrollable.ensureVisible(
        context,
        alignment: 0.5,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(widget.borderRadius);
    return AnimatedScale(
      scale: _focused ? 1.05 : 1,
      duration: const Duration(milliseconds: 150),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: radius,
          border: Border.all(
            color: _focused ? AppColors.dustyRose : Colors.transparent,
            width: 3,
          ),
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            autofocus: widget.autofocus,
            borderRadius: radius,
            onTap: widget.onSelect,
            onFocusChange: _onFocusChange,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

class TvButton extends StatelessWidget {
  const TvButton({
    super.key,
    required this.label,
    required this.onSelect,
    this.icon,
    this.primary = false,
    this.autofocus = false,
  });

  final String label;
  final IconData? icon;
  final bool primary;
  final bool autofocus;
  final VoidCallback? onSelect;

  @override
  Widget build(BuildContext context) {
    final foreground = primary ? AppColors.background : AppColors.charcoal;
    return TvFocusable(
      autofocus: autofocus,
      onSelect: onSelect,
      borderRadius: 28,
      child: Ink(
        decoration: BoxDecoration(
          color: primary ? AppColors.dustyRose : AppColors.surface,
          borderRadius: BorderRadius.circular(28),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, color: foreground, size: 28),
              const SizedBox(width: 10),
            ],
            Text(
              label,
              style: TextStyle(
                color: foreground,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TvPage extends StatelessWidget {
  const TvPage({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 27),
        child: child,
      ),
    );
  }
}
