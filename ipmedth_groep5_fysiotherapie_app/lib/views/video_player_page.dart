import 'package:flutter/material.dart';
import 'package:better_player_plus/better_player_plus.dart';
import 'package:ipmedth_groep5_fysiotherapie_app/widgets/ButtonControls.dart';

class VideoPlayerPage extends StatefulWidget {
  final String? videoPath1;
  final String? videoPath2;

  const VideoPlayerPage({super.key, required this.videoPath1, this.videoPath2});

  @override
  VideoPlayerPageState createState() => VideoPlayerPageState();
}

class VideoPlayerPageState extends State<VideoPlayerPage> {
  late BetterPlayerController _controller1;
  BetterPlayerController? _controller2;
  bool isPlayingFirstVideo = true;
  bool isLoopingEnabled = false;

  @override
  void initState() {
    super.initState();
    if (widget.videoPath1 != null) {
      _controller1 = _createController(widget.videoPath1!);
    }
    if (widget.videoPath2 != null) {
      _controller2 = _createController(widget.videoPath2!);
    }
  }

  BetterPlayerController _createController(String videoPath) {
    return BetterPlayerController(
      const BetterPlayerConfiguration(
          autoPlay: false,
          aspectRatio: 9 / 16,
          controlsConfiguration: BetterPlayerControlsConfiguration(
            showControls: false,
          )),
      betterPlayerDataSource: BetterPlayerDataSource(
        BetterPlayerDataSourceType.file,
        videoPath,
      ),
    );
  }

  void toggleVideo() {
    setState(() {
      isPlayingFirstVideo = !isPlayingFirstVideo;
    });
  }

  void toggleLooping() {
    setState(() {
      isLoopingEnabled = !isLoopingEnabled;
      _controller1.setLooping(isLoopingEnabled); // Apply loop to controller 1
      if (_controller2 != null) {
        _controller2!.setLooping(
            isLoopingEnabled); // Apply loop to controller 2 if it exists
      }
    });
  }

  void togglePlayPause() {
    setState(() {
      if (isPlayingFirstVideo) {
        if (_controller1.isPlaying() ?? false) {
          _controller1.pause();
        } else {
          _controller1.play();
        }
      } else {
        if (_controller2?.isPlaying() ?? false) {
          _controller2?.pause();
        } else {
          _controller2?.play();
        }
      }
    });
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Full-screen video stack
          Positioned.fill(
            child: Stack(
              children: [
                if (widget.videoPath1 != null)
                  Offstage(
                    offstage: !isPlayingFirstVideo,
                    child: SizedBox.expand(
                      child: BetterPlayer(controller: _controller1),
                    ),
                  ),
                if (widget.videoPath2 != null)
                  Offstage(
                    offstage: isPlayingFirstVideo,
                    child: SizedBox.expand(
                      child: BetterPlayer(controller: _controller2!),
                    ),
                  ),
              ],
            ),
          ),
          // Custom back button
          Positioned(
            top: 20, // Adjust for safe area if needed
            left: 10,
            child: SafeArea(
              child: IconButton(
                icon:
                    const Icon(Icons.arrow_back, color: Colors.white, size: 30),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
          // Toggle button at the bottom
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("First Video",
                        style: TextStyle(color: Colors.white)),
                    Switch(
                      value: isPlayingFirstVideo,
                      onChanged: (value) {
                        toggleVideo();
                      },
                    ),
                    const Text("Second Video",
                        style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ),
          ),
          // Button controls at the center bottom
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 0),
                child: ButtonControls(
                  controller1: _controller1,
                  controller2: _controller2,
                  isPlayingFirstVideo: isPlayingFirstVideo,
                  togglePlayPause: togglePlayPause,
                  isLoopingEnabled: isLoopingEnabled, // Pass the looping state
                  toggleLooping: toggleLooping,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
