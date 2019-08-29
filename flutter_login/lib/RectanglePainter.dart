import 'package:flutter/material.dart';

class RectanglePainter extends CustomPainter {
  double _width, _height;

  RectanglePainter(Size size) {
    this._width = size.width;
    this._height = size.height * 0.65;
  }

  @override
  void paint(Canvas canvas, Size size) {

    double padding = _width / 10;
    double smallHeight = _height - 100;

    final paint = Paint();
    paint.color = Colors.white;
    paint.strokeWidth = 4.0;

    Path path = Path();
    path.moveTo(padding + 20, smallHeight + 10);
    path.quadraticBezierTo(padding, smallHeight, padding, smallHeight - 20);
    path.lineTo(padding, padding);
    path.quadraticBezierTo(padding, 0, padding * 2, 0);
    path.lineTo(_width - padding * 2, 0);
    path.quadraticBezierTo(_width - padding, 0, _width - padding, padding);
    path.lineTo(_width - padding, _height - padding);
    path.quadraticBezierTo(
        _width - padding, _height, _width - padding * 2, _height - 10);
    path.close();

    canvas.drawPath(path, paint);
    canvas.drawShadow(path, Colors.black26, 7, true);
    // TODO: implement paint
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}