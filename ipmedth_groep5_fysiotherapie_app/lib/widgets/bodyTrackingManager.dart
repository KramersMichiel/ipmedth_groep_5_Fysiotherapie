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
  Map<LandmarkAngle,double> calculateAngles(Pose pose){
    //convert two landmarks into a vector
    Vector2 makeVector2d(PoseLandmarkType point1Type, PoseLandmarkType point2Type){
      final PoseLandmark point1 = pose.landmarks[point1Type]!;
      final PoseLandmark point2 = pose.landmarks[point2Type]!;
      return Vector2(point2.x - point1.x, point2.y - point1.y);
    }

    //Makes a vector between a landmark and a virtual point
    Vector2 makeVector2dVirtual(PoseLandmarkType point1Type, Map<String,double> virtualPoint){
      final PoseLandmark point1 = pose.landmarks[point1Type]!;
      return Vector2(virtualPoint['x']! - point1.x, virtualPoint['y']! - point1.y);
    }

    //takes the x of point 1 and the y of point 2 to make a virtual point for angle calculations with only two points
    Map<String,double> makeVirtualPoint(PoseLandmarkType point1Type, PoseLandmarkType point2Type){
      return {'x': pose.landmarks[point1Type]!.x, 'y': pose.landmarks[point2Type]!.y};
    }

    //takes three landmarks and calculate the angle between them
    double getAngle2d(PoseLandmarkType anglePoint, PoseLandmarkType point1, PoseLandmarkType point2){
      final Vector2 vector1 = makeVector2d(anglePoint, point1);
      final Vector2 vector2 = makeVector2d(anglePoint, point2);
      return calculateAngle2d(vector1, vector2);
    }

    //In horizontal angle calculations with two points, like the hip or shoulder placement in the back view,
    //it is important to calculate the angle between the shoulders and a straight line from the lowest shoulder
    //Therefore one vector is from the lowest point to the highest and the other vector from the lowest point to
    //a point directly below the higher point on the y of the lower point
    double getAngle2dVirtualHorizontal(PoseLandmarkType point1, PoseLandmarkType point2){
      final bool point1IsHigher = pose.landmarks[point1]!.y == pose.landmarks[point2]!.y;
      Map<String,double> virtualPoint = makeVirtualPoint(point2, point1);
      PoseLandmarkType higherPoint = point2;
      PoseLandmarkType lowerPoint = point1;
      if(point1IsHigher){
        virtualPoint = makeVirtualPoint(point1, point2);
        higherPoint = point1;
        lowerPoint = point2;
      }
      final Vector2 vector1 = makeVector2d(lowerPoint, higherPoint);
      final Vector2 vector2 = makeVector2dVirtual(lowerPoint, virtualPoint);

      return calculateAngle2d(vector1, vector2);
    }

    //With the vertical calculations it is already known which point is higher
    //However it can differ from which point the angle needs be calculated, this can be bottoms up or top down
    //Therefore it is needed to enter where the virtual point needs to be placed to determine that location and which
    //point will be the angle point
    double getAngle2dVirtualVertical(PoseLandmarkType higherPoint, PoseLandmarkType lowerPoint, bool virtualIsHigher){
      Map<String,double> virtualPoint = makeVirtualPoint(higherPoint, lowerPoint);
      PoseLandmarkType anglePoint = higherPoint;
      PoseLandmarkType extendedPoint = lowerPoint;
      if(virtualIsHigher){
        virtualPoint = makeVirtualPoint(lowerPoint, higherPoint);
        anglePoint = lowerPoint;
        extendedPoint = higherPoint;
      }
      final Vector2 vector1 = makeVector2d(anglePoint, extendedPoint);
      final Vector2 vector2 = makeVector2dVirtual(anglePoint, virtualPoint);
      return calculateAngle2d(vector1, vector2);
    }

    //store all the calculated angles in a single map
    Map<LandmarkAngle,double> angles = {};

    //calculate the required angles from the sideview
    //Fysiotherapists use the deviation angle from a stretched leg instead of the direct angle of the knee
    //therefore the angle needs to be the calculated angle subtracted from 180 as this is the inverse
    angles[LandmarkAngle.leftKnee] = 180 - getAngle2d(PoseLandmarkType.leftKnee,PoseLandmarkType.leftHip, PoseLandmarkType.leftAnkle);
    angles[LandmarkAngle.rightKnee] = 180 - getAngle2d(PoseLandmarkType.rightKnee,PoseLandmarkType.rightHip, PoseLandmarkType.rightAnkle);
    //With the back the required angle is the offset from a straight line up from the hip
    angles[LandmarkAngle.back] = getAngle2dVirtualVertical(PoseLandmarkType.rightHip, PoseLandmarkType.rightShoulder, true);

    //calculate the required angles from the backview
    angles[LandmarkAngle.shoulders] = getAngle2dVirtualHorizontal(PoseLandmarkType.leftShoulder, PoseLandmarkType.rightShoulder);
    angles[LandmarkAngle.hips] = getAngle2dVirtualHorizontal(PoseLandmarkType.leftHip, PoseLandmarkType.rightHip);
    //With the heels the required offset is the offset from a straight line down from the ankle
    angles[LandmarkAngle.leftHeel] = getAngle2dVirtualVertical(PoseLandmarkType.leftAnkle, PoseLandmarkType.leftHeel, true);
    angles[LandmarkAngle.rightHeel] = getAngle2dVirtualVertical(PoseLandmarkType.rightAnkle, PoseLandmarkType.rightHeel, true);

    return angles;    
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

enum LandmarkAngle {leftKnee,rightKnee,zoom,back,shoulders,hips,leftHeel,rightHeel}