import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lila_black_analytics/AppSession.dart';

class StylishLoadingPage extends StatefulWidget {
  AppSession appSession;
  StylishLoadingPage({super.key, required this.appSession});

  @override
  State<StylishLoadingPage> createState() => _StylishLoadingPageState();
}

class _StylishLoadingPageState extends State<StylishLoadingPage>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _textController;

  String loadingText = "Loading";

  @override
  void initState() {
    super.initState();

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    _animateText();
  }

  void _animateText() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 300));

      if (!mounted) return false;

      setState(() {
        if (loadingText == "Loading") {
          loadingText = "Loading.";
        } else if (loadingText == "Loading.") {
          loadingText = "Loading..";
        } else if (loadingText == "Loading..") {
          loadingText = "Loading...";
        } else {
          loadingText = "Loading";
        }
      });

      return mounted;
    });
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff0F172A), Color(0xff1E293B), Color(0xff111827)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Container(
            width: 260,
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white.withOpacity(0.15)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedBuilder(
                  animation: _rotationController,
                  builder: (_, child) {
                    return Transform.rotate(
                      angle: _rotationController.value * 2 * pi,
                      child: child,
                    );
                  },
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const SweepGradient(
                        colors: [
                          Colors.transparent,
                          Colors.cyan,
                          Colors.blue,
                          Colors.purple,
                        ],
                      ),
                    ),
                    child: Center(
                      child: Container(
                        width: 65,
                        height: 65,
                        decoration: const BoxDecoration(
                          color: Color(0xff111827),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.cloud_download_rounded,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  loadingText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "Please wait while we prepare everything",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.65),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
