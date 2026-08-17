import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:kids_magazine/custom_transliterate.dart';

class AudioGenerateScreen extends StatefulWidget {
  final String storyID;

  AudioGenerateScreen({required this.storyID});

  @override
  _AudioGenerateScreenState createState() => _AudioGenerateScreenState();
}

class _AudioGenerateScreenState extends State<AudioGenerateScreen> {
  String? originalText;
  String? language;
  String? transliteratedText;
  bool isLoading = false;
  bool isSwitched2 = false;
  List<String> audioQueue = [];
  int currentIndex = 0;

  bool isPlaying = false;
  bool isPaused = false;
  bool isStopped = false;
  CollectionReference stry = FirebaseFirestore.instance.collection('stories');
  AudioPlayer player = AudioPlayer();

  String? audioPath;

  @override
  void initState() {
    super.initState();
    fetchStory();
  }
  List<String> splitByWords(String text, int wordLimit) {
    List<String> words = text.split(' ');
    List<String> chunks = [];

    for (int i = 0; i < words.length; i += wordLimit) {
      chunks.add(
        words
            .sublist(
          i,
          i + wordLimit > words.length ? words.length : i + wordLimit,
        )
            .join(' '),
      );
    }
    return chunks;
  }

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

  Future<void> playQueue() async {
    if (currentIndex >= audioQueue.length || isStopped) return;

    setState(() {
      isPlaying = true;
      isPaused = false;
    });

    await player.play(DeviceFileSource(audioQueue[currentIndex]));

    player.onPlayerComplete.listen((event) async {
      if (!isStopped && !isPaused) {
        currentIndex++;
        await playQueue();
      }
    });
  }


  Future<void> generateSpeech() async {
    if (originalText == null) return;

    setState(() {
      isLoading = true;
      audioQueue.clear();
      currentIndex = 0;
      isStopped = false;
    });

    String languageCode = 'bn';

    switch (language?.toLowerCase()) {
      case 'hindi':
        languageCode = 'hi';
        break;
      case 'marathi':
        languageCode = 'mr';
        break;
      case 'gujarati':
        languageCode = 'gu';
        break;
      case 'telugu':
        languageCode = 'te';
        break;
      default:
        languageCode = 'bn';
    }

    try {
      List<String> chunks = splitByWords(originalText!, 100);

      Directory tempDir = await getTemporaryDirectory();

      // 🔥 Generate ALL audio first
      for (int i = 0; i < chunks.length; i++) {
        var url = Uri.parse("https://flask-tts-backend-1.onrender.com/generate_speech");

        var response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({"text": chunks[i], "language": languageCode}),
        );

        if (response.statusCode == 200) {
          String path = '${tempDir.path}/chunk_$i.mp3';
          File file = File(path);
          await file.writeAsBytes(response.bodyBytes);

          audioQueue.add(path);
        }
      }

      await playQueue(); // 🔥 start playing
    } catch (e) {
      print("Error: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void transliterateText(String selectedLanguage, String o_text) {
    setState(() {
      switch (selectedLanguage.toLowerCase()) {
        case 'bengali':
          transliteratedText = transliterateBengali(o_text);
          break;
        case 'hindi':
          transliteratedText = transliterateHindi(o_text);
          break;
        case 'marathi':
          transliteratedText = transliterateMarathi(o_text);
          break;
        case 'gujarati':
          transliteratedText = transliterateGujarati(o_text);
          break;
        case 'telugu':
          transliteratedText = transliterateTelugu(o_text);
          break;
        default:
          transliteratedText = 'Language not supported';
      }
    });
  }

  Future<void> playAudio() async {
    if (audioPath != null && await File(audioPath!).exists()) {
      try {
        await player.play(DeviceFileSource(audioPath!));
        setState(() {
          isPlaying = true;
          isPaused = false;
        });
      } catch (e) {
        print("Error playing audio: $e");
      }
    }
  }

  Future<void> pauseAudio() async {
    await player.pause();
    setState(() {
      isPlaying = false;
      isPaused = true;
    });
  }

  Future<void> resumeAudio() async {
    await player.resume();
    setState(() {
      isPlaying = true;
      isPaused = false;
    });
  }

  Future<void> stopAudio() async {
    await player.stop();
    setState(() {
      isPlaying = false;
      isPaused = false;
      isStopped = true;
      currentIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_sharp,
              color: Color(0xFFFFC857), size: 25.0),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Color(0xFF00073e), // Deep Blue Title Bar
        title: Text(
          "Gtts Audio",
          style: TextStyle(
            fontSize: 22.0,
            fontFamily: 'JosefinSans',
            fontWeight: FontWeight.w600,
            color: Color(0xFFFFC857),
          ),
        ),
      ),
      body: Container(
        color: Color(0xFFFFC857), // Warm Yellow Background
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
          SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
              children: [
                ElevatedButton(
                  onPressed: isLoading ? null : generateSpeech,
                  child: Text("Play"),
                ),

                ElevatedButton(
                  onPressed: isPlaying ? pauseAudio : null,
                  child: Text("Pause"),
                ),

                ElevatedButton(
                  onPressed: isPaused ? resumeAudio : null,
                  child: Text("Resume"),
                ),

                ElevatedButton(
                  onPressed: (isPlaying || isPaused) ? stopAudio : null,
                  child: Text("Stop"),
                ),
                SizedBox(width: 10),
                Switch(
                  value: isSwitched2,
                  onChanged: (bool value) {
                    setState(() {
                      isSwitched2 = value;

                      if (isSwitched2 && language != null) {
                        transliterateText(language!, originalText ?? "");
                      }
                    });
                  },
                  activeColor: Color(0xFF00073e), // Deep Blue for Switch
                ),
              ],
          ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: isSwitched2
                  ? Column(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFFDF8E6), // Off-white Background
                              borderRadius:
                                  BorderRadius.circular(15.0), // Rounded Edges
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 6.0,
                                  spreadRadius: 2.0,
                                ),
                              ],
                            ),
                            padding: EdgeInsets.all(16.0),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Original Text",
                                    style: TextStyle(
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'JosefinSans',
                                      color: Color(0xFF00073e),
                                    ),
                                  ),
                                  SizedBox(height: 10.0),
                                  Text(
                                    originalText ?? "Loading...",
                                    style: TextStyle(
                                        fontSize: 18.0, color: Colors.black87),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Divider(),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFFDF8E6), // Off-white Background
                              borderRadius:
                                  BorderRadius.circular(15.0), // Rounded Edges
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 6.0,
                                  spreadRadius: 2.0,
                                ),
                              ],
                            ),
                            padding: EdgeInsets.all(16.0),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Transliterated Text",
                                    style: TextStyle(
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'JosefinSans',
                                      color: Color(0xFF00073e),
                                    ),
                                  ),
                                  SizedBox(height: 10.0),
                                  Text(
                                    transliteratedText ?? "No Data",
                                    style: TextStyle(
                                        fontSize: 18.0, color: Colors.black87),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFFDF8E6), // Off-white Background
                        borderRadius:
                            BorderRadius.circular(15.0), // Rounded Edges
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 6.0,
                            spreadRadius: 2.0,
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(16.0),
                      child: SingleChildScrollView(
                        child: Text(
                          originalText ?? "Loading...",
                          style:
                              TextStyle(fontSize: 18.0, color: Colors.black87),
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
