import 'package:flutter/material.dart';

class HeatPoint {
  final double x;
  final double y;
  final double value;

  const HeatPoint({required this.x, required this.y, required this.value});

  factory HeatPoint.fromJson(Map<String, dynamic> json) {
    return HeatPoint(
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
      value: (json['value'] as num).toDouble(),
    );
  }
}

class HeatMapPainter extends CustomPainter {
  final List<HeatPoint> traffic;
  final List<HeatPoint> kills;
  final List<HeatPoint> deaths;

  HeatMapPainter({
    required this.traffic,
    required this.kills,
    required this.deaths,
  });

  static const double maxCoordinate = 1000.0;

  Offset _mapPoint(HeatPoint point, Size size) {
    return Offset(
      point.x / maxCoordinate * size.width,
      point.y / maxCoordinate * size.height,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    // Draw traffic heat nodes
    if (traffic.isNotEmpty) {
      final maxValue = traffic
          .map((e) => e.value)
          .reduce((a, b) => a > b ? a : b);

      for (final point in traffic) {
        final intensity = (point.value / maxValue).clamp(0.0, 1.0);
        drawTrafficNode(canvas, _mapPoint(point, size), intensity);
      }
    }

    // Draw kills
    for (final point in kills) {
      drawKillNode(canvas, _mapPoint(point, size));
    }

    // Draw deaths
    for (final point in deaths) {
      drawDeathNode(canvas, _mapPoint(point, size));
    }

    // Draw legend
    drawLegend(canvas, size);
  }

  // ==================================================
  // MAP NODES
  // ==================================================

  void drawTrafficNode(Canvas canvas, Offset center, double intensity) {
    final radius = 15 + (intensity * 70);

    final shader = RadialGradient(
      colors: [
        Colors.red.withOpacity(intensity * 0.9),
        Colors.orange.withOpacity(intensity * 0.5),
        Colors.transparent,
      ],
      stops: const [0.0, 0.55, 1.0],
    ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawCircle(center, radius, Paint()..shader = shader);
  }

  void drawKillNode(Canvas canvas, Offset center) {
    canvas.drawCircle(center, 10, Paint()..color = Colors.greenAccent);

    canvas.drawCircle(
      center,
      22,
      Paint()..color = Colors.greenAccent.withOpacity(0.25),
    );
  }

  void drawDeathNode(Canvas canvas, Offset center) {
    final paint = Paint()
      ..color = Colors.redAccent
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(center.dx - 8, center.dy - 8),
      Offset(center.dx + 8, center.dy + 8),
      paint,
    );

    canvas.drawLine(
      Offset(center.dx + 8, center.dy - 8),
      Offset(center.dx - 8, center.dy + 8),
      paint,
    );
  }

  // ==================================================
  // LEGEND
  // ==================================================

  void drawLegend(Canvas canvas, Size size) {
    const double padding = 16;
    const double width = 190;
    const double height = 110;

    final legendRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(padding, size.height - height - padding, width, height),
      const Radius.circular(12),
    );

    // Background
    canvas.drawRRect(
      legendRect,
      Paint()..color = Colors.black.withOpacity(0.7),
    );

    final startX = padding + 25;
    final textX = padding + 60;

    // Traffic
    drawTrafficNode(canvas, Offset(startX, size.height - 90), 0.8);

    _drawText(canvas, 'Traffic', Offset(textX, size.height - 98));

    // Kills
    drawKillNode(canvas, Offset(startX, size.height - 55));

    _drawText(canvas, 'Kills', Offset(textX, size.height - 63));

    // Deaths
    drawDeathNode(canvas, Offset(startX, size.height - 20));

    _drawText(canvas, 'Deaths', Offset(textX, size.height - 28));
  }

  void _drawText(Canvas canvas, String text, Offset offset) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant HeatMapPainter oldDelegate) {
    return oldDelegate.traffic != traffic ||
        oldDelegate.kills != kills ||
        oldDelegate.deaths != deaths;
  }
}
