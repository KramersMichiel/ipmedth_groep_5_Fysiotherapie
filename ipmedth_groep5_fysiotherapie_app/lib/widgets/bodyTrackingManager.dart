import 'dart:io';
import 'dart:math';
import 'package:vector_math/vector_math.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

//singleton that has the bodytracker and can be called to do all the actions involving that
class bodyTrackingManager {
  bodyTrackingManager._privateConstructor();

  static final bodyTrackingManager _instance = bodyTrackingManager._privateConstructor();

  //if the bodytracking managers constructor is called checks wether it already exists. If it does returns its instance instead of making a new one
  factory bodyTrackingManager(){
    return _instance;
  }

  //directly set a posedetector. Prevents multiple versions from existing and prevents having to construct it for every analasys
  final PoseDetector detector = PoseDetector(options: PoseDetectorOptions());

  //Takes an input image as file and runs the machine learning model on it
  //returns the found landmarks from the first person found
  Future<List<Pose>> analysePose(File image) async{
    final InputImage inputImage = InputImage.fromFile(image);
    final options = PoseDetectorOptions();
    final PoseDetector detector = PoseDetector(options: options);
    
    return await detector.processImage(inputImage);
  }

  //function for finding all the required body angles from a given persons found bodyparts
  void calculateAngles(Pose pose){
    //convert two landmarks into a vector
    Vector2 makeVector2d(PoseLandmarkType point1Type, PoseLandmarkType point2Type){
      final PoseLandmark point1 = pose.landmarks[point1Type]!;
      final PoseLandmark point2 = pose.landmarks[point2Type]!;
      return Vector2(point2.x - point1.x, point2.y - point1.y);
    }

    //takes three landmarks and calculate the angle between them
    double getAngle2d(PoseLandmarkType anglePoint, PoseLandmarkType point1, PoseLandmarkType point2){
      final Vector2 vector1 = makeVector2d(anglePoint, point1);
      final Vector2 vector2 = makeVector2d(anglePoint, point2);
      return calculateAngle2d(vector1, vector2);
    }
    //store all the calculated angles in a single map
    Map<String,double> angles = {};

    //calculate the required angles from the sideview
    angles['leftKnee'] = getAngle2d(PoseLandmarkType.leftKnee,PoseLandmarkType.leftHip, PoseLandmarkType.leftAnkle);
    angles['rightKnee'] = getAngle2d(PoseLandmarkType.rightKnee,PoseLandmarkType.rightHip, PoseLandmarkType.rightAnkle);

    
  }

}

//calculate the length of a vector
double calculateVectorLength(Vector2 vector){
  return sqrt(pow(vector.x,2)+pow(vector.y,2));
}

//calculate the angle of two vectors using the dot product them
double calculateAngle2d(Vector2 vector1, Vector2 vector2){
  return degrees(acos(dot2(vector1, vector2) / (calculateVectorLength(vector1) * calculateVectorLength(vector2))));
}