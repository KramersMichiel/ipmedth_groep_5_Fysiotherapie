import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'dart:ui' as ui;

import 'package:ipmedth_groep5_fysiotherapie_app/classes/coordinate_translator.dart';

//this is the class to paint the body landmarks and other required visualisations(body lines, angles) on a given image
class bodyPainter extends CustomPainter {
  bodyPainter(this.image, this.pose, this.angles, this.isSideView, this.offset, [this.zoom = 1]);

  final ui.Image image;
  final Pose pose;
  final Map<String,double> angles;
  final bool isSideView;
  final double zoom;
  final Offset offset;

  @override
  void paint(Canvas canvas, Size size){
    //Sets the paint pallette for the visualisation
    //currently exists of a default paint color for the landmarks and seperate colors for body lines on the right and left side of the body
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

    
    //draws the image on the canvas to make sure it is displayed correctly
    //This also ensures the landmarks and other visualisations are always displayed correctly on the body
    Size imageSize = Size(image.width.toDouble(),image.height.toDouble());

    //is fucked, heeft iets met het feit dat het inverted is te maken.
    //de grootte van de image is inverse aan zijn grootte?? de offset moet inverted zijn??
    Rect imageRect = offset * -1 *(imageSize.height / size.height) *(1/zoom) & imageSize * (1/zoom);
    Rect canvasSize = Offset.zero & size;
    canvas.drawImageRect(image, imageRect, canvasSize, Paint());

    //Takes all the landmarks and draws them as points on the body
    //should not paint all landmarks, but that should be implemented later
    pose.landmarks.forEach((_, landmark) {
      canvas.drawCircle(
        Offset(
          //Because the size of the image is rarely the same size as the canvas the translate function calculates where
          //the position will be on the resized image
          translateX(landmark.x, size, imageSize) * zoom,
          translateY(landmark.y, size, imageSize) * zoom
          ) + offset,
        1,
        paint,
      );
    });

    //Function to take two landmarks and draw a line between them
    void paintLine(PoseLandmarkType type1, PoseLandmarkType type2, Paint paintType){
        final PoseLandmark joint1 = pose.landmarks[type1]!;
        final PoseLandmark joint2 = pose.landmarks[type2]!;
        canvas.drawLine(
          Offset(
            translateX(joint1.x, size, imageSize) * zoom,
            translateY(joint1.y, size, imageSize) * zoom
          ) + offset,
          Offset(
            translateX(joint2.x, size, imageSize) * zoom,
            translateY(joint2.y, size, imageSize) * zoom 
          ) + offset,
          paintType
        );
    }

    //Draws all the bodypart lines to be displayed on the body

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
    paintLine(
        PoseLandmarkType.rightHip, PoseLandmarkType.leftHip, paint);
    paintLine(
        PoseLandmarkType.leftShoulder, PoseLandmarkType.rightShoulder, paint);

    //Draw legs
    paintLine(PoseLandmarkType.leftHip, PoseLandmarkType.leftKnee, leftPaint);
    paintLine(
        PoseLandmarkType.leftKnee, PoseLandmarkType.leftAnkle, leftPaint);
    paintLine(
        PoseLandmarkType.rightHip, PoseLandmarkType.rightKnee, rightPaint);
    paintLine(
        PoseLandmarkType.rightKnee, PoseLandmarkType.rightAnkle, rightPaint);
    
    //Draw feet
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


    //set up the functions to display angles next to their bodyparts
    const textStyle = TextStyle(
      color: Colors.white,
      fontSize: 15,
    );

    void drawText(double angle, PoseLandmarkType displayLandmark, bool isLeft){
      TextPainter testPainter = TextPainter(
        text: TextSpan(text: angle.toStringAsFixed(1), style: textStyle),
        textDirection: TextDirection.ltr,
      );
      testPainter.layout(minWidth: 0,maxWidth: 40);
      Offset textPlace = Offset(translateX(pose.landmarks[displayLandmark]!.x + 10, size, imageSize) * zoom, translateY(pose.landmarks[displayLandmark]!.y, size, imageSize) * zoom) + offset; 
      if(isLeft){
        textPlace = Offset(translateX(pose.landmarks[displayLandmark]!.x - 55, size, imageSize) * zoom, translateY(pose.landmarks[displayLandmark]!.y, size, imageSize) * zoom) + offset; 
      }
      testPainter.paint(canvas, textPlace);
    }

    //display the angles
    //First checks which view is displayed and draws the associated angles
    if(isSideView){
      drawText(angles["leftKnee"]!, PoseLandmarkType.leftKnee, false);
      drawText(angles["rightKnee"]!, PoseLandmarkType.rightKnee, false);
      drawText(angles["back"]!, PoseLandmarkType.rightHip, false);
    }
    else{
      drawText(angles["shoulders"]!, PoseLandmarkType.rightShoulder, false);
      drawText(angles["hips"]!, PoseLandmarkType.rightHip, false);
      drawText(angles["leftHeel"]!, PoseLandmarkType.leftAnkle, true);
      drawText(angles["rightHeel"]!, PoseLandmarkType.rightAnkle, false);
    }
   
  }

  //Sets the condition in which the painter needs to redraw the canvas.
  //When this returns true it will repaint
  @override
  bool shouldRepaint(covariant bodyPainter oldDelegate){
    return oldDelegate.image != image || oldDelegate.pose != pose || oldDelegate.angles != angles || oldDelegate.offset != offset;
  }
}

