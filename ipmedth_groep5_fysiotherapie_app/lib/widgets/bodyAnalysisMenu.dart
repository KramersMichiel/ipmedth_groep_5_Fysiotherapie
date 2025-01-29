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
    bodyManager.setIsSideView(activeController == widget.controller1);
    await captureFrame();
    bodyManager.analysePose(File(
        "/data/user/0/com.example.ipmedth_groep5_fysiotherapie_app/app_flutter/frame.png"));
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
        //ffmpeg accepteerd seconden om frames te pakken, hierbij accepteren ze wel commagetallen om ook tussen de seconden frames te pakken
        final double positionMilsSecond = position.inMilliseconds/1000;
        final ffmpeg = FlutterFFmpeg();
        final inputPath = activeController.betterPlayerDataSource?.url;
        final directory = await getApplicationDocumentsDirectory();
        final outputPath =
            '${directory.path}/frame.png'; // Change this to your desired output path
        final command =
            ' -y -i $inputPath -ss ${positionMilsSecond} -vframes 1 $outputPath';
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
          bottom: MediaQuery.of(context).size.height * 0.23,
          right: MediaQuery.of(context).size.width * 0.05,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Button 1
              if (isOpen)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: GestureDetector(
                    onTap: _toggleAnalysis,
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: const Color(0xFF77BEDB), // Blue background color
                        shape: BoxShape.circle, // Circular shape
                        border: Border.all(
                            color: Colors.black, width: 1), // Black border
                      ),
                      child: const Icon(
                        Icons.analytics_sharp,
                        color: Colors.black, // White icon color
                        size: 24,
                      ),
                    ),
                  ),
                ),
              // Button 2
              if (isOpen)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: GestureDetector(
                    onTap: bodyManager.switchDragState,
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: const Color(0xFF77BEDB), // Blue background color
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black, width: 1),
                      ),
                      child: const Icon(
                        Icons.open_with,
                        color: Colors.black,
                        size: 32,
                      ),
                    ),
                  ),
                ),
              // Button 3
              if (isOpen)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: GestureDetector(
                    onTap: () => print('testbutton3'),
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: const Color(0xFF77BEDB), // Blue background color
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black, width: 1),
                      ),
                      child: const Icon(
                        Icons.zoom_in,
                        color: Colors.black,
                        size: 32,
                      ),
                    ),
                  ),
                ),
              // Main Menu Button
              GestureDetector(
                onTap: _toggleMenu,
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: const Color(0xFF77BEDB),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black, width: 1),
                  ),
                  child: Center(
                    child: Icon(
                      isOpen ? Icons.close : Icons.build,
                      color: Colors.black,
                      size: 32,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
