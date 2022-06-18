import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ThisPost {
  String title;
  String body;
  List<dynamic> likes;
  List<dynamic> dislikes;
  ThisPost(this.body, this.title, this.likes, this.dislikes);
  ThisPost.fromSnapshot(DocumentSnapshot snapshot)
      : title = snapshot['title'],
        body = snapshot['body'],
        likes = snapshot['likes'],
        dislikes = snapshot['dislikes'];
}
