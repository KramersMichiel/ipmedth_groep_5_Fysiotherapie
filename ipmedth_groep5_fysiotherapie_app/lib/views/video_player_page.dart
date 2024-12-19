import 'package:flutter/material.dart';
import 'package:better_player_plus/better_player_plus.dart';

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

  @override
  void initState() {
    super.initState();
    print('Received Video Path 1: ${widget.videoPath1}');
    print('Received Video Path 2: ${widget.videoPath2}');
    if (widget.videoPath1 != null) {
      _controller1 = _createController(widget.videoPath1!);
    }
    if (widget.videoPath2 != null) {
      _controller2 = _createController(widget.videoPath2!);
    }
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

  void toggleVideo() {
    setState(() {
      isPlayingFirstVideo = !isPlayingFirstVideo;
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
      appBar: AppBar(
        title: const Text('Video Player'),
        actions: [
          if (widget.videoPath2 !=
              null) // Show toggle only if second video exists
            IconButton(
              icon: const Icon(Icons.swap_horiz),
              onPressed: toggleVideo,
            ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          if (widget.videoPath1 != null && widget.videoPath1!.isNotEmpty) ...[
            const Text(
              'First Video',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            AspectRatio(
              aspectRatio: 16 / 9,
              child: BetterPlayer(controller: _controller1),
            ),
            if (widget.videoPath2 != null && widget.videoPath2!.isNotEmpty) ...[
              const Divider(height: 20, thickness: 2),
              const Text(
                'Second Video',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              AspectRatio(
                aspectRatio: 16 / 9,
                child: BetterPlayer(controller: _controller2!),
              ),
            ],
            if (widget.videoPath2 == null || widget.videoPath2!.isEmpty) ...[
              const Text(
                'No Second Video Available',
                style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              ),
            ],
          ],
        ],
      ),
    );
  }
}
