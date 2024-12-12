import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'video_player_page.dart'; // Create this file for the video player page

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    print("MyApp initialized");
    return MaterialApp(
      title: 'Video Upload & Play',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const UploadVideoPage(),
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
    print("Started video picking process");
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.video,
        allowMultiple: false,
      );

      print(
          "FilePicker result: ${result != null ? "File selected" : "No file selected"}");

      if (result != null && result.files.single.path != null) {
        print("File path: ${result.files.single.path}");
        setState(() {
          _videoPath = result.files.single.path!;
        });

        print("Updated state with video path: $_videoPath");

        // Introduce a small delay to ensure smooth navigation
        Future.delayed(const Duration(milliseconds: 100), () {
          print("Navigating to VideoPlayerPage...");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VideoPlayerPage(videoPath: _videoPath!),
            ),
          ).then((_) {
            print("Returned from VideoPlayerPage");
          });
        });
      } else {
        print("No video selected");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No video selected")),
        );
      }
    } catch (e) {
      print("Error during video picking: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("An error occurred while picking the video")),
      );
    }
    print("Video picking process ended");
  }

  @override
  Widget build(BuildContext context) {
    print("UploadVideoPage build method called");
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Video'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            print("Upload Video button clicked");
            _pickVideo();
          },
          child: const Text('Upload Video'),
        ),
      ),
    );
  }
}
