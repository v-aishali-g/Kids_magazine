import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'admin_story.dart';

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  CollectionReference img = FirebaseFirestore.instance.collection('stories');
  final String defaultImageUrl =
      'https://firebasestorage.googleapis.com/v0/b/kids-magazine-c41d5.appspot.com/o/storyImages%2F4ea7b85bef0659b784f05faec7664278.jpg?alt=media&token=4326548d-263a-4a19-b509-5a18477c3ce6';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF181621),
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
        title: Text(
          "Uploaded Stories",
          style: TextStyle(
            fontSize: 25.0,
            fontFamily: 'Amaranth',
            color: Color(0xFFFFC857),
          ),
        ),
      ),
      body: Container(
        color: Color(0xFFFFC857),
        child: Column(
          children: [
            SizedBox(height: 10.0),
            Flexible(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('stories')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Something went wrong',
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  List<Widget> stories =
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    final data = document.data() as Map<String, dynamic>;

                    // Provide a default image if missing
                    if (!data.containsKey('image') || data['image'] == null) {
                      img.doc(document.id).update({'image': defaultImageUrl});
                    }

                    // Only show stories with 'waiting' status
                    if (data['status'] == 'waiting') {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AdminStory(document.id)),
                          );
                        },
                        child: Padding(
                          padding:
                              const EdgeInsets.fromLTRB(10.0, 2.0, 10.0, 2.0),
                          child: Card(
                            color: Color(0xFF181621),
                            elevation: 10.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                              side: BorderSide(color: Colors.transparent),
                            ),
                            child: Container(
                              width: double.infinity,
                              height: 100,
                              child: Row(
                                children: [
                                  SizedBox(width: 10.0),
                                  Container(
                                    width: 70.0,
                                    height: 70.0,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image: NetworkImage(
                                            data['image'] ?? defaultImageUrl),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10.0),
                                  Flexible(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          data['title'] ?? 'Untitled',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 22.0,
                                            fontFamily: 'JosefinSans',
                                            fontWeight: FontWeight.w400,
                                            color: Color(0xFFFFC857),
                                          ),
                                        ),
                                        SizedBox(height: 7.0),
                                        Row(
                                          children: [
                                            SizedBox(width: 70.0),
                                            Text(
                                              "~ ",
                                              style: TextStyle(
                                                fontSize: 15.0,
                                                fontFamily: 'JosefinSans',
                                                color: Color(0xFFFFC857),
                                              ),
                                            ),
                                            Flexible(
                                              child: Text(
                                                data['author'] ?? 'Unknown',
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: 15.0,
                                                  fontFamily: 'JosefinSans',
                                                  color: Color(0xFFFFC857),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 20.0),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 10.0),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    } else {
                      return SizedBox.shrink();
                    }
                  }).toList();

                  stories.add(
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Icon(
                            Icons.check_circle,
                            size: 40,
                            color: Color(0xFF181621),
                          ),
                          Text(
                            "You're All Caught Up",
                            style: Theme.of(context).textTheme.titleLarge,
                          )
                        ],
                      ),
                    ),
                  );

                  return ListView(children: stories);
                },
              ),
            ),
            SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }
}
