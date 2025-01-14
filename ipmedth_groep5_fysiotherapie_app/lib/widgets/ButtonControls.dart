import 'package:flutter/material.dart';
import 'package:better_player_plus/better_player_plus.dart';

class ButtonControls extends StatelessWidget {
  final BetterPlayerController controller1;
  final BetterPlayerController? controller2;
  final bool isPlayingFirstVideo;
  final VoidCallback togglePlayPause;
  final bool isLoopingEnabled; // Receive the loop state
  final VoidCallback toggleLooping;

  const ButtonControls({
    super.key,
    required this.controller1,
    this.controller2,
    required this.isPlayingFirstVideo,
    required this.togglePlayPause,
    required this.isLoopingEnabled, // Receive the loop state
    required this.toggleLooping,
  });

  BetterPlayerController get activeController {
    if (isPlayingFirstVideo || controller2 == null) {
      return controller1;
    } else {
      return controller2!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Loop Button
        IconButton(
          icon: Icon(
            Icons.loop,
            color: isLoopingEnabled
                ? Colors.red
                : Colors.black, // Change icon color based on loop state
          ),
          onPressed: toggleLooping, // Call the passed toggle function
        ),

        // Skip Backward Button (One Frame)
        IconButton(
          icon: const Icon(Icons.skip_previous),
          onPressed: () {
            skipFrame(context, backward: true);
          },
        ),

        // Pause/Play Button
        IconButton(
          icon: Icon(
            activeController.isPlaying() ?? false
                ? Icons.pause
                : Icons.play_arrow,
          ),
          onPressed: togglePlayPause,
        ),

        // Skip Forward Button (One Frame)
        IconButton(
          icon: const Icon(Icons.skip_next),
          onPressed: () {
            skipFrame(context, backward: false);
          },
        ),

        // Playback Speed Button
        IconButton(
          icon: const Icon(Icons.speed),
          onPressed: () {
            showPlaybackSpeedDialog(context);
          },
        ),
      ],
    );
  }

  void showPlaybackSpeedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Playback Speed'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [0.5, 1.0, 1.5, 2.0].map((speed) {
            return ListTile(
              title: Text('$speed x'),
              onTap: () {
                activeController.setSpeed(speed);
                Navigator.of(context).pop();
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void skipFrame(BuildContext context, {required bool backward}) async {
    // Get the current position of the video
    final currentPosition =
        await activeController.videoPlayerController!.position;
    if (currentPosition == null) return;

    // Frame duration assuming 30 FPS
    const frameDuration = Duration(milliseconds: 33);

    // Calculate the new position
    final newPosition = backward
        ? currentPosition - frameDuration
        : currentPosition + frameDuration;

    // Seek to the new position
    activeController.seekTo(newPosition);
  }
}
