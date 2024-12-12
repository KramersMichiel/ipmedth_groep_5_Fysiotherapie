import 'package:flutter/material.dart';
import 'dart:io';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:ipmedth_groep5_fysiotherapie_app/classes/bodyPainter.dart';
import 'dart:ui' as ui;

class Bodyanalasysdisplay extends StatelessWidget {
  const Bodyanalasysdisplay({super.key, required this.image, required this.imageFile, this.pose});

  final ui.Image image;
  final File imageFile;
  final Pose? pose;
  @override
  Widget build(BuildContext context) {
    return  FittedBox(
      child: pose != null
        ?SizedBox(
          height: MediaQuery.of(context).size.height*0.9,
          width: MediaQuery.of(context).size.width*0.9,
          child: CustomPaint(painter: bodyPainter(image, pose!,), size: Size(MediaQuery.of(context).size.width*0.9,MediaQuery.of(context).size.height*0.9),child: Container(),))
        :RawImage(image: image),
    );
  }
}