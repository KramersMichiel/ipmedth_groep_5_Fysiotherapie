import 'dart:ui';
import 'package:flutter/material.dart';


class ColorManager extends ChangeNotifier{
  ColorManager._privateConstructor();

  static final ColorManager _instance = ColorManager._privateConstructor();

  factory ColorManager(){
    return _instance;
  }
  
  final Map<Markers, Color> markerColors = {
    Markers.markerPoint: Colors.red,
    Markers.markerLeft: Colors.blue,
    Markers.markerRight: Colors.green,
  };

  Color getMarkerColor(Markers marker) {
    return markerColors[marker]!;
  }

  void setMarkerColor(Markers marker, Color newColor){
    markerColors[marker] = newColor;
    notifyListeners();
  }
}


enum Markers {
  markerPoint,
  markerLeft,
  markerRight,
}