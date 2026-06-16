// lib/views/telemetry_painter.dart

import 'package:flutter/material.dart';
import '../models.dart';

class TelemetryPainter extends CustomPainter {
  final List<PlaybackEvent> historicalEvents;
  final int currentPlaybackTime;

  TelemetryPainter({
    required this.historicalEvents,
    required this.currentPlaybackTime,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Group positions by user_id to render up-to-date coordinate trajectories
    final Map<String, PlaybackEvent> activeEntities = {};
    final List<PlaybackEvent> discreteEvents = [];

    for (var event in historicalEvents) {
      if (event.timestampSeconds > currentPlaybackTime) continue;

      if (event.eventType == 'Position' || event.eventType == 'BotPosition') {
        activeEntities[event.userId] = event; // Cache latest position coordinate
      } else {
        // Evaluate if discrete event sits within the 2-second fade buffer window
        if ((currentPlaybackTime - event.timestampSeconds) <= 2 && 
            (currentPlaybackTime - event.timestampSeconds) >= 0) {
          discreteEvents.add(event);
        }
      }
    }

    // 1. Draw Active Real-Time Movement Nodes
    activeEntities.forEach((userId, entity) {
      final Offset point = Offset(entity.pixelX, entity.pixelY);
      
      if (entity.isBot) {
        final botPaint = Paint()..color = Colors.orange..style = PaintingStyle.fill;
        canvas.drawCircle(point, 6.0, botPaint);
      } else {
        final humanPaint = Paint()..color = Colors.cyan..style = PaintingStyle.fill;
        canvas.drawCircle(point, 7.0, humanPaint);
        
        // Render a truncated slice of human UUID directly next to nodes
        final textPainter = TextPainter(
          text: TextSpan(
            text: userId.length > 5 ? userId.substring(0, 5) : userId,
            style: const TextStyle(color: Colors.white, fontSize: 10, backgroundColor: Colors.black54),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        textPainter.paint(canvas, Offset(point.dx + 9, point.dy - 5));
      }
    });

    // 2. Draw Discrete Combat Markers (Kills, Deaths, Loot Packages)
    for (var marker in discreteEvents) {
      final Offset point = Offset(marker.pixelX, marker.pixelY);
      
      switch (marker.eventType) {
        case 'Kill':
        case 'BotKill':
          _drawCrosshair(canvas, point, Colors.redAccent);
          break;
        case 'Killed':
        case 'BotKilled':
        case 'KilledByStorm':
          _drawSkullMarker(canvas, point, Colors.deepPurpleAccent);
          break;
        case 'Loot':
          _drawLootCrate(canvas, point, Colors.greenAccent);
          break;
      }
    }
  }

  void _drawCrosshair(Canvas canvas, Offset target, Color markerColor) {
    final paint = Paint()..color = markerColor..strokeWidth = 3.0..style = PaintingStyle.stroke;
    canvas.drawCircle(target, 8.0, paint);
    canvas.drawLine(Offset(target.dx - 12, target.dy), Offset(target.dx + 12, target.dy), paint);
    canvas.drawLine(Offset(target.dx, target.dy - 12), Offset(target.dx, target.dy + 12), paint);
  }

  void _drawSkullMarker(Canvas canvas, Offset target, Color markerColor) {
    final paint = Paint()..color = markerColor..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromCenter(center: target, width: 10, height: 10), paint);
    canvas.drawCircle(Offset(target.dx, target.dy - 4), 6.0, paint);
  }

  void _drawLootCrate(Canvas canvas, Offset target, Color markerColor) {
    final paint = Paint()..color = markerColor..style = PaintingStyle.stroke..strokeWidth = 2.5;
    canvas.drawRect(Rect.fromCenter(center: target, width: 12, height: 12), paint);
    canvas.drawLine(Offset(target.dx - 6, target.dy - 6), Offset(target.dx + 6, target.dy + 6), paint);
  }

  @override
  bool shouldRepaint(covariant TelemetryPainter oldDelegate) => true;
}