import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'video_player_page.dart'; // Create this file for the video player page

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
  @override
  _UploadVideoPageState createState() => _UploadVideoPageState();
}

class _UploadVideoPageState extends State<UploadVideoPage> {
  String? _videoPath;

  Future<void> _pickVideo() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.video,
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        setState(() {
          _videoPath = result.files.single.path!;
        });

        print("Navigating to VideoPlayerPage with path: $_videoPath");

        // Navigate to the video player page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideoPlayerPage(videoPath: _videoPath!),
          ),
        );
      } else {
        print("No video selected");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("No video selected")),
        );
      }
    } catch (e) {
      print("Error during video picking: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred while picking the video")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Video'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _pickVideo,
          child: Text('Upload Video'),
        ),
      ),
    );
  }
}
