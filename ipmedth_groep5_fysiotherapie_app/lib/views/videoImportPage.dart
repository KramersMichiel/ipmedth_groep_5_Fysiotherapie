import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:video_player/video_player.dart';
import '/views/video_player_page.dart'; // Add this line

class VideoImportPage extends StatefulWidget {
  @override
  _VideoImportPageState createState() => _VideoImportPageState();
}

class _VideoImportPageState extends State<VideoImportPage> {
  File? _videoFile1;
  File? _videoFile2;
  VideoPlayerController? _videoController1;
  VideoPlayerController? _videoController2;

  // Function to pick a video using file_picker
  Future<void> _pickVideo(int videoIndex) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.video, // Filter to only pick video files
      allowMultiple: false,
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        if (videoIndex == 1) {
          _videoFile1 = File(result.files.single.path!);
          _videoController1 = VideoPlayerController.file(_videoFile1!)
            ..initialize().then((_) {
              setState(() {}); // Update the UI after video is initialized
            });
        } else {
          _videoFile2 = File(result.files.single.path!);
          _videoController2 = VideoPlayerController.file(_videoFile2!)
            ..initialize().then((_) {
              setState(() {});
            });
        }
      });
    }
  }

  // Show a warning if fewer than two videos are selected
  void _showWarningDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Warning"),
          content: const Text(
            "Only one video has been selected. Would you like to continue analyzing just this one video?",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                _navigateToAnalysis(); // Proceed with one video
              },
              child: const Text("Continue"),
            ),
          ],
        );
      },
    );
  }

  // Navigate to the analysis page
  void _navigateToAnalysis() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPlayerPage(
          videoPath1: _videoFile1?.path ?? '',
          videoPath2:
              _videoFile2?.path.isNotEmpty == true ? _videoFile2?.path : null,
        ),
      ),
    );
  }

  Widget _videoPlaceholder(
      int videoIndex, File? videoFile, VideoPlayerController? controller) {
    return GestureDetector(
      onTap: () => _pickVideo(videoIndex),
      child: Container(
        width: 300,
        height: 200,
        color: const Color(0xFFE3F0F4),
        child: videoFile == null
            ? const Icon(Icons.add_box, size: 100, color: Colors.black)
            : (controller != null && controller.value.isInitialized
                ? const Icon(Icons.check_circle, size: 100, color: Colors.green)
                : const Icon(Icons.error,
                    size: 100, color: Colors.red)), // Fallback
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F0F4),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 16,
              left: 16,
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  size: 60,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.pop(context); // Goes back to the previous screen
                },
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _videoPlaceholder(1, _videoFile1, _videoController1),
                const SizedBox(height: 16),
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: const Divider(
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _videoPlaceholder(2, _videoFile2, _videoController2),
                const SizedBox(height: 32),
                InkWell(
                  onTap: _videoFile1 != null
                      ? () {
                          print('Video Path 1: ${_videoFile1?.path}');
                          print('Video Path 2: ${_videoFile2?.path}');
                          if (_videoFile2 == null) {
                            _showWarningDialog(); // Show warning if only one video
                          } else {
                            _navigateToAnalysis(); // Proceed normally
                          }
                        }
                      : null, // Disable button if no video is selected
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 64,
                      vertical: 28,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF77BFDC),
                          Color(0xFF76A9BE),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(64),
                      border: Border.all(
                        color: Colors.black,
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5), // Shadow color
                          blurRadius: 4, // Spread of the shadow
                          offset: Offset(0, 4), // Position of the shadow (x, y)
                        ),
                      ],
                    ),
                    child: Text(
                      'Analyseer beelden',
                      style: TextStyle(
                        fontFamily: 'Lato-regular',
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        color: _videoFile1 != null
                            ? Colors.black
                            : Colors
                                .grey, // Text color based on enabled/disabled
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _videoController1?.dispose();
    _videoController2?.dispose();
    super.dispose();
  }
}
