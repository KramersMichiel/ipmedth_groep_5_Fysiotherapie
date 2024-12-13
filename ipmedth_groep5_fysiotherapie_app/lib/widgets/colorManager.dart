import 'dart:ui';
import 'package:flutter/material.dart';


class ColorManager {
  ColorManager._privateConstructor();

  static final ColorManager _instance = ColorManager._privateConstructor();

  factory ColorManager(){
    return _instance;
  }
  
  final Map<Markers, Color> markerColors = {
    Markers.markerPoint: Colors.red,
    Markers.markerleft: Colors.blue,
    Markers.markerRight: Colors.green,
  };

  Color getMarkerColor(Markers marker) {
    return markerColors[marker]!;
  }

  void setMarkerColors(Markers marker, Color newColor){
    markerColors[marker] = newColor;
  }
}


enum Markers {
  markerPoint,
  markerleft,
  markerRight,
}