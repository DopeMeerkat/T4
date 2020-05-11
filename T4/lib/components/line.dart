// import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class AnimatedPainter extends CustomPainter {
  final Animation<double> _animation;
  double r1, c1, r2, c2, strokeWidth;
  bool visible;
  AnimatedPainter(this._animation, this.r1, this.c1, this.r2, this.c2,
      this.strokeWidth, this.visible)
      : super(repaint: _animation);

  Path _createPath(Size size) {
    Path path = Path();
    path.moveTo(r1, c1);
    path.lineTo(r2, c2);
    return path;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final animationPercent = this._animation.value;

    // print("Painting + ${animationPercent} - ${size}");

    Path path = _createPath(size);
    PathMetric pathMetric = path.computeMetrics().first;
    Path extractPath =
        pathMetric.extractPath(0.0, pathMetric.length * animationPercent);

    final Paint paint = Paint();
    paint.color = Colors.amberAccent;
    paint.style = PaintingStyle.stroke;

    paint.strokeWidth = strokeWidth; //currently hardCoded

    if (visible) canvas.drawPath(extractPath, paint);
  }

  @override
  bool shouldRepaint(AnimatedPainter oldDelegate) {
    return true;
  }
}
