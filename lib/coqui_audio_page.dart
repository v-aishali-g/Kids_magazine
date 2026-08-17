import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:kids_magazine/custom_transliterate.dart';

class StoryPage extends StatefulWidget {
  final String storyID;

  StoryPage({required this.storyID});

  @override
  _StoryPageState createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  String? originalText;
  String? language;
  bool isLoading = false;
  bool isPlaying = false;
  CollectionReference stry = FirebaseFirestore.instance.collection('stories');
  AudioPlayer _audioPlayer = AudioPlayer();

  String? audioUrl;

  @override
  void initState() {
    super.initState();
    fetchStory();
  }

  // Fetch story from Firebase using storyID
  Future<void> fetchStory() async {
    try {
      DocumentSnapshot storyDoc = await stry.doc(widget.storyID).get();

      if (storyDoc.exists) {
        setState(() {
          originalText = storyDoc['original_text'];
          language = storyDoc['language'];
        });
      } else {
        print("Story not found!");
      }
    } catch (e) {
      print("Error fetching story: $e");
    }
  }

  // Generate audio for the fetched story
  Future<void> generateAudio() async {
    if (originalText == null || originalText!.isEmpty) {
      print("No content available for audio generation.");
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final String apiUrl =
          "http://172.16.16.19:5000/synthesize"; // Flask API for TTS
      print("[DEBUG] Sending POST request to $apiUrl");

      // Send the story content to Flask API for TTS conversion
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"text": originalText!}), // Send story text
      );

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        audioUrl = responseData["audio_url"]; // Get audio URL from response
        print("[DEBUG] Audio URL received: $audioUrl");

        // Play the audio from the URL
        await _audioPlayer.play(UrlSource(audioUrl!));
        setState(() {
          isLoading = false;
          isPlaying = true;
        });

        // Listen for audio completion
        _audioPlayer.onPlayerComplete.listen((event) {
          setState(() {
            isPlaying = false;
          });
          print("[DEBUG] Audio finished playing.");
        });
      } else {
        setState(() {
          isLoading = false;
        });
        print("[ERROR] Failed to generate audio. Error: ${response.body}");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("[ERROR] Error generating audio: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFC857), // Warm Yellow Background
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_sharp,
              color: Color(0xFFFFC857), size: 25.0),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Color(0xFF00073e), // Deep Blue Title Bar
        title: Text(
          "Story Audio(in iit(bhu) network only)",
          style: TextStyle(
            fontSize: 22.0,
            fontFamily: 'JosefinSans',
            fontWeight: FontWeight.w600,
            color: Color(0xFFFFC857),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 10.0),

            // Audio Button on Top
            if (isLoading)
              CircularProgressIndicator()
            else if (originalText != null)
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6.0,
                      spreadRadius: 1.0,
                    ),
                  ],
                ),
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Audio",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontFamily: 'Amaranth',
                        color: Color(0xFF181621),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        isPlaying ? Icons.pause : Icons.volume_up,
                        color: Color(0xFF181621),
                        size: 28.0,
                      ),
                      onPressed: () {
                        if (!isPlaying) {
                          generateAudio(); // Generate audio when the button is pressed
                        } else {
                          _audioPlayer
                              .pause(); // Pause the audio if already playing
                          setState(() {
                            isPlaying = false;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),

            SizedBox(height: 20.0),

            // Story Content inside Rounded Rectangle
            if (originalText != null)
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Color(0xFFFDF8E6), // Off-white Background
                    borderRadius: BorderRadius.circular(15.0), // Rounded Edges
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 6.0,
                        spreadRadius: 2.0,
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 5.0),
                        SizedBox(height: 10.0),
                        Text(
                          originalText!, // Display the fetched story text
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
