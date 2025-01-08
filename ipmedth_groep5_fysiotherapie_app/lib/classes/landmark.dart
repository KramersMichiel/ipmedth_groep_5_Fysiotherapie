import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
class Landmark{
  double x;
  double y;
  double zoom;
  PoseLandmarkType type;

  Landmark(this.x, this.y, this.zoom, this.type);
}