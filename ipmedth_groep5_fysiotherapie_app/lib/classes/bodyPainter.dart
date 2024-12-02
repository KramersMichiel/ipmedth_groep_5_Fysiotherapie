import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'dart:ui' as ui;

import 'package:ipmedth_groep5_fysiotherapie_app/classes/coordinate_translator.dart';


class bodyPainter extends CustomPainter {
  bodyPainter(this.image, this.pose);

  final ui.Image image;
  final Pose pose;

  @override
  void paint(Canvas canvas, Size size){
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..color = Colors.green;

    final leftPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = Colors.yellow;

    final rightPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = Colors.blueAccent;

    print("test");
    print(size);
    // canvas.drawImage(image, Offset.zero, Paint());

    Size imageSize = Size(image.width.toDouble(),image.height.toDouble());

    Rect imageRect = Offset.zero & imageSize;
    Rect canvasSize = Offset.zero & size;
    canvas.drawImageRect(image, imageRect, canvasSize, Paint());

    pose.landmarks.forEach((_, landmark) {
      canvas.drawCircle(
        Offset(
          translateX(landmark.x, size, imageSize),
          translateX(landmark.y, size, imageSize) 
          ),
        1,
        paint,
      );
    });
  }

  @override
  bool shouldRepaint(covariant bodyPainter oldDelegate){
    return oldDelegate.image != image || oldDelegate.pose != pose;
  }
}