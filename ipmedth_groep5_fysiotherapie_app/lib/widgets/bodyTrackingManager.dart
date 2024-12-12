import 'dart:io';
import 'dart:math';
import 'package:vector_math/vector_math.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

//singleton that has the bodytracker and can be called to do all the actions involving that
class bodyTrackingManager {
  bodyTrackingManager._privateConstructor();

  static final bodyTrackingManager _instance = bodyTrackingManager._privateConstructor();

  factory bodyTrackingManager(){
    return _instance;
  }

  final PoseDetector detector = PoseDetector(options: PoseDetectorOptions());


  Future<List<Pose>> analysePose(File image) async{
    final InputImage inputImage = InputImage.fromFile(image);
    final options = PoseDetectorOptions();
    final PoseDetector detector = PoseDetector(options: options);
    
    return await detector.processImage(inputImage);
  }

  void calculateAngles(Pose pose){
    Vector2 makeVector2d(PoseLandmarkType point1Type, PoseLandmarkType point2Type){
      final PoseLandmark point1 = pose.landmarks[point1Type]!;
      final PoseLandmark point2 = pose.landmarks[point2Type]!;
      return Vector2(point2.x - point1.x, point2.y - point1.y);
    }

    double getAngle2d(PoseLandmarkType anglePoint, PoseLandmarkType point1, PoseLandmarkType point2){
      final Vector2 vector1 = makeVector2d(anglePoint, point1);
      final Vector2 vector2 = makeVector2d(anglePoint, point2);
      return calculateAngle2d(vector1, vector2);
    }
    Map<String,double> angles = {};

    angles['leftKnee'] = getAngle2d(PoseLandmarkType.leftKnee,PoseLandmarkType.leftHip, PoseLandmarkType.leftAnkle);
    angles['rightKneeAngle'] = getAngle2d(PoseLandmarkType.rightKnee,PoseLandmarkType.rightHip, PoseLandmarkType.rightAnkle);

    
  }

}

double calculateVectorLength(Vector2 vector){
    return sqrt(pow(vector.x,2)+pow(vector.y,2));
  }

  double calculateAngle2d(Vector2 vector1, Vector2 vector2){
    return degrees(acos(dot2(vector1, vector2) / (calculateVectorLength(vector1) * calculateVectorLength(vector2))));
  }