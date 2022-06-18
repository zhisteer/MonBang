import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monbang/Home/Pages/Home/board.dart';
import '../../../Login/components/users.dart';
import '../containers/post_field.dart';

class CreatePost extends StatefulWidget {
  CreatePost({Key? key}) : super(key: key);

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  final user = FirebaseAuth.instance.currentUser;

  final _formKey2 = GlobalKey<FormState>();

  final TextEditingController titleController = TextEditingController();

  final TextEditingController contentController = TextEditingController();

  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Users loggedInUser = Users();

  List likes = [];

  List dislikes = [];

  String uid = '';

  bool anon = true;

  void onPost() async {
    if (_formKey2.currentState!.validate()) {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user?.email)
          .get()
          .then((value) {
        loggedInUser = Users.fromMap(value.data());
      });

      Map<String, dynamic> posts = {
        "title": titleController.text,
        "body": contentController.text,
        "time": FieldValue.serverTimestamp(),
        "postby": loggedInUser.name,
        "likes": likes,
        "dislikes": dislikes,
        "anon": anon,
        "posteremail": loggedInUser.email
      };

      await _firestore
          .collection('posts')
          .doc('free')
          .collection('posts')
          .add(posts);

      Get.off(() => FreeBoard());
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Шинэ Пост",
            style: TextStyle(color: Colors.white, fontSize: 20)),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: Icon(Icons.post_add),
            onPressed: onPost,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Form(
              key: _formKey2,
              child: Column(
                children: [
                  Row(
                    children: [
                      Checkbox(
                          value: anon,
                          onChanged: (value) {
                            setState(() {
                              anon = value!;
                            });
                          }),
                      Text("Нэрээ нууцлах"),
                    ],
                  ),
                  PostField(
                    hintText: "Гарчиг",
                    controller: titleController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return ("Гарчиг бичнэ үү.");
                      }
                    },
                    height: 0.07,
                  ),
                  SizedBox(
                    width: size.width,
                    child: PostField(
                      hintText: "Агуулга",
                      controller: contentController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return ("Агуулга бичнэ үү");
                        }
                      },
                      height: 0.35,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
