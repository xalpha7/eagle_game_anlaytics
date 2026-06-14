import 'package:flutter/material.dart';
import 'package:lila_black_analytics/core/models/event_models.dart';
import 'package:lila_black_analytics/features/replay/replay_controller.dart';

class PathPainter extends CustomPainter {
  final ProcessedMatchData? data;
  final int currentPlaybackTime;

  PathPainter(this.data, this.currentPlaybackTime);

  @override
  void paint(Canvas canvas, Size size) {
    if (data == null) return;

    final humanPaint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final botPaint = Paint()
      ..color = Colors.orange
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    for (final pathData in data!.userPaths.values) {
      if (pathData.isEmpty) continue;
      if (pathData.first.ts > currentPlaybackTime) continue;

      final isBot = pathData.first.isBot;
      final paint = isBot ? botPaint : humanPaint;

      if (isBot) {
        _drawDashedPath(canvas, pathData, paint);
      } else {
        _drawSolidPath(canvas, pathData, paint);
      }
    }
  }

  void _drawSolidPath(Canvas canvas, List<EventModel> pathData, Paint paint) {
    final path = Path();
    bool first = true;
    for (final event in pathData) {
      if (event.ts > currentPlaybackTime) break; // Optimization
      final offset = Offset(event.pixelX, event.pixelY);
      if (first) {
        path.moveTo(offset.dx, offset.dy);
        first = false;
      } else {
        path.lineTo(offset.dx, offset.dy);
      }
    }
    canvas.drawPath(path, paint);
  }

  void _drawDashedPath(Canvas canvas, List<EventModel> pathData, Paint paint) {
    const double dashWidth = 6.0;
    const double dashSpace = 4.0;

    Offset? lastPos;

    for (final event in pathData) {
      if (event.ts > currentPlaybackTime) break;
      final currentPos = Offset(event.pixelX, event.pixelY);

      if (lastPos != null) {
        double distance = (currentPos - lastPos).distance;
        if (distance > 0) {
          int dashCount = (distance / (dashWidth + dashSpace)).floor();
          double dx = (currentPos.dx - lastPos.dx) / dashCount;
          double dy = (currentPos.dy - lastPos.dy) / dashCount;

          for (int i = 0; i < dashCount; i++) {
            final start = Offset(lastPos.dx + dx * i, lastPos.dy + dy * i);
            final end = Offset(
              lastPos.dx + dx * i + dx * (dashWidth / (dashWidth + dashSpace)),
              lastPos.dy + dy * i + dy * (dashWidth / (dashWidth + dashSpace)),
            );
            canvas.drawLine(start, end, paint);
          }
        }
      }
      lastPos = currentPos;
    }
  }

  @override
  bool shouldRepaint(covariant PathPainter oldDelegate) {
    return oldDelegate.currentPlaybackTime != currentPlaybackTime ||
        oldDelegate.data != data;
  }
}
