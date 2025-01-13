import 'package:flutter/material.dart';
import 'package:better_player_plus/better_player_plus.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:path_provider/path_provider.dart';


class ButtonControls extends StatelessWidget {
  final BetterPlayerController controller1;
  final BetterPlayerController? controller2;
  final bool isPlayingFirstVideo;

  const ButtonControls({
    super.key,
    required this.controller1,
    this.controller2,
    required this.isPlayingFirstVideo,
  });

  BetterPlayerController get activeController {
    if (isPlayingFirstVideo || controller2 == null) {
      return controller1;
    } else {
      return controller2!;
    }
  }

  void captureFrame() async {
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
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Pause Button
        IconButton(
          icon: const Icon(Icons.pause),
          onPressed: () {
            if (activeController.isPlaying() ?? false) {
              activeController.pause();
              captureFrame();
              print('paused');
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
