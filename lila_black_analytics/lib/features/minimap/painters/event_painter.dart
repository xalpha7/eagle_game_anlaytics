import 'package:flutter/material.dart';

import '../../replay/replay_controller.dart';

class EventPainter extends CustomPainter {
  final ProcessedMatchData? data;
  final int currentPlaybackTime;

  EventPainter(this.data, this.currentPlaybackTime);

  @override
  void paint(Canvas canvas, Size size) {
    if (data == null) return;

    for (final event in data!.allEvents) {
      if (event.ts > currentPlaybackTime) break; // Optimization: allEvents is pre-sorted

      final offset = Offset(event.pixelX, event.pixelY);
      switch (event.event) {
        case 'Loot':
          _drawCircle(canvas, offset, Colors.green);
          break;
        case 'Kill':
          _drawX(canvas, offset, Colors.red);
          break;
        case 'BotKill':
          _drawX(canvas, offset, Colors.orange);
          break;
        case 'Killed':
          _drawSkull(canvas, offset, Colors.black);
          break;
        case 'BotKilled':
          _drawSkull(canvas, offset, Colors.purple);
          break;
        case 'KilledByStorm':
          _drawTriangle(canvas, offset, Colors.yellow);
          break;
      }
    }
  }

  void _drawCircle(Canvas canvas, Offset center, Color color) {
    canvas.drawCircle(center, 4.0, Paint()..color = color..style = PaintingStyle.fill);
  }

  void _drawX(Canvas canvas, Offset center, Color color) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(center.dx - 4, center.dy - 4), Offset(center.dx + 4, center.dy + 4), paint);
    canvas.drawLine(Offset(center.dx + 4, center.dy - 4), Offset(center.dx - 4, center.dy + 4), paint);
  }

  void _drawSkull(Canvas canvas, Offset center, Color color) {
    final paint = Paint()..color = color..style = PaintingStyle.fill;
    // Skull Cranium
    canvas.drawCircle(center, 4, paint);
    // Skull Jaw
    canvas.drawRect(Rect.fromLTRB(center.dx - 2.5, center.dy, center.dx + 2.5, center.dy + 5), paint);
    // Eyes
    final eyePaint = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(center.dx - 1.5, center.dy), 1, eyePaint);
    canvas.drawCircle(Offset(center.dx + 1.5, center.dy), 1, eyePaint);
  }

  void _drawTriangle(Canvas canvas, Offset center, Color color) {
    final path = Path()
      ..moveTo(center.dx, center.dy - 5)
      ..lineTo(center.dx + 5, center.dy + 4)
      ..lineTo(center.dx - 5, center.dy + 4)
      ..close();
    canvas.drawPath(path, Paint()..color = color..style = PaintingStyle.fill);
  }

  @override
  bool shouldRepaint(covariant EventPainter oldDelegate) {
    return oldDelegate.currentPlaybackTime != currentPlaybackTime || oldDelegate.data != data;
  }
}