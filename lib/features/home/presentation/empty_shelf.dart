import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../app/theme/speednema_colors.dart';

/// The shelf from Speednema's logo, still empty: the case, the board, and
/// one disc leaning where the first film will go. Drawn, so it follows
/// both appearances; decorative, so screen readers skip it.
class EmptyShelf extends StatelessWidget {
  const EmptyShelf({super.key, this.width = 180});

  final double width;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return ExcludeSemantics(
      child: SizedBox(
        width: width,
        height: width * 0.62,
        child: CustomPaint(
          painter: _ShelfPainter(
            frame: colors.textSecondary,
            disc: colors.owned,
            spine: colors.accent,
          ),
        ),
      ),
    );
  }
}

class _ShelfPainter extends CustomPainter {
  _ShelfPainter({required this.frame, required this.disc, required this.spine});

  final Color frame;
  final Color disc;
  final Color spine;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final stroke = w * 0.035;
    final line = Paint()
      ..color = frame
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;

    // The case: posts with a rounded top, as in the logo.
    final top = h * 0.08;
    final board = h * 0.82;
    final left = w * 0.1;
    final right = w * 0.9;
    final radius = w * 0.08;
    final path = Path()
      ..moveTo(left, board)
      ..lineTo(left, top + radius)
      ..arcToPoint(Offset(left + radius, top), radius: Radius.circular(radius))
      ..lineTo(right - radius, top)
      ..arcToPoint(Offset(right, top + radius), radius: Radius.circular(radius))
      ..lineTo(right, board);
    canvas.drawPath(path, line);

    // The board and its feet.
    final boardPaint = Paint()..color = frame;
    canvas.drawRRect(
      RRect.fromLTRBR(
        w * 0.02,
        board,
        w * 0.98,
        board + stroke * 1.6,
        Radius.circular(stroke),
      ),
      boardPaint,
    );
    for (final x in [w * 0.12, w * 0.82]) {
      canvas.drawRect(
        Rect.fromLTWH(x, board + stroke * 1.6, w * 0.06, h * 0.08),
        boardPaint,
      );
    }

    // One film spine in the accent: where the collection starts.
    final spineRect = RRect.fromLTRBR(
      w * 0.2,
      h * 0.3,
      w * 0.3,
      board - stroke / 2,
      Radius.circular(stroke / 2),
    );
    canvas.drawRRect(spineRect, Paint()..color = spine.withValues(alpha: 0.85));

    // A disc leaning against it.
    final discCenter = Offset(w * 0.42, board - h * 0.2);
    final discRadius = h * 0.2;
    canvas.save();
    canvas.translate(discCenter.dx, discCenter.dy);
    canvas.rotate(-math.pi / 14);
    canvas.drawCircle(
      Offset.zero,
      discRadius,
      Paint()..color = disc.withValues(alpha: 0.85),
    );
    canvas.drawCircle(
      Offset.zero,
      discRadius * 0.28,
      Paint()
        ..color = frame
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke * 0.6,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(_ShelfPainter old) =>
      old.frame != frame || old.disc != disc || old.spine != spine;
}
