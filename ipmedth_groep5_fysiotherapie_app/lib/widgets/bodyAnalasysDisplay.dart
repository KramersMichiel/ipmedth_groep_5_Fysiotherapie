import 'package:flutter/material.dart';
import 'dart:io';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:ipmedth_groep5_fysiotherapie_app/classes/bodyPainter.dart';
import 'dart:ui' as ui;
import 'package:ipmedth_groep5_fysiotherapie_app/widgets/bodyTrackingManager.dart';

class Bodyanalasysdisplay extends StatefulWidget {
  const Bodyanalasysdisplay({super.key, required this.image, required this.imageFile, this.pose, this.angles, required this.newPose, required this.dragMode});

  final ui.Image image;
  final File imageFile;
  final Pose? pose;
  final Map<LandmarkAngle,double>? angles;
  final Map<PoseLandmarkType,Map<newPoseElement,double>> newPose;
  final PageState dragMode;

  @override
  State<Bodyanalasysdisplay> createState() => _BodyanalasysdisplayState();
}

class _BodyanalasysdisplayState extends State<Bodyanalasysdisplay> {

  bool isSideView = true;
  double zoom = 3;

  Offset offset = Offset(0,0);
  Offset minOffset = Offset(0,0);
  // Offset maxOffset = Offset(widget.image.width.toDouble(), );

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height*0.9;
    final width = MediaQuery.of(context).size.width*0.9;
    double ratio = width/widget.image.width;
    double maxWidth = widget.image.width*-1*(zoom-1) * ratio;
    double maxHeight = widget.image.height*-1*(zoom-1) * ratio;
    return  FittedBox(
      //currently checks wether poses have been calculated
      //will display the pose canvas if they have or the base image if they havent
      child: widget.pose != null
        ?GestureDetector(
          onPanUpdate: (details){
            this.setState(() {
              if(widget.dragMode == PageState.dragScreen){
                Offset offsetChange = offset + details.delta;
                if(offsetChange.dx < 0 && offsetChange.dy < 0 && offsetChange.dx > maxWidth && offsetChange.dy > maxHeight){
                  offset = offsetChange;
                }
              }
            });
            
          },
          child: SizedBox(
            //currently uses very large size coded in the widget itself to size itself
            height: height,
            width: width,
            //Also currently uses that same size, hardcoded in this section to size the canvas
            //Gives a custompaint, which uses the given image and pose to draw the image with the given landmarks as a canvas
            child: CustomPaint(painter: bodyPainter(widget.image, widget.pose!, widget.angles!, isSideView, offset, zoom),child: Container(),)),
        )
        :RawImage(image: widget.image),
    );
  }
}
enum PageState {dragScreen, dragLandmark}
enum newPoseElement {x,y,zoom}