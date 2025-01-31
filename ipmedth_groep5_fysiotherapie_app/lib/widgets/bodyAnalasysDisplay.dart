import 'package:flutter/material.dart';
import 'dart:io';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:ipmedth_groep5_fysiotherapie_app/classes/bodyPainter.dart';
import 'package:ipmedth_groep5_fysiotherapie_app/classes/debouncer.dart';
import 'package:ipmedth_groep5_fysiotherapie_app/classes/landmark.dart';
import 'dart:ui' as ui;
import 'package:ipmedth_groep5_fysiotherapie_app/widgets/bodyTrackingManager.dart';
import 'package:ipmedth_groep5_fysiotherapie_app/widgets/colorManager.dart';
import 'package:provider/provider.dart';
import 'package:collection/src/iterable_extensions.dart';

class Bodyanalasysdisplay extends StatefulWidget {
  const Bodyanalasysdisplay({super.key, required this.height, required this.width});

  final height;
  final width;

  @override
  State<Bodyanalasysdisplay> createState() => _BodyanalasysdisplayState();
}

class _BodyanalasysdisplayState extends State<Bodyanalasysdisplay> {
  final bodyManager = bodyTrackingManager();
  
  Debouncer debounce = Debouncer(milliseconds: 500);

  double zoom = 1;

  final ui.Image image = bodyTrackingManager().getImage()!;
  final File imageFile = File("/data/user/0/com.example.ipmedth_groep5_fysiotherapie_app/app_flutter/frame.png");

  Offset offset = Offset(0,0);
  Offset minOffset = Offset(0,0);

  //vars for drag and drop
  bool isDown = false;
  double dragX = 0;
  double dragY = 0;
  PoseLandmarkType? targetId;
  final double radius = 20;

  Offset fixOffset(Offset fingerOffset, double widthRatio, double heightRatio){
    fingerOffset = Offset(fingerOffset.dx/widthRatio, fingerOffset.dy/heightRatio);

    return fingerOffset;
  }

  double returnXorYRatio(double coordinate, double ratio){
    coordinate = coordinate * ratio;
    return coordinate;
  }

  //util function to determine if a landmark is inside the user drag circle
  bool isInObject(Landmark landmark, double dx, double dy, double widthRatio, double heightRatio){
    
    Path _tempPath = Path()
      ..addOval(Rect.fromCircle(
        center: Offset(landmark.x, landmark.y), radius: radius));
      Offset fixedOffset = fixOffset(Offset(dx, dy), widthRatio, heightRatio);
      return _tempPath.contains(fixedOffset);
  }

  //util function to detail the drag start details
  void _down(DragStartDetails details, Map<PoseLandmarkType,Landmark> landmarks, double widthRatio, double heightRatio){
    if(image != null){
      setState((){
        isDown = true;
        dragX = details.localPosition.dx;
        dragY = details.localPosition.dy;
      });

      targetId ??=landmarks.keys
        .firstWhereOrNull((PoseLandmarkType type) => isInObject(landmarks[type]!, dragX, dragY, widthRatio, heightRatio));
      if(targetId != null){
        print("Target: $targetId");
      }
    }
    
  }

  void _up(){
    setState((){
      isDown = false;
      targetId = null;
      bodyManager.calculateAngles();
    });
  }

//momenteel is ratio op x en y fucked, verder moet de drag constant werken en niet alleen elke halve seconde
//dus de point selectie moet op down gebeuren waarna de drag alleen dit punt verplaatst.
  void _move(DragUpdateDetails details, Map<PoseLandmarkType,Landmark> landmarks, double widthRatio, double heightRatio){
    if(isDown){
      print(targetId);
      if(targetId != null){
        setState((){
          landmarks[targetId]!.x = landmarks[targetId]!.x + details.delta.dx / widthRatio;
          landmarks[targetId]!.y = landmarks[targetId]!.y + details.delta.dy / heightRatio;
        });
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    bool isSideView = bodyManager.getIsSideView();

    double height = widget.height;
    double width = widget.width;
    
    double widthRatio = widget.width/image.width;
    
    double heightRatio = widget.height / image.height;
    
    if(image.height * widthRatio > widget.height){
      width = image.width * heightRatio;
      widthRatio = width / image.width;
    }
    else{
      height = image.height * widthRatio;
      heightRatio = height / image.height;
    }

    double maxWidth = image.width*-1*(zoom-1) * widthRatio;
    double maxHeight = image.height*-1*(zoom-1) * widthRatio;
    Map<PoseLandmarkType,Landmark> landmarks = Provider.of<bodyTrackingManager>(context).getLandmarks();
    

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
                else if(bodyManager.getDragState() == PageState.dragLandmark){
                  print(targetId);
                  _move(details, landmarks, widthRatio, heightRatio);
                }
              });
            },
            onPanStart:(details){
              if(bodyManager.getDragState() == PageState.dragLandmark){
                _down(details, landmarks, widthRatio, heightRatio);
                
              }
            },
            onPanEnd: (details){
              if(bodyManager.getDragState() == PageState.dragLandmark){
                _up();
              }
            },

            child: SizedBox(
              //currently uses very large size coded in the widget itself to size itself
              height: height,
              width: width,
              //Also currently uses that same size, hardcoded in this section to size the canvas
              //Gives a custompaint, which uses the given image and pose to draw the image with the given landmarks as a canvas
              child: 
                CustomPaint(painter: bodyPainter(image, landmarks, Provider.of<bodyTrackingManager>(context).getAngles()!, isSideView, offset, isDown, zoom),child: Container(),)
              ),
          )
          :RawImage(image: image),
      ),
    );
  }
}

