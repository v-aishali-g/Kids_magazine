import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class Transliteratei extends StatefulWidget {
  final String _storyID;
  final String t_text;
  final FlutterTts flutterTts;

  Transliteratei(this._storyID, this.flutterTts, this.t_text);

  @override
  _TransliterateState createState() => _TransliterateState();
}

enum TtsState { playing, stopped }

class _TransliterateState extends State<Transliteratei> {
  CollectionReference stry = FirebaseFirestore.instance.collection('stories');
  String? txt;
  String? language;
  double volume = 0.5;
  double pitch = 1.0;
  double rate = 0.5;

  TtsState ttsState = TtsState.stopped;
  bool shouldStop = false;

  @override
  void initState() {
    super.initState();

    widget.flutterTts.setStartHandler(() {
      setState(() => ttsState = TtsState.playing);
    });

    widget.flutterTts.setCompletionHandler(() {
      setState(() => ttsState = TtsState.stopped);
    });

    widget.flutterTts.setErrorHandler((msg) {
      print("TTS Error: $msg");
      setState(() => ttsState = TtsState.stopped);
    });
  }

  Future speak() async {
    shouldStop = false;

    await widget.flutterTts.setVolume(volume);
    await widget.flutterTts.setSpeechRate(rate);
    await widget.flutterTts.setPitch(pitch);

    if (language == "Gujarati") widget.flutterTts.setLanguage("gu-IN");
    if (language == "Bengali") widget.flutterTts.setLanguage("bn-IN");
    if (language == "Telugu") widget.flutterTts.setLanguage("te-IN");
    if (language == "Marathi") widget.flutterTts.setLanguage("mr-IN");
    if (language == "Hindi") widget.flutterTts.setLanguage("hi-IN");

    if (txt != null) {
      var count = txt!.length;
      var max = 4000;
      var loopCount = count ~/ max;

      for (var i = 0; i <= loopCount; i++) {
        if (shouldStop) {
          await widget.flutterTts.stop();
          break;
        }

        String chunk;
        if (i != loopCount) {
          chunk = txt!.substring(i * max, (i + 1) * max);
        } else {
          chunk = txt!.substring(i * max);
        }

        bool isDone = false;
        widget.flutterTts.setCompletionHandler(() {
          isDone = true;
        });

        await widget.flutterTts.speak(chunk);

        while (!isDone && !shouldStop) {
          await Future.delayed(Duration(milliseconds: 100));
        }

        if (shouldStop) {
          await widget.flutterTts.stop();
          break;
        }
      }

      setState(() => ttsState = TtsState.stopped);
    }
  }

  Future _stop() async {
    shouldStop = true;
    await widget.flutterTts.stop();
    setState(() => ttsState = TtsState.stopped);
  }

  @override
  Widget build(BuildContext context) {
    Widget _volume() {
      return Slider(
        value: volume,
        onChanged: (newVolume) {
          setState(() => volume = newVolume);
        },
        min: 0.0,
        max: 1.0,
        divisions: 10,
        label: "Volume: $volume",
        activeColor: Color(0xFF181621),
      );
    }

    Widget _pitch() {
      return Slider(
        value: pitch,
        onChanged: (newPitch) {
          setState(() => pitch = newPitch);
        },
        min: 0.5,
        max: 2.0,
        divisions: 10,
        label: "Pitch: $pitch",
        activeColor: Color(0xFF181621),
      );
    }

    Widget _rate() {
      return Slider(
        value: rate,
        onChanged: (newRate) {
          setState(() => rate = newRate);
        },
        min: 0.0,
        max: 2.0,
        divisions: 10,
        label: "Rate: $rate",
        activeColor: Color(0xFF181621),
      );
    }

    Widget _buildSliders() {
      return Column(
        children: [
          Text("Volume 🔊"),
          _volume(),
          Text("Pitch 〰️"),
          _pitch(),
          Text("Speed 🚄"),
          _rate(),
        ],
      );
    }

    return StreamBuilder<DocumentSnapshot>(
        stream: stry.doc(widget._storyID).snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          txt = widget.t_text;
          language = snapshot.data!['language'];

          return Container(
            alignment: Alignment.center,
            child: Column(
              children: [
                _buildSliders(),
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    FloatingActionButton(
                      onPressed: () => speak(),
                      child: Icon(Icons.play_arrow),
                      backgroundColor: Colors.green[500],
                    ),
                    FloatingActionButton(
                      onPressed: () => _stop(),
                      backgroundColor: Colors.red,
                      child: Icon(Icons.stop),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }
}
