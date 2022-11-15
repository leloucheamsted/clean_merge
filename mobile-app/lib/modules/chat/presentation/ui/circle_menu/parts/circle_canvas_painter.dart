part of circle_menu_all;

class CircleCanvasPainter extends CustomPainter {
  final Color color;
  final Color colorInteractive;
  final double radius;
  final double radiusChild;
  CircleCanvasPainter({
    required this.color,
    required this.colorInteractive,
    required this.radius,
    required this.radiusChild,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paintBorder = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final Paint paintBorderInteractive = Paint()
      ..color = colorInteractive
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final Paint circleFill = Paint()
      ..color = colorInteractive
      ..style = PaintingStyle.fill;

    final Offset startOffset = size.center(Offset.zero);

    final double radius2 = radius - radiusChild * 2 - 8;

    final double innerRadius = radius - radius2;

    canvas.drawCircle(startOffset, innerRadius + 2, circleFill);

    canvas.drawCircle(startOffset, innerRadius + 6, paintBorderInteractive);

    canvas.drawCircle(startOffset, radius - radiusChild, paintBorder);

    canvas.drawCircle(startOffset, radius2, paintBorder);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
