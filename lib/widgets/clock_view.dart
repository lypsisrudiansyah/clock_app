import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class ClockView extends StatefulWidget {
  final double size;

  const ClockView({Key key, this.size}) : super(key: key);

  @override
  _ClockViewState createState() => _ClockViewState();
}

class _ClockViewState extends State<ClockView> {
  @override
  void initState() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: 300,
      child: Transform.rotate(
        angle: -pi / 2,
        child: CustomPaint(
          painter: ClockPainter(),
        ),
      ),
    );
  }
}

class ClockPainter extends CustomPainter {
  var dateTime = DateTime.now();
  // 60 sec - 360 degree ,1 sec = 6 degree
  // 60 minute = 360, 1 minute = 6 degree
  // 24 hour = 360, 1 hour = 15 degree

  @override
  void paint(Canvas canvas, Size size) {
    var centerX = size.width / 2;
    var centerY = size.height / 2;
    var center = Offset(centerX, centerY);
    var radius = min(centerX, centerY);

    var fillBrush = Paint()..color = Color(0xFF444974);

    var outlineBrush = Paint()
      ..color = Color(0xFFEAECFF)
      ..style = PaintingStyle.stroke
      // ..strokeWidth = 16;
      ..strokeWidth = size.width / 20;

    var centerFillBruh = Paint()..color = Color(0xFFEAECFF);

    var secondHandBrush = Paint()
      ..color = Colors.orange
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      // ..strokeWidth = 5;
      ..strokeWidth = size.width / 60;

    var minuteHandBrush = Paint()
      ..shader = RadialGradient(colors: [Color(0xFF748EF6), Color(0xFF77DDFF)])
          .createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      // ..strokeWidth = 8;
      ..strokeWidth = size.width / 30;

    var hourHandBrush = Paint()
      ..shader = RadialGradient(colors: [Color(0xFFEA74AB), Color(0xFFC279FB)])
          .createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      // ..strokeWidth = 12;
      ..strokeWidth = size.width / 24;

    var dashBrush = Paint()
      ..color = Color(0xFFEAECFF)
      ..style = PaintingStyle.stroke
      // ..strokeCap = StrokeCap.round
      ..strokeWidth = 2;

    // canvas.drawCircle(center, radius - 40, fillBrush);
    // canvas.drawCircle(center, radius - 40, outlineBrush);
    canvas.drawCircle(center, radius * 0.75, fillBrush);
    canvas.drawCircle(center, radius * 0.75, outlineBrush);

    // var hourHandX = centerX + 60 * cos((dateTime.hour * 30 + dateTime.minute * 0.5) * pi / 180);
    // var hourHandY = centerX + 60 * sin((dateTime.hour * 30 + dateTime.minute * 0.5) * pi / 180);
    // canvas.drawLine(center, Offset(hourHandX, hourHandY), hourHandBrush);
    var hourHandX = centerX +
        radius *
            0.4 *
            cos((dateTime.hour * 30 + dateTime.minute * 0.5) * pi / 180);
    var hourHandY = centerX +
        radius *
            0.4 *
            sin((dateTime.hour * 30 + dateTime.minute * 0.5) * pi / 180);
    canvas.drawLine(center, Offset(hourHandX, hourHandY), hourHandBrush);

    var minuteHandX =
        centerX + radius * 0.6 * cos(dateTime.minute * 6 * pi / 180);
    var minuteHandY =
        centerX + radius * 0.6 * sin(dateTime.minute * 6 * pi / 180);
    canvas.drawLine(center, Offset(minuteHandX, minuteHandY), minuteHandBrush);

    var secondHandX =
        centerX + radius * 0.6 * cos(dateTime.second * 6 * pi / 180);
    var secondHandY =
        centerX + radius * 0.6 * sin(dateTime.second * 6 * pi / 180);
    canvas.drawLine(center, Offset(secondHandX, secondHandY), secondHandBrush);

    // canvas.drawCircle(center, 16, centerFillBruh);
    canvas.drawCircle(center, radius * 0.12, centerFillBruh);

    var outerCircleRadius = radius;
    var innerCircleRadius = radius * 0.9;
    for (var i = 0; i < 360; i += 12) {
      var x1 = centerX + outerCircleRadius * cos(i * pi / 180);
      var y1 = centerX + outerCircleRadius * sin(i * pi / 180);

      var x2 = centerX + innerCircleRadius * cos(i * pi / 180);
      var y2 = centerX + innerCircleRadius * sin(i * pi / 180);
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), dashBrush);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
