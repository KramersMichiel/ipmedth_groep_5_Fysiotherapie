import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'video_player_page.dart'; // Create this file for the video player page

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Upload & Play',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: UploadVideoPage(),
    );
  }
}

class UploadVideoPage extends StatefulWidget {
  const UploadVideoPage({super.key});

  @override
  _UploadVideoPageState createState() => _UploadVideoPageState();
}

class _UploadVideoPageState extends State<UploadVideoPage> {
  String? _videoPath;

  Future<void> _pickVideo() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.video,
      allowMultiple: false,
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _videoPath = result.files.single.path!;
      });

      // Navigate to video player page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VideoPlayerPage(videoPath1: _videoPath!),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Video'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _pickVideo,
          child: const Text('Upload Video'),
        ),
      ),
    );
  }
}
