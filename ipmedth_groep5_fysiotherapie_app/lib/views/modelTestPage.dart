import 'package:flutter/material.dart';
import 'dart:io';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:ipmedth_groep5_fysiotherapie_app/widgets/bodyAnalasysDisplay.dart';
import 'package:ipmedth_groep5_fysiotherapie_app/widgets/bodyTrackingManager.dart';
import 'dart:ui' as ui;
import 'package:image_picker/image_picker.dart';


class modelTestPage extends StatefulWidget {
  const modelTestPage({super.key});
  @override
  State<modelTestPage> createState() => _modelTestPageState();
  
}

class _modelTestPageState extends State<modelTestPage> {
  final bodyTrackingManager bodyManager = bodyTrackingManager();

  Pose? pose;
  Map<LandmarkAngle,double>? angles;
  ui.Image? image;
  File? imageFile;
  //Because the landmarks in the recieved pose cant be altered it is unfortunately needed to make a seperate variable that is alterable
  Map<PoseLandmarkType,Map<newPoseElement,double>> newPose = {};
  //govern the state of the analasys display widget
  String stateText = "pan";
  PageState curState = PageState.dragScreen;

  final ImagePicker grabber = ImagePicker();

  //gives the user their galary to select an image and stores them as a file and as an ui.image
  Future<void> grabImage() async{
    final XFile? grabbedImage = await grabber.pickImage(source: ImageSource.gallery);
    if(grabbedImage != null){
      
      final File grabbedImageFile = File(grabbedImage.path);
      
      final ui.Image convertedImage = await _loadImage(grabbedImageFile);
      print(convertedImage.width);
      print(convertedImage.height);
      setState((){
        image = convertedImage;
        imageFile = grabbedImageFile;
      });
    }
  }

  //takes the image and inserts it into the bodymanager to get the given landmarks.
  //stores them in the state as a pose variable
  void analyseImage() async{
    if(imageFile != null){
      final List<Pose> poses = await bodyManager.analysePose(imageFile!);
      print(poses[0]);
      setState((){
        pose = poses[0];
        angles = bodyManager.calculateAngles(poses[0]);
        //prints the coordinates per landmark for testing purposes
        pose!.landmarks.forEach((_, landmark) {
          String printding = "${landmark.type}: ${landmark.x},${landmark.y},${landmark.z} ${landmark.likelihood}";
          print(printding);
          newPose[landmark.type] = {newPoseElement.x:landmark.x, newPoseElement.y:landmark.y, newPoseElement.zoom:1};
        }); 
      });
    }
  }

  //convert a file image to an ui.image
  Future<ui.Image> _loadImage(File file) async{
    final data = await file.readAsBytes();
    return await decodeImageFromList(data);
  }

  //Switch between the drag states of the analasys display
  void switchState(){
    setState((){
      switch(curState){
        case PageState.dragLandmark:
          curState = PageState.dragScreen;
          stateText = "pan";
          break;
        case PageState.dragScreen:
          curState = PageState.dragLandmark;
          stateText = "drag";
          break;
      }
    });
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height*0.9,
              width: MediaQuery.of(context).size.width*0.9,
              child: 
              image != null
              ?Bodyanalasysdisplay(image: image!, imageFile: imageFile!, pose: pose, angles: angles, newPose: newPose, dragMode: curState,)
              :DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.black
                )
                ) ,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
              style:  ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      elevation: 0,
                    ),
              onPressed: (){
              grabImage();
              },
              child: const Text("select image",
              style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                      ),)),
                  ElevatedButton(
                style:  ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        elevation: 0,
                      ),
                onPressed: (){
                analyseImage();
                },
                child: const Text("checkImage",
                style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                        ),)),
                        ElevatedButton(
                style:  ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        elevation: 0,
                      ),
                onPressed: (){
                switchState();
                },
                child: Text(stateText,
                style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                        ),)),
                        ]
              ),
          ],
        )
      ),
    );
  }
}

