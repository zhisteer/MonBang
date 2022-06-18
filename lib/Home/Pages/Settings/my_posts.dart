import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';

import '../Home/post.dart';

class MyPosts extends StatefulWidget {
  MyPosts({Key? key}) : super(key: key);

  @override
  State<MyPosts> createState() => _MyPostsState();
}

class _MyPostsState extends State<MyPosts> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;
  var userSnap;
  List myPosts = [];

  getPostInfo() async {
    var data = await _firestore
        .collection('posts')
        .doc('free')
        .collection('posts')
        .where("postby", isEqualTo: userSnap["name"])
        .orderBy('time', descending: true)
        .get();
    setState(() {
      myPosts = data.docs;
    });
  }

  getUserInfo() async {
    var data = await _firestore.collection("users").doc(user!.email).get();
    setState(() {
      userSnap = data;
    });
    return data;
  }

  getInfos() async {
    await getUserInfo();
    await getPostInfo();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getInfos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Миний постууд",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView.builder(
          itemCount: myPosts.length,
          itemBuilder: (BuildContext context, int index) => Post(
                map: myPosts[index],
                userSnap: userSnap,
              )),
    );
  }
}

class Post extends StatelessWidget {
  DocumentSnapshot map;
  DocumentSnapshot userSnap;
  Post({Key? key, required this.map, required this.userSnap}) : super(key: key);
  List comments = [];
  bool gotComments = false;
  String postId = '';

  getPostId() async {
    postId = map.reference.id;
  }

  @override
  Widget build(BuildContext context) {
    String subtitle = (map['body'] as String).characters.take(50).toString();
    DateTime time = (map['time'] as Timestamp).toDate();
    String timeAgo = Jiffy(time).fromNow();
    String postBy = "Nuutsaa";
    if (map["anon"] == false) {
      postBy = map["postby"];
    }
    return Card(
      child: ListTile(
        title: Text(map['title']),
        onTap: () async {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => Center(
                    child: CircularProgressIndicator(),
                  ));
          try {
            await getPostId();
          } on FirebaseException catch (e) {
            print(e);
          }

          Get.back();
          Get.to(() => InsidePost(
                title: map['title'],
                body: map['body'],
                postId: postId,
                postBy: postBy,
                realName: map['postby'],
                myName: userSnap['name'],
              ));
        },
        onLongPress: () {},
        dense: false,
        subtitle: Text(
          '$subtitle \n\n$timeAgo | $postBy',
        ),
        trailing: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Icon(
                    Icons.thumb_up,
                    size: 20,
                  ),
                ),
                Text((map['likes'].length - map['dislikes'].length).toString()),
                const Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Icon(
                    Icons.comment,
                    size: 20,
                  ),
                ),
                Text((map['likes'].length - map['dislikes'].length).toString())
              ],
            )
          ],
        ),
        isThreeLine: true,
      ),
    );
  }
}
