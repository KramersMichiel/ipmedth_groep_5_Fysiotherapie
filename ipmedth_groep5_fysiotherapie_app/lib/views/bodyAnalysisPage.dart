import 'package:flutter/material.dart';
import 'dart:io';

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
      body: Center(
        child: Text('Body Analysis Content'),
      ),
    );
  }
}
