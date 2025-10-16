import 'dart:ui' as ui;
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DonutCalories extends StatelessWidget {
  final double radius;
  final double consumed;
  final double burned;
  final double target;
  final String remainingText;
  final String leftLabel;
  final String rightLabel;

  const DonutCalories({
    super.key,
    required this.radius,
    required this.consumed,
    required this.burned,
    required this.target,
    required this.remainingText,
    required this.leftLabel,
    required this.rightLabel,
  });

  @override
  Widget build(BuildContext context) {
    final remaining =
        (target - (consumed - burned)).clamp(0.0, double.infinity);
    final progress = target > 0 ? (consumed - burned) / target : 0.0;
    final clampedProgress = progress.clamp(0.0, 1.0);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Left column - consumed calories
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                leftLabel,
                maxLines: 2,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              FittedBox(
                child: Text(
                  '${consumed.round()}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Center donut chart - fixed size
        SizedBox(
          width: radius * 2,
          height: radius * 2,
          child: TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 800),
            tween: Tween(begin: 0.0, end: clampedProgress),
            builder: (context, animatedProgress, child) {
              return CustomPaint(
                size: Size(radius * 2, radius * 2),
                painter: DonutPainter(
                  progress: animatedProgress,
                  consumed: consumed,
                  burned: burned,
                  remaining: remaining,
                  remainingText: remainingText,
                ),
              );
            },
          ),
        ),
        // Right column - burned calories
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                rightLabel,
                maxLines: 2,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              FittedBox(
                child: Text(
                  '${burned.round()}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class DonutPainter extends CustomPainter {
  final double progress;
  final double consumed;
  final double burned;
  final double remaining;
  final String remainingText;

  DonutPainter({
    required this.progress,
    required this.consumed,
    required this.burned,
    required this.remaining,
    required this.remainingText,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final strokeWidth = 20.0;

    // Background circle
    final backgroundPaint = Paint()
      ..color = Colors.grey[200]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius - strokeWidth / 2, backgroundPaint);

    // Progress arc
    final progressPaint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * 3.14159 * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
      -3.14159 / 2, // Start from top
      sweepAngle,
      false,
      progressPaint,
    );

    // Text
    final textPainter = TextPainter(
      text: TextSpan(
        children: [
          TextSpan(
            text: NumberFormat('#,###').format(remaining.round()),
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          TextSpan(
            text: '\n$remainingText',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
      textAlign: TextAlign.center,
      textDirection: ui.TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        center.dx - textPainter.width / 2,
        center.dy - textPainter.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
