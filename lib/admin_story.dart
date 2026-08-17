import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminStory extends StatelessWidget {
  final String _storyID;

  AdminStory(this._storyID);

  @override
  Widget build(BuildContext context) {
    final CollectionReference stry =
        FirebaseFirestore.instance.collection('stories');

    return StreamBuilder<DocumentSnapshot>(
      stream: stry.doc(_storyID).snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('................Something went wrong');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData) {
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
              backgroundColor: Color(0xFF181621),
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
              child: Column(
                children: [
                  SizedBox(height: 15.0),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.70,
                    color: Colors.transparent,
                    child: Column(
                      children: [
                        SizedBox(height: 10.0),
                        Expanded(
                          flex: 1,
                          child: RawScrollbar(
                            thumbColor: Colors.black26,
                            thickness: 4,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  snapshot.data!['original_text'],
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
                  SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          await stry
                              .doc(_storyID)
                              .update({'status': 'approved'});
                          Navigator.pop(context, '/');
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Text(
                            "Approve",
                            style: TextStyle(
                              fontSize: 23.0,
                              fontFamily: 'Amaranth',
                              color: Color(0xFFFFC857),
                            ),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          await stry.doc(_storyID).delete();
                          Navigator.pop(context, '/');
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Text(
                            "Remove",
                            style: TextStyle(
                              fontSize: 23.0,
                              fontFamily: 'Amaranth',
                              color: Color(0xFFFFC857),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
        return Container(color: Color(0xFFFFC857));
      },
    );
  }
}
