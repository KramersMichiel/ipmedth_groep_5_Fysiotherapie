import 'package:flutter/material.dart';
import 'dart:io';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:ipmedth_groep5_fysiotherapie_app/classes/bodyPainter.dart';
import 'dart:ui' as ui;
import 'package:ipmedth_groep5_fysiotherapie_app/widgets/bodyTrackingManager.dart';
import 'package:ipmedth_groep5_fysiotherapie_app/widgets/colorManager.dart';
import 'package:provider/provider.dart';

class Bodyanalasysdisplay extends StatefulWidget {
  const Bodyanalasysdisplay({super.key, required this.image, required this.imageFile});

  final ui.Image image;
  final File imageFile;

  @override
  State<Bodyanalasysdisplay> createState() => _BodyanalasysdisplayState();
}

class _BodyanalasysdisplayState extends State<Bodyanalasysdisplay> {
  final bodyManager = bodyTrackingManager();
  

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
    return  ChangeNotifierProvider(
      create: (context) => bodyTrackingManager(),
      child: FittedBox(
        //currently checks wether poses have been calculated
        //will display the pose canvas if they have or the base image if they havent
        child: Provider.of<bodyTrackingManager>(context).hasPose
          ?GestureDetector(
            onPanUpdate: (details){
              this.setState(() {
                if(bodyManager.getDragState() == PageState.dragScreen){
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
              child: 
                CustomPaint(painter: bodyPainter(widget.image, Provider.of<bodyTrackingManager>(context).getLandmarks(), Provider.of<bodyTrackingManager>(context).getAngles()!, isSideView, offset, zoom),child: Container(),)
              ),
          )
          :RawImage(image: widget.image),
      ),
    );
  }
}

