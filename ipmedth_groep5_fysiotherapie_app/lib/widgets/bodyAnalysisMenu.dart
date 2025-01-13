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
  late AnimationController _controller;
  late Animation<double> _animation;
  final bodyTrackingManager bodyManager = bodyTrackingManager();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleMenu() {
    setState(() {
      isOpen = !isOpen;
      if (isOpen) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
    _toggleAnalysis();
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
      children: [
        Positioned(
          bottom: 30,
          right: 30,
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              _buildOption(Icons.color_lens, 0),
              FloatingActionButton(
                onPressed: _toggleAnalysis,
                child: const Icon(Icons.camera),
              ),
              // _buildOption(Icons.camera, 1),
              _buildOption(Icons.zoom_in, 2),
              FloatingActionButton(
                onPressed: _toggleMenu,
                child: const Icon(Icons.settings),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOption(IconData icon, int index) {
    final double angle = index * 45.0;
    final double rad = angle * (3.1415926535897932 / 180.0);
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset.fromDirection(
              rad - 3.1415926535897932, _animation.value * 100),
          child: Transform.scale(
            scale: _animation.value,
            child: FloatingActionButton(
              mini: true,
              onPressed: () {},
              child: Icon(icon),
            ),
          ),
        );
      },
    );
  }
}
