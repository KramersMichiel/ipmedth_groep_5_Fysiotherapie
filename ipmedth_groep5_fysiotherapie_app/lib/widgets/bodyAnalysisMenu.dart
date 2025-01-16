import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ipmedth_groep5_fysiotherapie_app/widgets/bodyTrackingManager.dart';
import 'package:better_player_plus/better_player_plus.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:path_provider/path_provider.dart';

class BodyAnalysisMenu extends StatefulWidget {
  final BetterPlayerController controller1;
  final BetterPlayerController? controller2;
  final bool isPlayingFirstVideo;

  const BodyAnalysisMenu({
    super.key,
    required this.controller1,
    this.controller2,
    required this.isPlayingFirstVideo,
    });

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


  void _toggleAnalysis() async {
    
    await captureFrame();
    bodyManager.analysePose(File("/data/user/0/com.example.ipmedth_groep5_fysiotherapie_app/app_flutter/frame.png"));
  }
  
  BetterPlayerController get activeController {
    if (widget.isPlayingFirstVideo || widget.controller2 == null) {
      return widget.controller1;
    } else {
      return widget.controller2!;
    }
  }

  Future<bool> captureFrame() async {
    final videoPlayerController = activeController.videoPlayerController;
    if (videoPlayerController != null) {
      final position = await videoPlayerController.position;
      if (position != null) {
        final ffmpeg = FlutterFFmpeg();
        final inputPath = activeController.betterPlayerDataSource?.url;
        final directory = await getApplicationDocumentsDirectory();
        final outputPath = '${directory.path}/frame.png'; // Change this to your desired output path
        final command = ' -y -i $inputPath -ss ${position.inSeconds} -vframes 1 $outputPath';
        await ffmpeg.execute(command);
        print('Frame captured at $outputPath');
        
        // Use a logging framework instead of print
        // print('Frame captured at $outputPath');
        // Example using a logging framework
        // log('Frame captured at $outputPath');
        //log the path
        // print('Frame captured at $outputPath');
      }
    }
    return true;
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
