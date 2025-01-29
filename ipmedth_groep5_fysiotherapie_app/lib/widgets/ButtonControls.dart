import 'package:flutter/material.dart';
import 'package:better_player_plus/better_player_plus.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:path_provider/path_provider.dart';

class ButtonControls extends StatefulWidget {
  final BetterPlayerController controller1;
  final BetterPlayerController? controller2;
  final bool isPlayingFirstVideo;

  const ButtonControls({
    super.key,
    required this.controller1,
    this.controller2,
    required this.isPlayingFirstVideo,
  });

  @override
  _ButtonControlsState createState() => _ButtonControlsState();
}

class _ButtonControlsState extends State<ButtonControls> {
  late ValueNotifier<bool> isPlayingNotifier;
  bool isLoopingEnabled = false; // ✅ Voeg deze variabele toe

  BetterPlayerController get activeController {
    if (widget.isPlayingFirstVideo || widget.controller2 == null) {
      return widget.controller1;
    } else {
      return widget.controller2!;
    }
  }

  @override
  void initState() {
    super.initState();

    // Initialize ValueNotifier and listen to playback state changes
    isPlayingNotifier =
        ValueNotifier<bool>(activeController.isPlaying() ?? false);
    activeController.videoPlayerController?.addListener(() {
      final isPlaying = activeController.isPlaying() ?? false;
      isPlayingNotifier.value = isPlaying;
    });
  }

  void captureFrame() async {
    final videoPlayerController = activeController.videoPlayerController;
    if (videoPlayerController != null) {
      final position = await videoPlayerController.position;
      if (position != null) {
        final ffmpeg = FlutterFFmpeg();
        final inputPath = activeController.betterPlayerDataSource?.url;
        final directory = await getApplicationDocumentsDirectory();
        final outputPath =
            '${directory.path}/frame.png'; // Change this to your desired output path
        final command =
            ' -y -i $inputPath -ss ${position.inSeconds} -vframes 1 $outputPath';
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
        // Loop Button
        IconButton(
          icon: Icon(Icons.loop),
          color: isLoopingEnabled
              ? Colors.green
              : Colors.red, // ✅ Dynamische kleur
          iconSize: 24,
          onPressed: () {
            setState(() {
              isLoopingEnabled = !isLoopingEnabled; // ✅ Toggle loop state
              activeController
                  .setLooping(isLoopingEnabled); // ✅ Gebruik activeController
            });
          },
        ),
        // 0.1 seconds backwards
        IconButton(
          icon: const Icon(Icons.replay_10), // Icon for rewinding
          color: Colors.white,
          iconSize: 32,
          onPressed: () async {
            final position =
                await activeController.videoPlayerController?.position ??
                    Duration.zero;
            final newPosition = position - const Duration(milliseconds: 100);
            activeController.seekTo(
                newPosition > Duration.zero ? newPosition : Duration.zero);
          },
        ),
        // // Pause Button
        // IconButton(
        //   icon: const Icon(Icons.pause),
        //   onPressed: () {
        //     if (activeController.isPlaying() ?? false) {
        //       activeController.pause();
        //       captureFrame();
        //       print('paused');
        //     } else {
        //       activeController.play();
        //     }
        //   },
        // ),

        // Play/Pause button
        ValueListenableBuilder<bool>(
          valueListenable: isPlayingNotifier,
          builder: (context, isPlaying, child) {
            return GestureDetector(
              onTap: () {
                if (isPlaying) {
                  activeController.pause();
                  captureFrame();
                } else {
                  activeController.play();
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(12),
                child: Icon(
                  isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.black,
                  size: 36,
                ),
              ),
            );
          },
        ),

        // Go 0.1 seconds forward button
        IconButton(
          icon: const Icon(Icons.forward_10), // Icon for forwarding
          color: Colors.white,
          iconSize: 32,
          onPressed: () async {
            final position =
                await activeController.videoPlayerController?.position ??
                    Duration.zero;
            final duration =
                activeController.videoPlayerController?.value.duration ??
                    Duration.zero;
            final newPosition = position + const Duration(milliseconds: 100);
            activeController
                .seekTo(newPosition < duration ? newPosition : duration);
          },
        ),

        // Playback Speed Button
        IconButton(
          icon: const Icon(Icons.speed),
          color: Colors.white,
          iconSize: 24,
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
