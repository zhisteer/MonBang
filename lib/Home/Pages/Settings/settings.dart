import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:monbang/Home/Pages/Settings/my_posts.dart';

import '../../../Login/components/logo_hero.dart';
import '../../../Login/login_screen.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  FirebaseFirestore _fb = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;
  late Future resultsLoaded;
  var userSnap;

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    resultsLoaded = getUserInfo();
  }

  getUserInfo() async {
    var data = await _fb.collection("users").doc(user!.email).get();
    setState(() {
      userSnap = data;
    });
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          if (userSnap != null)
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 201, 214, 220),
                            border: Border.all(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(100)),
                        child: IconButton(
                          iconSize: 80,
                          onPressed: () {},
                          icon: Icon(Icons.person),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userSnap["name"],
                              style: TextStyle(fontSize: 30),
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.thumb_up,
                                  size: 20,
                                ),
                                Text("  1")
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                SettingsButton(
                  title: "Миний постууд",
                  onPressed: () {
                    Get.to(() => MyPosts());
                  },
                ),
                SettingsButton(
                  title: "Гарах",
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                )
              ],
            ),
          if (userSnap == null) CircularProgressIndicator()
        ],
      ),
    ));
  }
}

class SettingsButton extends StatelessWidget {
  String title;
  var onPressed;
  SettingsButton({Key? key, required this.title, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPressed,
      title: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          title,
          style: TextStyle(fontSize: 20),
        ),
      ),
      trailing: Icon(Icons.keyboard_arrow_right),
    );
  }
}
