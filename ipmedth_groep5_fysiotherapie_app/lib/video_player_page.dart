import 'package:flutter/material.dart';
import 'package:better_player_plus/better_player_plus.dart';

class VideoPlayerPage extends StatelessWidget {
  final String videoPath;

  const VideoPlayerPage({super.key, required this.videoPath});

  @override
  Widget build(BuildContext context) {
    print("Initializing BetterPlayer with path: $videoPath");

    try {
      final BetterPlayerController betterPlayerController =
          BetterPlayerController(
        const BetterPlayerConfiguration(),
        betterPlayerDataSource: BetterPlayerDataSource(
          BetterPlayerDataSourceType.file,
          videoPath,
        ),
      );

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
    } catch (e) {
      print("Error initializing BetterPlayer: $e");
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('Failed to initialize the video player.'),
        ),
      );
    }
  }
}
