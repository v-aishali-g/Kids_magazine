import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:kids_magazine/custom_transliterate.dart';
import 'package:kids_magazine/highlighting.dart';
import 'package:kids_magazine/select.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kids_magazine/story.dart';
import 'package:kids_magazine/AudioGenerateScreen.dart';
import 'package:kids_magazine/forverylong.dart';
import 'package:kids_magazine/coqui_audio_page.dart';

bool isSwitched1 = false;
bool isSwitched2 = false;
bool isSwitched3 = true;

class BengaliStory extends StatefulWidget {
  final String storyID;

  BengaliStory(this.storyID, {Key? key}) : super(key: key);

  @override
  _BengaliStoryState createState() => _BengaliStoryState();
}

class _BengaliStoryState extends State<BengaliStory> {
  TutorialCoachMark? tutorialCoachMark;
  List<TargetFocus> targets = [];

  GlobalKey transliterateKey = GlobalKey();
  GlobalKey audioKey = GlobalKey();
  bool isLoggedIn = false;
  bool isTutorialShown = false;

  CollectionReference stry = FirebaseFirestore.instance.collection('stories');
  FlutterTts flutterTts = FlutterTts();
  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  @override
  void initState() {
    isLoggedIn = FirebaseAuth.instance.currentUser != null;

    if (!isLoggedIn && !isTutorialShown) {
      // Check if tutorial is not shown
      Future.delayed(const Duration(seconds: 1), () {
        _showTutorialCoachmark();
      });
    }
    super.initState();
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
  void _showTutorialCoachmark() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool tutorialShown = prefs.getBool('tutorialShown2') ?? false;

    if (!tutorialShown) {
      _initTarget();
      tutorialCoachMark = TutorialCoachMark(targets: targets);
      tutorialCoachMark!.show(context: context);

      // Save in SharedPreferences that tutorial has been shown
      prefs.setBool('tutorialShown2', true);
    }
  }

  void _initTarget() {
    targets = [
      TargetFocus(
          identify: "transliterate",
          keyTarget: transliterateKey,
          contents: [
            TargetContent(
                align: ContentAlign.bottom,
                builder: (context, controller) {
                  return CoachmarkDesc(
                    text: "Click this to see transliterated text.",
                    onNext: () {
                      controller.next();
                    },
                    onSkip: () {
                      controller.skip();
                    },
                  );
                })
          ]),
      TargetFocus(identify: "audio", keyTarget: audioKey, contents: [
        TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return CoachmarkDesc(
                text: "Click here for audio options",
                onNext: () {
                  controller.next();
                },
                onSkip: () {
                  controller.skip();
                },
              );
            })
      ]),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: stry.doc(widget.storyID).snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          String t_text = snapshot.data!['transliterated_text'];
          String tt_text = '';
          String o_text = snapshot.data!['original_text'];
          String selectedLanguage = snapshot.data!['language'];
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_sharp,
                  color: Color(0xFFFFC857),
                  size: 25.0,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              backgroundColor: Color(0xFF00073e),
              title: Row(
                children: [
                  Flexible(
                    child: Text(
                      snapshot.data!['title'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 22.0,
                        fontFamily: 'JosefinSans',
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFFFC857),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            body: Container(
              color: Color(0xFFFFC857),
              child: RawScrollbar(
                thumbColor: Colors.white70,
                thickness: 4,
                child: ListView(
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          height: 15.0,
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.1,
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.02,
                                  ),
                                  FittedBox(
                                    key: audioKey,
                                    fit: BoxFit.fitWidth,
                                    child: Text(
                                      "Audio",
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        fontFamily: 'Amaranth',
                                        color: Color(0xFF181621),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.volume_up,
                                      color: Color(0xFF181621),
                                      size: 28.0,
                                    ),
                                    onPressed: () {
                                      List<Widget> getDialogOptions() {
                                        return [
                                          ListTile(
                                            title: Text("Audio and Transliteration"),
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => Story(widget.storyID),
                                                ),
                                              );
                                            },
                                          ),
                                          ListTile(
                                            title: Text("Coqui Audio but no Transliteration"),
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => StoryPage(
                                                    storyID: widget.storyID,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                          ListTile(
                                            title: Text("gTTS Audio and Transliteration"),
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => AudioGenerateScreen(
                                                    storyID: widget.storyID,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ];
                                      }

                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            backgroundColor: Color(0xFFFFC857),
                                            title: Text("Choose Audio Option"),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children:
                                                  getDialogOptions(), // Dynamic content based on o_text
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.04,
                              ),
                              Column(
                                children: [
                                  FittedBox(
                                    fit: BoxFit.fitWidth,
                                    child: Text(
                                      "Original",
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        fontFamily: 'Amaranth',
                                        color: Color(0xFF181621),
                                      ),
                                    ),
                                  ),
                                  Switch(
                                    value: isSwitched3,
                                    onChanged: (bool value) {
                                      setState(() {
                                        isSwitched3 = value;
                                      });
                                    },
                                    activeTrackColor: Color(0xFF181621),
                                    activeColor: Colors.blue,
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.02,
                              ),
                              Column(
                                children: [
                                  FittedBox(
                                    key: transliterateKey,
                                    fit: BoxFit.fitWidth,
                                    child: Text(
                                      "Transliteration",
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        fontFamily: 'Amaranth',
                                        color: Color(0xFF181621),
                                      ),
                                    ),
                                  ),
                                  Switch(
                                    value: isSwitched2,
                                    onChanged: (bool value) {
                                      setState(() {
                                        isSwitched2 = value;
                                        if (isSwitched2) {
                                          tt_text =
                                              transliterateBengali(o_text);
                                          if (t_text != tt_text) {
                                            updateTransliteratedText(
                                                widget.storyID, tt_text);
                                          }
                                        }
                                        // Call your transliterateTelugu function here
                                        // Update Firestore document
                                      });
                                    },
                                    activeTrackColor: Color(0xFF181621),
                                    activeColor: Colors.blue,
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.02,
                              ),
                            ],
                          ),
                          // color: Color(0xFF181621),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        if (isSwitched2 ==
                                    false && /* isSwitched1 == false && */
                                isSwitched3 == true ||
                            isSwitched2 ==
                                    false && /* isSwitched1 == false && */
                                isSwitched3 == false)
                          Container(
                            height: MediaQuery.of(context).size.height * 0.74,
                            width: MediaQuery.of(context).size.width * 0.95,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 238, 222, 187),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    offset: Offset(0, -2),
                                    blurRadius: 15.0,
                                    spreadRadius: 0.0),
                              ],
                            ),
                            child: Column(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: RawScrollbar(
                                    thumbColor: Colors.black26,
                                    thickness: 4,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: HighlightedText(
                                          text: o_text,
                                          flutterTts: flutterTts,
                                          language: selectedLanguage,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (isSwitched2 == true /* && isSwitched1 == false */ &&
                            isSwitched3 == false)
                          Container(
                            height: MediaQuery.of(context).size.height * 0.74,
                            width: MediaQuery.of(context).size.width * 0.95,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 238, 222, 187),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    offset: Offset(0, -2),
                                    blurRadius: 15.0,
                                    spreadRadius: 0.0),
                              ],
                            ),
                            child: Column(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: RawScrollbar(
                                    thumbColor: Colors.black26,
                                    thickness: 4,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(
                                          t_text,
                                          style: TextStyle(
                                            fontFamily: 'JosefinSans',
                                            fontSize: 18.0,
                                            color: Color(0xFF181621),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (isSwitched2 == true && isSwitched3 == true)
                          Container(
                            height: MediaQuery.of(context).size.height * 0.35,
                            width: MediaQuery.of(context).size.width * 0.95,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 238, 222, 187),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    offset: Offset(0, -2),
                                    blurRadius: 15.0,
                                    spreadRadius: 0.0),
                              ],
                            ),
                            child: Column(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: RawScrollbar(
                                    thumbColor: Colors.black26,
                                    thickness: 4,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: HighlightedText(
                                          text: o_text,
                                          flutterTts: flutterTts,
                                          language: selectedLanguage,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (isSwitched2 == true /* || isSwitched1 == true */)
                          SizedBox(
                            height: 15.0,
                          ),
                        if (isSwitched2 == true)
                          Container(
                            height: MediaQuery.of(context).size.height * 0.35,
                            width: MediaQuery.of(context).size.width * 0.95,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 238, 222, 187),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    offset: Offset(0, -2),
                                    blurRadius: 15.0,
                                    spreadRadius: 0.0),
                              ],
                            ),
                            child: Column(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: RawScrollbar(
                                    thumbColor: Colors.black26,
                                    thickness: 4,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(
                                          t_text,
                                          style: TextStyle(
                                            fontFamily: 'JosefinSans',
                                            fontSize: 18.0,
                                            color: Color(0xFF181621),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        } // here i am ending my builder
        );
  }
}

void updateTransliteratedText(String storyID, String newText) {
  FirebaseFirestore.instance
      .collection('stories')
      .doc(storyID)
      .update({'transliterated_text': newText})
      .then((_) => print('Transliterated text updated successfully!'))
      .catchError(
          (error) => print('Error updating transliterated text: $error'));
}
