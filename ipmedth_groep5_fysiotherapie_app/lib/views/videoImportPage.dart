import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // For video picking
import 'dart:io'; // For File handling
import 'bodyAnalysisPage.dart'; // Import your bodyAnalysisPage file when ready

class VideoImportPage extends StatefulWidget {
  @override
  _VideoImportPageState createState() => _VideoImportPageState();
}

class _VideoImportPageState extends State<VideoImportPage> {
  File? _videoFile1;
  File? _videoFile2;

  // Function to pick a video from the gallery
  Future<void> _pickVideo(int videoIndex) async {
    final ImagePicker picker = ImagePicker();
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        if (videoIndex == 1) {
          _videoFile1 = File(pickedFile.path);
        } else {
          _videoFile2 = File(pickedFile.path);
        }
      });
    }
  }

  Widget _videoPlaceholder(int videoIndex, File? videoFile) {
    return GestureDetector(
      onTap: () => _pickVideo(videoIndex),
      child: Container(
        width: 300,
        height: 200,
        color: Colors.grey[300],
        child: videoFile == null
            ? Icon(Icons.video_library, size: 100, color: Colors.grey[700])
            : Image.file(videoFile, fit: BoxFit.cover),
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
            _videoPlaceholder(1, _videoFile1),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            _videoPlaceholder(2, _videoFile2),
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
                            child: Text('Analyze Videos'),
                          ),
                        ),
                      );
                    }
                  : null,
              child: Text('Analyze Videos'),
            ),
          ],
        ),
      ),
    );
  }
}
