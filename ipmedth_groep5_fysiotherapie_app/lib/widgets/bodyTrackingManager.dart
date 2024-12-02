import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

//singleton that has the bodytracker and can be called to do all the actions involving that
class bodyTrackingManager {
  bodyTrackingManager._privateConstructor();

  static final bodyTrackingManager _instance = bodyTrackingManager._privateConstructor();

  factory bodyTrackingManager(){
    return _instance;
  }

  final PoseDetector detector = PoseDetector(options: PoseDetectorOptions());


  Future<List<Pose>> analysePose(dynamic image) async{
    final InputImage inputImage = InputImage.fromFile(image);
    final options = PoseDetectorOptions();
    final PoseDetector detector = PoseDetector(options: options);
    
    return await detector.processImage(inputImage);
  }

  void paintBody(Canvas canvas, Size size){
    final paint = Paint();
  }

}