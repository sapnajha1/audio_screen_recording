import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_screen_recording/flutter_screen_recording.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Screen and Audio Recording',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ScreenAndAudioRecordingScreen(),
    );
  }
}

class ScreenAndAudioRecordingScreen extends StatefulWidget {
  @override
  _ScreenAndAudioRecordingScreenState createState() =>
      _ScreenAndAudioRecordingScreenState();
}

class _ScreenAndAudioRecordingScreenState
    extends State<ScreenAndAudioRecordingScreen> {
  late Record audioRecord;
  late AudioPlayer audioPlayer;
  bool isRecordingScreen = false;
  bool isRecordingAudio = false;
  String audioPath = '';
  String videoPath = '';

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    audioRecord = Record();
  }

  @override
  void dispose() {
    audioRecord.dispose();
    audioPlayer.dispose();
    super.dispose();
  }

  Future<void> startScreenAndAudioRecording() async {
    try {
      if (!isRecordingScreen) {
        // Specify the file path for the screen recording
        String videoFilePath = '/path/to/your/screen_recording.mp4';
        // Specify the file path for the audio recording
        String audioFilePath = '/path/to/your/audio_recording.mp3';

        // Start screen recording
        await FlutterScreenRecording.startRecordScreen(videoFilePath);

        // Start audio recording
        await audioRecord.start();

        setState(() {
          isRecordingScreen = true;
          isRecordingAudio = true;
        });
      }
    } catch (e) {
      print("Error starting screen and audio recording: $e");
    }
  }

  Future<void> stopScreenAndAudioRecording() async {
    try {
      // Stop screen recording
      await FlutterScreenRecording.stopRecordScreen;
      // Stop audio recording
      String? audioPathResult = await audioRecord.stop();

      setState(() {
        isRecordingScreen = false;
        isRecordingAudio = false;
        audioPath = audioPathResult ?? '';
        videoPath = '/path/to/your/screen_recording.mp4';
      });

      // The recorded video will be saved at the specified videoFilePath
      print('Screen recording saved at: $videoPath');
      print('Audio recording saved at: $audioPath');
    } catch (e) {
      print('Error stopping screen and audio recording: $e');
    }
  }

  Future<void> playAudioRecording() async {
    try {
      Source urlSource = UrlSource(audioPath);
      await audioPlayer.play(urlSource);
    } catch (e) {
      print("Error playing audio recording: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isRecordingScreen)
              Text("Recording screen in progress", style: TextStyle()),
            if (isRecordingAudio)
              Text("Recording audio in progress", style: TextStyle()),
            ElevatedButton(
              onPressed: isRecordingScreen || isRecordingAudio
                  ? stopScreenAndAudioRecording
                  : startScreenAndAudioRecording,
              child: isRecordingScreen || isRecordingAudio
                  ? const Text('Stop Recording')
                  : const Text('Start Recording'),
            ),
            SizedBox(height: 25),
            if (!isRecordingAudio && audioPath.isNotEmpty)
              ElevatedButton(
                onPressed: playAudioRecording,
                child: const Text('Play Audio Recording'),
              ),
          ],
        ),
      ),
    );
  }
}
