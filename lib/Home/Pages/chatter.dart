import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class Chatters extends StatefulWidget {
  const Chatters({Key? key}) : super(key: key);

  @override
  State<Chatters> createState() => _ChattersState();
}

class _ChattersState extends State<Chatters> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;
  List allChats = [];
  getChats() async {
    var data = await _firestore
        .collection("chat")
        .where(FieldPath.documentId, isGreaterThanOrEqualTo: user!.email)
        .get();
    print("get chats");
    setState(() {
      allChats = data.docs;
    });
  }

  wait() async {
    await getChats();
  }

  @override
  void initState() {
    super.initState();
    wait();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: ListView.builder(
          itemCount: allChats.length,
          itemBuilder: (BuildContext context, int index) => ChatName(
                map: allChats[index] as DocumentReference,
              )),
    );
  }
}

class ChatName extends StatelessWidget {
  DocumentReference map;
  ChatName({Key? key, required this.map}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    print(map.toString());
    return ListTile(
      title: Text("yay"),
    );
  }
}
