import 'package:flutter/material.dart';
import 'dart:io';
import '/widgets/bodyAnalysisMenu.dart'; // Import menu widget

class BodyAnalysisPage extends StatefulWidget {
  @override
  _BodyAnalysisPageState createState() => _BodyAnalysisPageState();
  final File? videoFile1;
  final File? videoFile2;
  final Widget child;

  BodyAnalysisPage(
      {required this.videoFile1,
      required this.videoFile2,
      required this.child});
}

class _BodyAnalysisPageState extends State<BodyAnalysisPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Body Analysis'),
      ),
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Body Analysis Content'),
              widget.child,
            ],
          ),
          BodyAnalysisMenu(), // Add your menu widget as an overlay
        ],
      ),
    );
  }
}
