import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:comment_tree/comment_tree.dart';

import '../chat.dart';

class InsidePost extends StatefulWidget {
  InsidePost(
      {Key? key,
      required this.title,
      required this.body,
      required this.postId,
      required this.postBy,
      required this.realName,
      required this.myName})
      : super(key: key);
  final String title;
  final String body;
  final String postId;
  var likeColor = Colors.black;
  var dislikeColor = Colors.black;
  String postBy;
  String realName;
  String myName;

  @override
  State<InsidePost> createState() => _InsidePostState();
}

class _InsidePostState extends State<InsidePost> {
  TextEditingController commentController = TextEditingController();

  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List comments = [];
  User? user = FirebaseAuth.instance.currentUser;
  late Future resultsLoaded;
  var postData;
  DateTime time = DateTime.now();
  String timeAgo = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getComments();
    getPostInfo();
  }

  getPostInfo() async {
    var doc = await _firestore
        .collection("posts")
        .doc("free")
        .collection("posts")
        .doc(widget.postId)
        .get();
    setState(() {
      postData = doc;
      time = (postData["time"] as Timestamp).toDate();
      timeAgo = Jiffy(time).fromNow();
    });
  }

  getComments() async {
    var data = await _firestore
        .collection("posts")
        .doc("free")
        .collection("posts")
        .doc(widget.postId)
        .collection("comments")
        .get();
    setState(() {
      comments = data.docs;
    });
    return data.docs;
  }

  postComment() async {
    Map<String, dynamic> comment = {
      "comment": commentController.text,
      "time": FieldValue.serverTimestamp(),
    };
    print(comment['comment']);
    await _firestore
        .collection("posts")
        .doc("free")
        .collection("posts")
        .doc(widget.postId)
        .collection("comments")
        .add(comment);
    setState(() {
      getComments();
      commentController.clear();
      FocusManager.instance.primaryFocus?.unfocus();
    });
  }

  updateLikes(String likes, String? uid) async {
    return await _firestore
        .collection("posts")
        .doc("free")
        .collection("posts")
        .doc(widget.postId)
        .update({
      likes: FieldValue.arrayUnion([uid])
    });
  }

  removeLikes(String likes, String? uid) async {
    return await _firestore
        .collection("posts")
        .doc("free")
        .collection("posts")
        .doc(widget.postId)
        .update({
      likes: FieldValue.arrayRemove([uid])
    });
  }

  String chatRoomId(String? user1, String? user2) {
    if (user1![0].toLowerCase().codeUnits[0] >
        user2![0].toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    String postBy = widget.postBy;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Чөлөөт Самбар",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        actions: [
          PopupMenuButton(
            onSelected: ((value) {
              if (value == 0) {
                String? userEmail = user!.email;
                String? roomId = chatRoomId(userEmail, widget.myName);

                _firestore.collection("chat");
                Get.to(() => Chat(
                    chatroomId: roomId, userName: userEmail, postBy: postBy));
              }
            }),
            itemBuilder: ((context) => [
                  const PopupMenuItem(
                    value: 0,
                    child: Text("Чат бичих"),
                  ),
                  PopupMenuItem(
                    child: widget.myName == user!.email
                        ? Text("Устгах")
                        : Text(""),
                    onTap: () {},
                  ),
                ]),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(children: [
          if (postData == null)
            Center(
              child: CircularProgressIndicator(),
            ),
          if (postData != null)
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(postData['title'],
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold)),
                          SizedBox(
                            height: 20,
                            child: Text(
                              "$timeAgo  |  $postBy",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 122, 122, 122),
                                  fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: SizedBox(
                        width: size.width - 40,
                        child: Text(
                          postData['body'],
                          style: TextStyle(fontSize: 18),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        GestureDetector(
                            onTap: () async {
                              if (postData['likes'].contains(user!.uid)) {
                                removeLikes('likes', user!.uid);
                              } else if (postData['dislikes']
                                  .contains(user!.uid)) {
                                removeLikes('dislikes', user!.uid);
                                updateLikes('likes', user!.uid);
                              } else {
                                updateLikes('likes', user!.uid);
                              }

                              try {
                                await getPostInfo();
                              } on FirebaseException catch (e) {
                                print(e);
                              }

                              setState(() {});
                            },
                            child: Icon(Icons.thumb_up)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text((postData['likes'].length -
                                  postData['dislikes'].length)
                              .toString()),
                        ),
                        GestureDetector(
                            onTap: () async {
                              if (postData['dislikes'].contains(user!.uid)) {
                                removeLikes('dislikes', user!.uid);
                              } else if (postData['likes']
                                  .contains(user!.uid)) {
                                removeLikes('likes', user!.uid);
                                updateLikes('dislikes', user!.uid);
                              } else {
                                updateLikes('dislikes', user!.uid);
                              }
                              try {
                                await getPostInfo();
                              } on FirebaseException catch (e) {
                                print(e);
                              }
                              setState(() {});
                            },
                            child: Icon(Icons.thumb_down)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          if (comments.isEmpty)
            Expanded(child: Center(child: Text("Сэтгэгдэл байхгүй байна."))),
          if (comments.isNotEmpty)
            Expanded(
              child: ListView.builder(
                  itemCount: comments.length,
                  itemBuilder: (BuildContext context, int index) {
                    return CommentMy(
                      map: comments[index],
                    );
                  }),
            ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(29)),
              child: TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                controller: commentController,
                decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    hintText: "Сэтгэгдэл бичих",
                    border: InputBorder.none,
                    suffixIcon: IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () async {
                        postComment();
                      },
                    )),
              ),
            ),
          )
        ]),
      ),
    );
  }
}

class CommentMy extends StatefulWidget {
  DocumentSnapshot map;
  CommentMy({
    Key? key,
    required this.map,
  }) : super(key: key);

  @override
  State<CommentMy> createState() => _CommentMyState();
}

class _CommentMyState extends State<CommentMy> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.person_outline),
                Text(
                  "Nuutsaa",
                  style: TextStyle(color: Colors.grey),
                ),
                PopupMenuButton(
                  itemBuilder: ((context) => [
                        PopupMenuItem(
                          child: Text("Start Chat"),
                          onTap: () {},
                        ),
                        PopupMenuItem(
                          child: Text("Report"),
                          onTap: () {},
                        ),
                      ]),
                )
              ],
            ),
            Container(
              width: 100,
              padding: EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 230, 230, 230),
                  borderRadius: BorderRadius.circular(29)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(
                    Icons.thumb_up,
                    size: 19,
                  ),
                  Text("1"),
                  Icon(
                    Icons.thumb_down,
                    size: 19,
                  )
                ],
              ),
            )
          ],
        ),
        Text(
          widget.map['comment'],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: [
              Text(
                "06/11 11:05",
                style: TextStyle(color: Colors.grey),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Icon(Icons.reply_rounded),
              )
            ],
          ),
        ),
      ],
    );
  }
}
