import 'package:flutter/material.dart';
import 'package:better_player_plus/better_player_plus.dart';
import 'dart:io';

class VideoPlayerPage extends StatefulWidget {
  final String videoPath;

  const VideoPlayerPage({super.key, required this.videoPath});

  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late BetterPlayerController betterPlayerController;

  @override
  void initState() {
    super.initState();
    print("VideoPlayerPage: initState called");
    print("Initializing BetterPlayerController with path: ${widget.videoPath}");
    try {
      betterPlayerController = BetterPlayerController(
        const BetterPlayerConfiguration(),
        betterPlayerDataSource: BetterPlayerDataSource(
          BetterPlayerDataSourceType.file,
          widget.videoPath,
        ),
      );
      print("BetterPlayerController initialized successfully");
    } catch (e) {
      print("Error initializing BetterPlayerController: $e");
    }
  }

  @override
  void dispose() {
    print("Disposing BetterPlayerController");
    betterPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("VideoPlayerPage: build method called");
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Player'),
      ),
      body: Center(
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: BetterPlayer(
            controller: betterPlayerController,
          ),
        ),
      ),
    );
  }
}
