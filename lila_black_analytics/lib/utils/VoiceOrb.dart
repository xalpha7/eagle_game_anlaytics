import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lila_black_analytics/AppSession.dart';

class VoiceOrb_Retro extends StatefulWidget {
  final AppSession appSession;
  const VoiceOrb_Retro({super.key, required this.appSession});

  @override
  State<VoiceOrb_Retro> createState() => _VoiceOrb_RetroState();
}

class _VoiceOrb_RetroState extends State<VoiceOrb_Retro>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  double energy = 0.0;

  @override
  void initState() {
    super.initState();
    // Using a longer duration for smooth, continuous geometric mutations
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 10))
          ..addListener(() => setState(() {}))
          ..repeat();
  }

  double _safe(double v) => (v.isNaN || v.isInfinite) ? 0.0 : v;

  @override
  Widget build(BuildContext context) {
    final state = "thinking";

    // High-precision running time scalar
    final double t = controller.value * 2 * pi;

    return Transform.scale(
      scale: 1.0 + (energy * 0.15),
      child: Center(
        child: CustomPaint(
          size: const Size(300, 300),
          painter: MorphOrbPainter(
            t: t,
            energy: energy.clamp(0.0, 1.0),
            state: state,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class MorphOrbPainter extends CustomPainter {
  final double t;
  final double energy;
  final String state;

  MorphOrbPainter({required this.t, required this.energy, required this.state});

  double clamp01(double v) => v.clamp(0.0, 1.0);

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final baseRadius = size.width * 0.25;

    // -----------------------------
    // DYNAMIC COLOR PALETTE MANAGMENT (JARVIS EMISSIONS)
    // -----------------------------
    Color coreColor = const Color(0xFF00E5FF); // Jarvis Cyan default
    Color accentColor = const Color(0xFF00B0FF);

    if (state == "speaking" || state == "start_speaking") {
      coreColor = const Color(0xFFFFC400); // Amber/Gold active communication
      accentColor = const Color(0xFFFF6D00);
    } else if (state == "processing" || state == "thinking") {
      coreColor = const Color(
        0xFF7C4DFF,
      ); // Deep Neural Purple / Brain-wave Blue
      accentColor = const Color(0xFF00E5FF);
    } else if (state == "fetching") {
      coreColor = const Color(
        0xFFFF1744,
      ); // High intensity network polling (Red/Pink)
      accentColor = const Color(0xFFFF9100);
    } else if (state == "fetched") {
      coreColor = const Color(0xFF00E676); // Success flash Green
      accentColor = const Color(0xFF00B0FF);
    }

    // -----------------------------
    // LAYER 1: AMBIENT DIGITAL GLOW
    // -----------------------------
    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          coreColor.withOpacity(clamp01(0.35 * (1.0 + energy))),
          accentColor.withOpacity(clamp01(0.12 * (1.0 + energy))),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: center, radius: baseRadius * 2.5))
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 30);

    canvas.drawCircle(center, baseRadius * 2.0, glowPaint);

    // -----------------------------
    // LAYER 2: TELEMETRY TECH RINGS (JARVIS HUD STYLING)
    // -----------------------------
    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = coreColor.withOpacity(0.25);

    // Inner rotating dashed telemetry bracket
    _drawDashedCircle(canvas, center, baseRadius * 0.8, ringPaint, 12, t);
    // Outer opposite-rotating bracket
    _drawDashedCircle(
      canvas,
      center,
      baseRadius * 1.3,
      ringPaint..color = accentColor.withOpacity(0.15),
      6,
      -t * 0.5,
    );

    // =========================================================
    // 🔥 LAYER 3: SHARP NEURAL FILAMENT PATH ENGINE
    // =========================================================
    final neuronPath = Path();
    // High resolution vertex evaluation for sharp fractures
    const int vertices = 180;

    for (int i = 0; i <= vertices; i++) {
      final angle = (i / vertices) * 2 * pi;
      double nodeModifier = 1.0;

      switch (state) {
        case "start_speaking":
          // Sharp outward sonic spikes
          double spike = sin(angle * 8).abs();
          nodeModifier = 1.0 + pow(spike, 4.0) * 0.6 * energy;
          break;

        case "speaking":
          // Extreme fractal neuron spikes driven by incoming voice frequency amplitudes
          double neuralFrequencies =
              sin(angle * 12 + t * 4) * cos(angle * 5 - t * 2);
          // Convert smooth waves to sharp crisp step vectors using absolute powers
          nodeModifier =
              1.0 + (neuralFrequencies.abs() * (0.15 + energy * 0.45));
          if (i % 15 == 0)
            nodeModifier += 0.12 * energy; // Artificial neuron structural nodes
          break;

        case "thinking":
          // Intricate Brain-lobe symmetry structure
          double brainLobeSymmetry =
              (sin(angle * 2).abs() * 0.2) + (cos(angle * 6).abs() * 0.1);
          nodeModifier = 0.85 + brainLobeSymmetry + sin(t * 2) * 0.05;
          break;

        case "processing":
          // Crystalline matrix layout (Hexagonal sharp steps)
          double hexPattern = sin(
            angle * 6 + t * 3,
          ).sign; // Hard geometric floor transitions
          nodeModifier = 1.0 + hexPattern * 0.08 * (1.0 + energy * 0.5);
          break;

        case "fetching":
          // Inward-collapsing data vortex lines
          double inwardSpike = cos(angle * 16 - t * 5).abs();
          nodeModifier = 1.2 - pow(inwardSpike, 3.0) * 0.35;
          break;

        case "fetched":
          // Symmetrical high frequency geometric star confirming handshake stabilization
          double starShape = sin(angle * 4).abs();
          nodeModifier = 1.0 + pow(starShape, 2.0) * 0.15 * (1.0 - energy);
          break;

        case "stopped_speaking":
        default:
          // Soft crystalline rest state
          nodeModifier = 1.0 + sin(angle * 5 + t) * 0.03 + (energy * 0.1);
          break;
      }

      final r = baseRadius * nodeModifier;
      final x = center.dx + cos(angle) * r;
      final y = center.dy + sin(angle) * r;

      if (i == 0) {
        neuronPath.moveTo(x, y);
      } else {
        neuronPath.lineTo(x, y);
      }
    }
    neuronPath.close();

    // Render primary neural filament shield
    final filamentPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..shader = RadialGradient(
        colors: [coreColor, accentColor.withOpacity(0.4)],
      ).createShader(Rect.fromCircle(center: center, radius: baseRadius * 1.5));

    canvas.drawPath(neuronPath, filamentPaint);

    // Render dense energetic crystalline web fill
    final meshFillPaint = Paint()
      ..style = PaintingStyle.fill
      ..shader = RadialGradient(
        colors: [
          coreColor.withOpacity(0.45),
          accentColor.withOpacity(0.15),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: center, radius: baseRadius * 1.2));
    canvas.drawPath(neuronPath, meshFillPaint);

    // =========================================================
    // LAYER 4: CENTRAL CORE ARCHITECTURE
    // =========================================================
    final corePaint = Paint()..style = PaintingStyle.fill;

    // Outer floating atomic shielding core
    corePaint.color = Colors.white.withOpacity(clamp01(0.2 + energy * 0.3));
    canvas.drawCircle(center, 12 + energy * 15, corePaint);

    // High energy sharp point node center
    corePaint.color = Colors.white;
    double coreRadius =
        5.0 +
        (state == "processing" || state == "fetching"
            ? 4.0 * sin(t * 6).abs()
            : 2.0);
    canvas.drawCircle(center, coreRadius, corePaint);
  }

  // Helper calculation engine to draw custom telemetry arc subdivisions safely
  void _drawDashedCircle(
    Canvas canvas,
    Offset center,
    double radius,
    Paint paint,
    int segments,
    double rotationPhase,
  ) {
    final double arcLength = (2 * pi) / (segments * 2);
    for (int i = 0; i < segments; i++) {
      final double startAngle = (i * 2 * pi / segments) + rotationPhase;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        arcLength,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant MorphOrbPainter oldDelegate) {
    return oldDelegate.t != t ||
        oldDelegate.energy != energy ||
        oldDelegate.state != state;
  }
}
