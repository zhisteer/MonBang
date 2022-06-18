import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";

class Chat extends StatefulWidget {
  Chat(
      {Key? key,
      required this.chatroomId,
      required this.userName,
      required this.postBy})
      : super(key: key);
  String? chatroomId;
  String? userName;
  String postBy;

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _message = TextEditingController();
  void OnSendMessage() async {
    if (_message.text.isNotEmpty) {
      Map<String, dynamic> messages = {
        "sendby": widget.userName,
        "message": _message.text,
        "time": FieldValue.serverTimestamp(),
      };

      await _firestore
          .collection('chat')
          .doc(widget.chatroomId)
          .collection('chats')
          .add(messages);
      _message.clear();
    } else {
      print("enter text");
    }
  }

  createChatRoom() async {
    await _firestore
        .collection("chat")
        .doc(widget.chatroomId)
        .set({"name": widget.postBy});
  }

  waitChatRoom() async {
    await createChatRoom();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    waitChatRoom();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(
            "Chat",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('chat')
                      .doc(widget.chatroomId)
                      .collection('chats')
                      .orderBy('time', descending: true)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.data != null) {
                      return ListView.builder(
                        reverse: true,
                        shrinkWrap: true,
                        itemCount: snapshot.data?.docs.length,
                        itemBuilder: ((context, index) {
                          Map<String, dynamic>? map = snapshot.data!.docs[index]
                              .data() as Map<String, dynamic>?;
                          return messages(size, map);
                        }),
                      );
                    } else {
                      return Container();
                    }
                  }),
            ),
            Container(
                decoration: BoxDecoration(color: Colors.grey),
                child: Row(
                  children: [
                    Flexible(
                      child: TextField(
                        controller: _message,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.send),
                      onPressed: OnSendMessage,
                    )
                  ],
                ))
          ],
        ));
  }

  Widget messages(Size size, Map<String, dynamic>? map) {
    return Container(
        width: size.width,
        alignment: map!['sendby'] == widget.userName
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Color.fromARGB(255, 255, 79, 138),
          ),
          child: Text(
            map['message'],
            style: const TextStyle(color: Colors.white),
          ),
        ));
  }
}
