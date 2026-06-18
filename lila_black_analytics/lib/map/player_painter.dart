import 'package:flutter/material.dart';
import 'package:lila_black_analytics/DashboardController.dart';

class PlayerPainter extends CustomPainter {
  final List<PlayerPosition> players;
  final double baseMapSize = 1024.0;

  PlayerPainter({required this.players});

  @override
  void paint(Canvas canvas, Size size) {
    double scaleX = size.width / baseMapSize;
    double scaleY = size.height / baseMapSize;

    for (var player in players) {
      double screenX = player.pixelX * scaleX;
      double screenY = player.pixelY * scaleY;
      Offset position = Offset(screenX, screenY);

      _drawIntelligentPlayer(canvas, player, position);
    }
  }

  void _drawIntelligentPlayer(
    Canvas canvas,
    PlayerPosition player,
    Offset position,
  ) {
    bool isDead =
        player.event == 'Killed' ||
        player.event == 'BotKilled' ||
        player.event == 'KilledByStorm';

    // 1. Draw the Base Entity (Alive or Dead)
    if (isDead) {
      _drawDeathMarker(canvas, position, player.event);
    } else {
      if (player.isBot) {
        _drawBotFigure(canvas, position);
      } else {
        _drawHumanFigure(canvas, position);
      }
    }

    // 2. Draw Event Specific Decorators (If alive)
    if (!isDead) {
      _drawEventDecorator(canvas, position, player.event);
    }
  }

  // --- MODULE: Entity Painters ---

  void _drawHumanFigure(Canvas canvas, Offset position) {
    // 1. Outer Neon Telemetry Glow Ring
    final glowPaint = Paint()
      ..color = const Color(0xFF00E5FF).withOpacity(0.3)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(position, 9.0, glowPaint);

    // 2. Tactical Directional Arrow
    final arrowPaint = Paint()
      ..color = const Color(0xFF00E5FF)
      ..style = PaintingStyle.fill;

    final Path directionalPath = Path()
      ..moveTo(position.dx, position.dy - 9)
      ..lineTo(position.dx - 5, position.dy - 3)
      ..lineTo(position.dx + 5, position.dy - 3)
      ..close();
    canvas.drawPath(directionalPath, arrowPaint);

    // 3. Core Player Dot
    final corePaint = Paint()
      ..color = const Color(0xFF00E5FF)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(position, 4.5, corePaint);

    // 4. High-Contrast Outer Border
    final borderPaint = Paint()
      ..color = const Color(0xFF000000)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(position, 4.5, borderPaint);
    canvas.drawPath(directionalPath, borderPaint);
  }

  void _drawBotFigure(Canvas canvas, Offset position) {
    // 1. Ambient Threat Ring
    final glowPaint = Paint()
      ..color = const Color(0xFFFF3D00).withOpacity(0.25)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(position, 10.0, glowPaint);

    // 2. Tactical AI Diamond Core
    final botPaint = Paint()
      ..color = const Color(0xFFFF3D00)
      ..style = PaintingStyle.fill;

    final Path diamondPath = Path()
      ..moveTo(position.dx, position.dy - 6.5) // Top
      ..lineTo(position.dx + 6.5, position.dy) // Right
      ..lineTo(position.dx, position.dy + 6.5) // Bottom
      ..lineTo(position.dx - 6.5, position.dy) // Left
      ..close();
    canvas.drawPath(diamondPath, botPaint);

    // 3. Inner Reticle Target Dot
    final reticlePaint = Paint()
      ..color = const Color(0xFFFFFFFF)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(position, 2.0, reticlePaint);

    // 4. High-Contrast Border
    final borderPaint = Paint()
      ..color = const Color(0xFF210000)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawPath(diamondPath, borderPaint);
  }

  void _drawDeathMarker(Canvas canvas, Offset position, String event) {
    final bool isStorm = event == 'KilledByStorm';

    // Graveyard Theme Colors
    final Color dirtColor = isStorm
        ? const Color(0xFF1A1025)
        : const Color(0xFF2D1E16);
    final Color stoneBaseColor = isStorm
        ? const Color(0xFF4A148C)
        : const Color(0xFF757575);
    final Color stoneEdgeColor = isStorm
        ? const Color(0xFF7B1FA2)
        : const Color(0xFF424242);
    final Color engraveColor = isStorm
        ? const Color(0xFF00E5FF)
        : const Color(
            0xFF212121,
          ); // Neon crack for storm, dark cross for combat

    // 1. Fresh Dirt Mound (Base of the grave)
    final Rect dirtRect = Rect.fromCenter(
      center: Offset(position.dx, position.dy + 4),
      width: 14,
      height: 6,
    );
    final Paint dirtPaint = Paint()
      ..color = dirtColor
      ..style = PaintingStyle.fill;
    canvas.drawOval(dirtRect, dirtPaint);

    // 2. Tombstone Body (Standing Upright - Isometric view)
    final Rect stoneRect = Rect.fromCenter(
      center: Offset(position.dx, position.dy - 2),
      width: 10,
      height: 12,
    );
    final RRect roundedStone = RRect.fromRectAndRadius(
      stoneRect,
      const Radius.circular(3.5),
    );

    final Paint stonePaint = Paint()
      ..color = stoneBaseColor
      ..style = PaintingStyle.fill;
    canvas.drawRRect(roundedStone, stonePaint);

    // 3. Tombstone 3D Bevel/Edge Shadow
    final Paint stoneBorderPaint = Paint()
      ..color = stoneEdgeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawRRect(roundedStone, stoneBorderPaint);

    // 4. Tombstone Engraving
    final Paint engravePaint = Paint()
      ..color = engraveColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    if (isStorm) {
      // Playzone Death: Render an electrified lightning crack on the stone
      final Path lightningPath = Path()
        ..moveTo(position.dx + 2, position.dy - 6)
        ..lineTo(position.dx - 1, position.dy - 2)
        ..lineTo(position.dx + 2, position.dy - 2)
        ..lineTo(position.dx - 2, position.dy + 3);
      canvas.drawPath(lightningPath, engravePaint);
    } else {
      // Combat Death: Render a traditional cross engraving
      canvas.drawLine(
        Offset(position.dx, position.dy - 5),
        Offset(position.dx, position.dy + 1),
        engravePaint,
      ); // Vertical
      canvas.drawLine(
        Offset(position.dx - 2.5, position.dy - 2.5),
        Offset(position.dx + 2.5, position.dy - 2.5),
        engravePaint,
      ); // Horizontal
    }
  }

  // --- MODULE: Event Decorators ---

  void _drawEventDecorator(Canvas canvas, Offset position, String event) {
    if (event == 'Kill' || event == 'BotKill') {
      // Hitmarker & Muzzle Flash
      final pulsePaint = Paint()
        ..color = const Color(0xFFFFD600).withOpacity(0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2;
      canvas.drawCircle(position, 15.0, pulsePaint);

      final crosshairPaint = Paint()
        ..color = const Color(0xFFFFD600)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.8
        ..strokeCap = StrokeCap.square;

      canvas.drawLine(
        Offset(position.dx, position.dy - 10),
        Offset(position.dx, position.dy - 16),
        crosshairPaint,
      );
      canvas.drawLine(
        Offset(position.dx, position.dy + 10),
        Offset(position.dx, position.dy + 16),
        crosshairPaint,
      );
      canvas.drawLine(
        Offset(position.dx - 10, position.dy),
        Offset(position.dx - 16, position.dy),
        crosshairPaint,
      );
      canvas.drawLine(
        Offset(position.dx + 10, position.dy),
        Offset(position.dx + 16, position.dy),
        crosshairPaint,
      );
    } else if (event == 'Loot') {
      // Realistic Airdrop / Loadout Decorator
      final Offset offsetDrop = Offset(position.dx + 10, position.dy - 8);

      // Shadow
      canvas.drawRect(
        Rect.fromLTWH(offsetDrop.dx - 4, offsetDrop.dy + 3, 9, 2),
        Paint()
          ..color = Colors.black54
          ..style = PaintingStyle.fill,
      );

      // Red Drop Base
      canvas.drawRect(
        Rect.fromLTWH(offsetDrop.dx - 4.5, offsetDrop.dy - 1, 9, 6),
        Paint()
          ..color = const Color(0xFFD32F2F)
          ..style = PaintingStyle.fill,
      );

      // Blue Tarpaulin Top
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(offsetDrop.dx - 5.5, offsetDrop.dy - 3, 11, 4),
          const Radius.circular(1.0),
        ),
        Paint()
          ..color = const Color(0xFF1976D2)
          ..style = PaintingStyle.fill,
      );
    }
  }

  @override
  bool shouldRepaint(covariant PlayerPainter oldDelegate) {
    return true;
  }
}

// ============================================================================
// NEW MODULE: UI LEGEND / KEY
// ============================================================================

class TelemetryLegend extends StatelessWidget {
  const TelemetryLegend({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF121212).withOpacity(0.85),
        border: Border.all(
          color: const Color(0xFF00E5FF).withOpacity(0.5),
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Wrap(
        spacing: 20,
        runSpacing: 12,
        children: [
          _buildLegendItem('Real Player', 'player'),
          _buildLegendItem('AI Bot', 'bot'),
          _buildLegendItem('Combat Death', 'grave_combat'),
          _buildLegendItem('Zone Death', 'grave_storm'),
          _buildLegendItem('Active Gunfire', 'combat'),
          _buildLegendItem('Looting Airdrop', 'loot'),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, String type) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 32,
          height: 24,
          child: CustomPaint(painter: _LegendIconPainter(iconType: type)),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// Painter specifically built to duplicate the logic of the main map but centered for UI
class _LegendIconPainter extends CustomPainter {
  final String iconType;

  _LegendIconPainter({required this.iconType});

  @override
  void paint(Canvas canvas, Size size) {
    // Center of the legend bounding box
    final Offset center = Offset(size.width / 2, size.height / 2);

    // Reusing the exact same painter logic by instantiating the PlayerPainter
    // with dummy data just to borrow its drawing methods.
    final renderer = PlayerPainter(players: []);

    switch (iconType) {
      case 'player':
        renderer._drawHumanFigure(canvas, center);
        break;
      case 'bot':
        renderer._drawBotFigure(canvas, center);
        break;
      case 'grave_combat':
        renderer._drawDeathMarker(canvas, center, 'Killed');
        break;
      case 'grave_storm':
        renderer._drawDeathMarker(canvas, center, 'KilledByStorm');
        break;
      case 'combat':
        // Draw player then hitmarker on top
        renderer._drawHumanFigure(canvas, center);
        renderer._drawEventDecorator(canvas, center, 'Kill');
        break;
      case 'loot':
        // Draw player then airdrop next to it
        renderer._drawHumanFigure(canvas, Offset(center.dx - 8, center.dy));
        renderer._drawEventDecorator(
          canvas,
          Offset(center.dx - 8, center.dy),
          'Loot',
        );
        break;
    }
  }

  @override
  bool shouldRepaint(covariant _LegendIconPainter oldDelegate) {
    return oldDelegate.iconType != iconType;
  }
}
