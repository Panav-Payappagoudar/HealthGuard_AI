import 'package:flutter/material.dart';
import 'dart:math' as math;

class AnimatedGradientBackground extends StatefulWidget {
  final Widget child;

  const AnimatedGradientBackground({
    super.key,
    required this.child,
  });

  @override
  State<AnimatedGradientBackground> createState() =>
      _AnimatedGradientBackgroundState();
}

class _AnimatedGradientBackgroundState extends State<AnimatedGradientBackground>
    with TickerProviderStateMixin {
  late AnimationController _waveController;
  late AnimationController _particleController;
  late Animation<double> _waveAnimation;
  late Animation<double> _particleAnimation;

  @override
  void initState() {
    super.initState();

    _waveController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    );

    _particleController = AnimationController(
      duration: const Duration(seconds: 12),
      vsync: this,
    );

    _waveAnimation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(
      parent: _waveController,
      curve: Curves.linear,
    ));

    _particleAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _particleController,
      curve: Curves.linear,
    ));

    _waveController.repeat();
    _particleController.repeat();
  }

  @override
  void dispose() {
    _waveController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_waveAnimation, _particleAnimation]),
      builder: (context, child) {
        return CustomPaint(
          painter: GradientWavePainter(
            wavePhase: _waveAnimation.value,
            particlePhase: _particleAnimation.value,
          ),
          child: widget.child,
        );
      },
    );
  }
}

class GradientWavePainter extends CustomPainter {
  final double wavePhase;
  final double particlePhase;

  GradientWavePainter({
    required this.wavePhase,
    required this.particlePhase,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Create gradient background
    final gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        const Color(0xFFFFFFFF),
        const Color(0xFFF5F5F7),
        const Color(0xFFFFFFFF),
      ],
      stops: const [0.0, 0.5, 1.0],
    );

    final backgroundPaint = Paint()
      ..shader =
          gradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height), backgroundPaint);

    // Draw animated waves
    _drawWaves(canvas, size);

    // Draw floating particles
    _drawParticles(canvas, size);
  }

  void _drawWaves(Canvas canvas, Size size) {
    final wavePaint = Paint()
      ..color = const Color(0xFF0071E3).withValues(alpha: 0.1)
      ..style = PaintingStyle.fill;

    final path = Path();
    final waveHeight = size.height * 0.15;
    final waveWidth = size.width;

    // First wave
    path.moveTo(0, size.height * 0.7);
    for (double x = 0; x <= waveWidth; x += 1) {
      final y = size.height * 0.7 +
          math.sin((x / waveWidth * 2 * math.pi) + wavePhase) *
              waveHeight *
              0.3;
      path.lineTo(x, y);
    }
    path.lineTo(waveWidth, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, wavePaint);

    // Second wave with different phase
    final path2 = Path();
    final wavePaint2 = Paint()
      ..color = const Color(0xFF0071E3).withValues(alpha: 0.05)
      ..style = PaintingStyle.fill;

    path2.moveTo(0, size.height * 0.8);
    for (double x = 0; x <= waveWidth; x += 1) {
      final y = size.height * 0.8 +
          math.sin((x / waveWidth * 2 * math.pi) + wavePhase + math.pi / 3) *
              waveHeight *
              0.2;
      path2.lineTo(x, y);
    }
    path2.lineTo(waveWidth, size.height);
    path2.lineTo(0, size.height);
    path2.close();

    canvas.drawPath(path2, wavePaint2);
  }

  void _drawParticles(Canvas canvas, Size size) {
    final particlePaint = Paint()
      ..color = const Color(0xFF0071E3).withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;

    // Draw floating particles
    for (int i = 0; i < 8; i++) {
      final x = (size.width * 0.1) +
          (i * size.width * 0.12) +
          math.sin(particlePhase * 2 * math.pi + i) * 20;
      final y = (size.height * 0.2) +
          (i % 3) * (size.height * 0.15) +
          math.cos(particlePhase * 2 * math.pi + i * 0.7) * 30;

      final radius =
          2.0 + math.sin(particlePhase * 2 * math.pi + i * 1.5) * 1.5;

      canvas.drawCircle(Offset(x, y), radius, particlePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
