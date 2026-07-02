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
    final bool isMobile = size.width < 600;

    // ==========================
    // Traffic Heat Nodes
    // ==========================
    if (traffic.isNotEmpty) {
      final maxValue = traffic
          .map((e) => e.value)
          .reduce((a, b) => a > b ? a : b);

      for (final point in traffic) {
        final intensity = (point.value / maxValue).clamp(0.0, 1.0);
        drawTrafficNode(canvas, _mapPoint(point, size), intensity, isMobile);
      }
    }

    // ==========================
    // Kill Markers
    // ==========================
    for (final point in kills) {
      drawKillNode(canvas, _mapPoint(point, size), isMobile);
    }

    // ==========================
    // Death Markers
    // ==========================
    for (final point in deaths) {
      drawDeathNode(canvas, _mapPoint(point, size), isMobile);
    }

    // ==========================
    // Legend
    // ==========================
    drawLegend(canvas, size, isMobile);
  }

  // ==================================================
  // MAP NODES
  // ==================================================

  void drawTrafficNode(
    Canvas canvas,
    Offset center,
    double intensity,
    bool isMobile,
  ) {
    final radius = isMobile ? 10 + (intensity * 40) : 15 + (intensity * 70);

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

  void drawKillNode(Canvas canvas, Offset center, bool isMobile) {
    final innerRadius = isMobile ? 5.0 : 8.0;
    final outerRadius = isMobile ? 10.0 : 18.0;

    canvas.drawCircle(center, innerRadius, Paint()..color = Colors.greenAccent);

    canvas.drawCircle(
      center,
      outerRadius,
      Paint()..color = Colors.greenAccent.withOpacity(0.25),
    );
  }

  void drawDeathNode(Canvas canvas, Offset center, bool isMobile) {
    final crossSize = isMobile ? 5.0 : 8.0;

    final paint = Paint()
      ..color = Colors.redAccent
      ..strokeWidth = isMobile ? 2 : 3
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(center.dx - crossSize, center.dy - crossSize),
      Offset(center.dx + crossSize, center.dy + crossSize),
      paint,
    );

    canvas.drawLine(
      Offset(center.dx + crossSize, center.dy - crossSize),
      Offset(center.dx - crossSize, center.dy + crossSize),
      paint,
    );
  }

  // ==================================================
  // LEGEND
  // ==================================================

  void drawLegend(Canvas canvas, Size size, bool isMobile) {
    final double padding = isMobile ? 8 : 16;
    final double legendWidth = isMobile ? 120 : 165;
    final double legendHeight = isMobile ? 70 : 105;

    final double fontSize = isMobile ? 9 : 13;
    final double rowSpacing = isMobile ? 18 : 30;

    // Top-right corner
    final double left = size.width - legendWidth - padding;
    final double top = padding;

    final legendRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(left, top, legendWidth, legendHeight),
      Radius.circular(isMobile ? 8 : 12),
    );

    // Background
    canvas.drawRRect(
      legendRect,
      Paint()..color = Colors.black.withOpacity(0.72),
    );

    final double iconX = left + (isMobile ? 14 : 18);
    final double textX = left + (isMobile ? 28 : 42);

    final double firstRowY = top + (isMobile ? 18 : 25);

    // Traffic
    drawTrafficNode(
      canvas,
      Offset(iconX, firstRowY),
      isMobile ? 0.35 : 0.55,
      isMobile,
    );

    _drawText(
      canvas,
      'Traffic',
      Offset(textX, firstRowY - (fontSize * 0.6)),
      fontSize,
    );

    // Kills
    drawKillNode(canvas, Offset(iconX, firstRowY + rowSpacing), isMobile);

    _drawText(
      canvas,
      'Kills',
      Offset(textX, firstRowY + rowSpacing - (fontSize * 0.6)),
      fontSize,
    );

    // Deaths
    drawDeathNode(
      canvas,
      Offset(iconX, firstRowY + (rowSpacing * 2)),
      isMobile,
    );

    _drawText(
      canvas,
      'Deaths',
      Offset(textX, firstRowY + (rowSpacing * 2) - (fontSize * 0.6)),
      fontSize,
    );
  }

  void _drawText(Canvas canvas, String text, Offset offset, double fontSize) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
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
