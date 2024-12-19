import 'package:flutter/material.dart';
import 'package:better_player_plus/better_player_plus.dart';

class ButtonControls extends StatelessWidget {
  final BetterPlayerController controller1;
  final BetterPlayerController? controller2;
  final bool isPlayingFirstVideo;

  const ButtonControls({
    Key? key,
    required this.controller1,
    this.controller2,
    required this.isPlayingFirstVideo,
  }) : super(key: key);

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
        // Pause Button
        IconButton(
          icon: Icon(Icons.pause),
          onPressed: () {
            if (activeController.isPlaying() ?? false) {
              activeController.pause();
            } else {
              activeController.play();
            }
          },
        ),

        // Loop Button
        IconButton(
          icon: const Icon(Icons.loop),
          onPressed: () {
            final loopingEnabled =
                activeController.betterPlayerConfiguration.looping;
            // Use a workaround for enabling/disabling looping
            activeController.setLooping(!loopingEnabled);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    !loopingEnabled ? 'Looping Enabled' : 'Looping Disabled'),
              ),
            );
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
}
