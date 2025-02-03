import 'package:flutter/material.dart';
import 'package:better_player_plus/better_player_plus.dart';

class TimelineDisplay extends StatefulWidget {
  final BetterPlayerController controller1;
  final BetterPlayerController? controller2;
  final bool isPlayingFirstVideo;

  const TimelineDisplay({
    super.key,
    required this.controller1,
    this.controller2,
    required this.isPlayingFirstVideo,
  });

  @override
  _TimelineDisplayState createState() => _TimelineDisplayState();
}

class _TimelineDisplayState extends State<TimelineDisplay> {
  late BetterPlayerController activeController;
  late double progress;
  late Duration currentTime;
  late Duration videoDuration;

  @override
  void didUpdateWidget(TimelineDisplay oldWidget){
    super.didUpdateWidget(oldWidget);
    if(oldWidget.isPlayingFirstVideo != widget.isPlayingFirstVideo){
      activeController.videoPlayerController?.removeListener(_updateTimeline);
      activeController = widget.isPlayingFirstVideo || widget.controller2 == null
        ? widget.controller1
        : widget.controller2!;
      activeController.videoPlayerController?.addListener(_updateTimeline);
      _updateTimeline();
    }
  }

  @override
  void initState() {
    super.initState();
    activeController = widget.isPlayingFirstVideo || widget.controller2 == null
        ? widget.controller1
        : widget.controller2!;
    progress = 0.0;
    currentTime = Duration.zero;
    videoDuration = Duration.zero;

    // Add listener to track position updates
    activeController.videoPlayerController?.addListener(_updateTimeline);
  }

  @override
  void dispose() {
    activeController.videoPlayerController?.removeListener(_updateTimeline);
    super.dispose();
  }

  void _updateTimeline() {
    final position =
        activeController.videoPlayerController?.value.position ?? Duration.zero;
    final duration =
        activeController.videoPlayerController?.value.duration ?? Duration.zero;

    setState(() {
      currentTime = position;
      videoDuration = duration;
      progress = position.inMilliseconds / duration.inMilliseconds;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Timeline bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Container(
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(2.5),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor:
                    progress.clamp(0.0, 1.0), // Update based on video progress
                child: Container(
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.yellow,
                    borderRadius: BorderRadius.circular(2.5),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        // Time display
        Text(
          "${_formatDuration(currentTime)} / ${_formatDuration(videoDuration)}",
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      ],
    );
  }

  // Helper function to format duration to "mm:ss"
  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }
}
