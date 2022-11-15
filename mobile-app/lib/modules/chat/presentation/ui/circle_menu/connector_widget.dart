import 'package:flutter/material.dart';

class ConnectorWidget extends StatelessWidget {
  final Color color;
  const ConnectorWidget({
    Key? key,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DotConnecPainter(
        color: color,
      ),
    );
  }
}

class _DotConnecPainter extends CustomPainter {
  final Color color;
  // final double radius;
  _DotConnecPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      // ..strokeWidth = 3
      ..style = PaintingStyle.fill;

    final Path path = Path();
    final double curveAddH = size.width * .15;
    const double curveAddV = 10;

    final Offset center = size.center(Offset.zero);

    path.moveTo(0, 0);
    // path.lineTo(size.width, 0);
    path.quadraticBezierTo(center.dx, curveAddV, size.width, 0);
    path.quadraticBezierTo(center.dx - curveAddH, center.dy, size.width, size.height);
    path.quadraticBezierTo(center.dx, size.height - curveAddV, 0, size.height);
    // path.lineTo(0, size.height);
    path.quadraticBezierTo(center.dx + curveAddH, center.dy, 0, 0);
    // path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
