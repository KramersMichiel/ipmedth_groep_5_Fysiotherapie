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

    // canvas.drawImage(image, Offset.zero, Paint());

    Size imageSize = Size(image.width.toDouble(),image.height.toDouble());

    Rect imageRect = Offset.zero & imageSize;
    Rect canvasSize = Offset.zero & size;
    canvas.drawImageRect(image, imageRect, canvasSize, Paint());

    pose.landmarks.forEach((_, landmark) {
      canvas.drawCircle(
        Offset(
          translateX(landmark.x, size, imageSize),
          translateY(landmark.y, size, imageSize) 
          ),
        1,
        paint,
      );
    });

    void paintLine(PoseLandmarkType type1, PoseLandmarkType type2, Paint paintType){
        final PoseLandmark joint1 = pose.landmarks[type1]!;
        final PoseLandmark joint2 = pose.landmarks[type2]!;
        canvas.drawLine(
          Offset(
            translateX(joint1.x, size, imageSize),
            translateY(joint1.y, size, imageSize) 
          ),
          Offset(
            translateX(joint2.x, size, imageSize),
            translateY(joint2.y, size, imageSize) 
          ),
          paintType
        );
    }

    //Draw arms
    // paintLine(
    //     PoseLandmarkType.leftShoulder, PoseLandmarkType.leftElbow, leftPaint);
    // paintLine(
    //     PoseLandmarkType.leftElbow, PoseLandmarkType.leftWrist, leftPaint);
    // paintLine(PoseLandmarkType.rightShoulder, PoseLandmarkType.rightElbow,
    //     rightPaint);
    // paintLine(
    //     PoseLandmarkType.rightElbow, PoseLandmarkType.rightWrist, rightPaint);

    //Draw Body
    paintLine(
        PoseLandmarkType.leftShoulder, PoseLandmarkType.leftHip, leftPaint);
    paintLine(PoseLandmarkType.rightShoulder, PoseLandmarkType.rightHip,
        rightPaint);

    //Draw legs
    paintLine(PoseLandmarkType.leftHip, PoseLandmarkType.leftKnee, leftPaint);
    paintLine(
        PoseLandmarkType.leftKnee, PoseLandmarkType.leftAnkle, leftPaint);
    paintLine(
        PoseLandmarkType.rightHip, PoseLandmarkType.rightKnee, rightPaint);
    paintLine(
        PoseLandmarkType.rightKnee, PoseLandmarkType.rightAnkle, rightPaint);
    paintLine(
        PoseLandmarkType.leftAnkle, PoseLandmarkType.leftHeel, leftPaint);
    paintLine(
        PoseLandmarkType.rightAnkle, PoseLandmarkType.rightHeel, rightPaint);
    paintLine(
        PoseLandmarkType.leftAnkle, PoseLandmarkType.leftFootIndex, leftPaint);
    paintLine(
        PoseLandmarkType.rightAnkle, PoseLandmarkType.rightFootIndex, rightPaint);
    paintLine(
        PoseLandmarkType.leftHeel, PoseLandmarkType.leftFootIndex, leftPaint);
    paintLine(
        PoseLandmarkType.rightHeel, PoseLandmarkType.rightFootIndex, rightPaint);

  }

  @override
  bool shouldRepaint(covariant bodyPainter oldDelegate){
    return oldDelegate.image != image || oldDelegate.pose != pose;
  }
}

