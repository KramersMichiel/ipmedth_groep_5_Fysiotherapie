import 'package:flutter/material.dart';
import 'dart:io';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:ipmedth_groep5_fysiotherapie_app/classes/bodyPainter.dart';
import 'package:ipmedth_groep5_fysiotherapie_app/widgets/bodyTrackingManager.dart';
import 'dart:ui' as ui;

class Bodyanalasysdisplay extends StatefulWidget {
  const Bodyanalasysdisplay({super.key, required this.image, required this.imageFile, this.pose, this.angles});

  final ui.Image image;
  final File imageFile;
  final Pose? pose;
  final Map<String,double>? angles;

  @override
  State<Bodyanalasysdisplay> createState() => _BodyanalasysdisplayState();
}

class _BodyanalasysdisplayState extends State<Bodyanalasysdisplay> {


  double zoom = 3;
  PageState dragMode = PageState.dragScreen;  

  Offset offset = Offset(0,0);
  Offset minOffset = Offset(0,0);
  // Offset maxOffset = Offset(widget.image.width.toDouble(), );

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height*0.9;
    final width = MediaQuery.of(context).size.width*0.9;
    return  FittedBox(
      //currently checks wether poses have been calculated
      //will display the pose canvas if they have or the base image if they havent
      child: widget.pose != null
        ?GestureDetector(
          onPanUpdate: (details){
            this.setState(() {
              print((offset+details.delta).dy);
              print((widget.image.height*-1*(zoom-1)));
              if(dragMode == PageState.dragScreen && (offset+details.delta).dx < 0 && (offset+details.delta).dy < 0 && (offset+details.delta).dx > (widget.image.width*-1*(zoom-1))&& (offset+details.delta).dy > (widget.image.height*-1*(zoom-1))){
                offset+=details.delta;
              }
            });
            
          },
          child: SizedBox(
            //currently uses very large size coded in the widget itself to size itself
            height: height,
            width: width,
            //Also currently uses that same size, hardcoded in this section to size the canvas
            //Gives a custompaint, which uses the given image and pose to draw the image with the given landmarks as a canvas
            child: CustomPaint(painter: bodyPainter(widget.image, widget.pose!, widget.angles!, true, offset, zoom),child: Container(),)),
        )
        :RawImage(image: widget.image),
    );
  }
}
enum PageState {dragScreen, dragLandmark}