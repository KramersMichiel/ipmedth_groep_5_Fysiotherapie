import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ipmedth_groep5_fysiotherapie_app/widgets/bodyTrackingManager.dart';

class BodyAnalysisMenu extends StatefulWidget {
  @override
  _BodyAnalysisMenuState createState() => _BodyAnalysisMenuState();
}

class _BodyAnalysisMenuState extends State<BodyAnalysisMenu>
    with SingleTickerProviderStateMixin {
  bool isOpen = false;
  final bodyTrackingManager bodyManager = bodyTrackingManager();

  @override
  void initState() {
    super.initState();
  }

  void _toggleMenu() {
    setState(() {
      isOpen = !isOpen;
    });
  }

  // Test functions for each button
  void _handleButton1() {
    print('Button 1 pressed - Color Lens');
  }

  void _handleButton2() {
    print('Button 2 pressed - Camera');
    _toggleAnalysis();
  }

  void _handleButton3() {
    print('Button 3 pressed - Zoom');
  }

  void _toggleAnalysis() {
    bodyManager.analysePose(File(
        "/data/user/0/com.example.ipmedth_groep5_fysiotherapie_app/app_flutter/frame.png"));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        // Background overlay when menu is open
        if (isOpen)
          Positioned.fill(
            child: GestureDetector(
              onTap: _toggleMenu,
              child: Container(color: Colors.black.withOpacity(0.5)),
            ),
          ),
        // Buttons and Menu
        Positioned(
          bottom: 30,
          right: 30,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Button 1
              if (isOpen)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: FloatingActionButton(
                    heroTag: 'btn1',
                    onPressed: () => print('testbutton1'),
                    child: Icon(Icons.analytics_sharp),
                  ),
                ),
              // Button 2
              if (isOpen)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: FloatingActionButton(
                    heroTag: 'btn2',
                    onPressed: () => print('testbutton2'),
                    child: Icon(Icons.color_lens),
                  ),
                ),
              // Button 3
              if (isOpen)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: FloatingActionButton(
                    heroTag: 'btn3',
                    onPressed: () => print('testbutton3'),
                    child: Icon(Icons.zoom_in),
                  ),
                ),
              // Main Menu Button
              FloatingActionButton(
                heroTag: 'menu',
                onPressed: _toggleMenu,
                child: Icon(isOpen ? Icons.close : Icons.settings),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
