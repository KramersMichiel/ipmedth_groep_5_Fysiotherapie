import 'package:flutter/material.dart';
import 'package:better_player_plus/better_player_plus.dart';

class ButtonControls extends StatelessWidget {
  final BetterPlayerController controller1;
  final BetterPlayerController? controller2;
  final bool isPlayingFirstVideo;
  final VoidCallback togglePlayPause;
  final bool isLoopingEnabled;
  final VoidCallback toggleLooping;

  const ButtonControls({
    Key? key,
    required this.controller1,
    this.controller2,
    required this.isPlayingFirstVideo,
    required this.togglePlayPause,
    required this.isLoopingEnabled,
    required this.toggleLooping,
  }) : super(key: key);

  BetterPlayerController get activeController {
    if (isPlayingFirstVideo || controller2 == null) {
      return controller1;
    } else {
      return controller2!;
    }
  }

  void skipOneFrameForward() {
    final currentPosition =
        activeController.videoPlayerController?.value.position ?? Duration.zero;
    activeController.seekTo(currentPosition +
        const Duration(milliseconds: 42)); // Approx. one frame
  }

  void skipOneFrameBackward() {
    final currentPosition =
        activeController.videoPlayerController?.value.position ?? Duration.zero;
    activeController.seekTo(currentPosition -
        const Duration(milliseconds: 42)); // Approx. one frame
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
            color: isLoopingEnabled ? Colors.red : Colors.black,
          ),
          onPressed: toggleLooping,
        ),
        // Skip Backward Button
        IconButton(
          icon: const Icon(Icons.skip_previous),
          onPressed: skipOneFrameBackward,
        ),
        // Pause Button
        IconButton(
          icon: Icon(
            activeController.isPlaying() ?? false
                ? Icons.pause
                : Icons.play_arrow,
          ),
          onPressed: togglePlayPause,
        ),
        // Skip Forward Button
        IconButton(
          icon: const Icon(Icons.skip_next),
          onPressed: skipOneFrameForward,
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
}
