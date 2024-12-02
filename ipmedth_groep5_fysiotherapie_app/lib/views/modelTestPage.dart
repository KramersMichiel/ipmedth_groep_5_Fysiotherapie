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
  ui.Image? image;
  File? imageFile;

  final ImagePicker grabber = ImagePicker();

  Future<void> grabImage() async{
    final XFile? grabbedImage = await grabber.pickImage(source: ImageSource.gallery);
    if(grabbedImage != null){
      
      final File grabbedImageFile = File(grabbedImage.path);
      
      final ui.Image convertedImage = await _loadImage(grabbedImageFile);
      print(convertedImage!.width);
      print(convertedImage!.height);
      setState((){
        image = convertedImage;
        imageFile = grabbedImageFile;
      });
    }
  }

  void analyseImage() async{
    if(imageFile != null){
      final List<Pose> poses = await bodyManager.analysePose(imageFile!);
      print(poses[0]);
      setState((){
        pose = poses[0];
        pose!.landmarks.forEach((_, landmark) {
          var type = landmark.type;
          var x = landmark.x;
          var y = landmark.y;
          String printDing = type.toString() + " " + x.toString() + " " + y.toString();
          print(printDing);
        }); 
      });
    }
  }

  Future<ui.Image> _loadImage(File file) async{
    final data = await file.readAsBytes();
    return await decodeImageFromList(data);
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
              ?Bodyanalasysdisplay(image: image!, imageFile: imageFile!, pose: pose,)
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
              child: Text("select image",
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
                child: Text("checkImage",
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