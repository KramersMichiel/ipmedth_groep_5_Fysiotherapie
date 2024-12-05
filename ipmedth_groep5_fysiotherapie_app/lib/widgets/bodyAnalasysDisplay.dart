import 'package:flutter/material.dart';
import 'dart:io';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:ipmedth_groep5_fysiotherapie_app/classes/bodyPainter.dart';
import 'package:ipmedth_groep5_fysiotherapie_app/widgets/bodyTrackingManager.dart';
import 'dart:ui' as ui;

class Bodyanalasysdisplay extends StatelessWidget {
  const Bodyanalasysdisplay({super.key, required this.image, required this.imageFile, this.pose, this.angles});

  final ui.Image image;
  final File imageFile;
  final Pose? pose;
  final Map<String,double>? angles;
  @override
  Widget build(BuildContext context) {
    return  FittedBox(
      //currently checks wether poses have been calculated
      //will display the pose canvas if they have or the base image if they havent
      child: pose != null
        ?SizedBox(
          //currently uses very large size coded in the widget itself to size itself
          height: MediaQuery.of(context).size.height*0.9,
          width: MediaQuery.of(context).size.width*0.9,
          //Also currently uses that same size, hardcoded in this section to size the canvas
          //Gives a custompaint, which uses the given image and pose to draw the image with the given landmarks as a canvas
          child: CustomPaint(painter: bodyPainter(image, pose!, angles!, false), size: Size(MediaQuery.of(context).size.width*0.9,MediaQuery.of(context).size.height*0.9),child: Container(),))
        :RawImage(image: image),
    );
  }
}