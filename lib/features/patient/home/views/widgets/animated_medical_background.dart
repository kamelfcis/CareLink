import 'dart:math';
import 'package:flutter/material.dart';

/// A widget that renders floating, animated medical shapes as an overlay
/// on top of the content. Uses [IgnorePointer] so taps pass through to
/// the child below.
class AnimatedMedicalBackground extends StatefulWidget {
  final Widget child;
  const AnimatedMedicalBackground({super.key, required this.child});

  @override
  State<AnimatedMedicalBackground> createState() =>
      _AnimatedMedicalBackgroundState();
}

class _AnimatedMedicalBackgroundState extends State<AnimatedMedicalBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Actual content first (bottom layer)
        widget.child,
        // Shapes overlay on top — IgnorePointer so taps go through
        Positioned.fill(
          child: IgnorePointer(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return CustomPaint(
                  painter: _MedicalShapesPainter(
                    animationValue: _controller.value,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _MedicalShapesPainter extends CustomPainter {
  final double animationValue;

  _MedicalShapesPainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final shapes = _generateShapes(size);
    for (final shape in shapes) {
      shape.draw(canvas, size, animationValue);
    }
  }

  List<_MedicalShape> _generateShapes(Size size) {
    return [
      // ──── Top area: white shapes visible on teal gradient ────

      // Medical crosses
      _CrossShape(
        baseX: 0.08, baseY: 0.06,
        size: 24, opacity: 0.18, speed: 0.5, drift: 14,
        color: Colors.white,
      ),
      _CrossShape(
        baseX: 0.88, baseY: 0.10,
        size: 20, opacity: 0.14, speed: 0.7, drift: 10,
        color: Colors.white,
      ),
      _CrossShape(
        baseX: 0.50, baseY: 0.18,
        size: 16, opacity: 0.12, speed: 0.6, drift: 12,
        color: Colors.white,
      ),
      _CrossShape(
        baseX: 0.25, baseY: 0.14,
        size: 14, opacity: 0.10, speed: 0.8, drift: 8,
        color: Colors.white,
      ),
      _CrossShape(
        baseX: 0.72, baseY: 0.04,
        size: 18, opacity: 0.15, speed: 0.4, drift: 16,
        color: Colors.white,
      ),

      // Heartbeat lines
      _HeartbeatShape(
        baseX: 0.30, baseY: 0.22,
        width: 70, opacity: 0.14, speed: 1.0, drift: 8,
        color: Colors.white,
      ),
      _HeartbeatShape(
        baseX: 0.75, baseY: 0.16,
        width: 55, opacity: 0.10, speed: 0.7, drift: 6,
        color: Colors.white,
      ),

      // Circles
      _CircleShape(
        baseX: 0.15, baseY: 0.03,
        radius: 10, opacity: 0.16, speed: 0.3, drift: 20,
        color: Colors.white,
      ),
      _CircleShape(
        baseX: 0.60, baseY: 0.08,
        radius: 14, opacity: 0.12, speed: 0.5, drift: 16,
        color: Colors.white,
      ),
      _CircleShape(
        baseX: 0.92, baseY: 0.20,
        radius: 8, opacity: 0.14, speed: 0.4, drift: 18,
        color: Colors.white,
      ),

      // Capsules
      _CapsuleShape(
        baseX: 0.40, baseY: 0.12,
        width: 28, height: 12, opacity: 0.12, speed: 0.6, drift: 12, angle: 0.4,
        color: Colors.white,
      ),
      _CapsuleShape(
        baseX: 0.10, baseY: 0.20,
        width: 22, height: 9, opacity: 0.10, speed: 0.5, drift: 10, angle: -0.3,
        color: Colors.white,
      ),

      // ──── Lower area: teal shapes visible on white background ────

      _CrossShape(
        baseX: 0.12, baseY: 0.55,
        size: 22, opacity: 0.07, speed: 0.6, drift: 14,
        color: const Color(0xFF00C2CB),
      ),
      _CrossShape(
        baseX: 0.85, baseY: 0.65,
        size: 18, opacity: 0.06, speed: 0.5, drift: 10,
        color: const Color(0xFF00C2CB),
      ),
      _CrossShape(
        baseX: 0.50, baseY: 0.80,
        size: 16, opacity: 0.05, speed: 0.7, drift: 12,
        color: const Color(0xFF00C2CB),
      ),

      _HeartbeatShape(
        baseX: 0.35, baseY: 0.70,
        width: 65, opacity: 0.06, speed: 0.8, drift: 8,
        color: const Color(0xFF00C2CB),
      ),

      _CircleShape(
        baseX: 0.22, baseY: 0.45,
        radius: 12, opacity: 0.06, speed: 0.4, drift: 16,
        color: const Color(0xFF00C2CB),
      ),
      _CircleShape(
        baseX: 0.78, baseY: 0.50,
        radius: 9, opacity: 0.05, speed: 0.6, drift: 14,
        color: const Color(0xFF00C2CB),
      ),
      _CircleShape(
        baseX: 0.55, baseY: 0.90,
        radius: 10, opacity: 0.06, speed: 0.3, drift: 18,
        color: const Color(0xFF00C2CB),
      ),

      _CapsuleShape(
        baseX: 0.70, baseY: 0.75,
        width: 26, height: 10, opacity: 0.05, speed: 0.5, drift: 14, angle: 0.5,
        color: const Color(0xFF00C2CB),
      ),
      _CapsuleShape(
        baseX: 0.08, baseY: 0.85,
        width: 20, height: 8, opacity: 0.06, speed: 0.7, drift: 10, angle: -0.4,
        color: const Color(0xFF00C2CB),
      ),
    ];
  }

  @override
  bool shouldRepaint(_MedicalShapesPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}

// ────────── Base ──────────

abstract class _MedicalShape {
  final double baseX;
  final double baseY;
  final double opacity;
  final double speed;
  final double drift;
  final Color color;

  _MedicalShape({
    required this.baseX,
    required this.baseY,
    required this.opacity,
    required this.speed,
    required this.drift,
    required this.color,
  });

  Offset _offset(Size size, double t) {
    final dx = sin(t * speed * 2 * pi) * drift;
    final dy = cos(t * speed * 2 * pi * 0.7 + 0.5) * drift * 0.6;
    return Offset(
      baseX * size.width + dx,
      baseY * size.height + dy,
    );
  }

  void draw(Canvas canvas, Size size, double t);
}

// ────────── Cross / Plus ──────────

class _CrossShape extends _MedicalShape {
  final double size;

  _CrossShape({
    required super.baseX,
    required super.baseY,
    required this.size,
    required super.opacity,
    required super.speed,
    required super.drift,
    required super.color,
  });

  @override
  void draw(Canvas canvas, Size sz, double t) {
    final center = _offset(sz, t);
    final paint = Paint()
      ..color = color.withOpacity(opacity)
      ..strokeWidth = size * 0.28
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(center.dx, center.dy - size / 2),
      Offset(center.dx, center.dy + size / 2),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx - size / 2, center.dy),
      Offset(center.dx + size / 2, center.dy),
      paint,
    );
  }
}

// ────────── Heartbeat Line ──────────

class _HeartbeatShape extends _MedicalShape {
  final double width;

  _HeartbeatShape({
    required super.baseX,
    required super.baseY,
    required this.width,
    required super.opacity,
    required super.speed,
    required super.drift,
    required super.color,
  });

  @override
  void draw(Canvas canvas, Size sz, double t) {
    final center = _offset(sz, t);
    final paint = Paint()
      ..color = color.withOpacity(opacity)
      ..strokeWidth = 2.2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    final startX = center.dx - width / 2;
    final midY = center.dy;

    path.moveTo(startX, midY);
    path.lineTo(startX + width * 0.25, midY);
    path.lineTo(startX + width * 0.35, midY - width * 0.25);
    path.lineTo(startX + width * 0.45, midY + width * 0.15);
    path.lineTo(startX + width * 0.55, midY - width * 0.35);
    path.lineTo(startX + width * 0.65, midY + width * 0.1);
    path.lineTo(startX + width * 0.75, midY);
    path.lineTo(startX + width, midY);

    canvas.drawPath(path, paint);
  }
}

// ────────── Circle ──────────

class _CircleShape extends _MedicalShape {
  final double radius;

  _CircleShape({
    required super.baseX,
    required super.baseY,
    required this.radius,
    required super.opacity,
    required super.speed,
    required super.drift,
    required super.color,
  });

  @override
  void draw(Canvas canvas, Size sz, double t) {
    final center = _offset(sz, t);
    final paint = Paint()
      ..color = color.withOpacity(opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawCircle(center, radius, paint);
  }
}

// ────────── Capsule / Pill ──────────

class _CapsuleShape extends _MedicalShape {
  final double width;
  final double height;
  final double angle;

  _CapsuleShape({
    required super.baseX,
    required super.baseY,
    required this.width,
    required this.height,
    required super.opacity,
    required super.speed,
    required super.drift,
    required this.angle,
    required super.color,
  });

  @override
  void draw(Canvas canvas, Size sz, double t) {
    final center = _offset(sz, t);
    final paint = Paint()
      ..color = color.withOpacity(opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle + sin(t * speed * 2 * pi) * 0.2);

    final rect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset.zero, width: width, height: height),
      Radius.circular(height / 2),
    );
    canvas.drawRRect(rect, paint);

    canvas.restore();
  }
}
