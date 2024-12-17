import 'package:flutter/material.dart';
import 'package:better_player_plus/better_player_plus.dart';

class VideoPlayerPage extends StatefulWidget {
  final String videoPath1;
  final String videoPath2;

  const VideoPlayerPage(
      {super.key, required this.videoPath1, required this.videoPath2});

  @override
  VideoPlayerPageState createState() => VideoPlayerPageState();
}

class VideoPlayerPageState extends State<VideoPlayerPage> {
  late BetterPlayerController _controller1;
  late BetterPlayerController _controller2;
  bool isPlayingFirstVideo = true;

  @override
  void initState() {
    super.initState();
    _controller1 = _createController(widget.videoPath1);
    _controller2 = _createController(widget.videoPath2);
  }

  BetterPlayerController _createController(String videoPath) {
    return BetterPlayerController(
      const BetterPlayerConfiguration(),
      betterPlayerDataSource: BetterPlayerDataSource(
        BetterPlayerDataSourceType.file,
        videoPath,
      ),
    );
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    super.dispose();
  }

  void toggleVideo() {
    setState(() {
      isPlayingFirstVideo = !isPlayingFirstVideo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Player'),
        actions: [
          IconButton(
            icon: const Icon(Icons.swap_horiz),
            onPressed: toggleVideo,
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Text(
            'First Video',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          if (_controller1 != null)
            AspectRatio(
              aspectRatio: 16 / 9,
              child: BetterPlayer(controller: _controller1),
            ),
          const Divider(height: 20, thickness: 2),
          const Text(
            'Second Video',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          if (_controller2 != null)
            AspectRatio(
              aspectRatio: 16 / 9,
              child: BetterPlayer(controller: _controller2),
            ),
        ],
      ),
    );
  }
}
