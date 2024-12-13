import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import '/views/bodyAnalysisPage.dart';

class VideoImportPage extends StatefulWidget {
  @override
  _VideoImportPageState createState() => _VideoImportPageState();
}

class _VideoImportPageState extends State<VideoImportPage> {
  File? _videoFile1;
  File? _videoFile2;
  VideoPlayerController? _videoController1;
  VideoPlayerController? _videoController2;

  // Function to pick a video from the gallery
  Future<void> _pickVideo(int videoIndex) async {
    final ImagePicker picker = ImagePicker();
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        if (videoIndex == 1) {
          _videoFile1 = File(pickedFile.path);
          _videoController1 = VideoPlayerController.file(_videoFile1!)
            ..initialize().then((_) {
              setState(() {}); // Update the UI after the video is initialized
            });
        } else {
          _videoFile2 = File(pickedFile.path);
          _videoController2 = VideoPlayerController.file(_videoFile2!)
            ..initialize().then((_) {
              setState(() {});
            });
        }
      });
    }
  }

  Widget _videoPlaceholder(
      int videoIndex, File? videoFile, VideoPlayerController? controller) {
    return GestureDetector(
      onTap: () => _pickVideo(videoIndex),
      child: Container(
        width: 300,
        height: 200,
        color: Colors.grey[300],
        child: videoFile == null
            ? Icon(Icons.video_library, size: 100, color: Colors.grey[700])
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
      backgroundColor: Colors.blue.shade50,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _videoPlaceholder(1, _videoFile1, _videoController1),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            _videoPlaceholder(2, _videoFile2, _videoController2),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _videoFile1 != null || _videoFile2 != null
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BodyAnalysisPage(
                            videoFile1: _videoFile1,
                            videoFile2: _videoFile2,
                            child:
                                Container(), // Add the required child parameter
                          ),
                        ),
                      );
                    }
                  : null,
              child: const Text('Analyze Videos'),
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
