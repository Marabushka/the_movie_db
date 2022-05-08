import 'dart:math';
import 'package:flutter/material.dart';

class RadialPercentWidget extends StatelessWidget {
  final Widget child;
  final double percent;
  final Color arcColor;
  final Color arcLeftColor;
  final double lineWidth;
  final Color freeColor;
  const RadialPercentWidget({
    Key? key,
    required this.child,
    required this.arcColor,
    required this.arcLeftColor,
    required this.lineWidth,
    required this.freeColor,
    required this.percent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        CustomPaint(
          painter: MyPainter(
            percent: percent,
            arcColor: arcColor,
            arcLeftColor: arcLeftColor,
            freeColor: freeColor,
            lineWidth: lineWidth,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(11.0),
          child: Center(child: child),
        ),
      ],
    );
  }
}

class MyPainter extends CustomPainter {
  final double percent;
  final Color arcColor;
  final Color arcLeftColor;
  final double lineWidth;
  final Color freeColor;

  MyPainter({
    required this.percent,
    required this.arcColor,
    required this.arcLeftColor,
    required this.lineWidth,
    required this.freeColor,
  });
  @override
  void paint(Canvas canvas, Size size) {
    final arcRect = calculatingArcsRect(size);
    drawBackground(canvas, size);
    drawLeftArc(canvas, arcRect);
    drawMainArc(canvas, arcRect);
  }

  void drawMainArc(Canvas canvas, Rect arcRect) {
    final arcPaint = Paint();
    arcPaint.color = arcColor;
    arcPaint.style = PaintingStyle.stroke;
    arcPaint.strokeWidth = lineWidth;
    arcPaint.strokeCap = StrokeCap.round;
    canvas.drawArc(
      arcRect,
      -pi / 2,
      percent * 2 * pi,
      false,
      arcPaint,
    );
  }

  void drawLeftArc(Canvas canvas, Rect arcRect) {
    final arcLeftPaint = Paint();
    arcLeftPaint.color = arcLeftColor;
    arcLeftPaint.style = PaintingStyle.stroke;
    arcLeftPaint.strokeWidth = lineWidth;

    canvas.drawArc(
      arcRect,
      percent * 2 * pi - (pi / 2),
      (1.0 - percent) * 2 * pi,
      false,
      arcLeftPaint,
    );
  }

  void drawBackground(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = freeColor;
    canvas.drawOval(Offset.zero & size, paint);
  }

  Rect calculatingArcsRect(Size size) {
    const linesMargin = 3;
    final offset = lineWidth / 2 + linesMargin;
    final arcRect = Offset(offset, offset) &
        Size(size.width - offset * 2, size.height - offset * 2);
    return arcRect;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
